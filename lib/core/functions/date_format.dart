import 'package:intl/intl.dart';

String formatDate(String dateTimeString) {
  DateTime dateTime = DateTime.parse(dateTimeString);
  String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
  return formattedDate;
}

// String formatDate(String dateTimeString , String  lang ) {
//   DateTime dateTime = DateTime.parse(dateTimeString);

//   String formattedDate = DateFormat('d MMMM yyyy', lang).format(dateTime);

//   return formattedDate;
// }

String formatDate2(String dateTimeString) {
  DateFormat inputFormat = DateFormat('dd/MM/yyyy HH:mm:ss');
  DateTime dateTime = inputFormat.parse(dateTimeString);
  DateFormat outputFormat = DateFormat('yyyy-MM-dd');
  String formattedDate = outputFormat.format(dateTime);
  return formattedDate;
}

String formatDateTime(String inputDateTime) {
  // Parse the input string into DateTime
  DateTime parsedDateTime = DateFormat('yyyy-MM-dd hh:mm:ss a').parse(inputDateTime);

  String formattedTime = DateFormat('hh:mm a').format(parsedDateTime);
  return formattedTime;
}

String formatTime(String dateTimeString) {
  DateTime dateTime = DateTime.parse(dateTimeString);
  String formattedDate = DateFormat('HH:mm:ss').format(dateTime);
  return formattedDate;
}

DateTime formatTimeDateTime(String dateTimeString) {
  return DateTime.parse(dateTimeString);
}

String getCurrentTime() {
  DateTime now = DateTime.now();
  String formattedTime = DateFormat('HH:mm:ss').format(now);

  return formattedTime;
}
