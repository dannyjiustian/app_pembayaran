String formatDateFullLimit(String? dateString) {
  if (dateString == null) {
    dateString = "2024-01-01T12:49:37.517Z";
  }
  DateTime date = DateTime.parse(dateString).toLocal();

  final List<String> indonesianMonths = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des'
  ];

  String formattedDate =
      '${date.day.toString().padLeft(2, '0')} ${indonesianMonths[date.month - 1]} ${date.year} '
      '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}';

  return formattedDate;
}
