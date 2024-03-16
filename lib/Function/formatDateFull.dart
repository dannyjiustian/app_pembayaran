import 'package:intl/intl.dart';

String formatDateFull(String dateString) {
  DateTime date = DateTime.parse(dateString).toLocal();

  final List<String> indonesianDays = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu'
  ];

  final List<String> indonesianMonths = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember'
  ];

  String formattedDate = '${indonesianDays[date.weekday - 1]}, '
      '${date.day.toString().padLeft(2, '0')} '
      '${indonesianMonths[date.month - 1]} '
      '${date.year} '
      '${DateFormat.Hm().format(date)}';

  return formattedDate;
}
