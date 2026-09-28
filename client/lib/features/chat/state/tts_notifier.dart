import 'dart:async';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/chat_repository.dart';

part 'tts_notifier.g.dart';

@riverpod
class TtsNotifier extends _$TtsNotifier {
  late final AudioPlayer _audioPlayer;
  @override
  Future<Uint8List?> build() async {
    _audioPlayer = AudioPlayer();

    ref.onDispose(() {
      _audioPlayer.dispose();
    });

    return null;
  }

  Future<void> pronounceWord({required String text, String? voiceName}) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(chatRepositoryProvider);
      final audioData = await repository.pronounceWord(
        text: text,
        voiceName: voiceName,
      );

      if (audioData != null && audioData.isNotEmpty) {
        await _audioPlayer.play(BytesSource(audioData));
      }
    });
  }
}
