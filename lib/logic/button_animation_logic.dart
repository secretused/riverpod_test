import 'package:flutter/material.dart';
import 'package:riverpod_test/logic/count_data_changed_notifier.dart';
import 'dart:math' as math;
import '../data/count_data.dart';

class ButtonAnimationLogic with CountDataChangedNotifier {
  late AnimationController _animationController;
  late Animation<double> _animationScale;
  late Animation<double> _animationRotation;

  late AnimationConbination _animationConbination;

  get animationScale => _animationScale;
  get animationRotation => _animationRotation;

  get animationConbination => _animationConbination;

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

    _animationRotation = _animationController
        .drive(CurveTween(
          curve: Interval(
            0.4,
            0.9,
            curve: ButtonRoatationCurve(),
          ),
        ))
        .drive(Tween(begin: 0, end: 1.0));

    _animationConbination =
        AnimationConbination(_animationScale, _animationRotation);
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
    } else {}
  }

  void start() {
    _animationController
        .forward()
        .whenComplete(() => _animationController.reset());
  }
}

class ButtonRoatationCurve extends Curve {
  @override
  double transform(double t) {
    return math.sin(2 * math.pi * t) / 16;
  }
}

// ScaleとRotationの汎用クラス
class AnimationConbination {
  final Animation<double> animationScale;
  final Animation<double> animationRotation;
  AnimationConbination(this.animationScale, this.animationRotation);
}
