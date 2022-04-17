import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/logic.dart';
import 'package:riverpod_test/provider.dart';

class ViewModel {
  Logic _logic = Logic();
  late WidgetRef _ref;

  void setRef(WidgetRef ref) {
    this._ref = ref;
  }

  get count => _ref.watch(countDataProvider).count.toString();
  get countUp =>
      _ref.watch(countDataProvider.select((value) => value.countUp)).toString();
  get countDown => _ref
      .watch(countDataProvider.select((value) => value.countDown))
      .toString();

  void onIncrease() {
    // Logicで計算してもらう
    _logic.increase();
    //Logicで更新された値をcountDataProvider
    _ref.watch(countDataProvider.notifier).update((state) => _logic.countData);
  }

  void onDecrease() {
    _logic.decrease();
    _ref.watch(countDataProvider.notifier).update((state) => _logic.countData);
  }

  void onReset() {
    _logic.reset();
    _ref.watch(countDataProvider.notifier).update((state) => _logic.countData);
  }
}
