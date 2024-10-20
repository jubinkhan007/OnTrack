import 'package:flutter/material.dart';
import 'package:tmbi/config/palette.dart';
import 'package:tmbi/data/inquiry_response.dart';
import 'package:tmbi/widgets/widgets.dart';

import '../config/converts.dart';

class InquiryList extends StatelessWidget {
  final InquiryResponse inquiryResponse;
  final VoidCallback onTap;

  const InquiryList({super.key, required this.inquiryResponse, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        onTap();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Palette.cardColor,
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.all(8),
        //color: Colors.green,
        margin: const EdgeInsets.only(top: 8, right: 8, left: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// title
            TextViewCustom(
                text: inquiryResponse.title,
                fontSize: Converts.c20,
                tvColor: Colors.black,
                isTextAlignCenter: false,
                isBold: false),

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
                    color: Palette.circleColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(4),
                    ),
                  ),
                ),
                SizedBox(
                  width: Converts.c8,
                ),
                TextViewCustom(
                  text: inquiryResponse.buyerInfo.name,
                  fontSize: Converts.c16,
                  tvColor: Palette.semiTv,
                  isTextAlignCenter: false,
                  isBold: false,
                ),
                const SizedBox(
                  width: 4,
                ),
                inquiryResponse.buyerInfo.isVerified
                    ? Icon(
                        Icons.verified_user_rounded,
                        color: Palette.mainColor.withOpacity(0.5),
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
                tvColor: Palette.semiNormalTv,
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
                  color: Palette.semiTv,
                  size: Converts.c20,
                ),
                SizedBox(
                  width: Converts.c8,
                ),
                TextViewCustom(
                    text: inquiryResponse.company,
                    fontSize: Converts.c16,
                    tvColor: Palette.semiNormalTv,
                    isTextAlignCenter: false,
                    isBold: false),
              ],
            ),

            /// end date
            Row(
              children: [
                Icon(
                  Icons.timer_outlined,
                  color: Palette.semiTv,
                  size: Converts.c20,
                ),
                SizedBox(
                  width: Converts.c8,
                ),
                TextViewCustom(
                    text: inquiryResponse.endDate,
                    fontSize: Converts.c16,
                    tvColor: Palette.semiNormalTv,
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
                  text: inquiryResponse.commentCount.toString(),
                  iconData: Icons.chat,
                  radius: Converts.c20,
                  bgColor: Palette.mainColor,
                  onTap: () {},
                ),
                SizedBox(
                  width: Converts.c8,
                ),
                ButtonCircularIcon(
                  height: Converts.c32,
                  width: Converts.c72,
                  text: inquiryResponse.attachmentCount.toString(),
                  iconData: Icons.attach_file,
                  radius: Converts.c20,
                  bgColor: Palette.mainColor,
                  onTap: () {},
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
