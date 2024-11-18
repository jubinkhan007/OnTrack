import 'package:tmbi/screens/home_screen.dart';

class HomeFlag {
  final String title;
  final Status status;
  bool isSelected;

  HomeFlag({required this.status, required this.title, required this.isSelected});

  toggleButton() {
    isSelected = !isSelected;
  }
}
