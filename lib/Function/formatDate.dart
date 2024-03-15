String formatDate(String dateString) {
  DateTime date = DateTime.parse(dateString);
  
  final List<String> indonesianMonths = [
    'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
  ];

  String formattedDate = '${date.day.toString().padLeft(2, '0')} ${indonesianMonths[date.month - 1]} ${date.year}';
  return formattedDate;
}
