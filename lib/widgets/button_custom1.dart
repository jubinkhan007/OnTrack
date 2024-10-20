import 'package:flutter/material.dart';
import 'package:tmbi/config/converts.dart';
import 'package:tmbi/widgets/text_view_custom.dart';

class ButtonCustom1 extends StatelessWidget {
  final String btnText;
  final double btnHeight;
  final double btnWidth;
  final double cornerRadius;
  final Color stockColor;
  final Color bgColor;
  bool isLoading;
  final VoidCallback onTap;

  ButtonCustom1(
      {super.key,
      required this.btnText,
      required this.btnHeight,
      required this.btnWidth,
      required this.cornerRadius,
      required this.stockColor,
      required this.bgColor,
      this.isLoading = false,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: btnHeight,
      width: btnWidth,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: stockColor,
          side: BorderSide(
            width: 1,
            color: stockColor,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(cornerRadius),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: Converts.c24,
                height: Converts.c24,
                child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2.0,
                ),
              )
            : TextViewCustom(
                text: btnText,
                fontSize: Converts.c16,
                tvColor: Colors.white,
                isBold: true,
              ),
      ),
    );
  }
}
