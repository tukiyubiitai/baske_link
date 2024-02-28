// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$messageNotifierHash() => r'6c5dd4cb3c7f055453f2cc6ba726a0c3b7600e02';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$MessageNotifier
    extends BuildlessAutoDisposeAsyncNotifier<List<Message>> {
  late final TalkRoom talkRoom;

  FutureOr<List<Message>> build(
    TalkRoom talkRoom,
  );
}

/// See also [MessageNotifier].
@ProviderFor(MessageNotifier)
const messageNotifierProvider = MessageNotifierFamily();

/// See also [MessageNotifier].
class MessageNotifierFamily extends Family<AsyncValue<List<Message>>> {
  /// See also [MessageNotifier].
  const MessageNotifierFamily();

  /// See also [MessageNotifier].
  MessageNotifierProvider call(
    TalkRoom talkRoom,
  ) {
    return MessageNotifierProvider(
      talkRoom,
    );
  }

  @override
  MessageNotifierProvider getProviderOverride(
    covariant MessageNotifierProvider provider,
  ) {
    return call(
      provider.talkRoom,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'messageNotifierProvider';
}

/// See also [MessageNotifier].
class MessageNotifierProvider extends AutoDisposeAsyncNotifierProviderImpl<
    MessageNotifier, List<Message>> {
  /// See also [MessageNotifier].
  MessageNotifierProvider(
    TalkRoom talkRoom,
  ) : this._internal(
          () => MessageNotifier()..talkRoom = talkRoom,
          from: messageNotifierProvider,
          name: r'messageNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$messageNotifierHash,
          dependencies: MessageNotifierFamily._dependencies,
          allTransitiveDependencies:
              MessageNotifierFamily._allTransitiveDependencies,
          talkRoom: talkRoom,
        );

  MessageNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.talkRoom,
  }) : super.internal();

  final TalkRoom talkRoom;

  @override
  FutureOr<List<Message>> runNotifierBuild(
    covariant MessageNotifier notifier,
  ) {
    return notifier.build(
      talkRoom,
    );
  }

  @override
  Override overrideWith(MessageNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: MessageNotifierProvider._internal(
        () => create()..talkRoom = talkRoom,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        talkRoom: talkRoom,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<MessageNotifier, List<Message>>
      createElement() {
    return _MessageNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MessageNotifierProvider && other.talkRoom == talkRoom;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, talkRoom.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MessageNotifierRef on AutoDisposeAsyncNotifierProviderRef<List<Message>> {
  /// The parameter `talkRoom` of this provider.
  TalkRoom get talkRoom;
}

class _MessageNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<MessageNotifier,
        List<Message>> with MessageNotifierRef {
  _MessageNotifierProviderElement(super.provider);

  @override
  TalkRoom get talkRoom => (origin as MessageNotifierProvider).talkRoom;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
