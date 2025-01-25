import 'package:flutter/material.dart';
import 'package:tmbi/config/converts.dart';
import 'package:tmbi/models/home_flag.dart';
import 'package:tmbi/widgets/text_view_custom.dart';

import '../../config/palette.dart';

class CustomDropdown extends StatefulWidget {
  final List<HomeFlag> items;

  //final List<String> items;
  final String hintName;
  final ValueChanged<HomeFlag?> onChanged;

  //final ValueChanged<String?> onChanged;

  const CustomDropdown(
      {super.key,
      required this.items,
      required this.hintName,
      required this.onChanged});

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  HomeFlag? selectedItem;

  //String? selectedItem;

  @override
  void initState() {
    super.initState();
    selectedItem = widget.items.isNotEmpty ? widget.items[0] : null;
    //selectedItem = widget.items.isNotEmpty ? widget.items[0] : "";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
      decoration: BoxDecoration(
        gradient: Palette.createRoomGradient, // Set gradient as background
        borderRadius: BorderRadius.circular(4), // Rounded corners
      ),
      //child: DropdownButton<String>(
      child: DropdownButton<HomeFlag>(
        value: selectedItem,
        // This will be the value of the selected item
        hint: TextViewCustom(
          text: widget.hintName,
          fontSize: Converts.c12,
          tvColor: Palette.semiTv,
          isBold: true,
        ),
        onChanged: (HomeFlag? newValue) {
          setState(() {
            selectedItem = newValue;
            //widget.onChanged(newValue);
          });
          widget.onChanged(newValue);
        },
        /*onChanged: (String? newValue) {
          setState(() {
            //selectedItem = newValue;
            //widget.onChanged(newValue);
          });
          //widget.onChanged(newValue);
        },*/
        items: widget.items.map<DropdownMenuItem<HomeFlag>>((HomeFlag value) {
          return DropdownMenuItem<HomeFlag>(
            value: value,
            child: TextViewCustom(
              text: value.title,
              fontSize: Converts.c12,
              tvColor: Palette.semiTv,
              isBold: true,
            ),
          );
        }).toList(),
        /*items: widget.items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: TextViewCustom(
              text: value,
              fontSize: Converts.c12,
              tvColor: Palette.semiTv,
              isBold: true,
            ),
          );
        }).toList(),*/
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

/*
class CustomDropdown extends StatefulWidget {
  final List<HomeFlag> items;
  final String hintName;
  final ValueChanged<HomeFlag?> onChanged;

  const CustomDropdown({
    super.key,
    required this.items,
    required this.hintName,
    required this.onChanged,
  });

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  HomeFlag? selectedItem;

  @override
  void initState() {
    super.initState();
    // Default selection (first item or null)
    selectedItem = widget.items.isNotEmpty ? widget.items[0] : null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.green],
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButton<HomeFlag>(
        value: selectedItem,
        hint: Text(
          widget.hintName,
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        onChanged: (HomeFlag? newValue) {
          setState(() {
            selectedItem = newValue;
          });
          if (newValue != null) {
            // Toggle the selection of the item when it's selected
            newValue.toggleButton();
            widget.onChanged(newValue);
          }
        },
        items: widget.items.map<DropdownMenuItem<HomeFlag>>((HomeFlag value) {
          return DropdownMenuItem<HomeFlag>(
            //value: value, // Set the value as HomeFlag object
            value: value, // Set the value as HomeFlag object
            child: TextViewCustom(
              text: value.title, // Display the title, but store the full object
              fontSize: Converts.c12,
              tvColor: Palette.semiTv,
              isBold: true,
            ),
          );
        }).toList(),
        iconSize: 24,
        isDense: true,
        style: TextStyle(color: Colors.black),
        underline: Container(), // Remove underline
      ),
    );
  }
}
*/
