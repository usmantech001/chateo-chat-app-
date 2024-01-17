import 'package:intl/intl.dart';

String timeFormat(DateTime time){
  var now = DateTime.now();
  var diff = now.difference(time);
  if(diff.inMinutes < 60){
    return "${diff.inMinutes} m ago";
  }else if(diff.inHours < 24){
    return "${diff.inHours} h ago";
  }else if(diff.inDays < 30){
    return "${diff.inDays} d ago";
  }else if(diff.inDays < 365){
      final format = DateFormat('MM-dd');
    return  format.format(time);
  }else{
    final format = DateFormat('yyyy-MM-dd');
    return format.format(time);
  }
 }