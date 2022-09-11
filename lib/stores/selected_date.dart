import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final DateTime now = DateTime.now();

final strSelectedYearProvider = StateProvider((ref) {
  return DateFormat("yyyy").format(now);
});

final strSelectedMonthProvider = StateProvider((ref) {
  return DateFormat("M").format(now);
});
