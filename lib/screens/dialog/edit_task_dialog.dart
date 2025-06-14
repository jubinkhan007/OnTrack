import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmbi/config/converts.dart';
import 'package:tmbi/config/palette.dart';
import 'package:tmbi/models/models.dart';
import 'package:tmbi/viewmodel/task_update_viewmodel.dart';

import '../../config/sp_helper.dart';
import '../../config/strings.dart';
import '../../models/user_response.dart';
import '../../network/ui_state.dart';
import '../../widgets/widgets.dart';

class EditTaskDialog extends StatefulWidget {
  //final InquiryResponse inquiryResponse;
  final String inquiryId;
  final Task task;

  final Function(String, String, String, bool) onSave;

  const EditTaskDialog(
      {super.key,
      required this.inquiryId,
      required this.task,
      required this.onSave});

  @override
  State<EditTaskDialog> createState() => _UpdateTaskDialogState();
}

class _UpdateTaskDialogState extends State<EditTaskDialog> {
  late TextEditingController descriptionController;

  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    descriptionController =
        TextEditingController(text: Uri.decodeComponent(widget.task.name));
    //final taskUpdateViewModel =
        //Provider.of<TaskUpdateViewModel>(context, listen: false);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    descriptionController.clear();
  }



  @override
  Widget build(BuildContext context) {
    showMessage(String message) {
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

    //return AlertDialog(
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Converts.c16)),
      /*title: TextViewCustom(
        text: Strings.update_task,
        tvColor: Palette.normalTv,
        fontSize: Converts.c16,
        isBold: true,
      ),*/
      //content: Consumer<InquiryCreateViewModel>(
      child:
          Consumer<TaskUpdateViewModel>(builder: (context, viewmodel, child) {
        return Padding(
          padding: EdgeInsets.all(Converts.c16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// title
                TextViewCustom(
                  text: Strings.edit_task,
                  tvColor: Palette.normalTv,
                  fontSize: Converts.c16,
                  isBold: true,
                ),
                SizedBox(
                  height: Converts.c16,
                ),

                /// description
                TextFieldInquiry(
                  fontSize: Converts.c16,
                  fontColor: Palette.normalTv,
                  hintColor: Palette.semiTv,
                  hint: Strings.enter_brief_description,
                  controller: descriptionController,
                  maxLine: 6,
                  hasBorder: true,
                ),

                SizedBox(
                  height: Converts.c8,
                ),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: Text(
                        "Also update this task for other users it may be assigned to.(if any)",
                        style: TextStyle(fontSize: Converts.c16),
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: Converts.c20,
                ),

                /// update button
                ButtonCustom1(
                    btnText: Strings.save,
                    btnHeight: Converts.c48,
                    bgColor: Palette.mainColor,
                    btnWidth: double.infinity,
                    cornerRadius: 4,
                    isLoading: viewmodel.uiState == UiState.loading,
                    stockColor: Palette.mainColor,
                    onTap: () async {
                      String userId = await _getUserId();
                      //debugPrint("END_DATE:: $_selectedDate");
                      //widget.onSave(descriptionController.text, "", "", true);
                      //if (mStatusId != "") {
                      if (descriptionController.text != "") {
                        // save inquiry
                        await viewmodel.editTask(
                            widget.inquiryId,
                            widget.task.id.toString(),
                            isChecked.toString(),
                            Uri.encodeComponent(descriptionController.text),
                            userId,
                            []);
                        if (viewmodel.uiState == UiState.error) {
                          showMessage("Error: ${viewmodel.message}");
                        }
                        // check the status of the request
                        else {
                          if (viewmodel.isSavedInquiry != null) {
                            if (viewmodel.isSavedInquiry!) {
                              showMessage(Strings.data_saved_successfully);
                              widget.onSave(descriptionController.text, "", "", isChecked);
                              Navigator.pop(context);
                            } else {
                              showMessage(Strings.failed_to_save_the_data);
                            }
                          } else {
                            showMessage(Strings.data_is_missing);
                          }
                        }
                      } else {
                        showMessage(Strings.some_values_are_missing);
                      }
                    }),
              ],
            ),
          ),
        );
      }),
    );
  }

  Future<String> _getUserId() async {
    try {
      UserResponse? userResponse = await SPHelper().getUser();
      String name = userResponse != null ? userResponse.users![0].staffId! : "";
      return name;
    } catch (e) {
      return "";
    }
  }
}
