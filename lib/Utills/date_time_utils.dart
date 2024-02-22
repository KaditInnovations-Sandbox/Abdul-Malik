import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

class DateTimeUtils {
  static String getCurrentTime() {
    final now = tz.TZDateTime.now(tz.getLocation('Asia/Singapore'));
    return DateFormat('hh:mm:ss a').format(now);
  }

  static String getCurrentDate() {
    final now = tz.TZDateTime.now(tz.getLocation('Asia/Singapore'));
    return DateFormat('MMM dd, yyyy').format(now);
  }
}
