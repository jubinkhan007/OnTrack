import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmbi/config/extension_file.dart';
import 'package:tmbi/config/palette.dart';
import 'package:tmbi/models/comment_response.dart';

import '../config/converts.dart';
import '../config/sp_helper.dart';
import '../config/strings.dart';
import '../models/user_response.dart';
import '../network/ui_state.dart';
import '../viewmodel/viewmodel.dart';
import '../widgets/widgets.dart';

class CommentScreen extends StatefulWidget {
  static const String routeName = '/comment_screen';
  final String inquiryId;

  const CommentScreen({super.key, required this.inquiryId});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _bodyController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  /*final List<Comments> comments = [
    Comments(
        id: "1",
        body:
            "Lorem Ipsum is simply dummy text, Lorem Ipsum is simply dummy text, Lorem Ipsum is simply dummy text",
        date: "9 Oct, 24",
        time: "7:12 AM",
        owner: Owner(id: "101", name: "Mr. Alan")),
    Comments(
        id: "2",
        body: "Sample looks good",
        date: "9 Oct, 24",
        time: "8:12 AM",
        owner: Owner(id: "102", name: "Akash")),
    Comments(
        id: "3",
        body: "Need more sample",
        time: "9:12 AM",
        date: "9 Oct, 24",
        owner: Owner(id: "103", name: "Md. Alamgir")),
  ];*/

  @override
  void dispose() {
    _bodyController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // delay the call to `getComments()` using addPostFrameCallback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // fetch the comments after the widget has been built
      Provider.of<InquiryViewModel>(context, listen: false)
          .getComments(widget.inquiryId, "0");
      _scrollToBottom();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Palette.mainColor,
        centerTitle: false,
        title: TextViewCustom(
          text: Strings.post_comment,
          fontSize: Converts.c20,
          tvColor: Colors.white,
          isTextAlignCenter: false,
          isBold: true,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
      ),
      body: Consumer<InquiryViewModel>(
          builder: (context, inquiryViewModel, child) {
        // handle loading view
        /*if (inquiryViewModel.uiState == UiState.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        else*/
        // handle error view
        if (inquiryViewModel.uiState == UiState.error) {
          return Center(
            child: ErrorContainer(
                message: inquiryViewModel.message != null
                    ? inquiryViewModel.message!
                    : Strings.something_went_wrong),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: inquiryViewModel.commentResponse != null
                    ? inquiryViewModel.commentResponse!.length
                    : 0,
                itemBuilder: (context, index) {
                  return CommentList(
                      comment: inquiryViewModel.commentResponse![index]);
                },
              ),
            ),
            const Divider(
              thickness: 0.5, // Thickness of the line
              color: Palette.semiNormalTv, // Color of the line
            ),
            Padding(
              padding: EdgeInsets.only(left: Converts.c8, right: Converts.c8),
              child: Row(
                children: [
                  Expanded(
                    child: TextFieldInquiry(
                      fontSize: Converts.c16,
                      fontColor: Palette.normalTv,
                      hintColor: Palette.semiNormalTv,
                      hint: Strings.type_a_comment,
                      controller: _bodyController,
                      maxLine: 1,
                      hasBorder: false,
                    ),
                  ),
                  IconButton(
                    icon: inquiryViewModel.uiState == UiState.loading
                        ? SizedBox(
                            width: Converts.c16,
                            height: Converts.c16,
                            child: const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Palette.mainColor),
                              strokeWidth: 2.0,
                            ),
                          )
                        : const Icon(
                            Icons.send,
                            color: Palette.mainColor,
                          ),
                    onPressed: () async {
                      String userId = await _getUserInfo();
                      String name = await _getUserInfo(isName: true);
                      if (_bodyController.text != "") {
                        // save comment
                        await inquiryViewModel.saveComment(
                          widget.inquiryId,
                          _bodyController.text,
                          "0", // task id must be '0'
                          userId,
                        );
                        // handle error view
                        if (inquiryViewModel.uiState == UiState.error) {
                          _showMessage("Error: ${inquiryViewModel.message}");
                        }
                        // check the status of the request
                        else {
                          if (inquiryViewModel.isSavedInquiry != null) {
                            if (inquiryViewModel.isSavedInquiry!) {
                              //_addComment(name);
                              setState(() {
                                inquiryViewModel.commentResponse!.add(Discussion(
                                    body: _bodyController.text,
                                    dateTime:
                                    DateTime.now().toFormattedString(format: "dd MMM, yy'T'h:mm a"),
                                    staffId: userId,
                                    name: name));
                                _bodyController.text = "";
                                _scrollToBottom();
                              });

                            } else {
                              _showMessage(Strings.failed_to_save_the_data);
                            }
                          } else {
                            _showMessage(Strings.data_is_missing);
                          }
                        }
                      } else {
                        _showMessage(Strings.some_values_are_missing);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Future<String> _getUserInfo({bool isName = false}) async {
    try {
      UserResponse? userResponse = await SPHelper().getUser();
      String id = userResponse != null ? userResponse.users![0].staffId! : "";
      String name =
          userResponse != null ? userResponse.users![0].staffName! : "";
      return isName ? name : id;
    } catch (e) {
      return "";
    }
  }

  _showMessage(String message) {
    final snackBar = SnackBar(
      content: TextViewCustom(
        text: message,
        tvColor: Colors.white,
        fontSize: Converts.c16,
        isBold: false,
        isRubik: true,
        isTextAlignCenter: false,
      ),
      action: SnackBarAction(
        label: 'Ok',
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // scroll to the bottom of the ListView
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300), // Animation duration
        curve: Curves.easeOut, // Animation curve
      );
    }
  }

}
