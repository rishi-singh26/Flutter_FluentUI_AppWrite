class DateService {
  static List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  static String getDateToShow(DateTime date) {
    final String month = months[date.month - 1];
    final String monthDate = date.day.toString();
    final String year = date.year.toString();
    return '$monthDate $month, $year';
  }
}
