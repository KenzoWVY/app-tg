import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../domain/chat.dart';
import '../domain/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final Dio _dio;
  ChatRepositoryImpl(this._dio);

  @override
  Future<Chat> translateAndSave({
    required String sourceText,
    required String targetLanguage,
    String? sourceLanguage,
    String? title,
  }) async {
    try {
      final response = await _dio.post(
        '/chats',
        data: {
          'sourceText': sourceText,
          'targetLanguage': targetLanguage,
          if (sourceLanguage != null) 'sourceLanguage': sourceLanguage,
          if (title != null) 'title': title,
        },
      );

      final responseData = response.data;
      if (responseData is! Map<String, dynamic>) {
        throw Exception(
          'Invalid server response format: Expected JSON object.',
        );
      }

      final chatData = responseData['chat'];
      if (chatData is! Map<String, dynamic>) {
        throw Exception(
          'Invalid server response: "chat" field missing or malformed.',
        );
      }

      return Chat.fromJson(chatData);
    } on DioException catch (e) {
      final errorMessage = e.response?.data is Map
          ? e.response?.data['error']
          : e.message;
      throw Exception(errorMessage ?? 'Translation failed');
    }
  }

  @override
  Future<Map<String, dynamic>> lookupWord({
    required String word,
    required String contextSentence,
    required String sourceLanguage,
    required String targetLanguage,
  }) async {
    try {
      final response = await _dio.post(
        '/translation/lookup',
        data: {
          'word': word,
          'contextSentence': contextSentence,
          'sourceLanguage': sourceLanguage,
          'targetLanguage': targetLanguage,
        },
      );

      final responseData = response.data;
      if (responseData is! Map<String, dynamic>) {
        throw Exception('Invalid server response format.');
      }

      return responseData;
    } on DioException catch (e) {
      final errorMessage = e.response?.data is Map
          ? e.response?.data['error']
          : e.message;
      throw Exception(errorMessage ?? 'Failed to lookup word');
    }
  }

  @override
  Future<Uint8List> pronounceWord({
    required String text,
    String? voiceName,
  }) async {
    try {
      final response = await _dio.post(
        '/tts/synthesize',
        data: {
          'text': text,
          'voiceName': voiceName ?? 'en-US-AndrewMultilingualNeural',
        },
        options: Options(responseType: ResponseType.bytes),
      );

      return Uint8List.fromList(response.data);
    } on DioException catch (e) {
      final responseData = e.response?.data;
      String? errorMessage;

      if (responseData is Map<String, dynamic>) {
        errorMessage = responseData['error']?.toString();
      }

      throw Exception(
        errorMessage ?? e.message ?? 'Failed to synthesize speech',
      );
    }
  }
}
