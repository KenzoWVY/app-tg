import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/chat.dart' as chat_domain;
import '../state/chat_notifier.dart';
import '../domain/word_alignment.dart';
import 'word_lookup_card.dart';

class TranslationScreen extends ConsumerStatefulWidget {
  const TranslationScreen({super.key});

  @override
  ConsumerState<TranslationScreen> createState() => _TranslationScreenState();
}

class _TranslationScreenState extends ConsumerState<TranslationScreen> {
  final _textController = TextEditingController();
  String _sourceLanguage = 'pt';
  String _targetLanguage = 'en';
  WordAlignment? _selectedAlignment;
  bool _isEditing = true;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);

    ref.listen(chatProvider, (previous, next) {
      next.whenOrNull(
        data: (chat) {
          if (chat != null && _isEditing) {
            setState(() => _isEditing = false);
          }
        },
      );
    });

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        actions: [
          TextButton.icon(
            onPressed: () {
              // TODO
            },
            icon: const Icon(Icons.quiz_outlined, size: 18),
            label: const Text('Create Quiz'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Source Text',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'From: ',
                            style: TextStyle(color: Colors.grey),
                          ),
                          DropdownButton<String>(
                            value: _sourceLanguage,
                            underline: const SizedBox(),
                            onChanged: _isEditing
                                ? (val) {
                                    if (val != null) {
                                      setState(() => _sourceLanguage = val);
                                    }
                                  }
                                : null,
                            items: const [
                              DropdownMenuItem(
                                value: 'pt',
                                child: Text('Portuguese (PT)'),
                              ),
                              DropdownMenuItem(
                                value: 'en',
                                child: Text('English (EN)'),
                              ),
                              DropdownMenuItem(
                                value: 'de',
                                child: Text('German (DE)'),
                              ),
                              DropdownMenuItem(
                                value: 'es',
                                child: Text('Spanish (ES)'),
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (!_isEditing)
                        TextButton.icon(
                          onPressed: () => setState(() {
                            _isEditing = true;
                            _selectedAlignment = null;
                          }),
                          icon: const Icon(Icons.edit, size: 18),
                          label: const Text('Edit'),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: _isEditing
                        ? _buildEditableSource(chatState.isLoading)
                        : _buildSimpleWordView(
                            chatState.value?.sourceText ?? '',
                            chatState.value?.wordAlignments ?? [],
                            true,
                          ),
                  ),
                ],
              ),
            ),
          ),

          const Divider(height: 1, thickness: 1),

          Expanded(
            child: Container(
              color: Colors.blue.shade50.withOpacity(0.5),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Translated Text',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        children: [
                          const Text('To: '),
                          DropdownButton<String>(
                            value: _targetLanguage,
                            underline: const SizedBox(),
                            onChanged: _isEditing
                                ? (val) {
                                    if (val != null) {
                                      setState(() => _targetLanguage = val);
                                    }
                                  }
                                : null,
                            items: const [
                              DropdownMenuItem(
                                value: 'pt',
                                child: Text('Portuguese (PT)'),
                              ),
                              DropdownMenuItem(
                                value: 'en',
                                child: Text('English (EN)'),
                              ),
                              DropdownMenuItem(
                                value: 'de',
                                child: Text('German (DE)'),
                              ),
                              DropdownMenuItem(
                                value: 'es',
                                child: Text('Spanish (ES)'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: chatState.when(
                      data: (chat) {
                        if (chat == null) {
                          return const Center(
                            child: Text(
                              'Enter text above and click translate.',
                              style: TextStyle(color: Colors.grey),
                            ),
                          );
                        }
                        return _buildReadOnlyTarget(chat);
                      },
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (err, stack) => Center(
                        child: Text(
                          'Error: $err',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableSource(bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: TextField(
            controller: _textController,
            decoration: const InputDecoration(
              hintText: 'Enter text to translate...',
              border: OutlineInputBorder(),
            ),
            maxLines: null,
            expands: true,
            textAlignVertical: TextAlignVertical.top,
          ),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            onPressed: isLoading
                ? null
                : () {
                    if (_textController.text.trim().isEmpty) return;
                    setState(() => _selectedAlignment = null);
                    ref
                        .read(chatProvider.notifier)
                        .translate(
                          sourceText: _textController.text,
                          sourceLanguage: _sourceLanguage,
                          targetLanguage: _targetLanguage,
                        );
                  },
            icon: isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.translate),
            label: const Text('Translate'),
          ),
        ),
      ],
    );
  }

  Widget _buildSimpleWordView(
    String text,
    List<WordAlignment> alignments,
    bool isSource,
  ) {
    if (text.isEmpty) return const SizedBox();

    final words = text.split(RegExp(r'\s+'));

    return SingleChildScrollView(
      child: Wrap(
        spacing: 4,
        runSpacing: 4,
        children: words.map((rawWord) {
          final cleanWord = rawWord.replaceAll(
            RegExp(r'[^\p{L}\p{N}]', unicode: true),
            '',
          );

          WordAlignment? match;
          if (cleanWord.isNotEmpty) {
            try {
              match = alignments.firstWhere((a) {
                final alignText = isSource ? a.sourceWord : a.targetWord;
                return alignText.toLowerCase().contains(
                  cleanWord.toLowerCase(),
                );
              });
            } catch (_) {}
          }

          final isSelected =
              _selectedAlignment != null &&
              match != null &&
              _selectedAlignment!.sourceWord == match.sourceWord &&
              _selectedAlignment!.targetWord == match.targetWord;

          return GestureDetector(
            onTap: match != null
                ? () => setState(() => _selectedAlignment = match)
                : null,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue.shade200 : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                rawWord,
                style: TextStyle(
                  fontSize: 16,
                  color: isSelected ? Colors.blue.shade900 : Colors.black87,
                  height: 1.5,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildReadOnlyTarget(chat_domain.Chat chat) {
    return Stack(
      children: [
        Positioned.fill(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: _selectedAlignment != null ? 160.0 : 16.0,
            ),
            child: _buildSimpleWordView(
              chat.translatedText,
              chat.wordAlignments,
              false,
            ),
          ),
        ),
        if (_selectedAlignment != null)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: WordLookupCard(
              wordAlignment: _selectedAlignment!,
              onClose: () => setState(() => _selectedAlignment = null),
            ),
          ),
      ],
    );
  }
}
