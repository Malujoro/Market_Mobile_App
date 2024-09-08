import 'package:intl/intl.dart';

mixin HourMixins {
  String timeToString(DateTime date, {bool hour = true}) {
    if (hour) {
      return DateFormat('yyyy-MM-dd - kk:mm').format(date);
    }
    return DateFormat('yyyy-MM-dd').format(date);
  }
}