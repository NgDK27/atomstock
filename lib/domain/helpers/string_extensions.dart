extension StringExtension on String {
  String sentenceCase() {
    return isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : '';
  }
}