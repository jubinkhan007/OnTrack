import 'package:flutter/material.dart';
import 'package:tmbi/config/converts.dart';
import 'package:tmbi/config/extension_file.dart';
import 'package:tmbi/config/palette.dart';
import 'package:tmbi/widgets/text_view_custom.dart';

import '../config/strings.dart';

class DateSelectionView extends StatefulWidget {
  final Function(String?) onDateSelected;
  String hint;
  bool isFromTodo;
  bool isDateSelected;

  DateSelectionView({
    super.key,
    required this.onDateSelected,
    this.hint = Strings.select_a_date,
    this.isFromTodo = false,
    this.isDateSelected = false,
  });

  @override
  State<DateSelectionView> createState() => _DateSelectionViewState();
}

class _DateSelectionViewState extends State<DateSelectionView> {
  //String? _selectedDate;
  String? _selectedDate = DateTime.now().toFormattedString(
    format: "yyyy-MM-dd",
  );

  @override
  Widget build(BuildContext context) {
    return widget.isFromTodo
        ? Material(
            color: Colors.transparent,
            child: IconButton(
              icon: Icon(
                Icons.date_range,
                size: Converts.c16,
                color:
                    widget.isDateSelected ? Palette.mainColor : Palette.semiTv,
              ),
              onPressed: () {
                _selectDate(context);
              },
            ),
          )
        : GestureDetector(
            onTap: () => _selectDate(context),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey, // Border color
                  width: 1.0, // Border width
                ),
                borderRadius:
                    BorderRadius.circular(Converts.c8), // Rounded corners
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextViewCustom(
                        text: _selectedDate ?? widget.hint,
                        fontSize: Converts.c16,
                        tvColor: Palette.semiTv,
                        isTextAlignCenter: false,
                        isBold: false),
                  ),
                  Icon(
                    Icons.calendar_today,
                    color: Palette.semiTv,
                    size: Converts.c16,
                  ),
                ],
              ),
            ),
          );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate =
            "${pickedDate.toLocal()}".split(' ')[0]; // Format the date
        widget.onDateSelected(_selectedDate);
      });
    }
  }
}
