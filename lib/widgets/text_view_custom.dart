import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class TextViewCustom extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color tvColor;
  final bool isBold;
  final bool isDecodeNeeded;
  final bool isTextAlignCenter;
  final bool isRubik;

  const TextViewCustom(
      {super.key,
      required this.text,
      required this.fontSize,
      required this.tvColor,
      required this.isBold,
      this.isDecodeNeeded = true,
      this.isTextAlignCenter = true,
      this.isRubik = true});

  /// Safely attempt URI decoding; returns the original string on failure.
  static String _safeDecode(String value) {
    try {
      return Uri.decodeComponent(value);
    } catch (_) {
      return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      isDecodeNeeded ? _safeDecode(text) : text,
      textAlign: isTextAlignCenter ? TextAlign.center : TextAlign.start,
      style: !isRubik
          ? GoogleFonts.roboto(
              fontSize: fontSize,
              color: tvColor,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            )
          : GoogleFonts.rubik(
              fontSize: fontSize,
              color: tvColor,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
    );
  }
}
