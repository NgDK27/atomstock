class SearchQueryFormatter {
  static String format(String query) {
    return query
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), '_')  // Replace spaces with underscores
        .replaceAll(RegExp(r'[^\w-]'), '')  // Remove all characters except alphanumeric, underscore, and hyphen
        .replaceAll(RegExp(r'-+'), '-');  // Replace multiple hyphens with single hyphen
    }

  static String addWildcards(String query) {
    return '*${query.trim()}*';  // Add wildcards for partial matching
  }
}