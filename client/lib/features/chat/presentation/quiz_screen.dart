import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/quiz_notifier.dart';

class QuizScreen extends ConsumerStatefulWidget {
  final String chatId;

  const QuizScreen({super.key, required this.chatId});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  int _currentIndex = 0;
  int? _selectedOptionIndex;
  bool _isAnswered = false;
  int _score = 0;
  bool _isFinished = false;

  void _handleOptionSelected(int index, int correctIndex) {
    if (_isAnswered) return;

    setState(() {
      _selectedOptionIndex = index;
      _isAnswered = true;
      if (index == correctIndex) {
        _score++;
      }
    });
  }

  void _nextQuestion(int totalQuestions) {
    setState(() {
      if (_currentIndex < totalQuestions - 1) {
        _currentIndex++;
        _selectedOptionIndex = null;
        _isAnswered = false;
      } else {
        _isFinished = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final quizState = ref.watch(quizProvider(widget.chatId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comprehension Quiz'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: quizState.when(
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('AI is generating your questions...'),
            ],
          ),
        ),
        error: (err, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 12),
                Text(
                  'Failed to load quiz:\n$err',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref.read(quizProvider(widget.chatId).notifier).retry();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (questions) {
          if (questions.isEmpty) {
            return const Center(child: Text('No questions generated.'));
          }

          if (_isFinished) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.emoji_events,
                      color: Colors.amber,
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Quiz Completed!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your Score: $_score / ${questions.length}',
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Back to Translation'),
                    ),
                  ],
                ),
              ),
            );
          }

          final question = questions[_currentIndex];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LinearProgressIndicator(
                  value: (_currentIndex + 1) / questions.length,
                  backgroundColor: Colors.grey.shade200,
                ),
                const SizedBox(height: 16),
                Text(
                  'Question ${_currentIndex + 1} of ${questions.length}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  question.question,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                ...List.generate(question.options.length, (index) {
                  Color buttonColor = Colors.white;
                  Color textColor = Colors.black87;
                  BorderSide borderSide = BorderSide(
                    color: Colors.grey.shade300,
                  );

                  if (_isAnswered) {
                    if (index == question.correctIndex) {
                      buttonColor = Colors.green.shade50;
                      borderSide = const BorderSide(
                        color: Colors.green,
                        width: 2,
                      );
                      textColor = Colors.green.shade900;
                    } else if (index == _selectedOptionIndex) {
                      buttonColor = Colors.red.shade50;
                      borderSide = const BorderSide(
                        color: Colors.red,
                        width: 2,
                      );
                      textColor = Colors.red.shade900;
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: buttonColor,
                        side: borderSide,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () =>
                          _handleOptionSelected(index, question.correctIndex),
                      child: Text(
                        question.options[index],
                        style: TextStyle(fontSize: 15, color: textColor),
                      ),
                    ),
                  );
                }),

                const Spacer(),

                if (_isAnswered) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      question.explanation,
                      style: TextStyle(
                        color: Colors.blue.shade900,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                    ),
                    onPressed: () => _nextQuestion(questions.length),
                    child: Text(
                      _currentIndex < questions.length - 1
                          ? 'Next Question'
                          : 'View Results',
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
