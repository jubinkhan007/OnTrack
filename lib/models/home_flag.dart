class HomeFlag {
  final String title;
  bool isSelected;

  HomeFlag({required this.title, required this.isSelected});

  toggleButton() {
    isSelected = !isSelected;
  }
}
