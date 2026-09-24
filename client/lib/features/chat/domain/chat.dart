import 'word_alignment.dart';

class Chat {
  final String id;
  final String sourceLanguage;
  final String targetLanguage;
  final String sourceText;
  final String translatedText;
  final String title;
  final List<WordAlignment> wordAlignments;
  final DateTime createdAt;

  Chat({
    required this.id,
    required this.sourceLanguage,
    required this.targetLanguage,
    required this.sourceText,
    required this.translatedText,
    required this.title,
    required this.wordAlignments,
    required this.createdAt,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    var rawWordAlignments = json['alignments'];
    List<WordAlignment> parsedWordAlignments = [];

    if (rawWordAlignments is List) {
      parsedWordAlignments = rawWordAlignments
          .where((item) => item != null)
          .map((item) {
            if (item is Map) {
              return WordAlignment.fromJson(Map<String, dynamic>.from(item));
            }
            return null;
          })
          .whereType<WordAlignment>()
          .toList();
    }

    DateTime parsedDate = DateTime.now();
    if (json['createdAt'] != null) {
      parsedDate =
          DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now();
    }

    return Chat(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      sourceLanguage: json['sourceLanguage']?.toString() ?? 'auto',
      targetLanguage: json['targetLanguage']?.toString() ?? '',
      sourceText: json['sourceText']?.toString() ?? '',
      translatedText: json['translatedText']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      wordAlignments: parsedWordAlignments,
      createdAt: parsedDate,
    );
  }
}
