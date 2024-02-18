// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$accountNotifierHash() => r'05154fbacda557996cbb67bfc034a092ba85183e';

/// See also [AccountNotifier].
@ProviderFor(AccountNotifier)
final accountNotifierProvider =
    NotifierProvider<AccountNotifier, Account>.internal(
  AccountNotifier.new,
  name: r'accountNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$accountNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AccountNotifier = Notifier<Account>;
String _$accountStateNotifierHash() =>
    r'79d6fe502211b1644814b6339dc46aad960b9ceb';

/// See also [AccountStateNotifier].
@ProviderFor(AccountStateNotifier)
final accountStateNotifierProvider =
    AutoDisposeNotifierProvider<AccountStateNotifier, AccountState>.internal(
  AccountStateNotifier.new,
  name: r'accountStateNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$accountStateNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AccountStateNotifier = AutoDisposeNotifier<AccountState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
