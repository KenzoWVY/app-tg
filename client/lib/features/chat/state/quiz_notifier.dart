import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/chat_repository.dart';
import '../domain/quiz_question.dart';

part 'quiz_notifier.g.dart';

@riverpod
class QuizNotifier extends _$QuizNotifier {
  @override
  Future<List<QuizQuestion>> build(String chatId) async {
    final repository = ref.watch(chatRepositoryProvider);
    return await repository.generateQuiz(chatId);
  }

  Future<void> retry() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(chatRepositoryProvider);
      return await repository.generateQuiz(chatId);
    });
  }
}
