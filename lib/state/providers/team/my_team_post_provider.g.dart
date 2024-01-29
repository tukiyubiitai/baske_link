// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_team_post_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$myTeamPostNotifierHash() =>
    r'd8e64625a1e68389e8942fe9e96480a7f0310ee4';

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

abstract class _$MyTeamPostNotifier
    extends BuildlessAutoDisposeAsyncNotifier<List<TeamPost>?> {
  late final Account myAccount;

  FutureOr<List<TeamPost>?> build(
    Account myAccount,
  );
}

/// See also [MyTeamPostNotifier].
@ProviderFor(MyTeamPostNotifier)
const myTeamPostNotifierProvider = MyTeamPostNotifierFamily();

/// See also [MyTeamPostNotifier].
class MyTeamPostNotifierFamily extends Family<AsyncValue<List<TeamPost>?>> {
  /// See also [MyTeamPostNotifier].
  const MyTeamPostNotifierFamily();

  /// See also [MyTeamPostNotifier].
  MyTeamPostNotifierProvider call(
    Account myAccount,
  ) {
    return MyTeamPostNotifierProvider(
      myAccount,
    );
  }

  @override
  MyTeamPostNotifierProvider getProviderOverride(
    covariant MyTeamPostNotifierProvider provider,
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
  String? get name => r'myTeamPostNotifierProvider';
}

/// See also [MyTeamPostNotifier].
class MyTeamPostNotifierProvider extends AutoDisposeAsyncNotifierProviderImpl<
    MyTeamPostNotifier, List<TeamPost>?> {
  /// See also [MyTeamPostNotifier].
  MyTeamPostNotifierProvider(
    Account myAccount,
  ) : this._internal(
          () => MyTeamPostNotifier()..myAccount = myAccount,
          from: myTeamPostNotifierProvider,
          name: r'myTeamPostNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$myTeamPostNotifierHash,
          dependencies: MyTeamPostNotifierFamily._dependencies,
          allTransitiveDependencies:
              MyTeamPostNotifierFamily._allTransitiveDependencies,
          myAccount: myAccount,
        );

  MyTeamPostNotifierProvider._internal(
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
  FutureOr<List<TeamPost>?> runNotifierBuild(
    covariant MyTeamPostNotifier notifier,
  ) {
    return notifier.build(
      myAccount,
    );
  }

  @override
  Override overrideWith(MyTeamPostNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: MyTeamPostNotifierProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<MyTeamPostNotifier, List<TeamPost>?>
      createElement() {
    return _MyTeamPostNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MyTeamPostNotifierProvider && other.myAccount == myAccount;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, myAccount.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MyTeamPostNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<List<TeamPost>?> {
  /// The parameter `myAccount` of this provider.
  Account get myAccount;
}

class _MyTeamPostNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<MyTeamPostNotifier,
        List<TeamPost>?> with MyTeamPostNotifierRef {
  _MyTeamPostNotifierProviderElement(super.provider);

  @override
  Account get myAccount => (origin as MyTeamPostNotifierProvider).myAccount;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
