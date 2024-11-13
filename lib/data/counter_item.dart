import 'package:tmbi/models/models.dart';

import '../config/strings.dart';

class CounterItem {
  List<Counter> counters = [
    Counter(title: Strings.delayed_inquiry, isDelayed: true),
    Counter(
      title: Strings.pending_inquiry,
    ),
    Counter(
      title: Strings.completed_inquiry,
    ),
  ];
}
