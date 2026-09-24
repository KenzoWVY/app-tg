import 'chat.dart';

abstract class ChatRepository {
  Future<Chat> translateAndSave({
    required String sourceText,
    required String targetLanguage,
    String? sourceLanguage,
    String? title,
  });
}
