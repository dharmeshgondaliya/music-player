import 'package:intl/intl.dart';

String formatDuration(Duration duration) {
  final format = duration.inHours >= 1 ? 'hh:mm:ss' : 'mm:ss';
  return DateFormat(format).format(DateTime(0).add(duration));
}
