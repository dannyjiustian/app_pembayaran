import 'package:intl/intl.dart';

String formatTime(String dateString) {
  DateTime date =
      DateTime.parse(dateString).toLocal(); // Convert to local time zone
  String formattedTime =
      DateFormat.Hm().format(date); // Format in Indonesia locale
  return formattedTime;
}
