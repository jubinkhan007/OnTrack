import 'package:flutter/material.dart';


class TextFieldInquiry extends StatelessWidget {
  final double fontSize;
  final Color fontColor;
  final Color hintColor;
  final String hint;
  final TextEditingController controller;
  final bool hasBorder;
  final int maxLine;

  const TextFieldInquiry({
    super.key,
    required this.fontSize,
    required this.fontColor,
    required this.hintColor,
    required this.hint,
    required this.controller,
    this.hasBorder = false,
    this.maxLine = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLine,
      style: TextStyle(
        fontSize: fontSize, // Hint text size
        color: fontColor, // Text color
      ),
      decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: fontSize, // Hint text size
            color: hintColor, // Hint text color
          ),
          border:
              hasBorder ? const OutlineInputBorder() : const UnderlineInputBorder(),
          enabledBorder: hasBorder
              ? const OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.grey, width: 1.0), // Enabled border style
                )
              : const UnderlineInputBorder()),
    );
  }
}
