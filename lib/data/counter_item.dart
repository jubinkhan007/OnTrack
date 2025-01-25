import 'package:tmbi/models/models.dart';

import '../config/enum.dart';
import '../config/strings.dart';

class CounterItem {
  List<Counter> counters = [
    /*Counter(
        title: Strings.delayed_inquiry,
        flag: StatusFlag.delayed,
        isDelayed: true),*/
    Counter(title: Strings.pending_inquiry, flag: StatusFlag.pending),
    Counter(title: Strings.completed_inquiry, flag: StatusFlag.completed),
  ];
}
