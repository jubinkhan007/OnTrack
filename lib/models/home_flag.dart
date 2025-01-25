import '../config/enum.dart';

class HomeFlag {
  final String title;
  final StatusFlag status;
  bool isSelected;

  HomeFlag(
      {required this.status, required this.title, required this.isSelected});

  toggleButton() {
    isSelected = !isSelected;
  }

  // Override equality check to compare based on `title` or `status`
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HomeFlag && other.title == title;  // Compare based on title (or status)
  }

  // Override hashCode to match the equality check
  @override
  int get hashCode => title.hashCode;  // Use title (or status)
}
