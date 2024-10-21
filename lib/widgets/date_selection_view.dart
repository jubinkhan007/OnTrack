import 'package:flutter/material.dart';
import 'package:tmbi/config/converts.dart';
import 'package:tmbi/widgets/text_view_custom.dart';

import '../config/strings.dart';

class DateSelectionView extends StatefulWidget {
  const DateSelectionView({super.key});

  @override
  State<DateSelectionView> createState() => _DateSelectionViewState();
}

class _DateSelectionViewState extends State<DateSelectionView> {
  String? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Container(
        padding: EdgeInsets.all(Converts.c16),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey, // Border color
            width: 1.0, // Border width
          ),
          borderRadius: BorderRadius.circular(Converts.c8), // Rounded corners
        ),
        child: Row(
          children: [
            Expanded(
              child: TextViewCustom(
                  text: _selectedDate ?? Strings.select_a_date,
                  fontSize: Converts.c16,
                  tvColor: Colors.black54,
                  isTextAlignCenter: false,
                  isBold: false),
            ),
             Icon(Icons.calendar_today, color: Colors.black54, size: Converts.c16,),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate =
            "${pickedDate.toLocal()}".split(' ')[0]; // Format the date
      });
    }
  }
}
