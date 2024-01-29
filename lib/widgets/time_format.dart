import 'package:intl/intl.dart';

String timeFormat(DateTime time, {bool fomChat = false}) {
  var now = DateTime.now();
  var monthMsg = time.month;
  var yearMsg = time.year;
  var dateMsg = time.day;
  var monthNow = now.month;
  var yearNow = now.year;
  var dateNow = now.day;

  if (monthNow == monthMsg && yearNow == yearMsg) {
    if (dateNow == dateMsg) {
      return fomChat == true ? DateFormat().add_jm().format(time) : 'Today';
    } else if ((dateNow - dateMsg) == 1) {
      return 'Yesterday';
    } else {
      return DateFormat('yMd').format(time);
    }
  } else {
    return DateFormat('yMd').format(time);
  }
}
