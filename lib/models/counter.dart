import '../screens/home_screen.dart';

class Counter {
  final String title;
  Status flag;
  String count;
  bool isDelayed;
  bool isSelected;
  bool isLoading;

  Counter({
    required this.title,
    required this.flag,
    this.count = "0",
    this.isDelayed = false,
    this.isSelected = false,
    this.isLoading = false
  });
}
