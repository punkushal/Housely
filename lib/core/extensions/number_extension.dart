import 'package:intl/intl.dart';

extension NumberFormatting on int {
  String get toCompact {
    if (this < 1000) return toString();

    // NumberFormat.compact() creates the 1.2K, 1M logic automatically
    return NumberFormat.compact().format(this).toLowerCase();
  }
}
