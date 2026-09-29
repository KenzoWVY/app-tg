import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/chat.dart';
import '../domain/chat_repository.dart';

part 'user_chats_notifier.g.dart';

@riverpod
class UserChatsNotifier extends _$UserChatsNotifier {
  @override
  Future<List<Chat>> build() async {
    final repository = ref.watch(chatRepositoryProvider);
    return await repository.getUserChats();
  }

  Future<void> refreshChats() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(chatRepositoryProvider);
      return await repository.getUserChats();
    });
  }
}
