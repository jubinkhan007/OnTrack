import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmbi/config/converts.dart';
import 'package:tmbi/config/palette.dart';
import 'package:tmbi/models/models.dart';

import '../../config/strings.dart';
import '../../network/ui_state.dart';
import '../../viewmodel/viewmodel.dart';
import '../../widgets/widgets.dart';

class UpdateTaskDialog extends StatelessWidget {
  final TextEditingController descriptionController = TextEditingController();

  // files
  final List<ImageFile> imageFiles = [];
  String mStatusId = "";

  UpdateTaskDialog({super.key});

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

    return AlertDialog(
      title: TextViewCustom(
        text: Strings.update_task,
        tvColor: Palette.normalTv,
        fontSize: Converts.c16,
        isBold: true,
      ),
      content: Consumer<InquiryCreateViewModel>(
          builder: (context, inquiryViewModel, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// status
            ComboBoxPriority(
              hintName: Strings.select,
              items: [
                Priority(id: 1, name: "Update"),
                Priority(id: 2, name: "Completed"),
              ],
              onChanged: (id) {
                mStatusId = id;
              },
            ),

            SizedBox(
              height: Converts.c8,
            ),

            /// description
            TextFieldInquiry(
              fontSize: Converts.c16,
              fontColor: Palette.normalTv,
              hintColor: Palette.semiTv,
              hint: Strings.enter_brief_description,
              controller: descriptionController,
              maxLine: 3,
              hasBorder: true,
            ),

            SizedBox(
              height: Converts.c8,
            ),

            /// file
            TextViewCustom(
                text: Strings.attachment,
                fontSize: Converts.c16,
                tvColor: Palette.normalTv,
                isRubik: false,
                isBold: true),
            SizedBox(
              height: Converts.c8,
            ),

            FileAttachment(
              onFileAttached: (files) {
                if (files != null) {
                  if (imageFiles.isNotEmpty) {
                    imageFiles.clear();
                  }
                  imageFiles.addAll(files);
                  debugPrint(imageFiles.length.toString());
                }
              },
            ),
            SizedBox(
              height: Converts.c16,
            ),

            /// update button
            ButtonCustom1(
                btnText: Strings.update,
                btnHeight: Converts.c48,
                bgColor: Palette.mainColor,
                btnWidth: double.infinity,
                cornerRadius: 4,
                isLoading: inquiryViewModel.uiState == UiState.loading,
                stockColor: Palette.mainColor,
                onTap: () async {
                  if (mStatusId != "") {
                    // upload files, if any are selected
                    if (imageFiles.isNotEmpty) {
                      await inquiryViewModel.saveFiles(imageFiles);
                    }
                    // save inquiry
                    await inquiryViewModel.saveInquiry(
                        "X",
                        mStatusId,
                        "X",
                        descriptionController.text,
                        "X",
                        "2024-11-15",
                        "X",
                        "X",
                        "X",
                        "340553",
                        inquiryViewModel.files);
                    if (inquiryViewModel.uiState == UiState.error) {
                      showMessage("Error: ${inquiryViewModel.message}");
                    }
                    // check the status of the request
                    else {
                      if (inquiryViewModel.isSavedInquiry != null) {
                        if (inquiryViewModel.isSavedInquiry!) {
                          showMessage(Strings.data_saved_successfully);
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
        );
      }),
    );
  }
}
