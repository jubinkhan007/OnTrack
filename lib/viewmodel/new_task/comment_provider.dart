import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tmbi/models/new_task/comment_response.dart';
import 'package:tmbi/models/new_task/main_task_response.dart';
import 'package:tmbi/network/dio_exception.dart';

import '../../network/ui_state.dart';
import '../../repo/new_task/comment_repo.dart';

class CommentProvider extends ChangeNotifier {
  final TextEditingController commentController = TextEditingController();
  final CommentRepo commentRepo;
  final String staffId;
  final String inqId;
  final SubTask? subTask;

  bool _disposed = false;
  Timer? _pendingSyncTimer;
  bool _isSyncingPendingComments = false;

  CommentProvider(this.staffId, this.inqId, this.subTask,
      {required this.commentRepo}) {
    _startPendingSyncTimer();
    _migrateLegacyLocalSubTaskKeys().then((_) {
      getComments(staffId, inqId, subTask);
    });
  }

  @override
  void dispose() {
    _disposed = true;
    _pendingSyncTimer?.cancel();
    commentController.dispose();
    super.dispose();
  }

  // --- API --- \\
  String? _message;

  String? get message => _message;

  List<Comment> _commentList = [];

  List<Comment> get commentList => _commentList;

  bool? _isSuccess;

  bool? get isSuccess => _isSuccess;

  // UI state
  UiState _uiState = UiState.init;

  UiState get uiState => _uiState;

  set uiState(UiState newState) {
    if (_uiState != newState) {
      _uiState = newState;
      notifyListeners();
    }
  }

  Future<void> refresh(
    String staffId,
    String inquiryId,
    SubTask? subTask,
  ) async {
    try {
      final response = await commentRepo.getComments(
        staffId,
        inquiryId,
        subTask,
      );

      _commentList
        ..clear()
        ..addAll(response);
      // Only merge pending comments that failed to sync (still in queue).
      // Do NOT merge cached comments — server data is the source of truth.
      final pendingAfterSync = await _getPendingComments();
      if (pendingAfterSync.isNotEmpty) {
        await _mergePendingCommentsIntoList();
      }
      _sortCommentsByDate();
      await _cacheComments(staffId, inquiryId, subTask, _commentList);
      await _syncCommentCountCache(_commentList.length);

      notifyListeners();
    } catch (e) {
      debugPrint("GET COMMENTS ERROR: $e");
    }
  }

