class VisitingCardData {
  String name = '';
  String title = '';
  String company = '';
  String email = '';
  String phone = '';
  String mobile = '';
  String website = '';
  String extraText = ''; // Remaining text
}

VisitingCardData parseVisitingCard(String text) {
  final data = VisitingCardData();
  String remainingText = text;

  // Split into lines
  final lines = text
      .split('\n')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();

  // ---------------------------
  // EMAIL
  // ---------------------------
  final emailRegex = RegExp(r'\b\S+@\S+\.\S+\b');
  final emailMatch = emailRegex.firstMatch(text);
  data.email = emailMatch?.group(0) ?? '';
  if (data.email.isNotEmpty) remainingText = remainingText.replaceAll(data.email, '');

  // ---------------------------
  // WEBSITE
  // ---------------------------
  final websiteRegex = RegExp(
    r'\b((?:https?:\/\/)?(?:www\.)?[a-zA-Z0-9-]+\.(?:com|net|org|in|co|io|biz|info|edu)(?:\.[a-zA-Z]{2,})?)\b',
    caseSensitive: false,
  );
  final websiteMatch = websiteRegex.firstMatch(text);
  data.website = websiteMatch?.group(0) ?? '';
  if (data.website.isNotEmpty) remainingText = remainingText.replaceAll(data.website, '');

  // ---------------------------
  // PHONE / MOBILE
  // ---------------------------
  final phoneRegex = RegExp(r'(\+?\d[\d -]{8,}\d)');
  final phones = phoneRegex.allMatches(text).map((e) => e.group(0)!).toList();

  if (phones.isNotEmpty) {
    data.mobile = phones.first;
    remainingText = remainingText.replaceAll(data.mobile, '');
  }
  if (phones.length > 1) {
    data.phone = phones.last;
    remainingText = remainingText.replaceAll(data.phone, '');
  }

  // ---------------------------
  // NAME (usually first line)
  // ---------------------------
  if (lines.isNotEmpty) {
    data.name = lines.first;
    remainingText = remainingText.replaceFirst(data.name, '');
  }

  // ---------------------------
  // TITLE (keywords)
  // ---------------------------
  final titleKeywords = [
    'manager',
    'engineer',
    'developer',
    'director',
    'ceo',
    'cto',
    'founder',
    'consultant',
    'president',
    'vp',
    'lead'
  ];
  for (var line in lines) {
    if (titleKeywords.any((k) => line.toLowerCase().contains(k))) {
      data.title = line;
      remainingText = remainingText.replaceFirst(line, '');
      break;
    }
  }

  // ---------------------------
  // COMPANY (keywords or uppercase)
  // ---------------------------
  final companyKeywords = ['ltd', 'limited', 'pvt', 'private', 'inc', 'company'];
  for (var line in lines) {
    final lowerLine = line.toLowerCase();
    if (companyKeywords.any((k) => lowerLine.contains(k))) {
      data.company = line;
      remainingText = remainingText.replaceFirst(line, '');
      break;
    }

    // Fallback: uppercase line with more than 3 letters
    if (line.toUpperCase() == line && line.length > 3) {
      data.company = line;
      remainingText = remainingText.replaceFirst(line, '');
      break;
    }
  }

  // ---------------------------
  // CLEAN EXTRA TEXT
  // ---------------------------
  data.extraText = remainingText
      .split('\n')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .join('\n');

  return data;
}
