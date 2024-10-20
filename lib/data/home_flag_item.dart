import 'package:tmbi/models/home_flag.dart';

class HomeFlagItem {
  List<HomeFlag> homeFlagItems = [
    HomeFlag(title: "Pending", isSelected: true),
    HomeFlag(title: "Upcoming", isSelected: false),
    HomeFlag(title: "Completed", isSelected: false),
    HomeFlag(title: "Delayed", isSelected: false),
  ];
}
