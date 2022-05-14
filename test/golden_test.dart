import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_test/main.dart';
import 'package:riverpod_test/provider.dart';
import 'package:riverpod_test/view_model.dart';

class MockViewModel extends Mock implements ViewModel {}

void main() {
  // テストの前に一度だけ実行する
  setUpAll(() async {
    await loadAppFonts();
  });
  const iPhone55 =
      Device(size: Size(414, 736), name: "iPhone55", devicePixelRatio: 3.0);
  List<Device> devices = [iPhone55];
  testGoldens("normal", (tester) async {
    ViewModel viewModel = ViewModel();

    await tester.pumpWidgetBuilder(ProviderScope(
        child: MyHomePage(
      viewModel,
    )));

    await multiScreenGolden(tester, "myHomePage_0init", devices: devices);

    await tester.tap(find.byIcon(CupertinoIcons.plus));
    await tester.tap(find.byIcon(CupertinoIcons.plus));
    await tester.tap(find.byIcon(CupertinoIcons.minus));
    await tester.pump();

    await multiScreenGolden(tester, "myHomePage_1tapped", devices: devices);
  });
  // 指定の値を指定 - mockでViewModelと紐付け
  testGoldens("viewModelTest", (tester) async {
    var mock = MockViewModel();
    when(() => mock.count).thenReturn(1123456789.toString());
    when((() => mock.countUp)).thenReturn(2123456789.toString());
    when((() => mock.countDown)).thenReturn(3123456789.toString());

    // Providrを書き換えて実行
    final mockTitleProvider = Provider<String>((ref) => "mockTitle");
    final mockMessageProvider = Provider<String>((ref) => "mockMessage");

    await tester.pumpWidgetBuilder(
      ProviderScope(
        child: MyHomePage(mock),
        overrides: [
          titileProvider.overrideWithProvider(mockTitleProvider),
          messageProvider.overrideWithValue("mockMessage"),
        ],
      ),
    );
    await multiScreenGolden(tester, "myHomePage_mock", devices: devices);

    // -タップ回数確認
    verifyNever(() => mock.onIncrease());
    verifyNever(() => mock.onDecrease());
    verifyNever(() => mock.onReset());

    // +
    await tester.tap(find.byIcon(CupertinoIcons.plus));
    verify(() => mock.onIncrease()).called(1);
    verifyNever(() => mock.onDecrease());
    verifyNever(() => mock.onReset());

    // -
    await tester.tap(find.byIcon(CupertinoIcons.minus));
    // 一度verifyされているためonIncreaseは0回
    verifyNever(() => mock.onIncrease());
    verify(() => mock.onDecrease()).called(1);
    verifyNever(() => mock.onReset());

    // reset
    await tester.tap(find.byIcon(Icons.refresh));
    verifyNever(() => mock.onIncrease());
    verifyNever(() => mock.onDecrease());
    verify(() => mock.onReset()).called(1);
  });
}
