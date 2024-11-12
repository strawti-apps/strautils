class StrautilsDateTimeHelper {
  ///
  /// ```
  /// var today = DateTime.now();
  /// return DateTime(today.year, today.month, today.day);
  /// ```
  ///
  static DateTime get nowWithoutTime {
    var today = DateTime.now();
    return DateTime(today.year, today.month, today.day);
  }

  ///
  /// ```
  /// return a.year == b.year && a.month == b.month && a.day == b.day;
  /// ```
  ///
  static bool isEqualDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  ///
  /// ```
  /// return a.hour == b.hour && a.minute == b.minute && a.second == b.second;
  /// ```
  ///
  static bool isEqualTime(DateTime a, DateTime b) {
    return a.hour == b.hour && a.minute == b.minute && a.second == b.second;
  }

  ///
  /// ```
  /// return isEqualDate(a, b) && isEqualTime(a, b);
  /// ```
  ///
  static bool isEqualDateTime(DateTime a, DateTime b) {
    return isEqualDate(a, b) && isEqualTime(a, b);
  }
}
