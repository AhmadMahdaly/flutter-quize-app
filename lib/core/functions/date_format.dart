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
  final DateTime parsedDateTime = DateFormat('yyyy-MM-dd hh:mm:ss a').parse(inputDateTime);

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
