import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/dio_provider.dart';
import '../data/chat_repository_impl.dart';
import 'chat.dart';

part 'chat_repository.g.dart';

abstract class ChatRepository {
  Future<Chat> translateAndSave({
    required String sourceText,
    required String targetLanguage,
    String? sourceLanguage,
    String? title,
  });

  Future<Map<String, dynamic>> lookupWord({
    required String word,
    required String contextSentence,
    required String sourceLanguage,
    required String targetLanguage,
  });
}

@riverpod
ChatRepository chatRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  return ChatRepositoryImpl(dio);
}
