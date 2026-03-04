class HttpHeaderSanitizer {
  /// Dart's underlying `HttpClient` rejects header values containing CR/LF,
  /// characters outside ISO-8859-1 (Latin-1), and bare `%` signs that form
  /// invalid percent-encoding sequences (throws "Illegal percent encoding in
  /// URI").
  ///
  /// This sanitizes a string to be safe for use as an HTTP header value:
  /// - replaces CR/LF/control chars with spaces
  /// - collapses whitespace
  /// - replaces non-Latin-1 characters with '?'
  /// - percent-encodes bare `%` signs that don't form valid `%HH` sequences
  static String sanitize(String input) {
    var s = input;

    // Replace CR/LF first (primary cause of "Invalid HTTP header field value").
    s = s.replaceAll(RegExp(r"[\r\n]+"), " ");

    // Replace other control chars (except TAB which is also risky; replace it too).
    s = s.replaceAll(RegExp(r"[\u0000-\u001F\u007F]"), " ");

    // Collapse whitespace to keep headers compact and predictable.
    s = s.replaceAll(RegExp(r"\s+"), " ").trim();

    // Ensure Latin-1 only.
    final latin1 = StringBuffer();
    for (final r in s.runes) {
      if (r <= 0xFF) {
        latin1.writeCharCode(r);
      } else {
        latin1.write("?");
      }
    }
    s = latin1.toString();

    // Fix bare `%` signs that would cause "Illegal percent encoding in URI".
    // A valid percent-encoding is `%` followed by exactly two hex digits.
    // Replace any `%` that is NOT followed by two hex digits with `%25`.
    s = s.replaceAllMapped(
      RegExp(r'%(?![0-9A-Fa-f]{2})'),
      (_) => '%25',
    );

    return s;
  }
}
