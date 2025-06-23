import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmbi/config/converts.dart';
import 'package:tmbi/config/palette.dart';
import 'package:tmbi/viewmodel/task_update_viewmodel.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/sp_helper.dart';
import '../../config/strings.dart';
import '../../models/user_response.dart';
import '../../network/ui_state.dart';
import '../../widgets/widgets.dart';

class UpdateUserInfoDialog extends StatefulWidget {
  final User user;
  final Function(bool, String, String) onUpdate;

  const UpdateUserInfoDialog(
      {super.key, required this.user, required this.onUpdate});

  @override
  State<UpdateUserInfoDialog> createState() => _UpdateUserInfoDialogState();
}

class _UpdateUserInfoDialogState extends State<UpdateUserInfoDialog> {
  late TextEditingController emailController; //= TextEditingController();
  late TextEditingController mobileNoController; //= TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailController = TextEditingController(text: widget.user.mailId ?? "");
    mobileNoController =
        TextEditingController(text: widget.user.mobileNo ?? "");
    final taskUpdateViewModel =
        Provider.of<TaskUpdateViewModel>(context, listen: false);
    _reset(taskUpdateViewModel);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.clear();
    mobileNoController.clear();
  }

  void _reset(TaskUpdateViewModel taskUpdateViewModel) {}

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

    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Converts.c16)),
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
                  text: Strings.update_info,
                  tvColor: Palette.normalTv,
                  fontSize: Converts.c16,
                  isBold: true,
                ),

                SizedBox(
                  height: Converts.c16,
                ),

                /// email
                TextFieldInquiry(
                  fontSize: Converts.c16,
                  fontColor: Palette.normalTv,
                  hintColor: Palette.semiTv,
                  hint: Strings.email,
                  controller: emailController,
                  //maxLine: 3,
                  hasBorder: true,
                ),

                SizedBox(
                  height: Converts.c8,
                ),

                /// mobile no
                TextFieldInquiry(
                  fontSize: Converts.c16,
                  fontColor: Palette.normalTv,
                  hintColor: Palette.semiTv,
                  hint: Strings.mobile_no,
                  controller: mobileNoController,
                  //maxLine: 3,
                  hasBorder: true,
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
                    isLoading: viewmodel.uiState == UiState.loading,
                    stockColor: Palette.mainColor,
                    onTap: () async {
                      String userId = await _getUserId();

                      if (emailController.text != "") {
                        await viewmodel.updateEmailMob(
                            emailController.text ?? "",
                            mobileNoController.text ?? "",
                            userId);
                        if (viewmodel.uiState == UiState.error) {
                          showMessage("Error: ${viewmodel.message}");
                        }
                        // check the status of the request
                        else {
                          if (viewmodel.isSavedInquiry != null) {
                            if (viewmodel.isSavedInquiry!) {
                              showMessage(Strings.data_saved_successfully);
                              //widget.onUpdate(true, emailController.text,mobileNoController.text);
                              //if (context.mounted) {
                                //Navigator.pop(context);
                                Navigator.of(context).pop({
                                  'email': emailController.text,
                                  'mobileNo': mobileNoController.text,
                                });
                             // }
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

  Future<void> openWhatsApp() async {
    final phone = '8801704133015';
    final message = '340553';
    final url =
        Uri.parse('https://wa.me/$phone?text=${Uri.encodeComponent(message)}');

    var whatsappUrl = Uri.parse(
        "whatsapp://send?phone=$phone&text=${Uri.encodeComponent("Your Message Here")}");
    try {
      launchUrl(whatsappUrl);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
