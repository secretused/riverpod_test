import 'package:test/test.dart';
import 'package:riverpod_test/logic.dart';

void main() {
  Logic target = Logic();
  setUp(() async {
    target = Logic();
  });

  test("init", () async {
    expect(target.countData.count, 0);
    expect(target.countData.countUp, 0);
    expect(target.countData.countDown, 0);
  });
  test("increase", () async {
    target.increase();
    target.increase();
    expect(target.countData.count, 2);
    expect(target.countData.countUp, 2);
    expect(target.countData.countDown, 0);
  });
  test("decrease", () async {
    target.decrease();
    target.decrease();
    expect(target.countData.count, -2);
    expect(target.countData.countUp, 0);
    expect(target.countData.countDown, 2);
  });
  test("reset", () async {
    expect(target.countData.count, 0);
    expect(target.countData.countUp, 0);
    expect(target.countData.countDown, 0);
    target.increase();
    target.decrease();
    target.increase();
    expect(target.countData.count, 1);
    expect(target.countData.countUp, 2);
    expect(target.countData.countDown, 1);
    target.reset();
    expect(target.countData.count, 0);
    expect(target.countData.countUp, 0);
    expect(target.countData.countDown, 0);
  });
}
