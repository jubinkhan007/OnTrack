import '../config/enum.dart';

class Counter {
  final String title;
  StatusFlag flag;
  String count;
  bool isDelayed;
  bool isSelected;
  bool isLoading;

  Counter(
      {required this.title,
      required this.flag,
      this.count = "0",
      this.isDelayed = false,
      this.isSelected = false,
      this.isLoading = false});
}
