/*
class BusinessCardInfo {
  final String? name;
  final String? designation;
  final String? company;
  final String? phone;
  final String? email;
  final String? website;
  final String? address;
  final List<String> rawLines;

  BusinessCardInfo({
    this.name,
    this.designation,
    this.company,
    this.phone,
    this.email,
    this.website,
    this.address,
    required this.rawLines,
  });
}

class BusinessCardExtractor {

  /// Fix OCR text for emails/websites
  static String fixOCRText(String text) {
    return text.replaceAll(' @ ', '@')
        .replaceAll(' . ', '.')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  /// Normalize full text
  static String normalize(String text) {
    return text.replaceAll('\n', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  /// Extract Email
  static String? extractEmail(String text) {
    final fixed = fixOCRText(text);
    final tokens = fixed.split(RegExp(r'[ ,|]'));
    final regex = RegExp(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}');
    for (final token in tokens) {
      final match = regex.firstMatch(token.trim());
      if (match != null) return match.group(0);
    }
    return null;
  }

  /// Extract Phone
  static String? extractPhone(String text) {
    final regex = RegExp(r'(\+?\d{1,3}[\s-]?)?(\d[\s-]?){8,15}');
    for (final match in regex.allMatches(text)) {
      final phone = match.group(0)!;
      final digits = phone.replaceAll(RegExp(r'\D'), '');
      if (digits.length >= 8) return phone.trim();
    }
    return null;
  }

  /// Extract Website
  static String? extractWebsite(String text) {
    final fixed = fixOCRText(text);
    final tokens = fixed.split(RegExp(r'[ ,|]'));
    final regex = RegExp(r'www\.[a-zA-Z0-9-]+(\.[a-zA-Z]{2,})+');
    for (final token in tokens) {
      final trimmed = token.trim();
      if (trimmed.contains('@')) continue;
      final match = regex.firstMatch(trimmed);
      if (match != null) return match.group(0);
    }
    return null;
  }

  /// Extract Name (top lines)
  static String? extractName(List<String> lines) {
    for (final line in lines.take(5)) {
      final text = line.trim();
      if (text.length < 3 || text.length > 40) continue;
      if (RegExp(r'\d').hasMatch(text)) continue;
      if (text.contains('@')) continue;
      if (text.split(' ').length > 4) continue;
      return text;
    }
    return null;
  }

  /// Extract Designation
  static String? extractDesignation(List<String> lines) {
    final keywords = [
      'manager','engineer','developer','designer','director',
      'officer','ceo','cto','founder','consultant','lead','head'
    ];
    for (final line in lines) {
      final lower = line.toLowerCase();
      if (keywords.any((k) => lower.contains(k))) return line.trim();
    }
    return null;
  }

  /// Extract Company
  static String? extractCompany(List<String> lines) {
    final keywords = [
      'limited','ltd','inc','corp','company','group',
      'technologies','solutions','systems'
    ];
    for (final line in lines.take(10)) {
      final text = line.trim();
      final lower = text.toLowerCase();
      if (keywords.any((k) => lower.contains(k)) &&
          !text.contains('@') &&
          !RegExp(r'\d').hasMatch(text)) {
        return text;
      }
    }
    return null;
  }

  /// Extract Address
  static String? extractAddress(List<String> lines) {
    final addressWords = [
      'street','st','road','rd','avenue','ave','block','sector',
      'floor','building','house','city','state','zip','pin',
      'gulshan','dhaka'
    ];
    final buffer = <String>[];
    for (final line in lines) {
      final lower = line.toLowerCase();
      if (addressWords.any((w) => lower.contains(w)) || RegExp(r'\d{3,6}').hasMatch(line)) {
        buffer.add(line.trim());
      }
    }
    return buffer.isNotEmpty ? buffer.join(', ') : null;
  }

  /// Main extractor
  static BusinessCardInfo extract({
    required String fullText,
    required List<String> lines,
  }) {
    final normalized = normalize(fullText);

    return BusinessCardInfo(
      name: extractName(lines),
      designation: extractDesignation(lines),
      company: extractCompany(lines),
      phone: extractPhone(normalized),
      email: extractEmail(normalized),
      website: extractWebsite(normalized),
      address: extractAddress(lines),
      rawLines: lines,
    );
  }
}
*/

