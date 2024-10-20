class Counter {
  final String title;
  final int count;
  bool isDelayed;

  Counter({
    required this.title,
    required this.count,
    this.isDelayed = false
  });
}
