import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/data/count_data.dart';
import 'package:riverpod_test/logic/button_animation_logic.dart';
import 'package:riverpod_test/logic/count_data_changed_notifier.dart';
import 'package:riverpod_test/logic/logic.dart';
import 'package:riverpod_test/provider.dart';

import 'logic/sound_logic.dart';

class ViewModel {
  Logic _logic = Logic();

  SoundLogic _soundLogic = SoundLogic();
  late ButtonAnimationLogic _buttonAnimationLogicPlus;
  late ButtonAnimationLogic _buttonAnimationLogicMinus;
  late ButtonAnimationLogic _buttonAnimationLogicreset;

  late WidgetRef _ref;

  // 起動条件のインスタンスをリスト化
  List<CountDataChangedNotifier> notifiers = [];

  void setRef(WidgetRef ref, TickerProvider tickerProvider) {
    this._ref = ref;

    // ValueChangedConditionに条件結果をboolで渡してる
    ValueChangedCondition conditionPlus =
        (CountData oldValue, CountData newValue) {
      return oldValue.countUp + 1 == newValue.countUp;
    };

    _buttonAnimationLogicPlus =
        ButtonAnimationLogic(tickerProvider, conditionPlus);
    _buttonAnimationLogicMinus = ButtonAnimationLogic(tickerProvider,
        (CountData oldValue, CountData newValue) {
      return oldValue.countDown + 1 == newValue.countDown;
    });
    _buttonAnimationLogicreset = ButtonAnimationLogic(
        tickerProvider,
        (oldValue, newvalue) =>
            oldValue.countUp == 0 && newvalue.countDown == 0);

    _soundLogic.load();

    notifiers = [
      _soundLogic,
      _buttonAnimationLogicPlus,
      _buttonAnimationLogicMinus,
      _buttonAnimationLogicreset
    ];
  }

  get count => _ref.watch(countDataProvider).count.toString();
  get countUp =>
      _ref.watch(countDataProvider.select((value) => value.countUp)).toString();
  get countDown => _ref
      .watch(countDataProvider.select((value) => value.countDown))
      .toString();

  get animationPlus => _buttonAnimationLogicPlus.animationScale;
  get animationMinus => _buttonAnimationLogicMinus.animationScale;
  get animationReset => _buttonAnimationLogicreset.animationScale;

  void onIncrease() {
    // Logicで計算してもらう
    _logic.increase();
    //Logicで更新された値をcountDataProvider
    // _ref.watch(countDataProvider.notifier).update((state) => _logic.countData);
    update();
  }

  void onDecrease() {
    _logic.decrease();
    update();
  }

  void onReset() {
    _logic.reset();
    update();
  }

  // ボタン押した時に変動したStateを呼みこむ
  void update() {
    // 今の状態
    CountData oldValue = _ref.watch(countDataProvider.notifier).state;
    _ref.watch(countDataProvider.notifier).update((state) => _logic.countData);
    // 新しい状態
    CountData newvalue = _ref.watch(countDataProvider.notifier).state;

    // 各LogicのvalueChangeを読み込み、関数を実行
    notifiers.forEach((element) => element.valueChange(oldValue, newvalue));
  }
}
