import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/dio_provider.dart';
import '../data/chat_repository_impl.dart';
import 'chat.dart';
import 'quiz_question.dart';

abstract class ChatRepository {
  Future<Chat> translateAndSave({
    required String sourceText,
    required String targetLanguage,
    String? sourceLanguage,
    String? title,
  });

  Future<List<Chat>> getUserChats();

  Future<Map<String, dynamic>> lookupWord({
    required String word,
    required String contextSentence,
    required String sourceLanguage,
    required String targetLanguage,
  });

  Future<Uint8List?> pronounceWord({required String text, String? voiceName});

  Future<List<QuizQuestion>> generateQuiz(String chatId);
}

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ChatRepositoryImpl(dio);
});
