// Shared utilities for the app

import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  static String formatDate(DateTime date) {
    DateFormat formatter = DateFormat('EEEE, d MMMM, y');
    return formatter.format(date);
  }

  static String formatShortDate(DateTime date) {
    DateFormat formatter = DateFormat('d MMMM, y');
    return formatter.format(date);
  }

  static Future<void> launchPhoneDialer(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw Exception('Could not launch phone dialer for $phoneNumber');
    }
  }
}
