class Counter {
  final String title;
  String count;
  bool isDelayed;
  bool isSelected;
  bool isLoading;

  Counter({
    required this.title,
    this.count = "0",
    this.isDelayed = false,
    this.isSelected = false,
    this.isLoading = false
  });
}
