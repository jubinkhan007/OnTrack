import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmbi/config/converts.dart';
import 'package:tmbi/config/extension_file.dart';
import 'package:tmbi/config/palette.dart';
import 'package:tmbi/models/models.dart';
import 'package:tmbi/viewmodel/task_update_viewmodel.dart';

import '../../config/sp_helper.dart';
import '../../config/strings.dart';
import '../../models/user_response.dart';
import '../../network/ui_state.dart';
import '../../widgets/date_selection_view.dart';
import '../../widgets/widgets.dart';

class EditTaskDialog extends StatefulWidget {
  //final InquiryResponse inquiryResponse;
  final Task inquiryResponse;

  final Function(String, String, String, bool) onSave;

  EditTaskDialog(
      {super.key, required this.inquiryResponse, required this.onSave});

  @override
  State<EditTaskDialog> createState() => _UpdateTaskDialogState();
}

class _UpdateTaskDialogState extends State<EditTaskDialog> {
  late TextEditingController descriptionController;
  String? _selectedDate;

  @override
  void initState() {
    super.initState();
    descriptionController = TextEditingController(
        text: Uri.decodeComponent(widget.inquiryResponse.name));
    //_selectedDate = widget.inquiryResponse.endDate;
    final taskUpdateViewModel =
    Provider.of<TaskUpdateViewModel>(context, listen: false);
    _reset(taskUpdateViewModel);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    descriptionController.clear();
  }

  void _reset(TaskUpdateViewModel taskUpdateViewModel) {
    taskUpdateViewModel.removeImageFiles();
    taskUpdateViewModel.removeFiles();
    taskUpdateViewModel.addStatus("");
    taskUpdateViewModel.addStatusName("");
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
      child: Consumer<TaskUpdateViewModel>(
          builder: (context, inquiryViewModel, child) {
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

                    /// end date
                    /*Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextViewCustom(
                      text: _selectedDate == null
                          ? "End Date# ${widget.inquiryResponse.endDate}"
                          : "End Date# $_selectedDate",
                      tvColor: widget.inquiryResponse.endDate.isOverdue()
                          ? Palette.mainColor
                          : Palette.normalTv,
                      fontSize: Converts.c16,
                      isBold: true,
                    ),
                    DateSelectionView(
                      onDateSelected: (date) {
                        if (date != null) {
                          setState(() {
                            _selectedDate = date;
                            debugPrint(_selectedDate);
                          });
                        }
                      },
                      isFromTodo: true,
                      isDateSelected: false,
                    ),
                  ],
                ),*/

                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: false,
                          onChanged: (bool? value) {
                            setState(() {
                              //isChecked = value ?? false;
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
                        isLoading: inquiryViewModel.uiState == UiState.loading,
                        stockColor: Palette.mainColor,
                        onTap: () async {
                          String userId = await _getUserId();
                          //debugPrint("END_DATE:: $_selectedDate");
                          widget.onSave(
                              descriptionController.text, _selectedDate ?? "",
                              "", true);
                          //if (mStatusId != "") {
                          if (inquiryViewModel.status != null &&
                              inquiryViewModel.status != "" &&
                              descriptionController.text != "") {
                            // upload files, if any are selected
                            //if (imageFiles.isNotEmpty) {
                            if (inquiryViewModel.imageFiles.isNotEmpty) {
                              //await inquiryViewModel.saveFiles(imageFiles);
                              await inquiryViewModel
                                  .saveFiles(inquiryViewModel.imageFiles);
                            }
                            // save inquiry
                            /*   await inquiryViewModel.updateTask(
                            widget.inquiryId,
                            widget.task.id.toString(),
                            //mStatusId,
                            inquiryViewModel.status!,
                            //descriptionController.text,
                            Uri.encodeComponent(descriptionController.text),
                            userId,
                            inquiryViewModel.files);*/
                            if (inquiryViewModel.uiState == UiState.error) {
                              showMessage("Error: ${inquiryViewModel.message}");
                            }
                            // check the status of the request
                            else {
                              if (inquiryViewModel.isSavedInquiry != null) {
                                if (inquiryViewModel.isSavedInquiry!) {
                                  showMessage(Strings.data_saved_successfully);
                                  // reset value
                                  inquiryViewModel.addStatus("");
                                  inquiryViewModel.removeFiles();
                                  inquiryViewModel.removeImageFiles();
                                  // update task
                                  //onCall(mStatusId == "7" ? true : false, mStatusName);
                                  /* widget.onCall(
                                  mStatusId == "7" ? true : false,
                                  inquiryViewModel.statusName != null
                                      ? inquiryViewModel.statusName!
                                      : "");*/
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
