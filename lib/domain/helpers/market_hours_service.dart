class MarketHoursService {
  static bool isMarketOpen() {
    final now = DateTime.now();
    
    // Check if it's a weekday (Monday to Friday)
    if (now.weekday >= 1 && now.weekday <= 5) {
      final currentTime = now.hour * 60 + now.minute;

      // Morning session: 8:55 AM to 11:35 AM
      if (currentTime >= 535 && currentTime < 695) {
        return true;
      }

      // Afternoon session: 12:55 PM to 3:05 PM
      if (currentTime >= 775 && currentTime < 905) {
        return true;
      }
    }

    return false;
    // return true;
  }
}