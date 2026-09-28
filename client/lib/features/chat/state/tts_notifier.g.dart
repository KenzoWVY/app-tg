// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tts_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TtsNotifier)
final ttsProvider = TtsNotifierProvider._();

final class TtsNotifierProvider
    extends $AsyncNotifierProvider<TtsNotifier, Uint8List?> {
  TtsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ttsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ttsNotifierHash();

  @$internal
  @override
  TtsNotifier create() => TtsNotifier();
}

String _$ttsNotifierHash() => r'183c3d12d5619aa890e699f77c2f21920cd3330e';

abstract class _$TtsNotifier extends $AsyncNotifier<Uint8List?> {
  FutureOr<Uint8List?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Uint8List?>, Uint8List?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Uint8List?>, Uint8List?>,
              AsyncValue<Uint8List?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