class ExtractedCardInfo {
  final String? name;
  final List<String> designation; // multi-line
  final String? company;
  final List<String> phones;
  final List<String> emails;
  final List<String> websites;
  final String? address;
  final List<String> rawLines;

  ExtractedCardInfo({
    this.name,
    required this.designation,
    this.company,
    required this.phones,
    required this.emails,
    required this.websites,
    this.address,
    required this.rawLines,
  });
}

class BusinessCardExtractor {

  /// Clean OCR text
  static String cleanOCR(String text) {
    return text.replaceAll(' @ ', '@')
        .replaceAll(' . ', '.')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  /// Extract first email from line
  static String? extractEmail(String line) {
    final regex = RegExp(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}');
    final match = regex.firstMatch(cleanOCR(line));
    return match?.group(0);
  }

  /// Extract all phones from line
  static List<String> extractPhones(String line) {
    final regex = RegExp(r'(\+?\d{1,3}[\s-]?)?(\d[\s-]?){8,15}');
    final matches = regex.allMatches(line);
    final phones = <String>[];
    for (final m in matches) {
      final phone = m.group(0)!.trim();
      final digits = phone.replaceAll(RegExp(r'\D'), '');
      if (digits.length >= 8) phones.add(phone);
    }
    return phones;
  }

  /// Extract first website from line
  static String? extractWebsite(String line) {
    final cleaned = cleanOCR(line).replaceAll(' ', '');
    final regex = RegExp(r'(https?:\/\/)?(www\.)?[a-zA-Z0-9-]+(\.[a-zA-Z]{2,})+');
    final match = regex.firstMatch(cleaned);
    return match?.group(0);
  }

  /// Main extraction logic
  static ExtractedCardInfo extract(List<String> lines) {
    String? name;
    String? company;
    List<String> designation = [];
    List<String> emails = [];
    List<String> phones = [];
    List<String> websites = [];
    List<String> addressLines = [];

    for (var line in lines) {
      var text = line.trim();
      if (text.isEmpty) continue;

      // 1️⃣ Extract email
      final email = extractEmail(text);
      if (email != null && emails.isEmpty) {
        emails.add(email);
        text = text.replaceAll(email, '');
      }

      // 2️⃣ Extract phones
      final linePhones = extractPhones(text);
      if (linePhones.isNotEmpty) {
        phones.addAll(linePhones);
        for (final p in linePhones) text = text.replaceAll(p, '');
      }

      // 3️⃣ Extract website
      final website = extractWebsite(text);
      if (website != null && websites.isEmpty) {
        websites.add(website);
        text = text.replaceAll(website, '');
      }

      // 4️⃣ Extract company (keywords)
      final companyKeywords = ['ltd', 'limited', 'inc', 'corp', 'company', 'group'];
      if (company == null && companyKeywords.any((k) => text.toLowerCase().contains(k))) {
        company = text;
        text = '';
      }

      // 5️⃣ Extract name (first reasonable line)
      if (name == null &&
          text.length >= 3 &&
          text.length < 40 &&
          !RegExp(r'\d').hasMatch(text) &&
          !text.toLowerCase().contains('collection')) {
        name = text;
        text = '';
      }

      // 6️⃣ Extract designation (multi-line)
      if (text.isNotEmpty && name != null && company != null) {
        designation.add(text);
        text = '';
      }

      // 7️⃣ Remaining text → address
      if (text.isNotEmpty) addressLines.add(text);
    }

    final address = addressLines.isNotEmpty ? addressLines.join(', ') : null;

    return ExtractedCardInfo(
      name: name,
      designation: designation,
      company: company,
      phones: phones,
      emails: emails,
      websites: websites,
      address: address,
      rawLines: lines,
    );
  }
}

