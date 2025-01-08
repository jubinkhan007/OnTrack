import 'package:tmbi/models/home_flag.dart';
import 'package:tmbi/screens/home_screen.dart';

import '../models/models.dart';

class HomeFlagItem {
  List<HomeFlag> homeFlagItems = [
    HomeFlag(status: Status.delayed, title: "Delayed", isSelected: false),
    HomeFlag(status: Status.pending, title: "Pending", isSelected: true),
    HomeFlag(status: Status.upcoming, title: "Upcoming", isSelected: false),
    HomeFlag(status: Status.completed, title: "Completed", isSelected: false),
  ];
}
