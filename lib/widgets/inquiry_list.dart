import 'package:flutter/material.dart';
import 'package:tmbi/config/palette.dart';
import 'package:tmbi/widgets/widgets.dart';

import '../config/converts.dart';
import '../models/models.dart';

class InquiryList extends StatelessWidget {
  final InquiryResponse inquiryResponse;
  final VoidCallback onTap;
  final Function(String) onCommentTap;
  final Function(String) onAttachmentTap;

  const InquiryList(
      {super.key,
      required this.inquiryResponse,
      required this.onTap,
      required this.onCommentTap,
      required this.onAttachmentTap});

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
        elevation: 4, // Shadow effect
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// title
              TextViewCustom(
                  text: inquiryResponse.title,
                  fontSize: Converts.c20,
                  tvColor: Palette.normalTv,
                  isTextAlignCenter: false,
                  isRubik: false,
                  isBold: true),

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
                  TextViewCustom(
                    text: inquiryResponse.customer != null
                        ? inquiryResponse.customer.name!
                        : "",
                    fontSize: Converts.c16,
                    tvColor: Palette.semiTv,
                    isTextAlignCenter: false,
                    isBold: false,
                  ),
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
                      text: inquiryResponse.company,
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
                    iconData: Icons.attach_file,
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
