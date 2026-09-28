// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_lookup_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(WordLookupNotifier)
final wordLookupProvider = WordLookupNotifierProvider._();

final class WordLookupNotifierProvider
    extends $AsyncNotifierProvider<WordLookupNotifier, Map<String, dynamic>?> {
  WordLookupNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'wordLookupProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wordLookupNotifierHash();

  @$internal
  @override
  WordLookupNotifier create() => WordLookupNotifier();
}

String _$wordLookupNotifierHash() =>
    r'0b9c6e78d8228873662c6c888c2fefa94b0daac4';

abstract class _$WordLookupNotifier
    extends $AsyncNotifier<Map<String, dynamic>?> {
  FutureOr<Map<String, dynamic>?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<Map<String, dynamic>?>, Map<String, dynamic>?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<Map<String, dynamic>?>,
                Map<String, dynamic>?
              >,
              AsyncValue<Map<String, dynamic>?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
