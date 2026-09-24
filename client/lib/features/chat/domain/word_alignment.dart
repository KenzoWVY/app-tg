class WordAlignment {
  final String sourceWord;
  final String targetWord;
  final int sourceStartIndex;
  final int sourceEndIndex;
  final int targetStartIndex;
  final int targetEndIndex;

  WordAlignment({
    required this.sourceWord,
    required this.targetWord,
    required this.sourceStartIndex,
    required this.sourceEndIndex,
    required this.targetStartIndex,
    required this.targetEndIndex,
  });

  factory WordAlignment.fromJson(Map<String, dynamic> json) {
    int parseToInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) {
        return int.tryParse(value) ?? double.tryParse(value)?.toInt() ?? 0;
      }
      return 0;
    }

    return WordAlignment(
      sourceWord: json['sourceWord']?.toString() ?? '',
      targetWord: json['targetWord']?.toString() ?? '',
      sourceStartIndex: parseToInt(json['sourceStartIndex']),
      sourceEndIndex: parseToInt(json['sourceEndIndex']),
      targetStartIndex: parseToInt(json['targetStartIndex']),
      targetEndIndex: parseToInt(json['targetEndIndex']),
    );
  }
}
