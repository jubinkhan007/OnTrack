import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
