import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/chat_repository.dart';

part 'word_lookup_notifier.g.dart';

@riverpod
class WordLookupNotifier extends _$WordLookupNotifier {
  @override
  Future<Map<String, dynamic>?> build() async {
    return null;
  }

  Future<void> fetchDefinition({
    required String word,
    required String contextSentence,
    required String sourceLanguage,
    required String targetLanguage,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(chatRepositoryProvider);

      return await repository.lookupWord(
        word: word,
        contextSentence: contextSentence,
        sourceLanguage: sourceLanguage,
        targetLanguage: targetLanguage,
      );
    });

    if (state.hasError) {
      print('LOOKUP ERROR: ${state.error}');
    }
  }
}
