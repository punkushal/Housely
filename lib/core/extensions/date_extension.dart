import 'package:intl/intl.dart';

extension DateExtension on DateTime {
  String dayMonthFormat() {
    return DateFormat('MMM dd').format(this);
  }
}
