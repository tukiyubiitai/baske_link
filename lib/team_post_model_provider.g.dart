// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_post_model_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$postStateNotifierHash() => r'94697e136cda8ead42995226ce48415eb985e62a';

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

abstract class _$PostStateNotifier
    extends BuildlessAutoDisposeAsyncNotifier<TeamPost?> {
  late final String? postId;
  late final bool isEditing;

  FutureOr<TeamPost?> build(
    String? postId,
    bool isEditing,
  );
}

/// See also [PostStateNotifier].
@ProviderFor(PostStateNotifier)
const postStateNotifierProvider = PostStateNotifierFamily();

/// See also [PostStateNotifier].
class PostStateNotifierFamily extends Family<AsyncValue<TeamPost?>> {
  /// See also [PostStateNotifier].
  const PostStateNotifierFamily();

  /// See also [PostStateNotifier].
  PostStateNotifierProvider call(
    String? postId,
    bool isEditing,
  ) {
    return PostStateNotifierProvider(
      postId,
      isEditing,
    );
  }

  @override
  PostStateNotifierProvider getProviderOverride(
    covariant PostStateNotifierProvider provider,
  ) {
    return call(
      provider.postId,
      provider.isEditing,
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
  String? get name => r'postStateNotifierProvider';
}

/// See also [PostStateNotifier].
class PostStateNotifierProvider
    extends AutoDisposeAsyncNotifierProviderImpl<PostStateNotifier, TeamPost?> {
  /// See also [PostStateNotifier].
  PostStateNotifierProvider(
    String? postId,
    bool isEditing,
  ) : this._internal(
          () => PostStateNotifier()
            ..postId = postId
            ..isEditing = isEditing,
          from: postStateNotifierProvider,
          name: r'postStateNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$postStateNotifierHash,
          dependencies: PostStateNotifierFamily._dependencies,
          allTransitiveDependencies:
              PostStateNotifierFamily._allTransitiveDependencies,
          postId: postId,
          isEditing: isEditing,
        );

  PostStateNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.postId,
    required this.isEditing,
  }) : super.internal();

  final String? postId;
  final bool isEditing;

  @override
  FutureOr<TeamPost?> runNotifierBuild(
    covariant PostStateNotifier notifier,
  ) {
    return notifier.build(
      postId,
      isEditing,
    );
  }

  @override
  Override overrideWith(PostStateNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: PostStateNotifierProvider._internal(
        () => create()
          ..postId = postId
          ..isEditing = isEditing,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        postId: postId,
        isEditing: isEditing,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<PostStateNotifier, TeamPost?>
      createElement() {
    return _PostStateNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PostStateNotifierProvider &&
        other.postId == postId &&
        other.isEditing == isEditing;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, postId.hashCode);
    hash = _SystemHash.combine(hash, isEditing.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PostStateNotifierRef on AutoDisposeAsyncNotifierProviderRef<TeamPost?> {
  /// The parameter `postId` of this provider.
  String? get postId;

  /// The parameter `isEditing` of this provider.
  bool get isEditing;
}

class _PostStateNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<PostStateNotifier,
        TeamPost?> with PostStateNotifierRef {
  _PostStateNotifierProviderElement(super.provider);

  @override
  String? get postId => (origin as PostStateNotifierProvider).postId;
  @override
  bool get isEditing => (origin as PostStateNotifierProvider).isEditing;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
