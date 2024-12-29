import 'package:flutter/material.dart';
import 'package:tmbi/config/converts.dart';
import 'package:tmbi/config/palette.dart';
import 'package:tmbi/widgets/text_view_custom.dart';

import '../models/models.dart';

class ComboBoxCompany extends StatefulWidget {
  final String hintName;
  final List<Company> items;
  final Function(String) onChanged;

  const ComboBoxCompany({
    super.key,
    required this.hintName,
    required this.items,
    required this.onChanged,
  });

  @override
  State<ComboBoxCompany> createState() => _ComboBoxCompanyState();
}

class _ComboBoxCompanyState extends State<ComboBoxCompany> {
  String? selectedValue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.items.isNotEmpty && widget.items.length == 1) {
      selectedValue = widget.items[0].id.toString();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onChanged(selectedValue!);
      });
    }
  }

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
          text: widget.hintName,
          tvColor: Palette.semiTv,
          fontSize: Converts.c16,
          isBold: false,
        ),
        value: selectedValue,
        items: widget.items.map((Company company) {
          return DropdownMenuItem<String>(
            value: company.id.toString(),
            child: Text(
              company.name ?? "",
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
        //onChanged: (value) => onChanged(value ?? ""));
        onChanged: (value) {
          setState(() {
            selectedValue = value!;
          });
          widget.onChanged(value ?? "");
        });
  }

}
