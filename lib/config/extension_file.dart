
import 'package:intl/intl.dart';

extension DateTimeFormatter on DateTime{
  String toFormattedString() {
    DateFormat dateFormat = DateFormat("dd MMM, yyyy");
    return dateFormat.format(this);
  }
}