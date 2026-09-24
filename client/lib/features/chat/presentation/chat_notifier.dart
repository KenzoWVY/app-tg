import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/chat.dart';
import '../domain/chat_repository.dart';
import '../data/chat_repository_impl.dart';

class ChatNotifier extends AsyncNotifier<Chat?> {
  late final ChatRepository _chatRepository;

  @override
  FutureOr<Chat?> build() async {
    _chatRepository = ref.read(chatRepositoryProvider);
    return null;
  }

  Future<void> translate({
    required String sourceText,
    required String targetLanguage,
    String? sourceLanguage,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await _chatRepository.translateAndSave(
        sourceText: sourceText,
        targetLanguage: targetLanguage,
        sourceLanguage: sourceLanguage,
      );
    });
  }
}

final chatNotifierProvider = AsyncNotifierProvider<ChatNotifier, Chat?>(() {
  return ChatNotifier();
});
