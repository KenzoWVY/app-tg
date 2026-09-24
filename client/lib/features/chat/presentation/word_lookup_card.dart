import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/word_alignment.dart';
import '../state/chat_notifier.dart';
import '../state/word_lookup_notifier.dart'; // 👈 Import the notifier we just made

// Converted from ConsumerStatefulWidget to ConsumerWidget
class WordLookupCard extends ConsumerWidget {
  final WordAlignment wordAlignment;
  final VoidCallback onClose;

  const WordLookupCard({
    super.key,
    required this.wordAlignment,
    required this.onClose,
  });

  // Helper function to trigger the notifier
  void _triggerLookup(WidgetRef ref) {
    final currentChat = ref.read(chatProvider).value;
    if (currentChat == null) return;

    ref
        .read(wordLookupProvider.notifier)
        .fetchDefinition(
          word: wordAlignment.targetWord,
          contextSentence: currentChat.translatedText,
          sourceLanguage: currentChat.sourceLanguage,
          targetLanguage: currentChat.targetLanguage,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lookupState = ref.watch(wordLookupProvider);

    return Card(
      color: Colors.white,
      elevation: 4,
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.blue.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(
                  wordAlignment.sourceWord,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.blue,
                    size: 16,
                  ),
                ),
                Text(
                  wordAlignment.targetWord,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.blue,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(
                    Icons.volume_up,
                    color: Colors.blue,
                    size: 20,
                  ),
                  tooltip: 'Pronounce Word',
                  onPressed: () {
                    // TODO: add word pronunciation functionality
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                  onPressed: onClose,
                ),
              ],
            ),
            const Divider(height: 12),

            lookupState.when(
              data: (data) {
                if (data == null) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Center(
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            _triggerLookup(ref), // Trigger from here
                        icon: const Icon(Icons.translate, size: 18),
                        label: const Text('Translate Definition'),
                      ),
                    ),
                  );
                }

                final pos = data['partOfSpeech'] ?? '';
                final gender = data['gender'];
                final definition = data['definition'] ?? '';
                final example = data['example'] ?? '';

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (pos.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              pos,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue.shade800,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        if (gender != null) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.purple.shade50,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              gender,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.purple.shade800,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (definition.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        definition,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                    if (example.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Example: $example',
                        style: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ],
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
              error: (err, _) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: [
                    Text(
                      'Error translating.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red.shade400,
                      ),
                    ),
                    const SizedBox(height: 4),
                    TextButton(
                      onPressed: () => _triggerLookup(ref),
                      child: const Text('Retry Lookup'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
