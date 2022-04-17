import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/data/count_data.dart';

// 定数用
final titileProvider = Provider<String>((ref) {
  return "Riverpod Demo Home Page";
});

final messageProvider = Provider<String>((ref) => "message here");

final countProvider = StateProvider<int>((ref) => 0);
final countDataProvider = StateProvider<CountData>(
    (ref) => CountData(count: 0, countUp: 0, countDown: 0));
