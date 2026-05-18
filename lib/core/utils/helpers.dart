import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Helpers {
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  static String getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return '🟢';
      case 'closed':
        return '🔴';
      case 'filled':
        return '🟡';
      default:
        return '⚪';
    }
  }

  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return Colors.green;
      case 'closed':
        return Colors.red;
      case 'filled':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}