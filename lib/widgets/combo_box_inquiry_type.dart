import 'package:flutter/material.dart';
import 'package:tmbi/config/converts.dart';
import 'package:tmbi/config/palette.dart';
import 'package:tmbi/widgets/text_view_custom.dart';

import '../models/models.dart';

class ComboBoxInquiryType extends StatelessWidget {
  final String hintName;
  final List<InquiryType> items;
  final Function(String) onChanged;

  const ComboBoxInquiryType(
      {super.key,
      required this.hintName,
      required this.items,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
        decoration: InputDecoration(
          //contentPadding: EdgeInsets.symmetric(vertical: 8.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0), // Rounded corners
            borderSide: const BorderSide(
              color: Colors.grey, // Border color
              width: 0.5, // Border width
            ),
          ),
          filled: true, // Optional: background color
          fillColor: Colors.white, // Background color
        ),
        hint: TextViewCustom(
          text: hintName,
          tvColor: Palette.semiTv,
          fontSize: Converts.c16,
          isBold: false,
        ),
        items: items.map((InquiryType inquiryTYpe) {
          return DropdownMenuItem<String>(
            value: inquiryTYpe.id.toString(),
            child: TextViewCustom(
              text: inquiryTYpe.name ?? "",
              tvColor: Palette.normalTv,
              fontSize: Converts.c16,
              isBold: false,
            ),
          );
        }).toList(),
        onChanged: (value) {
          onChanged(value ?? "");
        });
  }
}
