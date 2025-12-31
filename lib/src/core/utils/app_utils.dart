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

  static bool isSameDay(DateTime dateTime, DateTime dateTime2) {
    return dateTime.year == dateTime2.year &&
        dateTime.month == dateTime2.month &&
        dateTime.day == dateTime2.day;
  }

  static timeRemainingString(String dateString) {
    DateFormat formatter = DateFormat('d MMMM, y');
    DateTime date = formatter.parse(dateString);
    Duration difference = date.difference(DateTime.now());
    if (difference.inDays > 0) {
      return '**${difference.inDays} jours**';
    } else if (difference.inHours > 0) {
      return '**${difference.inHours} heures**';
    } else if (difference.inMinutes > 0) {
      return '**${difference.inMinutes} minutes**';
    } else {
      return 'Maintenant';
    }
  }

  static timeRemaining(DateTime date) {
    Duration difference = date.difference(DateTime.now());
    if (difference.inDays > 0) {
      return '**${difference.inDays} jours**';
    } else if (difference.inHours > 0) {
      return '**${difference.inHours} heures**';
    } else if (difference.inMinutes > 0) {
      return '**${difference.inMinutes} minutes**';
    } else {
      return 'Maintenant';
    }
  }

  static anonymousEmail(String text) {
    var parts = text.split("@");
    if (parts.length != 2) return text;
    var name = parts[0];
    var domain = parts[1];
    if (name.length <= 2) {
      name = "${name[0]}*";
    } else {
      name = name[0] + "*" * (name.length - 2) + name[name.length - 1];
    }
    return "$name@$domain";
  }
}
