import 'package:flutter/material.dart';
import 'package:tmbi/config/extension_file.dart';
import 'package:tmbi/config/palette.dart';
import 'package:tmbi/widgets/widgets.dart';

import '../config/converts.dart';
import '../models/models.dart';

class InquiryList extends StatelessWidget {
  final InquiryResponse inquiryResponse;
  final int selectedFlagIndex;
  final String staffId;
  final VoidCallback onTap;
  final Function(String) onCommentTap;
  final Function(String) onAttachmentTap;
  final Function(String) onDeleteTap;

  const InquiryList(
      {super.key,
      required this.inquiryResponse,
      required this.selectedFlagIndex,
      required this.staffId,
      required this.onTap,
      required this.onCommentTap,
      required this.onAttachmentTap,
      required this.onDeleteTap});

  /*bool _isDateOverdue(String inputDateString) {
    final dateFormat = DateFormat("d MMM, yy");
    final DateTime targetDate = dateFormat.parse(inputDateString);
    final DateTime currentDate = DateTime.now();
    return currentDate.isAfter(targetDate);
  }*/

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4), // Rounded corners
          //side: BorderSide(color: Colors.blue, width: 2), // Border color and width
        ),
        elevation: 4,
        // Shadow effect
        //color: _isDateOverdue(inquiryResponse.endDate) && selectedFlagIndex == 0
        color: inquiryResponse.endDate.isOverdue() && selectedFlagIndex == 0
            ? Colors.deepOrange.withOpacity(0.3)
            : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// title
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextViewCustom(
                        text: inquiryResponse.title,
                        fontSize: Converts.c20,
                        tvColor: Palette.normalTv,
                        isTextAlignCenter: false,
                        isRubik: false,
                        isBold: true),
                  ),
                  staffId == inquiryResponse.postedBy.staffId &&
                          selectedFlagIndex == 0
                      ? Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            // Allows padding to be tappable
                            onTapDown: (TapDownDetails details) {
                              showMenu(
                                context: context,
                                position: RelativeRect.fromLTRB(
                                  details.globalPosition.dx,
                                  details.globalPosition.dy,
                                  0,
                                  0,
                                ),
                                items: [
                                  const PopupMenuItem(
                                      value: 'delete', child: Text('Delete')),
                                  //const PopupMenuItem(value: 'edit', child: Text('Edit')),
                                ],
                              ).then((value) {
                                if (value == 'delete') {
                                  onDeleteTap(inquiryResponse.id.toString());
                                } /*else if (value == 'edit') {
                                    print('Edit tapped');
                                }*/
                              });
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.all(4), // Increase tap area
                              child: Icon(
                                Icons.more_vert,
                                size: Converts.c16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),

              /// user & buyer info
              Row(
                children: [
                  Icon(
                    Icons.account_circle,
                    color: Palette.semiTv,
                    size: Converts.c20,
                  ),
                  SizedBox(
                    width: Converts.c8,
                  ),
                  TextViewCustom(
                    text: inquiryResponse.postedBy.name,
                    fontSize: Converts.c16,
                    tvColor: Palette.semiTv,
                    isTextAlignCenter: false,
                    isBold: false,
                  ),
                  SizedBox(
                    width: Converts.c8,
                  ),
                  Container(
                    height: Converts.c8,
                    width: Converts.c8,
                    decoration: const BoxDecoration(
                      color: Palette.semiTv,
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: Converts.c8,
                  ),
                  //Expanded(
                  //child:
                  TextViewCustom(
                    text: inquiryResponse.customer != null
                        ? inquiryResponse.customer.name!
                        : "",
                    fontSize: Converts.c16,
                    tvColor: Palette.semiTv,
                    isTextAlignCenter: false,
                    isBold: false,
                  ),
                  //),
                  const SizedBox(
                    width: 4,
                  ),
                  inquiryResponse.customer!.isVerified!
                      ? Icon(
                          Icons.verified_user_rounded,
                          color: Palette.iconColor,
                          size: Converts.c16,
                        )
                      : const SizedBox.shrink(),
                ],
              ),
              SizedBox(
                height: Converts.c16,
              ),

              /// description
              TextViewCustom(
                  text: inquiryResponse.description,
                  fontSize: Converts.c16,
                  tvColor: Palette.semiTv,
                  isTextAlignCenter: false,
                  isBold: false),
              SizedBox(
                height: Converts.c8,
              ),

              /// company name
              if (inquiryResponse.company != null)
                Row(
                  children: [
                    Icon(
                      Icons.label_outline,
                      color: Palette.tabColor,
                      size: Converts.c20,
                    ),
                    SizedBox(
                      width: Converts.c8,
                    ),
                    TextViewCustom(
                        text: inquiryResponse.company!,
                        fontSize: Converts.c16,
                        tvColor: Palette.iconColor,
                        isTextAlignCenter: false,
                        isBold: false),
                  ],
                ),

              /// end date
              Row(
                children: [
                  Icon(
                    Icons.timer_outlined,
                    color: Palette.navyBlueColor,
                    size: Converts.c20,
                  ),
                  SizedBox(
                    width: Converts.c8,
                  ),
                  TextViewCustom(
                      text: inquiryResponse.endDate,
                      fontSize: Converts.c16,
                      tvColor: Palette.navyBlueColor,
                      isTextAlignCenter: false,
                      isBold: false),
                ],
              ),
              SizedBox(
                height: Converts.c8,
              ),

              /// comment & file section
              Row(
                children: [
                  ButtonCircularIcon(
                    height: Converts.c32,
                    width: Converts.c72,
                    text: inquiryResponse.comment.count,
                    iconData: Icons.chat,
                    radius: Converts.c20,
                    bgColor: Palette.iconColor,
                    hasOpacity: false,
                    tvColor: Colors.white,
                    onTap: () {
                      onCommentTap(inquiryResponse.id.toString());
                    },
                  ),
                  SizedBox(
                    width: Converts.c8,
                  ),
                  ButtonCircularIcon(
                    height: Converts.c32,
                    width: Converts.c72,
                    text: inquiryResponse.attachment.count,
                    iconData: Icons.image,
                    radius: Converts.c20,
                    bgColor: Palette.iconColor,
                    hasOpacity: false,
                    tvColor: Colors.white,
                    onTap: () {
                      onAttachmentTap(inquiryResponse.id.toString());
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
