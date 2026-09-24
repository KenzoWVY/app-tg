import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/chat.dart' as chat_domain;

class WordLookupCard extends ConsumerStatefulWidget {
  final chat_domain.Alignment alignment;
  final VoidCallback onClose;

  const WordLookupCard({
    super.key,
    required this.alignment,
    required this.onClose,
  });

  @override
  ConsumerState<WordLookupCard> createState() => _WordLookupCardState();
}

class _WordLookupCardState extends ConsumerState<WordLookupCard> {
  AsyncValue<Map<String, dynamic>?> _lookupState = const AsyncValue.data(null);

  Future<void> _fetchDefinition() async {
    setState(() {
      _lookupState = const AsyncValue.loading();
    });

    // TODO: add actual API call to fetch definition
  }

  @override
  Widget build(BuildContext context) {
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
                  widget.alignment.sourceWord,
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
                  widget.alignment.targetWord,
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
                  onPressed: widget.onClose,
                ),
              ],
            ),
            const Divider(height: 12),

            _lookupState.when(
              data: (data) {
                if (data == null) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Center(
                      child: ElevatedButton.icon(
                        onPressed: _fetchDefinition,
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
                      onPressed: _fetchDefinition,
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
