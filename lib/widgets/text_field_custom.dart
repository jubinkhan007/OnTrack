import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextFieldCustom extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final bool obscureText;
  final TextInputType textInputType;
  final double cpVertical;
  final double cpHorizontal;
  final Color focusedColor;
  final Color hintColor;
  final Color iconColor;
  final double hintFontSize;
  final IconData icon;
  final double iconSize;
  final String? Function(String?)? validator;

  const TextFieldCustom(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obscureText,
      required this.textInputType,
      required this.cpVertical,
      required this.cpHorizontal,
      required this.focusedColor,
      required this.hintColor,
      required this.iconColor,
      required this.hintFontSize,
      required this.icon,
      required this.iconSize,
      required this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: textInputType,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          vertical: cpVertical,
          horizontal: cpHorizontal,
        ),
        hintText: hintText,
        hintStyle: GoogleFonts.rubik(
            color: hintColor,
            fontWeight: FontWeight.normal,
            fontSize: hintFontSize),
        prefixIcon: Container(
          margin: const EdgeInsets.only(right: 4),
          decoration: BoxDecoration(
            color: focusedColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              bottomLeft: Radius.circular(6),
            ), // Adjust the radius as needed
          ),
          child: Icon(
            icon,
            size: iconSize, // Adjust the size as needed
            color: iconColor, // Adjust the color as needed
          ),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: focusedColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: focusedColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: focusedColor),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.redAccent, width: 2),
        ),
      ),
      obscureText: obscureText,
      validator: validator,
    );
  }
}
