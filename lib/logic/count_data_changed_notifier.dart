// ポリモーフィズム
import 'package:flutter/material.dart';

import '../data/count_data.dart';

// 条件用のクラス
typedef ValueChangedCondition = bool Function(
    CountData oldValue, CountData newvalue);

abstract class CountDataChangedNotifier {
  void valueChange(CountData oldValue, CountData newvalue);
}
