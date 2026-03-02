class HttpHeaderSanitizer {
  /// Dart's underlying `HttpClient` rejects header values containing CR/LF and
  /// also cannot send characters outside ISO-8859-1 (Latin-1).
  ///
  /// This sanitizes a string to be safe for use as an HTTP header value:
  /// - replaces CR/LF/control chars with spaces
  /// - collapses whitespace
  /// - replaces non-Latin-1 characters with '?'
  static String sanitize(String input) {
    var s = input;

    // Replace CR/LF first (primary cause of "Invalid HTTP header field value").
    s = s.replaceAll(RegExp(r"[\r\n]+"), " ");

    // Replace other control chars (except TAB which is also risky; replace it too).
    s = s.replaceAll(RegExp(r"[\u0000-\u001F\u007F]"), " ");

    // Collapse whitespace to keep headers compact and predictable.
    s = s.replaceAll(RegExp(r"\s+"), " ").trim();

    // Ensure Latin-1 only.
    final out = StringBuffer();
    for (final r in s.runes) {
      if (r <= 0xFF) {
        out.writeCharCode(r);
      } else {
        out.write("?");
      }
    }
    return out.toString();
  }
}

