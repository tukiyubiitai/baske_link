// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_post_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$gamePostNotifierHash() => r'7273f7eac5e3da6f3831d804e86eeffb64152214';

/// See also [GamePostNotifier].
@ProviderFor(GamePostNotifier)
final gamePostNotifierProvider =
    AutoDisposeAsyncNotifierProvider<GamePostNotifier, GamePostData>.internal(
  GamePostNotifier.new,
  name: r'gamePostNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$gamePostNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GamePostNotifier = AutoDisposeAsyncNotifier<GamePostData>;
String _$myGamePostNotifierHash() =>
    r'18065b7769a4a2033022846c38adad7597eb7e65';

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

abstract class _$MyGamePostNotifier
    extends BuildlessAutoDisposeAsyncNotifier<List<GamePost>?> {
  late final Account myAccount;

  FutureOr<List<GamePost>?> build(
    Account myAccount,
  );
}

/// See also [MyGamePostNotifier].
@ProviderFor(MyGamePostNotifier)
const myGamePostNotifierProvider = MyGamePostNotifierFamily();

/// See also [MyGamePostNotifier].
class MyGamePostNotifierFamily extends Family<AsyncValue<List<GamePost>?>> {
  /// See also [MyGamePostNotifier].
  const MyGamePostNotifierFamily();

  /// See also [MyGamePostNotifier].
  MyGamePostNotifierProvider call(
    Account myAccount,
  ) {
    return MyGamePostNotifierProvider(
      myAccount,
    );
  }

  @override
  MyGamePostNotifierProvider getProviderOverride(
    covariant MyGamePostNotifierProvider provider,
  ) {
    return call(
      provider.myAccount,
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
  String? get name => r'myGamePostNotifierProvider';
}

/// See also [MyGamePostNotifier].
class MyGamePostNotifierProvider extends AutoDisposeAsyncNotifierProviderImpl<
    MyGamePostNotifier, List<GamePost>?> {
  /// See also [MyGamePostNotifier].
  MyGamePostNotifierProvider(
    Account myAccount,
  ) : this._internal(
          () => MyGamePostNotifier()..myAccount = myAccount,
          from: myGamePostNotifierProvider,
          name: r'myGamePostNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$myGamePostNotifierHash,
          dependencies: MyGamePostNotifierFamily._dependencies,
          allTransitiveDependencies:
              MyGamePostNotifierFamily._allTransitiveDependencies,
          myAccount: myAccount,
        );

  MyGamePostNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.myAccount,
  }) : super.internal();

  final Account myAccount;

  @override
  FutureOr<List<GamePost>?> runNotifierBuild(
    covariant MyGamePostNotifier notifier,
  ) {
    return notifier.build(
      myAccount,
    );
  }

  @override
  Override overrideWith(MyGamePostNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: MyGamePostNotifierProvider._internal(
        () => create()..myAccount = myAccount,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        myAccount: myAccount,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<MyGamePostNotifier, List<GamePost>?>
      createElement() {
    return _MyGamePostNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MyGamePostNotifierProvider && other.myAccount == myAccount;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, myAccount.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MyGamePostNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<List<GamePost>?> {
  /// The parameter `myAccount` of this provider.
  Account get myAccount;
}

class _MyGamePostNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<MyGamePostNotifier,
        List<GamePost>?> with MyGamePostNotifierRef {
  _MyGamePostNotifierProviderElement(super.provider);

  @override
  Account get myAccount => (origin as MyGamePostNotifierProvider).myAccount;
}

String _$gameSearchNotifierHash() =>
    r'6446a37033f6cb5bdc0fd122ed16c95d12f69f90';

abstract class _$GameSearchNotifier
    extends BuildlessAutoDisposeAsyncNotifier<GamePostData> {
  late final String? selectedLocation;
  late final String? keywordLocation;

  FutureOr<GamePostData> build(
    String? selectedLocation,
    String? keywordLocation,
  );
}

/// See also [GameSearchNotifier].
@ProviderFor(GameSearchNotifier)
const gameSearchNotifierProvider = GameSearchNotifierFamily();

/// See also [GameSearchNotifier].
class GameSearchNotifierFamily extends Family<AsyncValue<GamePostData>> {
  /// See also [GameSearchNotifier].
  const GameSearchNotifierFamily();

  /// See also [GameSearchNotifier].
  GameSearchNotifierProvider call(
    String? selectedLocation,
    String? keywordLocation,
  ) {
    return GameSearchNotifierProvider(
      selectedLocation,
      keywordLocation,
    );
  }

  @override
  GameSearchNotifierProvider getProviderOverride(
    covariant GameSearchNotifierProvider provider,
  ) {
    return call(
      provider.selectedLocation,
      provider.keywordLocation,
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
  String? get name => r'gameSearchNotifierProvider';
}

/// See also [GameSearchNotifier].
class GameSearchNotifierProvider extends AutoDisposeAsyncNotifierProviderImpl<
    GameSearchNotifier, GamePostData> {
  /// See also [GameSearchNotifier].
  GameSearchNotifierProvider(
    String? selectedLocation,
    String? keywordLocation,
  ) : this._internal(
          () => GameSearchNotifier()
            ..selectedLocation = selectedLocation
            ..keywordLocation = keywordLocation,
          from: gameSearchNotifierProvider,
          name: r'gameSearchNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$gameSearchNotifierHash,
          dependencies: GameSearchNotifierFamily._dependencies,
          allTransitiveDependencies:
              GameSearchNotifierFamily._allTransitiveDependencies,
          selectedLocation: selectedLocation,
          keywordLocation: keywordLocation,
        );

  GameSearchNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.selectedLocation,
    required this.keywordLocation,
  }) : super.internal();

  final String? selectedLocation;
  final String? keywordLocation;

  @override
  FutureOr<GamePostData> runNotifierBuild(
    covariant GameSearchNotifier notifier,
  ) {
    return notifier.build(
      selectedLocation,
      keywordLocation,
    );
  }

  @override
  Override overrideWith(GameSearchNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: GameSearchNotifierProvider._internal(
        () => create()
          ..selectedLocation = selectedLocation
          ..keywordLocation = keywordLocation,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        selectedLocation: selectedLocation,
        keywordLocation: keywordLocation,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<GameSearchNotifier, GamePostData>
      createElement() {
    return _GameSearchNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GameSearchNotifierProvider &&
        other.selectedLocation == selectedLocation &&
        other.keywordLocation == keywordLocation;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, selectedLocation.hashCode);
    hash = _SystemHash.combine(hash, keywordLocation.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GameSearchNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<GamePostData> {
  /// The parameter `selectedLocation` of this provider.
  String? get selectedLocation;

  /// The parameter `keywordLocation` of this provider.
  String? get keywordLocation;
}

class _GameSearchNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<GameSearchNotifier,
        GamePostData> with GameSearchNotifierRef {
  _GameSearchNotifierProviderElement(super.provider);

  @override
  String? get selectedLocation =>
      (origin as GameSearchNotifierProvider).selectedLocation;
  @override
  String? get keywordLocation =>
      (origin as GameSearchNotifierProvider).keywordLocation;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
