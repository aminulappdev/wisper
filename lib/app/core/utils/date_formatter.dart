// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class DateFormatter {
  final DateTime dateTime;

  DateFormatter(dynamic input) : dateTime = _parseInput(input);

  // প্রাইভেট হেল্পার: String বা DateTime থেকে DateTime বানাবে
  static DateTime _parseInput(dynamic input) {
    if (input is DateTime) {
      return input;
    }

    if (input is String) {
      final trimmed = input.trim();
      if (trimmed.isEmpty) {
        return DateTime.now(); // fallback
      }

      // সাধারণ ISO format (e.g., "2025-12-13T10:20:30.000Z")
      DateTime? parsed = DateTime.tryParse(trimmed);

      // যদি UTC 'Z' থাকে, তাহলে local-এ কনভার্ট করো (অপশনাল)
      if (parsed != null && trimmed.endsWith('Z')) {
        parsed = parsed.toLocal();
      }

      return parsed ?? DateTime.now(); // fallback যদি পার্স না হয়
    }

    // অন্য কোনো টাইপ হলে current time দাও
    return DateTime.now();
  }

  // Format time as "11:00 am"
  String getTimeIn12HourFormat() {
    return DateFormat('hh:mm a').format(dateTime);
  }

  // Format date as "20 July 2025"
  String getFullDateFormat() {
    return DateFormat('d MMMM yyyy').format(dateTime);
  }

  // Format date as "20/5/2025"
  String getShortDateFormat() {
    return DateFormat('d/M/yyyy').format(dateTime);
  }

  // Format date and time as "20 July 2025, 11:00 am"
  String getDateTimeFormat() {
    return DateFormat('d MMMM yyyy, hh:mm a').format(dateTime);
  }

  // Relative time (e.g., "2 hours ago", "Yesterday", etc.)
  String getRelativeTimeFormat() {
    final Duration difference = DateTime.now().difference(dateTime);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} years ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 7) {
      return DateFormat('d MMMM yyyy').format(dateTime);
    } else if (difference.inDays >= 1) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} min ago';
    } else {
      return 'Just now';
    }
  }
}
