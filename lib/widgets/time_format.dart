import 'package:intl/intl.dart';

String timeFormat(DateTime time){
  var now = DateTime.now();
  var diff = now.difference(time);
  if(diff.inDays == 0){
    return DateFormat().add_jm().format(time);
  }else if(diff.inDays==1){
    return "Yesterday";
  }else{
    return DateFormat('yMd').format(time);
  }
 }

String timeFormat2(DateTime time){
  var now = DateTime.now();
  var diff = now.difference(time);
  if(diff.inDays == 0){
    return 'Today';
  }else if(diff.inDays==1){
    return "Yesterday";
  }else{
    return DateFormat('yMd').format(time);
  }
 }