  Future<void> getComments(
    String staffId,
    String inqId,
    SubTask? subTask,
  ) async {
    if (_uiState == UiState.loading) return;

    _uiState = UiState.loading;
    notifyListeners();
    await _migrateLegacyLocalSubTaskKeys();

    if (_isLocalTaskId(inqId)) {
      final hasCache = await _loadCachedComments(staffId, inqId, subTask);
      await _mergePendingCommentsIntoList();
      _sortCommentsByDate();
      _message =
          hasCache || _commentList.isNotEmpty ? null : "(No comments found)";
      _uiState = UiState.success;
      notifyListeners();
      return;
    }

    try {
      await _syncPendingComments();
      final response = await commentRepo.getComments(
        staffId,
        inqId,
        subTask,
      );

      _commentList
        ..clear()
        ..addAll(response);
      // Server data is the source of truth when online.
      // Only merge pending comments that genuinely failed to sync.
      // Do NOT merge cached comments — they contain stale local entries.
      final stillPending = await _getPendingComments();
      if (stillPending.isNotEmpty) {
        await _mergePendingCommentsIntoList();
      }
      _sortCommentsByDate();
      _message = null;
      await _cacheComments(staffId, inqId, subTask, _commentList);
      await _syncCommentCountCache(_commentList.length);

      _uiState = UiState.success;
    } on DioException catch (error) {
      if (_isOfflineError(error)) {
        final hasCache = await _loadCachedComments(staffId, inqId, subTask);
        if (hasCache) {
          await _mergePendingCommentsIntoList();
          _sortCommentsByDate();
          _message = null;
          await _syncCommentCountCache(_commentList.length);
          _uiState = UiState.success;
        } else {
          _uiState = UiState.error;
          _message = "No internet detected, please check your connection.";
        }
      } else {
        _uiState = UiState.error;
        _message = error.toString();
      }
    } catch (error) {
      _uiState = UiState.error;
      _message = error.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> saveComment(
      String inquiryId, String userId, SubTask? subTask) async {
    final text = commentController.text.trim();
    if (text.isEmpty) return;

    if (_uiState == UiState.loading) return;
    _uiState = UiState.loading;
    notifyListeners();
    try {
      final response =
          await commentRepo.saveComment(inquiryId, text, userId, subTask);
      debugPrint("ID: $userId, InqId: $inquiryId");
      if (response) {
        commentController.clear();
        await refresh(userId, inquiryId, subTask);
      }

      _isSuccess = response;
      _uiState = UiState.success;
    } on DioException catch (error) {
      if (_isOfflineError(error)) {
        final createdAt = DateTime.now().toIso8601String();
        final localComment = Comment(
          name: "You",
          staffId: userId,
          dateTime: createdAt,
          body: text,
        );
        commentController.clear();
        _commentList.add(localComment);
        await _enqueuePendingComment(text, userId, createdAt);
        await _cacheComments(staffId, inquiryId, subTask, _commentList);
        await _syncCommentCountCache(_commentList.length);
        _isSuccess = true;
        _uiState = UiState.success;
        _message = null;
      } else {
        _uiState = UiState.error;
        _message = error.toString();
      }
    } catch (error) {
      _uiState = UiState.error;
      _message = error.toString();
    } finally {
      notifyListeners();
    }
  }

  bool _isOfflineError(DioException error) {
    return error is NoInternetException ||
        error is TimeoutException ||
        error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout;
  }

  String _commentCacheKey(String staffId, String inquiryId, SubTask? subTask) {
    final subTaskId = subTask?.id ?? "0";
    return "comments_cache_${staffId}_${inquiryId}_$subTaskId";
  }

  String _pendingCommentQueueKey(
      String staffId, String inquiryId, SubTask? subTask) {
    final subTaskId = subTask?.id ?? "0";
    return "comments_pending_queue_${staffId}_${inquiryId}_$subTaskId";
  }

  Future<void> _cacheComments(
    String staffId,
    String inquiryId,
    SubTask? subTask,
    List<Comment> comments,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final payload = {
      "comments": comments.map((e) => e.toJson()).toList(),
      "cachedAt": DateTime.now().toIso8601String(),
    };
    await prefs.setString(
      _commentCacheKey(staffId, inquiryId, subTask),
      jsonEncode(payload),
    );
  }

  Future<bool> _loadCachedComments(
    String staffId,
    String inquiryId,
    SubTask? subTask,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_commentCacheKey(staffId, inquiryId, subTask));
    if (raw == null || raw.isEmpty) return false;

    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final list = (decoded["comments"] as List? ?? [])
          .map((item) => Comment.fromJson(item as Map<String, dynamic>))
          .toList();
      _commentList
        ..clear()
        ..addAll(list);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> _enqueuePendingComment(
      String body, String userId, String createdAt) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _pendingCommentQueueKey(staffId, inqId, subTask);
    final existing = _pendingQueueFromRaw(prefs.getString(key));
    existing.add({
      "body": body,
      "userId": userId,
      "createdAt": createdAt,
    });
    await prefs.setString(key, jsonEncode(existing));
  }

  Future<List<Map<String, dynamic>>> _getPendingComments() async {
    final prefs = await SharedPreferences.getInstance();
    final key = _pendingCommentQueueKey(staffId, inqId, subTask);
    return _pendingQueueFromRaw(prefs.getString(key));
  }

  List<Map<String, dynamic>> _pendingQueueFromRaw(String? raw) {
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = jsonDecode(raw) as List;
      return decoded.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _savePendingComments(List<Map<String, dynamic>> list) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _pendingCommentQueueKey(staffId, inqId, subTask);
    if (list.isEmpty) {
      await prefs.remove(key);
    } else {
      await prefs.setString(key, jsonEncode(list));
    }
  }

  Future<void> _mergePendingCommentsIntoList() async {
    final pending = await _getPendingComments();
    if (pending.isEmpty) return;

    // Match on staffId|body only — the server returns a different dateTime
    // format than what we store locally, so including dateTime causes
    // duplicates when comments are synced but the pending queue isn't cleared.
    final existingKeys =
        _commentList.map((c) => "${c.staffId}|${c.body}").toSet();

    for (final p in pending) {
      final tempDate =
          (p["createdAt"] ?? DateTime.now().toIso8601String()).toString();
      final tempBody = (p["body"] ?? "").toString();
      final tempUser = (p["userId"] ?? staffId).toString();
      final signature = "$tempUser|$tempBody";
      if (existingKeys.contains(signature)) continue;
      _commentList.add(
        Comment(
          name: "You",
          staffId: tempUser,
          dateTime: tempDate,
          body: tempBody,
        ),
      );
    }
  }

  Future<void> _mergeCachedCommentsFromStorage(
    String staffId,
    String inquiryId,
    SubTask? subTask,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_commentCacheKey(staffId, inquiryId, subTask));
    if (raw == null || raw.isEmpty) return;

    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final list = (decoded["comments"] as List? ?? [])
          .map((item) => Comment.fromJson(item as Map<String, dynamic>))
          .toList();
      final existingKeys =
          _commentList.map((c) => "${c.staffId}|${c.body}|${c.dateTime}").toSet();
      for (final item in list) {
        final signature = "${item.staffId}|${item.body}|${item.dateTime}";
        if (existingKeys.contains(signature)) continue;
        _commentList.add(item);
      }
    } catch (_) {
      // Ignore malformed cache.
    }
  }

  Future<void> _syncPendingComments() async {
    if (_isSyncingPendingComments || _disposed) return;
    if (_isLocalTaskId(inqId)) return;
    _isSyncingPendingComments = true;
    try {
      final pending = await _getPendingComments();
      if (pending.isEmpty) return;

      final remaining = <Map<String, dynamic>>[];
      for (var i = 0; i < pending.length; i++) {
        final p = pending[i];
        try {
          final body = (p["body"] ?? "").toString();
          final userId = (p["userId"] ?? staffId).toString();
          final ok =
              await commentRepo.saveComment(inqId, body, userId, subTask);
          if (!ok) {
            remaining.add(p);
            remaining.addAll(pending.skip(i + 1));
            break;
          }
        } on DioException catch (error) {
          remaining.add(p);
          remaining.addAll(pending.skip(i + 1));
          if (_isOfflineError(error)) break;
          break;
        } catch (_) {
          remaining.add(p);
          remaining.addAll(pending.skip(i + 1));
          break;
        }
      }

      if (remaining.isEmpty) {
        await _savePendingComments([]);
      } else {
        await _savePendingComments(remaining);
      }
    } finally {
      _isSyncingPendingComments = false;
    }
  }

  void _startPendingSyncTimer() {
    _pendingSyncTimer?.cancel();
    _pendingSyncTimer = Timer.periodic(const Duration(seconds: 20), (_) async {
      await _syncPendingComments();
      if (_disposed) return;
      final hasPending = (await _getPendingComments()).isNotEmpty;
      if (!hasPending) {
        await refresh(staffId, inqId, subTask);
      }
    });
  }

  bool _isLocalTaskId(String id) => id.startsWith("local_");

  void _sortCommentsByDate() {
    _commentList.sort((a, b) {
      final da = _tryParseDateTime(a.dateTime);
      final db = _tryParseDateTime(b.dateTime);
      if (da == null && db == null) return 0;
      if (da == null) return -1;
      if (db == null) return 1;
      return da.compareTo(db);
    });
  }

  DateTime? _tryParseDateTime(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    // Try ISO 8601 first (local comments)
    final iso = DateTime.tryParse(raw);
    if (iso != null) return iso;
    // Try common server formats: "dd-MM-yyyy hh:mm a", "dd/MM/yyyy HH:mm", etc.
    try {
      // Handle "15-02-2026 03:45 PM" or "15-02-2026 15:45"
      final cleaned = raw.replaceAll('/', '-');
      final parts = cleaned.split(' ');
      if (parts.isEmpty) return null;
      final dateParts = parts[0].split('-');
      if (dateParts.length == 3) {
        final day = int.tryParse(dateParts[0]) ?? 0;
        final month = int.tryParse(dateParts[1]) ?? 0;
        final year = int.tryParse(dateParts[2]) ?? 0;
        var hour = 0;
        var minute = 0;
        if (parts.length >= 2) {
          final timeParts = parts[1].split(':');
          hour = int.tryParse(timeParts[0]) ?? 0;
          minute = timeParts.length > 1 ? (int.tryParse(timeParts[1]) ?? 0) : 0;
        }
        if (parts.length >= 3) {
          final ampm = parts[2].toUpperCase();
          if (ampm == 'PM' && hour < 12) hour += 12;
          if (ampm == 'AM' && hour == 12) hour = 0;
        }
        return DateTime(year, month, day, hour, minute);
      }
    } catch (_) {}
    return null;
  }

  Future<void> _syncCommentCountCache(int count) async {
    final prefs = await SharedPreferences.getInstance();
    final normalized = count.toString();

    if (subTask == null) {
      final prefix = "task_cache_${staffId}_";
      final keys = prefs.getKeys().where((k) => k.startsWith(prefix));
      for (final key in keys) {
        final raw = prefs.getString(key);
        if (raw == null || raw.isEmpty) continue;
        try {
          final decoded = jsonDecode(raw) as Map<String, dynamic>;
          final tasks = decoded["tasks"] as List? ?? [];
          var updated = false;
          for (final task in tasks) {
            if (task is Map<String, dynamic> &&
                task["ID"]?.toString() == inqId) {
              task["COMMENT_COUNT"] = normalized;
              updated = true;
            }
          }
          if (updated) {
            await prefs.setString(key, jsonEncode(decoded));
          }
        } catch (_) {}
      }
    } else {
      final key = "task_details_cache_${staffId}_$inqId";
      final raw = prefs.getString(key);
      if (raw == null || raw.isEmpty) return;
      try {
        final decoded = jsonDecode(raw) as Map<String, dynamic>;
        final data = decoded["DATA"] as List? ?? [];
        if (data.isNotEmpty) {
          final first = data.first;
          if (first is Map<String, dynamic>) {
            final tasks = first["TASKS"] as List? ?? [];
            for (final task in tasks) {
              if (task is Map<String, dynamic> &&
                  task["TASK_ID"]?.toString() == subTask!.id) {
                task["COMMENT_COUNT"] = normalized;
              }
            }
          }
        }
        await prefs.setString(key, jsonEncode(decoded));
      } catch (_) {}
    }
  }

  Future<void> _migrateLegacyLocalSubTaskKeys() async {
    if (subTask == null || _isLocalTaskId(inqId)) return;
    final prefs = await SharedPreferences.getInstance();
    final targetSubTaskId = subTask!.id;
    final cachePrefix = "comments_cache_${staffId}_${inqId}_local_subtask_";
    final queuePrefix =
        "comments_pending_queue_${staffId}_${inqId}_local_subtask_";
    final targetCacheKey = _commentCacheKey(staffId, inqId, subTask);
    final targetQueueKey = _pendingCommentQueueKey(staffId, inqId, subTask);

    final keys = prefs.getKeys().toList();

    for (final key in keys) {
      if (!key.startsWith(cachePrefix) && !key.startsWith(queuePrefix)) {
        continue;
      }
      final raw = prefs.getString(key);
      if (raw == null || raw.isEmpty) {
        await prefs.remove(key);
        continue;
      }

      if (key.startsWith(cachePrefix)) {
        await _mergeCommentCachePayload(
          prefs: prefs,
          targetKey: targetCacheKey,
          sourceRaw: raw,
        );
      } else if (key.startsWith(queuePrefix)) {
        await _mergePendingQueuePayload(
          prefs: prefs,
          targetKey: targetQueueKey,
          sourceRaw: raw,
        );
      }
      await prefs.remove(key);
      debugPrint(
        "MIGRATE_COMMENT_KEY: $key -> ${key.startsWith(cachePrefix) ? targetCacheKey : targetQueueKey} ($targetSubTaskId)",
      );
    }
  }

  Future<void> _mergeCommentCachePayload({
    required SharedPreferences prefs,
    required String targetKey,
    required String sourceRaw,
  }) async {
    final targetRaw = prefs.getString(targetKey);
    final merged = <Map<String, dynamic>>[];
    final signatures = <String>{};

    void absorb(String? raw) {
      if (raw == null || raw.isEmpty) return;
      try {
        final decoded = jsonDecode(raw) as Map<String, dynamic>;
        final comments = decoded["comments"] as List? ?? [];
        for (final item in comments) {
          if (item is! Map<String, dynamic>) continue;
          final copied = Map<String, dynamic>.from(item);
          final sig =
              "${copied["STAFFID"]}|${copied["COMMENTS"]}|${copied["DATETIME"]}";
          if (signatures.contains(sig)) continue;
          signatures.add(sig);
          merged.add(copied);
        }
      } catch (_) {}
    }

    absorb(targetRaw);
    absorb(sourceRaw);

    await prefs.setString(
      targetKey,
      jsonEncode({
        "comments": merged,
        "cachedAt": DateTime.now().toIso8601String(),
      }),
    );
  }

  Future<void> _mergePendingQueuePayload({
    required SharedPreferences prefs,
    required String targetKey,
    required String sourceRaw,
  }) async {
    final targetRaw = prefs.getString(targetKey);
    final merged = <Map<String, dynamic>>[];
    final signatures = <String>{};

    void absorb(String? raw) {
      if (raw == null || raw.isEmpty) return;
      try {
        final decoded = jsonDecode(raw) as List;
        for (final item in decoded) {
          if (item is! Map) continue;
          final copied = Map<String, dynamic>.from(item);
          final sig =
              "${copied["userId"]}|${copied["body"]}|${copied["createdAt"]}";
          if (signatures.contains(sig)) continue;
          signatures.add(sig);
          merged.add(copied);
        }
      } catch (_) {}
    }

    absorb(targetRaw);
    absorb(sourceRaw);

    if (merged.isEmpty) {
      await prefs.remove(targetKey);
      return;
    }
    await prefs.setString(targetKey, jsonEncode(merged));
  }
}
