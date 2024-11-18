import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:tmbi/repo/repo.dart';

import '../models/models.dart';
import '../network/ui_state.dart';

class InquiryViewModel extends ChangeNotifier {
  final InquiryRepo inquiryRepo;

  InquiryViewModel({required this.inquiryRepo});

  /// message
  String? _message;

  String? get message => _message;

  /// inquiry list
  List<InquiryResponse>? _inquiries;

  List<InquiryResponse>? get inquiries => _inquiries;

  /// attachment list
  AttachmentViewResponse? _attachmentViewResponse;

  AttachmentViewResponse? get attachmentViewResponse => _attachmentViewResponse;

  /// note list
  NoteResponse? _noteResponse;

  NoteResponse? get noteResponse => _noteResponse;

  /// comment
  CommentResponse? _commentResponse;

  CommentResponse? get commentResponse => _commentResponse;

  /// ui state
  UiState _uiState = UiState.init;

  UiState get uiState => _uiState;

  Future<void> getInquiries(String flag, String userId) async {
    if (_uiState == UiState.loading) return;

    _uiState = UiState.loading;
    notifyListeners();
    try {
      final response = await inquiryRepo.getInquiries(flag, userId);
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

  Future<void> getAttachments() async {
    if (_uiState == UiState.loading) return;

    _uiState = UiState.loading;
    notifyListeners();
    try {
      final response = await inquiryRepo.getAttachments();
      _attachmentViewResponse = response;
      _uiState = UiState.success;
    } catch (error) {
      _uiState = UiState.error;
      _message = error.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> getNotes() async {
    if (_uiState == UiState.loading) return;

    _uiState = UiState.loading;
    notifyListeners();
    try {
      final response = await inquiryRepo.getNotes();
      _noteResponse = response;
      _uiState = UiState.success;
    } catch (error) {
      _uiState = UiState.error;
      _message = error.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> getComments() async {
    if (_uiState == UiState.loading) return;

    _uiState = UiState.loading;
    notifyListeners();
    try {
      final response = await inquiryRepo.getComments();
      _commentResponse = response;
      _uiState = UiState.success;
    } catch (error) {
      _uiState = UiState.error;
      _message = error.toString();
    } finally {
      notifyListeners();
    }
  }

  List<InquiryResponse> _getDemoTasks() {
    /*const jsonString = '''{
        "queries": []
      }''';*/
    const jsonString = '''{
    "queries": [
        {
            "id": "123C321",
            "title": "Need shoe sample for walker",
            "description": "Lorem Ipsum is simply dummy text of the printingand  typesetting industry. Lorem Ipsum has  ... ",
            "company": "Walker",
            "end_date": "Oct 8, 2024",
            "status": "pending",
            "comment": {
                "id": "123A",
                "count": "1"
            },
            "attachment": {
                "id": "32A",
                "count": "2"
            },
            "posted_by": {
                "id": "1",
                "name": "Mr. Fahad Alam",
                "is_owner": true
            },
            "customer": {
                "ID": "12",
                "NAME": "Mr. Alan John",
                "IS_VERIFIED": true
            },
            "tasks": [
                {
                    "id": "1",
                    "name": "Collect materials to create a sample from the store.",
                    "date": "19 Oct, 2024 - 21 Oct, 2024",
                    "total_time": "2",
                    "has_access": false,
                    "is_updated": false,
                    "assigned_person": "Mr. Rtotn"
                },
                {
                    "id": "2",
                    "name": "Create a sample using that material.",
                    "date": "22 Oct, 2024 - 26 Oct, 2024",
                    "total_time": "4",
                    "has_access": true,
                    "is_updated": true,
                    "assigned_person": "Mr. Alamgir Hossain"
                },
                {
                    "id": "3",
                    "name": "Gate Pass.",
                    "date": "27 Oct, 2024 - 27 Oct, 2024",
                    "total_time": "1",
                    "has_access": false,
                    "is_updated": true,
                    "assigned_person": "Mr. Hossain"
                }
            ]
        },
        {
            "id": "123C322",
            "title": "Need shirt sample for Winner",
            "description": "Lorem Ipsum is simply dummy text of the printingand  typesetting industry. Lorem Ipsum has  ... ",
            "company": "Winner",
            "end_date": "Oct 29, 2024",
            "status": "pending",
            "comment": {
                "id": "123A",
                "count": "1"
            },
            "attachment": {
                "id": "32A",
                "count": "2"
            },
            "posted_by": {
                "id": "2",
                "name": "Mr. Alam",
                "is_owner": false
            },
            "customer": {
                "ID": "13",
                "NAME": "Mr. John",
                "IS_VERIFIED": false
            },
            "tasks": [
                {
                    "id": "2",
                    "name": "Create a sample using that material.",
                    "date": "22 Oct, 2024 - 26 Oct, 2024",
                    "total_time": "4",
                    "has_access": false,
                    "is_updated": false,
                    "assigned_person": "Mr. Alamgir Hossain"
                },
                {
                    "id": "3",
                    "name": "Gate Pass.",
                    "date": "27 Oct, 2024 - 27 Oct, 2024",
                    "total_time": "1",
                    "has_access": true,
                    "is_updated": false,
                    "assigned_person": "Mr. Alamgir Hossain"
                }
            ]
        },
        {
            "id": "123C322",
            "title": "Need shirt sample for Winner",
            "description": "Lorem Ipsum is simply dummy text of the printingand  typesetting industry. Lorem Ipsum has  ... ",
            "company": "Winner",
            "end_date": "Oct 29, 2024",
            "status": "pending",
            "comment": {
                "id": "123A",
                "count": "10"
            },
            "attachment": {
                "id": "32A",
                "count": "3"
            },
            "posted_by": {
                "id": "2",
                "name": "Mr. Alam",
                "is_owner": false
            },
            "customer": {
                "ID": "13",
                "NAME": "Mr. John",
                "IS_VERIFIED": false
            },
            "tasks": [
                {
                    "id": "2",
                    "name": "Create a sample using that material.",
                    "date": "22 Oct, 2024 - 26 Oct, 2024",
                    "total_time": "4",
                    "has_access": false,
                    "is_updated": false,
                    "assigned_person": "Mr. Alamgir Hossain"
                },
                {
                    "id": "3",
                    "name": "Gate Pass.",
                    "date": "27 Oct, 2024 - 27 Oct, 2024",
                    "total_time": "1",
                    "has_access": true,
                    "is_updated": false,
                    "assigned_person": "Mr. Alamgir Hossain"
                }
            ]
        }
    ]
}''';

    // decode the JSON string to a Map
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    // access the list of inquiries under the 'queries' key
    final List<dynamic> jsonList = jsonMap['queries'];
    // map the list of JSON objects to InquiryResponse objects
    return jsonList.map((json) => InquiryResponse.fromJson(json)).toList();
  }

}
