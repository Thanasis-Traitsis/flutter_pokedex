class UrlUtils {
  static String extractId(String url) {
    final cleanUrl = url.endsWith('/') ? url.substring(0, url.length - 1) : url;
    return cleanUrl.split('/').last;
  }
}