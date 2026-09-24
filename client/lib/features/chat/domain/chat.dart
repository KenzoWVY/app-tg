class Alignment {
  final String sourceWord;
  final String targetWord;
  final int sourceStartIndex;
  final int sourceEndIndex;
  final int targetStartIndex;
  final int targetEndIndex;

  Alignment({
    required this.sourceWord,
    required this.targetWord,
    required this.sourceStartIndex,
    required this.sourceEndIndex,
    required this.targetStartIndex,
    required this.targetEndIndex,
  });

  factory Alignment.fromJson(Map<String, dynamic> json) {
    int parseToInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) {
        return int.tryParse(value) ?? double.tryParse(value)?.toInt() ?? 0;
      }
      return 0;
    }

    return Alignment(
      sourceWord: json['sourceWord']?.toString() ?? '',
      targetWord: json['targetWord']?.toString() ?? '',
      sourceStartIndex: parseToInt(json['sourceStartIndex']),
      sourceEndIndex: parseToInt(json['sourceEndIndex']),
      targetStartIndex: parseToInt(json['targetStartIndex']),
      targetEndIndex: parseToInt(json['targetEndIndex']),
    );
  }
}

class Chat {
  final String id;
  final String sourceLanguage;
  final String targetLanguage;
  final String sourceText;
  final String translatedText;
  final String title;
  final List<Alignment> alignments;
  final DateTime createdAt;

  Chat({
    required this.id,
    required this.sourceLanguage,
    required this.targetLanguage,
    required this.sourceText,
    required this.translatedText,
    required this.title,
    required this.alignments,
    required this.createdAt,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    var rawAlignments = json['alignments'];
    List<Alignment> parsedAlignments = [];
    
    if (rawAlignments is List) {
      parsedAlignments = rawAlignments
          .where((item) => item != null)
          .map((item) {
            if (item is Map) {
              return Alignment.fromJson(Map<String, dynamic>.from(item));
            }
            return null;
          })
          .whereType<Alignment>()
          .toList();
    }

    DateTime parsedDate = DateTime.now();
    if (json['createdAt'] != null) {
      parsedDate = DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now();
    }

    return Chat(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      sourceLanguage: json['sourceLanguage']?.toString() ?? 'auto',
      targetLanguage: json['targetLanguage']?.toString() ?? '',
      sourceText: json['sourceText']?.toString() ?? '',
      translatedText: json['translatedText']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      alignments: parsedAlignments,
      createdAt: parsedDate,
    );
  }
}