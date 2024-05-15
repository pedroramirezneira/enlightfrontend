class DayIndex {
  static String getDay(int index) {
    final Map<int, String> map = {
      1: "Monday",
      2: "Tuesday",
      3: "Wednesday",
      4: "Thursday",
      5: "Friday",
      6: "Saturday",
      7: "Sunday"
    };
    return map[index]!;
  }
}
