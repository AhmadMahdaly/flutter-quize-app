import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatDate(String dateTimeString) {
  final DateTime dateTime = DateTime.parse(dateTimeString);
  final String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
  return formattedDate;
}

// String formatDate(String dateTimeString , String  lang ) {
//   DateTime dateTime = DateTime.parse(dateTimeString);

//   String formattedDate = DateFormat('d MMMM yyyy', lang).format(dateTime);

//   return formattedDate;
// }

String formatDate2(String dateTimeString) {
  final DateFormat inputFormat = DateFormat('dd/MM/yyyy HH:mm:ss');
  final DateTime dateTime = inputFormat.parse(dateTimeString);
  final DateFormat outputFormat = DateFormat('yyyy-MM-dd');
  final String formattedDate = outputFormat.format(dateTime);
  return formattedDate;
}

String formatDateTime(String inputDateTime) {
  // Parse the input string into DateTime
  final DateTime parsedDateTime = DateFormat(
    'yyyy-MM-dd hh:mm:ss a',
  ).parse(inputDateTime);

  final String formattedTime = DateFormat('hh:mm a').format(parsedDateTime);
  return formattedTime;
}

String formatTime(String dateTimeString) {
  final DateTime dateTime = DateTime.parse(dateTimeString);
  final String formattedDate = DateFormat('HH:mm:ss').format(dateTime);
  return formattedDate;
}

DateTime formatTimeDateTime(String dateTimeString) {
  return DateTime.parse(dateTimeString);
}

String getCurrentTime() {
  final DateTime now = DateTime.now();
  final String formattedTime = DateFormat('HH:mm:ss').format(now);

  return formattedTime;
}

int calculateRemainingDaysFromString(String dateString) {
  final parts = dateString.split(' ');

  final day = int.parse(parts[0]);
  final month = int.parse(parts[1]);
  final year = int.parse(parts[2]);

  final nowUtc = DateTime.now().toUtc();
  final expireDateUtc = DateTime.utc(year, month, day);

  final todayUtc = DateTime.utc(nowUtc.year, nowUtc.month, nowUtc.day);

  return expireDateUtc.difference(todayUtc).inDays;
}

String getGreetingWithEmoji(BuildContext context) {
  final hour = DateTime.now().hour;

  if (hour >= 5 && hour < 12) {
    return '${'Good Morning'} 🌞'; // صباح الخير
  } else if (hour >= 12 && hour < 17) {
    return '${'Good Afternoon'} 🌤️'; // مساء الخير (ظهر)
  } else {
    return '${'Good Evening'} 🌙'; // مساء الخير (ليل)
  }
}
