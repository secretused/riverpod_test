import 'package:audioplayers/audioplayers.dart';
import 'package:riverpod_test/data/count_data.dart';

import 'count_data_changed_notifier.dart';

class SoundLogic with CountDataChangedNotifier {
  static const SOUND_DATA_UP = "sounds/Onoma-Flash08-1(High-Long).mp3";
  static const SOUND_DATA_DOWN = "sounds/Onoma-Flash09-1(High-Long).mp3";
  static const SOUND_DATA_RESET = "sounds/Onoma-Flash10-1(Low-1).mp3";

  final AudioCache _cache = AudioCache(
    fixedPlayer: AudioPlayer(),
  );

  // キャッシュ読み込む
  void load() {
    _cache.loadAll([SOUND_DATA_UP, SOUND_DATA_DOWN, SOUND_DATA_RESET]);
  }

  // 条件(抽象クラスに定義)
  @override
  void valueChange(CountData oldValue, CountData newValue) {
    if (newValue.countUp == 0 &&
        newValue.countDown == 0 &&
        newValue.count == 0) {
      playResetSound();
    } else if (oldValue.countUp + 1 == newValue.countUp) {
      playUpSound();
    } else if (oldValue.countDown + 1 == newValue.countDown) {
      playDownSound();
    }
  }

  void playUpSound() {
    _cache.play(SOUND_DATA_UP);
  }

  void playDownSound() {
    _cache.play(SOUND_DATA_DOWN);
  }

  void playResetSound() {
    _cache.play(SOUND_DATA_RESET);
  }
}
