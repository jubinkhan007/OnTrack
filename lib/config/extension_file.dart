import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/data.dart';
import '../widgets/widgets.dart';
import 'converts.dart';

extension DateTimeFormatter on DateTime {
  String toFormattedString({isFullYear = false, format = "dd MMM, yy"}) {
    String fullYearFormat = "dd MMM, yyyy";
    DateFormat dateFormat = isFullYear ? DateFormat(fullYearFormat) : DateFormat(format);
    return dateFormat.format(this);
  }
}


extension SnackbarExtension on BuildContext {
  void showMessage(String message) {
    final snackBar = SnackBar(
      content: TextViewCustom(
        text: message,
        tvColor: Colors.white,
        fontSize: Converts.c16,
        isBold: false,
        isRubik: true,
        isTextAlignCenter: false,
      ),
      action: SnackBarAction(
        label: 'Ok',
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(this).showSnackBar(snackBar);
  }
}

extension StatusColor on String {
  Color get statusColor {
    // Priority list initialization
    String started = PriorityList().priorities[0].name ?? "";
    String progress = PriorityList().priorities[1].name ?? "";
    String hold = PriorityList().priorities[2].name ?? "";
    String completed = PriorityList().priorities[3].name ?? "";

    // Check the status and return the appropriate color
    if (this == started) {
      return Colors.blue;
    } else if (this == progress) {
      return Colors.yellow;
    } else if (this == hold) {
      return Colors.redAccent;
    } else if (this == completed) {
      return Colors.green;
    } else {
      return Colors.grey; // Default color if status is unknown
    }
  }
}
