// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_chats_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UserChatsNotifier)
final userChatsProvider = UserChatsNotifierProvider._();

final class UserChatsNotifierProvider
    extends $AsyncNotifierProvider<UserChatsNotifier, List<Chat>> {
  UserChatsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userChatsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userChatsNotifierHash();

  @$internal
  @override
  UserChatsNotifier create() => UserChatsNotifier();
}

String _$userChatsNotifierHash() => r'29cfe00f79b436e6ece4031154e3a1ebe75c012d';

abstract class _$UserChatsNotifier extends $AsyncNotifier<List<Chat>> {
  FutureOr<List<Chat>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Chat>>, List<Chat>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Chat>>, List<Chat>>,
              AsyncValue<List<Chat>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
