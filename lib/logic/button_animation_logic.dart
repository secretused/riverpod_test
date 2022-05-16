import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:riverpod_test/logic/count_data_changed_notifier.dart';

import '../data/count_data.dart';

class ButtonAnimationLogic with CountDataChangedNotifier {
  late AnimationController _animationController;
  late Animation<double> _animationScale;

  get animationScale => _animationScale;

  ValueChangedCondition startCondition;

  // 初期化？
  ButtonAnimationLogic(TickerProvider tickerProvider, this.startCondition) {
    _animationController = AnimationController(
      vsync: tickerProvider,
      duration: Duration(milliseconds: 500),
    );

    _animationScale = _animationController
        .drive(CurveTween(
          curve: Interval(0.1, 0.7),
        ))
        .drive(Tween(begin: 1.0, end: 1.8));
  }

  @override
  // インスタンスが消える時に呼ばれる
  void dispose() {
    _animationController.dispose();
  }

  // 条件(抽象クラスに定義)
  @override
  void valueChange(CountData oldValue, CountData newValue) {
    if (startCondition(oldValue, newValue)) {
      start();
    }
  }

  void start() {
    _animationController
        .forward()
        .whenComplete(() => _animationController.reset());
  }
}
