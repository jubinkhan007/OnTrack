class Counter {
  final String title;
  final int count;
  bool isDelayed;
  bool isSelected;

  Counter({
    required this.title,
    required this.count,
    this.isDelayed = false,
    this.isSelected = false
  });
}
