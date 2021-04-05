import 'package:intl/intl.dart';

class Formatter {
  static String dateToString(DateTime date) {
    final formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(date);
  }
}
