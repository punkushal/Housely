int calculateDuration({
  List<DateTime> selectedMonths = const [],
  DateTime? start,
  DateTime? end,
}) {
  if (selectedMonths.isNotEmpty) {
    return selectedMonths.length;
  } else {
    int days = end!.difference(start!).inDays;
    if (days == 0) return 1;
    return days;
  }
}
