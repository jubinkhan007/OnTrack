import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton2 extends StatelessWidget {
  final String text;
  final bool isLoading;
  final double height;
  final Color bgColor;
  final Color tvColor;
  final VoidCallback onTap;

  const CustomButton2({
    super.key,
    required this.text,
    this.isLoading = false,
    required this.height,
    required this.bgColor,
    required this.tvColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, height),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: bgColor,
      ),
      child: isLoading
          ? SizedBox(
              height: height - 16,
              width: height - 16,
              child: const CircularProgressIndicator(
                strokeWidth: 1,
                color: Colors.white,
              ),
            )
          : Text(
              text,
              style: GoogleFonts.roboto(color: tvColor),
            ),
    );
  }
}
