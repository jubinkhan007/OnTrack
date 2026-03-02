import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class NetworkDebugLogger {
  static const int _chunkSize = 900;

  static void logRequest(RequestOptions options) {
    if (!kDebugMode) return;

    final requestId = _ensureRequestId(options);
    final startedAtMs = _ensureStartTime(options);

    _p("");
    _p("[HTTP $requestId] --- Request ---");
    _p("[HTTP $requestId] Method: ${options.method}");
    _p("[HTTP $requestId] URL: ${options.uri}");
    _p("[HTTP $requestId] BaseURL: ${options.baseUrl}");
    _p("[HTTP $requestId] Path: ${options.path}");
    _p("[HTTP $requestId] Content-Type: ${options.contentType ?? "(none)"}");
    _p("[HTTP $requestId] ResponseType: ${options.responseType}");
    _p("[HTTP $requestId] FollowRedirects: ${options.followRedirects}");
    _p("[HTTP $requestId] PersistentConnection: ${options.persistentConnection}");

    if (options.queryParameters.isNotEmpty) {
      _p("[HTTP $requestId] QueryParameters:");
      _logMap(
        requestId: requestId,
        label: "QueryParameters",
        map: options.queryParameters,
      );
    }

    _p("[HTTP $requestId] Headers (type/len/preview):");
    _logHeaders(options.headers, requestId: requestId);

    _p("[HTTP $requestId] Data: ${_describeValue(options.data)}");
    _logJsonIfPossible(
      requestId: requestId,
      label: "Data",
      value: options.data,
    );

    _p("[HTTP $requestId] cURL:");
    _p(_toCurl(options, requestId: requestId));

    // ignore: unused_local_variable
    final _ = startedAtMs; // helps ensure stored even if logs change
  }

  static void logResponse(Response response) {
    if (!kDebugMode) return;

    final options = response.requestOptions;
    final requestId = _ensureRequestId(options);
    final startedAtMs = _ensureStartTime(options);
    final tookMs = DateTime.now().millisecondsSinceEpoch - startedAtMs;

    _p("");
    _p("[HTTP $requestId] --- Response (${tookMs}ms) ---");
    _p("[HTTP $requestId] URL: ${options.uri}");
    _p("[HTTP $requestId] Status Code: ${response.statusCode}");
    _p("[HTTP $requestId] Status Message: ${response.statusMessage ?? "(none)"}");

    if (response.headers.map.isNotEmpty) {
      _p("[HTTP $requestId] Response Headers:");
      _logMap(
        requestId: requestId,
        label: "ResponseHeaders",
        map: response.headers.map,
      );
    }

    _p("[HTTP $requestId] Data: ${_describeValue(response.data)}");
    _logJsonIfPossible(
      requestId: requestId,
      label: "ResponseData",
      value: response.data,
    );
  }

  static void logDioError(DioException err) {
    if (!kDebugMode) return;

    final options = err.requestOptions;
    final requestId = _ensureRequestId(options);
    final startedAtMs = _ensureStartTime(options);
    final tookMs = DateTime.now().millisecondsSinceEpoch - startedAtMs;

    _p("");
    _p("[HTTP $requestId] --- Error (${tookMs}ms) ---");
    _p("[HTTP $requestId] URL: ${options.uri}");
    _p("[HTTP $requestId] Type: ${err.type}");
    _p("[HTTP $requestId] Message: ${err.message}");
    if (err.error != null) {
      _p("[HTTP $requestId] Error: ${err.error}");
    }

    final status = err.response?.statusCode;
    if (status != null) {
      _p("[HTTP $requestId] Status Code: $status");
    }

    final responseData = err.response?.data;
    if (responseData != null) {
      _p("[HTTP $requestId] Response Data: ${_describeValue(responseData)}");
      _logJsonIfPossible(
        requestId: requestId,
        label: "ErrorResponseData",
        value: responseData,
      );
    }
  }

  static void logSaveTaskDiagnostics({
    required String title,
    required String details,
    required String dueDate,
    required String? startDate,
    required String assignees,
    required Map<String, dynamic> headers,
  }) {
    if (!kDebugMode) return;

    _p("");
    _p("[saveTask] --- Payload Diagnostics ---");
    _p("[saveTask] title(len=${title.length}): ${_preview(title)}");
    _p("[saveTask] details(len=${details.length}): ${_preview(details)}");
    _p("[saveTask] dueDate: $dueDate | startDate: ${startDate ?? "(null)"}");

    _p("[saveTask] taskdetail(len=${assignees.length}) preview: ${_preview(assignees)}");
    final decoded = _tryJsonDecode(assignees);
    if (decoded == null) {
      _p("[saveTask] WARNING: taskdetail is not valid JSON (jsonDecode failed).");
      _p("[saveTask] taskdetail tail: ${_tail(assignees)}");
    } else {
      _p("[saveTask] taskdetail JSON type: ${decoded.runtimeType}");
      if (decoded is List) {
        _p("[saveTask] taskdetail list length: ${decoded.length}");
        // Quick schema fingerprint for backend compatibility debugging.
        final keySet = <String>{};
        for (final e in decoded) {
          if (e is Map) {
            for (final k in e.keys) {
              keySet.add(k.toString());
            }
          }
        }
        if (keySet.isNotEmpty) {
          final keys = keySet.toList()..sort();
          _p("[saveTask] taskdetail keys: ${keys.join(', ')}");
          if (keySet.contains("STARTDATE") || keySet.contains("ENDDATE")) {
            _p(
              "[saveTask] WARNING: taskdetail includes STARTDATE/ENDDATE. Some backends only accept NAME/STAFFID/DATETIME/COMMENTS.",
            );
          }
        }
      }
      _logJsonIfPossible(requestId: "saveTask", label: "taskdetail", value: decoded);
    }

    final approxBytes = _approxHeaderBytes(headers);
    _p("[saveTask] Approx header bytes: $approxBytes");
    _p("[saveTask] Headers (type/len/preview):");
    _logHeaders(headers, requestId: "saveTask");
  }

  static String _ensureRequestId(RequestOptions options) {
    final extra = options.extra;
    final existing = extra["debug_request_id"];
    if (existing is String && existing.isNotEmpty) return existing;
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    extra["debug_request_id"] = id;
    return id;
  }

  static int _ensureStartTime(RequestOptions options) {
    final extra = options.extra;
    final existing = extra["debug_start_ms"];
    if (existing is int) return existing;
    final ms = DateTime.now().millisecondsSinceEpoch;
    extra["debug_start_ms"] = ms;
    return ms;
  }

  static void _logHeaders(
    Map<String, dynamic> headers, {
    required String requestId,
  }) {
    final keys = headers.keys.toList()..sort();
    for (final k in keys) {
      final v = headers[k];
      final valueStr = v?.toString() ?? "(null)";

      final lowerKey = k.toLowerCase();
      final shouldMask = lowerKey.contains("authorization") ||
          lowerKey.contains("cookie") ||
          lowerKey.contains("token") ||
          lowerKey.contains("password");
      final displayValue = shouldMask ? "(masked)" : valueStr;

      if (!shouldMask && (valueStr.contains("\n") || valueStr.contains("\r"))) {
        _p(
          "[HTTP $requestId]   WARNING: header '$k' contains newline characters (may break parsing).",
        );
      }
      if (!shouldMask &&
          valueStr.runes.any((r) => r > 0xFF)) {
        _p(
          "[HTTP $requestId]   WARNING: header '$k' contains non-Latin-1 characters. Dart HttpClient may throw unless sanitized.",
        );
      }
      if (valueStr.length > 4096) {
        _p(
          "[HTTP $requestId]   WARNING: header '$k' is very large (len=${valueStr.length}). Some servers/proxies reject large headers.",
        );
      }

      _p(
        "[HTTP $requestId]   $k: (${v.runtimeType}, len=${valueStr.length}) ${_preview(displayValue)}",
      );
      // If this looks like JSON, print a prettified version too.
      if (!shouldMask && v is String && _looksLikeJson(v)) {
        _logJsonIfPossible(requestId: requestId, label: "Header:$k", value: v);
      }
    }
  }

  static void _logMap({
    required String requestId,
    required String label,
    required Map map,
  }) {
    final keys = map.keys.toList()
      ..sort((a, b) => a.toString().compareTo(b.toString()));
    for (final k in keys) {
      final v = map[k];
      _p("[HTTP $requestId]   $label.$k = ${_preview(v?.toString() ?? "(null)")}");
    }
  }

  static void _logJsonIfPossible({
    required String requestId,
    required String label,
    required dynamic value,
  }) {
    final decoded = _tryJsonDecode(value);
    if (decoded == null) return;

    try {
      final pretty = const JsonEncoder.withIndent("  ").convert(decoded);
      _p("[HTTP $requestId] $label (pretty JSON):");
      _p(pretty, prefix: "[HTTP $requestId] ");
    } catch (_) {
      // ignore
    }
  }

  static dynamic _tryJsonDecode(dynamic value) {
    if (value == null) return null;
    if (value is Map || value is List) return value;
    if (value is! String) return null;
    final trimmed = value.trim();
    if (!_looksLikeJson(trimmed)) return null;
    try {
      return jsonDecode(trimmed);
    } catch (_) {
      return null;
    }
  }

  static bool _looksLikeJson(String s) {
    final t = s.trimLeft();
    return t.startsWith("{") || t.startsWith("[");
  }

  static int _approxHeaderBytes(Map<String, dynamic> headers) {
    var total = 0;
    headers.forEach((k, v) {
      final valueStr = v?.toString() ?? "";
      total += k.length + valueStr.length + 4; // rough ": " + CRLF
    });
    return total;
  }

  static String _toCurl(RequestOptions options, {required String requestId}) {
    final b = StringBuffer();
    b.write("curl -i");
    b.write(" -X ${options.method}");
    b.write(" '${options.uri}'");

    // Headers
    final keys = options.headers.keys.toList()..sort();
    for (final k in keys) {
      final v = options.headers[k];
      if (v == null) continue;
      final value = v.toString().replaceAll("'", "'\\''");
      b.write(" -H '$k: $value'");
    }

    // Data (best-effort)
    final data = options.data;
    if (data != null) {
      if (data is String) {
        final escaped = data.replaceAll("'", "'\\''");
        b.write(" --data '$escaped'");
      } else {
        try {
          final encoded = jsonEncode(data).replaceAll("'", "'\\''");
          b.write(" --data '$encoded'");
        } catch (_) {
          b.write(" --data '${data.toString().replaceAll("'", "'\\''")}'");
        }
      }
    }

    // Helpful note if request appears to be header-only
    if (options.data == null) {
      b.write(
        "  # NOTE: body is null; this request uses headers for payload",
      );
    }

    return b.toString();
  }

  static String _describeValue(dynamic value) {
    if (value == null) return "(null)";
    if (value is String) return "String(len=${value.length})";
    if (value is List) return "List(len=${value.length})";
    if (value is Map) return "Map(len=${value.length})";
    return value.runtimeType.toString();
  }

  static String _preview(String s, {int head = 160, int tail = 160}) {
    if (s.length <= head + tail + 10) return s;
    return "${s.substring(0, head)} … ${s.substring(s.length - tail)}";
  }

  static String _tail(String s, {int tail = 220}) {
    if (s.length <= tail) return s;
    return s.substring(s.length - tail);
  }

  static void _p(String message, {String prefix = ""}) {
    if (!kDebugMode) return;
    if (message.isEmpty) {
      debugPrint("");
      return;
    }
    final full = "$prefix$message";
    if (full.length <= _chunkSize) {
      debugPrint(full);
      return;
    }

    var i = 0;
    while (i < full.length) {
      final end = (i + _chunkSize < full.length) ? i + _chunkSize : full.length;
      debugPrint(full.substring(i, end));
      i = end;
    }
  }
}
