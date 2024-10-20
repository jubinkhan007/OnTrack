import 'package:tmbi/models/models.dart';

import '../config/strings.dart';

class CounterItem {
  List<Counter> counters = [
    Counter(title: Strings.pending_inquiry, count: 10),
    Counter(title: Strings.delayed_inquiry, count: 3, isDelayed: true),
    Counter(title: Strings.completed_inquiry, count: 6),
  ];
}
