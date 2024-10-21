import 'package:flutter/material.dart';
import 'package:tmbi/config/converts.dart';
import 'package:tmbi/widgets/text_view_custom.dart';

class ComboBoxCustom extends StatelessWidget {
  final String hintName;
  final List<String> items;

  const ComboBoxCustom(
      {super.key, required this.hintName, required this.items});

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
          tvColor: Colors.black54,
          fontSize: Converts.c16,
          isBold: false,
        ),
        /*items: [
          DropdownMenuItem<String>(
            value: "Option 1",
            child: TextViewCustom(
              text: "Walker",
              tvColor: Colors.black54,
              fontSize: Converts.c16,
              isBold: false,
            ),
          ),
          DropdownMenuItem<String>(
            value: "Option 2",
            child: TextViewCustom(
              text: "Winner",
              tvColor: Colors.black54,
              fontSize: Converts.c16,
              isBold: false,
            ),
          ),
        ],*/
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: TextViewCustom(
              text: item,
              tvColor: Colors.black54,
              fontSize: Converts.c16,
              isBold: false,
            ),
          );
        }).toList(),
        onChanged: (value) {});
  }
}
