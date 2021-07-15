import 'package:topgo_web/functions/time_string.dart';

List<int>? parseNaiveDateTime(String? naive) {
  if (naive == null) return null;

  List<String> time = naive.split('T')[1].substring(0, 5).split(':');
  return time.map((v) => int.parse(v)).toList();
}

List<int>? parseNaiveTime(String? naive) {
  if (naive == null) return null;

  List<String> time = naive.split(':').sublist(0, 2);
  return time.map((v) => int.parse(v)).toList();
}

String toNaiveTime(List<int> time) => '${timeString(time)}:00';
