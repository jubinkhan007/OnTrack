import 'package:tmbi/models/home_flag.dart';
import 'package:tmbi/screens/home_screen.dart';

class HomeFlagItem {
  List<HomeFlag> homeFlagItems = [
    HomeFlag(status: Status.DELAYED, title: "Delayed", isSelected: false),
    HomeFlag(status: Status.PENDING, title: "Pending", isSelected: true),
    HomeFlag(status: Status.UPCOMING, title: "Upcoming", isSelected: false),
    HomeFlag(status: Status.COMPLETED, title: "Completed", isSelected: false),
  ];
}
