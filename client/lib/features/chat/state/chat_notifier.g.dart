// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ChatNotifier)
final chatProvider = ChatNotifierProvider._();

final class ChatNotifierProvider
    extends $AsyncNotifierProvider<ChatNotifier, Chat?> {
  ChatNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatNotifierHash();

  @$internal
  @override
  ChatNotifier create() => ChatNotifier();
}

String _$chatNotifierHash() => r'25a7c45bd597a0f21aa946ab0bc9f3d5aff6e87a';

abstract class _$ChatNotifier extends $AsyncNotifier<Chat?> {
  FutureOr<Chat?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Chat?>, Chat?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Chat?>, Chat?>,
              AsyncValue<Chat?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
