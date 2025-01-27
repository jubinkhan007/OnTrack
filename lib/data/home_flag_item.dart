import 'package:tmbi/models/home_flag.dart';
import 'package:tmbi/screens/home_screen.dart';

import '../config/enum.dart';
import '../models/models.dart';

class HomeFlagItem {
  List<HomeFlag> homeFlagItems = [
    //HomeFlag(status: StatusFlag.delayed, title: "Delayed", isSelected: false),
    HomeFlag(status: StatusFlag.pending, title: "Pending", isSelected: true),
    //HomeFlag(status: StatusFlag.upcoming, title: "Upcoming", isSelected: false),
    HomeFlag(status: StatusFlag.completed, title: "Completed", isSelected: false),
  ];

  final List<Priority> priorities = [
    Priority(id: 1, name: "Started"),
    Priority(id: 3, name: "In Progress"),
    Priority(id: 5, name: "Hold"),
    Priority(id: 7, name: "Completed"),
  ];
}


