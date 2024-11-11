import 'package:flutter/material.dart';
import 'package:tmbi/config/converts.dart';
import 'package:tmbi/config/palette.dart';
import 'package:tmbi/widgets/text_view_custom.dart';

import '../models/models.dart';

class ComboBoxPriority extends StatelessWidget {
  final String hintName;
  final List<Priority> items;
  final Function(String) onChanged;

  const ComboBoxPriority(
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
        isExpanded: true,
        hint: TextViewCustom(
          text: hintName,
          tvColor: Palette.semiTv,
          fontSize: Converts.c16,
          isBold: false,
        ),
        items: items.map((Priority priority) {
          return DropdownMenuItem<String>(
            value: priority.id.toString(),
            child: /*TextViewCustom(
              text: priority.name ?? "",
              tvColor: Palette.normalTv,
              fontSize: Converts.c16,
              isBold: false,
            ),*/
                Text(
              priority.name ?? "",
              overflow: TextOverflow.ellipsis,
              // Add this line to handle overflow
              maxLines: 1,
              softWrap: true,
              // Optional: ensure only one line is shown
              style: TextStyle(
                color: Palette.normalTv,
                fontSize: Converts.c16,
              ),
            ),
          );
        }).toList(),
        onChanged: (value) {
          onChanged(value ?? "");
        });
  }
}
