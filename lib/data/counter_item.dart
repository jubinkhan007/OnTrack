import 'package:tmbi/models/models.dart';
import 'package:tmbi/screens/home_screen.dart';

import '../config/strings.dart';

class CounterItem {
  List<Counter> counters = [
    Counter(
        title: Strings.delayed_inquiry, flag: Status.delayed, isDelayed: true),
    Counter(title: Strings.pending_inquiry, flag: Status.pending),
    Counter(title: Strings.completed_inquiry, flag: Status.completed),
  ];
}
