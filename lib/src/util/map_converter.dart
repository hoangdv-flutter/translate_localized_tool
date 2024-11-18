class StringFormat {
  static const mark = "[1q2w3e4r5t6y7u8i";

  static String encode(String content) {
    return content.replaceAll("%d", "${mark}d]").replaceAll("%s", "${mark}s]");
  }

  static String decode(String content) {
    return content
        .replaceAll("${mark}d]", "%d")
        .replaceAll("${mark}d]".toUpperCase(), "%d")
        .replaceAll("${mark}s]", "%s")
        .replaceAll("${mark}s]".toUpperCase(), "%s");
  }

  StringFormat._();
}
