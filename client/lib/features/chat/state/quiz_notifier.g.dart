// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(QuizNotifier)
final quizProvider = QuizNotifierFamily._();

final class QuizNotifierProvider
    extends $AsyncNotifierProvider<QuizNotifier, List<QuizQuestion>> {
  QuizNotifierProvider._({
    required QuizNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'quizProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$quizNotifierHash();

  @override
  String toString() {
    return r'quizProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  QuizNotifier create() => QuizNotifier();

  @override
  bool operator ==(Object other) {
    return other is QuizNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$quizNotifierHash() => r'c83ff5821bdb8b7f68451ba9fc32fd88b637bca2';

final class QuizNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          QuizNotifier,
          AsyncValue<List<QuizQuestion>>,
          List<QuizQuestion>,
          FutureOr<List<QuizQuestion>>,
          String
        > {
  QuizNotifierFamily._()
    : super(
        retry: null,
        name: r'quizProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  QuizNotifierProvider call(String chatId) =>
      QuizNotifierProvider._(argument: chatId, from: this);

  @override
  String toString() => r'quizProvider';
}

abstract class _$QuizNotifier extends $AsyncNotifier<List<QuizQuestion>> {
  late final _$args = ref.$arg as String;
  String get chatId => _$args;

  FutureOr<List<QuizQuestion>> build(String chatId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<QuizQuestion>>, List<QuizQuestion>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<QuizQuestion>>, List<QuizQuestion>>,
              AsyncValue<List<QuizQuestion>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
