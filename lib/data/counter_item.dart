import 'package:tmbi/models/models.dart';
import 'package:tmbi/screens/home_screen.dart';

import '../config/strings.dart';

class CounterItem {
  List<Counter> counters = [
    Counter(
        title: Strings.delayed_inquiry, flag: Status.DELAYED, isDelayed: true),
    Counter(title: Strings.pending_inquiry, flag: Status.PENDING),
    Counter(title: Strings.completed_inquiry, flag: Status.COMPLETED),
  ];
}
