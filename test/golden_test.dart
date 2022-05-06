import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:riverpod_test/main.dart';
import 'package:riverpod_test/view_model.dart';

void main() {
  testGoldens("normal", (tester) async {
    const iPhone55 =
        Device(size: Size(414, 736), name: "iPhone55", devicePixelRatio: 3.0);

    List<Device> devices = [iPhone55];

    ViewModel viewModel = ViewModel();

    await tester.pumpWidgetBuilder(ProviderScope(
        child: MyHomePage(
      viewModel,
    )));

    await multiScreenGolden(tester, "myHomePage_0init", devices: devices);
  });
}
