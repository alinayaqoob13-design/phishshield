class Validators {
  // URL Validation
  static bool isValidUrl(String url) {
    if (url.isEmpty) return false;

    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  // Check if URL has valid format
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a URL';
    }

    if (!isValidUrl(value)) {
      return 'Please enter a valid URL (http:// or https://)';
    }

    return null;
  }

  // Extract domain from URL
  static String extractDomain(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.host;
    } catch (e) {
      return url;
    }
  }

  // Check if URL has HTTPS
  static bool hasHttps(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.scheme == 'https';
    } catch (e) {
      return false;
    }
  }
}
