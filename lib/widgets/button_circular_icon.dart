import 'package:flutter/material.dart';
import 'package:tmbi/widgets/widgets.dart';

class ButtonCircularIcon extends StatelessWidget {
  final double height;
  final double width;
  final double radius;
  final Color bgColor;
  final Color? tvColor;
  final String? text;
  final IconData? iconData;
  final double iconSize;
  final double fontSize;
  final bool hasOpacity;
  final VoidCallback onTap;

  const ButtonCircularIcon({
    super.key,
    required this.height,
    required this.width,
    required this.radius,
    required this.bgColor,
    this.tvColor,
    this.text,
    this.iconData,
    this.iconSize = 16,
    this.fontSize = 16,
    this.hasOpacity = true,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: hasOpacity ? bgColor.withOpacity(0.1) : bgColor,
        borderRadius: BorderRadius.all(
          Radius.circular(radius),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          iconData != null
              ? Icon(
                  iconData,
                  color: tvColor != null ? tvColor! : bgColor,
                  size: iconSize,
                )
              : const SizedBox.shrink(),
          const SizedBox(
            width: 4,
          ),
          text != null
              ? TextViewCustom(
                  text: text!,
                  fontSize: fontSize,
                  tvColor: tvColor != null ? tvColor! : bgColor,
                  isTextAlignCenter: false,
                  isBold: false)
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
