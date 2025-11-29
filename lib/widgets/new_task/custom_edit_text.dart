import 'package:flutter/material.dart';

import '../../config/converts.dart';

class CustomEditText extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final bool obscure;
  final Widget? suffix;
  final ValueChanged<String>? onChanged;

  const CustomEditText({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.suffix,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: Converts.c16 - 2)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            onChanged: onChanged,
            obscureText: obscure,
            decoration: InputDecoration(
              icon: Icon(icon),
              hintText: hint,
              border: InputBorder.none,
              suffixIcon: suffix,
            ),
          ),
        ),
      ],
    );
  }
}
