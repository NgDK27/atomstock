class MarketHoursService {
  static bool isMarketOpen() {
    final now = DateTime.now();
    
    // Check if it's a weekday (Monday to Friday)
    if (now.weekday >= 1 && now.weekday <= 5) {
      final currentTime = now.hour * 60 + now.minute;

      // Morning session: 8:45 AM to 11:45 AM
      if (currentTime >= 525 && currentTime < 705) {
        return true;
      }

      // Afternoon session: 12:45 PM to 3:15 PM
      if (currentTime >= 765 && currentTime < 915) {
        return true;
      }
    }

    return false;
    // return true;
  }
}