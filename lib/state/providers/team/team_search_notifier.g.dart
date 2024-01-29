// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_search_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$teamSearchNotifierHash() =>
    r'd554167bcfb8576e0d5f7b5cf883802b67d32c2f';

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

abstract class _$TeamSearchNotifier
    extends BuildlessAutoDisposeAsyncNotifier<TeamPostData> {
  late final String? selectedLocation;
  late final String? keywordLocation;

  FutureOr<TeamPostData> build(
    String? selectedLocation,
    String? keywordLocation,
  );
}

/// See also [TeamSearchNotifier].
@ProviderFor(TeamSearchNotifier)
const teamSearchNotifierProvider = TeamSearchNotifierFamily();

/// See also [TeamSearchNotifier].
class TeamSearchNotifierFamily extends Family<AsyncValue<TeamPostData>> {
  /// See also [TeamSearchNotifier].
  const TeamSearchNotifierFamily();

  /// See also [TeamSearchNotifier].
  TeamSearchNotifierProvider call(
    String? selectedLocation,
    String? keywordLocation,
  ) {
    return TeamSearchNotifierProvider(
      selectedLocation,
      keywordLocation,
    );
  }

  @override
  TeamSearchNotifierProvider getProviderOverride(
    covariant TeamSearchNotifierProvider provider,
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
  String? get name => r'teamSearchNotifierProvider';
}

/// See also [TeamSearchNotifier].
class TeamSearchNotifierProvider extends AutoDisposeAsyncNotifierProviderImpl<
    TeamSearchNotifier, TeamPostData> {
  /// See also [TeamSearchNotifier].
  TeamSearchNotifierProvider(
    String? selectedLocation,
    String? keywordLocation,
  ) : this._internal(
          () => TeamSearchNotifier()
            ..selectedLocation = selectedLocation
            ..keywordLocation = keywordLocation,
          from: teamSearchNotifierProvider,
          name: r'teamSearchNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$teamSearchNotifierHash,
          dependencies: TeamSearchNotifierFamily._dependencies,
          allTransitiveDependencies:
              TeamSearchNotifierFamily._allTransitiveDependencies,
          selectedLocation: selectedLocation,
          keywordLocation: keywordLocation,
        );

  TeamSearchNotifierProvider._internal(
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
  FutureOr<TeamPostData> runNotifierBuild(
    covariant TeamSearchNotifier notifier,
  ) {
    return notifier.build(
      selectedLocation,
      keywordLocation,
    );
  }

  @override
  Override overrideWith(TeamSearchNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: TeamSearchNotifierProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<TeamSearchNotifier, TeamPostData>
      createElement() {
    return _TeamSearchNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TeamSearchNotifierProvider &&
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

mixin TeamSearchNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<TeamPostData> {
  /// The parameter `selectedLocation` of this provider.
  String? get selectedLocation;

  /// The parameter `keywordLocation` of this provider.
  String? get keywordLocation;
}

class _TeamSearchNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<TeamSearchNotifier,
        TeamPostData> with TeamSearchNotifierRef {
  _TeamSearchNotifierProviderElement(super.provider);

  @override
  String? get selectedLocation =>
      (origin as TeamSearchNotifierProvider).selectedLocation;
  @override
  String? get keywordLocation =>
      (origin as TeamSearchNotifierProvider).keywordLocation;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
