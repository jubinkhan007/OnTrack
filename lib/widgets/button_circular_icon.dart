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
  final bool isTvBold;
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
    this.isTvBold = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        //width: width,
        //height: height,
        decoration: BoxDecoration(
          color: hasOpacity ? bgColor.withOpacity(0.5) : bgColor,
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
            SizedBox(
              width: iconData != null ? 4 : 0,
            ),
            text != null
                ? Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8.0, top: 2, bottom: 2),
                    child: TextViewCustom(
                        text: text!,
                        fontSize: fontSize,
                        tvColor: tvColor != null ? tvColor! : bgColor,
                        isTextAlignCenter: false,
                        isBold: isTvBold),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
