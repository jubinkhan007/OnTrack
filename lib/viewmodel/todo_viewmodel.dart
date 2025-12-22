import 'package:flutter/cupertino.dart';
import 'package:tmbi/repo/repo.dart';

import '../models/models.dart';
import '../network/ui_state.dart';

class TodoViewModel extends ChangeNotifier {
  final InquiryRepo inquiryRepo;
  TextEditingController taskTextEdit = TextEditingController();

  TodoViewModel({required this.inquiryRepo});

  @override
  void dispose() {
    taskTextEdit.dispose();
    super.dispose();
  }

  /// message
  String? _message;

  String? get message => _message;

  /// inquiry list
  List<InquiryResponse>? _inquiries;

  List<InquiryResponse>? get inquiries => _inquiries;

  List<StringUrl>? _attachmentViewResponse;

  List<StringUrl>? get attachmentViewResponse => _attachmentViewResponse;


  List<Note>? _noteResponse;

  List<Note>? get noteResponse => _noteResponse;


  List<Discussion>? _commentResponse;

  List<Discussion>? get commentResponse => _commentResponse;

  /// save inquiry
  bool? _isSavedInquiry;

  bool? get isSavedInquiry => _isSavedInquiry;

  /// ui state
  UiState _uiState = UiState.init;

  UiState get uiState => _uiState;

  /// tab index
  int _tabSelectedFlag = 0;

  int get tabSelectedFlag => _tabSelectedFlag;

  set tabSelectedFlag(int value) {
    if (_tabSelectedFlag != value) {
      _tabSelectedFlag = value;
      notifyListeners(); // This will trigger a UI update
    }
  }

  Future<void> getInquiries(String flag, String userId, String isAssigned,
      {String vm = "INQALL_ALL"}) async {
    if (_uiState == UiState.loading) return;
    _message = null;
    _uiState = UiState.loading;
    notifyListeners();
    try {
      final response =
          await inquiryRepo.getInquiries(flag, userId, isAssigned, vm);
      //final response = _getDemoTasks(); // test purpose
      _inquiries = response;
      _uiState = UiState.success;
    } catch (error) {
      _uiState = UiState.error;
      _message = error.toString();
    } finally {
      notifyListeners();
    }
  }

  /*
  Future<void> getNotes(String inquiryId, String taskId) async {
    if (_uiState == UiState.loading) return;

    _uiState = UiState.loading;
    notifyListeners();
    try {
      final response = await inquiryRepo.getNotes(inquiryId, taskId);
      _noteResponse = response;
      _uiState = UiState.success;
    } catch (error) {
      _uiState = UiState.error;
      _message = error.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> getAttachments(String inquiryId, String taskId) async {
    if (_uiState == UiState.loading) return;

    _uiState = UiState.loading;
    notifyListeners();
    try {
      final response = await inquiryRepo.getAttachments(inquiryId, taskId);
      _attachmentViewResponse = response;
      _uiState = UiState.success;
    } catch (error) {
      _uiState = UiState.error;
      _message = error.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> getComments(String inquiryId, String taskId) async {
    if (_uiState == UiState.loading) return;

    _uiState = UiState.loading;
    notifyListeners();
    try {
      final response = await inquiryRepo.getComments(inquiryId, taskId);
      _commentResponse = response;
      _uiState = UiState.success;
    } catch (error) {
      _uiState = UiState.error;
      _message = error.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> saveComment(
      String inquiryId, String body, String priorityId, String userId) async {
    if (_uiState == UiState.loading) return;

    _uiState = UiState.loading;
    notifyListeners();
    try {
      final response =
          await inquiryRepo.saveComment(inquiryId, body, priorityId, userId);
      _isSavedInquiry = response;
      _uiState = UiState.success;
    } catch (error) {
      _uiState = UiState.error;
      _message = error.toString();
    } finally {
      notifyListeners();
    }
  }*/

  Future<void> saveComment(
      String inquiryId, String body, String priorityId, String userId) async {
    if (_uiState == UiState.commentLoading) return;

    _uiState = UiState.commentLoading;
    notifyListeners();
    try {
      final response =
          await inquiryRepo.saveComment(inquiryId, body, priorityId, userId);
      _isSavedInquiry = response;
      _uiState = UiState.success;
    } catch (error) {
      _uiState = UiState.error;
      _message = error.toString();
    } finally {
      notifyListeners();
    }
  }

  /// NEW TASK ENTRY \\\

  bool _canCreate = false;

  bool get canCreate => _canCreate;

  void onTaskTextChanged(String value) {
    _canCreate = value.trim().isNotEmpty;
    notifyListeners();
  }

  final List<String> _allMembers = [
    'Mithun',
    'Rahul',
    'Anita',
    'Suman',
    'Amit',
    'Neha',
  ];

  final Set<String> _selected = {};
  String _search = '';

  List<String> get members {
    if (_search.isEmpty) return _allMembers;
    return _allMembers
        .where((e) => e.toLowerCase().contains(_search.toLowerCase()))
        .toList();
  }

  Set<String> get selected => _selected;

  void toggle(String name) {
    _selected.contains(name)
        ? _selected.remove(name)
        : _selected.add(name);
    notifyListeners();
  }

  void search(String value) {
    _search = value;
    notifyListeners();
  }


}
