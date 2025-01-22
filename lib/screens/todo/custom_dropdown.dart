import 'package:flutter/material.dart';
import 'package:tmbi/config/converts.dart';
import 'package:tmbi/widgets/text_view_custom.dart';

import '../../config/palette.dart';

class CustomDropdown extends StatefulWidget {
  final List<String> items;
  final String hintName;
  final ValueChanged<String> onChanged;

  const CustomDropdown(
      {super.key,
      required this.items,
      required this.hintName,
      required this.onChanged});

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? selectedItem;

  @override
  void initState() {
    super.initState();
    selectedItem = widget.items.isNotEmpty ? widget.items[0] : null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
      decoration: BoxDecoration(
        gradient: Palette.createRoomGradient, // Set gradient as background
        borderRadius: BorderRadius.circular(4), // Rounded corners
      ),
      child: DropdownButton<String>(
        value: selectedItem,
        // This will be the value of the selected item
        hint: TextViewCustom(
          text: widget.hintName,
          fontSize: Converts.c12,
          tvColor: Palette.semiTv,
          isBold: true,
        ),
        onChanged: (String? newValue) {
          setState(() {
            selectedItem = newValue;
          });
          widget.onChanged(newValue ?? "");
        },
        items: widget.items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: TextViewCustom(
              text: value,
              fontSize: Converts.c12,
              tvColor: Palette.semiTv,
              isBold: true,
            ),
          );
        }).toList(),
        iconSize: Converts.c12,
        isDense: true,
        // Reduce padding inside the dropdown button
        style: const TextStyle(color: Palette.semiTv),
        // Customize text style
        underline: Container(), // Remove underline
      ),
    );
  }
}
