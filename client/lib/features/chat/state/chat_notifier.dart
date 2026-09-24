import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/chat.dart';
import '../domain/chat_repository.dart';

part 'chat_notifier.g.dart';

@riverpod
class ChatNotifier extends _$ChatNotifier {
  @override
  Future<Chat?> build() async {
    return null;
  }

  Future<void> translate({
    required String sourceText,
    required String targetLanguage,
    String? sourceLanguage,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(chatRepositoryProvider);
      return await repository.translateAndSave(
        sourceText: sourceText,
        targetLanguage: targetLanguage,
        sourceLanguage: sourceLanguage,
      );
    });
  }

  void loadChat(Chat? chat) {
    state = AsyncData(chat);
  }
}
