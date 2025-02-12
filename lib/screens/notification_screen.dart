import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tmbi/widgets/load_image.dart';

import '../config/converts.dart';
import '../config/palette.dart';
import '../config/strings.dart';
import '../widgets/text_view_custom.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  static const String routeName = '/notification_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.mainColor,
        centerTitle: false,
        title: TextViewCustom(
          text: Strings.notification,
          fontSize: Converts.c20,
          tvColor: Colors.white,
          isTextAlignCenter: false,
          isRubik: false,
          isBold: true,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          // Customize icon color
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
      ),
      body: Column(
        children: [
          notyItem("Md: Salauddin", "340553", "added a", "Task", "for you to complete.",
              "11 feb, 2025"),
          notyItem("Md: Emrul Kaish", "397820", "added a comment to this", "Task.", "",
              "11 feb, 2025")
        ],
      ),
    );
  }

  Widget richTextCommon(
      String text1, String text2, String text3, String text4) {
    return RichText(
      text: TextSpan(children: [
        TextSpan(
            text: "$text1 ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black, // Bold and clickable part
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                debugPrint(text1);
              }),
        TextSpan(
          text: text2,
          style: const TextStyle(
            //fontWeight: FontWeight.bold,
            color: Palette.normalTv, // Bold and clickable part
          ),
        ),
        TextSpan(
            text: " $text3 ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black, // Bold and clickable part
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                debugPrint(text3);
              }),
        TextSpan(
          text: text4,
          style: const TextStyle(
            //fontWeight: FontWeight.bold,
            color: Palette.normalTv, // Bold and clickable part
          ),
        ),
      ]),
    );
  }

  Widget notyItem(
      String name, String id, String title1, String title2, String title3, String date) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 2, bottom: 0),
      child: Material(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        elevation: 0.5,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              LoadImage(
                  id: id, height: Converts.c32, width: Converts.c32),
              SizedBox(
                width: Converts.c8,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    richTextCommon(name, title1, title2, title3),
                    SizedBox(
                      height: Converts.c8,
                    ),
                    TextViewCustom(
                        text: date,
                        fontSize: Converts.c16 - 2,
                        tvColor: Palette.grayColor,
                        isBold: false)
                  ],
                ),
              ),
              Container(
                height: Converts.c8,
                width: Converts.c8,
                decoration: BoxDecoration(
                  color: Palette.online.withOpacity(0.5),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Palette.online, // Border color
                    width: 0.5, // Border width
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
