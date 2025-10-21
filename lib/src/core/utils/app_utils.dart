// Shared utilities for the app

import 'package:intl/intl.dart';

class Utils {
  static String formatDate(DateTime date) {
    DateFormat formatter = DateFormat('EEEE, d MMMM, y');
    return formatter.format(date);
  }

  static String formatShortDate(DateTime date) {
    DateFormat formatter = DateFormat('d MMMM, y');
    return formatter.format(date);
  }
}
