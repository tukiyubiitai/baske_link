// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$Account {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get myToken => throw _privateConstructorUsedError;
  String get imagePath => throw _privateConstructorUsedError;
  List<String> get blockList => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AccountCopyWith<Account> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountCopyWith<$Res> {
  factory $AccountCopyWith(Account value, $Res Function(Account) then) =
      _$AccountCopyWithImpl<$Res, Account>;
  @useResult
  $Res call(
      {String id,
      String name,
      String myToken,
      String imagePath,
      List<String> blockList});
}

/// @nodoc
class _$AccountCopyWithImpl<$Res, $Val extends Account>
    implements $AccountCopyWith<$Res> {
  _$AccountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? myToken = null,
    Object? imagePath = null,
    Object? blockList = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      myToken: null == myToken
          ? _value.myToken
          : myToken // ignore: cast_nullable_to_non_nullable
              as String,
      imagePath: null == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String,
      blockList: null == blockList
          ? _value.blockList
          : blockList // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AccountImplCopyWith<$Res> implements $AccountCopyWith<$Res> {
  factory _$$AccountImplCopyWith(
          _$AccountImpl value, $Res Function(_$AccountImpl) then) =
      __$$AccountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String myToken,
      String imagePath,
      List<String> blockList});
}

/// @nodoc
class __$$AccountImplCopyWithImpl<$Res>
    extends _$AccountCopyWithImpl<$Res, _$AccountImpl>
    implements _$$AccountImplCopyWith<$Res> {
  __$$AccountImplCopyWithImpl(
      _$AccountImpl _value, $Res Function(_$AccountImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? myToken = null,
    Object? imagePath = null,
    Object? blockList = null,
  }) {
    return _then(_$AccountImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      myToken: null == myToken
          ? _value.myToken
          : myToken // ignore: cast_nullable_to_non_nullable
              as String,
      imagePath: null == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String,
      blockList: null == blockList
          ? _value._blockList
          : blockList // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$AccountImpl implements _Account {
  const _$AccountImpl(
      {this.id = '',
      this.name = '',
      this.myToken = '',
      this.imagePath = '',
      final List<String> blockList = const []})
      : _blockList = blockList;

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String myToken;
  @override
  @JsonKey()
  final String imagePath;
  final List<String> _blockList;
  @override
  @JsonKey()
  List<String> get blockList {
    if (_blockList is EqualUnmodifiableListView) return _blockList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_blockList);
  }

  @override
  String toString() {
    return 'Account(id: $id, name: $name, myToken: $myToken, imagePath: $imagePath, blockList: $blockList)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccountImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.myToken, myToken) || other.myToken == myToken) &&
            (identical(other.imagePath, imagePath) ||
                other.imagePath == imagePath) &&
            const DeepCollectionEquality()
                .equals(other._blockList, _blockList));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name, myToken, imagePath,
      const DeepCollectionEquality().hash(_blockList));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AccountImplCopyWith<_$AccountImpl> get copyWith =>
      __$$AccountImplCopyWithImpl<_$AccountImpl>(this, _$identity);
}

abstract class _Account implements Account {
  const factory _Account(
      {final String id,
      final String name,
      final String myToken,
      final String imagePath,
      final List<String> blockList}) = _$AccountImpl;

  @override
  String get id;
  @override
  String get name;
  @override
  String get myToken;
  @override
  String get imagePath;
  @override
  List<String> get blockList;
  @override
  @JsonKey(ignore: true)
  _$$AccountImplCopyWith<_$AccountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AccountState {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get imagePath => throw _privateConstructorUsedError;
  bool get isAccountCreatedSuccessfully => throw _privateConstructorUsedError;
  bool get isEditing => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AccountStateCopyWith<AccountState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountStateCopyWith<$Res> {
  factory $AccountStateCopyWith(
          AccountState value, $Res Function(AccountState) then) =
      _$AccountStateCopyWithImpl<$Res, AccountState>;
  @useResult
  $Res call(
      {String id,
      String name,
      String imagePath,
      bool isAccountCreatedSuccessfully,
      bool isEditing});
}

/// @nodoc
class _$AccountStateCopyWithImpl<$Res, $Val extends AccountState>
    implements $AccountStateCopyWith<$Res> {
  _$AccountStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? imagePath = null,
    Object? isAccountCreatedSuccessfully = null,
    Object? isEditing = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      imagePath: null == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String,
      isAccountCreatedSuccessfully: null == isAccountCreatedSuccessfully
          ? _value.isAccountCreatedSuccessfully
          : isAccountCreatedSuccessfully // ignore: cast_nullable_to_non_nullable
              as bool,
      isEditing: null == isEditing
          ? _value.isEditing
          : isEditing // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AccountStateImplCopyWith<$Res>
    implements $AccountStateCopyWith<$Res> {
  factory _$$AccountStateImplCopyWith(
          _$AccountStateImpl value, $Res Function(_$AccountStateImpl) then) =
      __$$AccountStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String imagePath,
      bool isAccountCreatedSuccessfully,
      bool isEditing});
}

/// @nodoc
class __$$AccountStateImplCopyWithImpl<$Res>
    extends _$AccountStateCopyWithImpl<$Res, _$AccountStateImpl>
    implements _$$AccountStateImplCopyWith<$Res> {
  __$$AccountStateImplCopyWithImpl(
      _$AccountStateImpl _value, $Res Function(_$AccountStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? imagePath = null,
    Object? isAccountCreatedSuccessfully = null,
    Object? isEditing = null,
  }) {
    return _then(_$AccountStateImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      imagePath: null == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String,
      isAccountCreatedSuccessfully: null == isAccountCreatedSuccessfully
          ? _value.isAccountCreatedSuccessfully
          : isAccountCreatedSuccessfully // ignore: cast_nullable_to_non_nullable
              as bool,
      isEditing: null == isEditing
          ? _value.isEditing
          : isEditing // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$AccountStateImpl implements _AccountState {
  const _$AccountStateImpl(
      {this.id = '',
      this.name = '',
      this.imagePath = '',
      this.isAccountCreatedSuccessfully = false,
      this.isEditing = false});

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String imagePath;
  @override
  @JsonKey()
  final bool isAccountCreatedSuccessfully;
  @override
  @JsonKey()
  final bool isEditing;

  @override
  String toString() {
    return 'AccountState(id: $id, name: $name, imagePath: $imagePath, isAccountCreatedSuccessfully: $isAccountCreatedSuccessfully, isEditing: $isEditing)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccountStateImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.imagePath, imagePath) ||
                other.imagePath == imagePath) &&
            (identical(other.isAccountCreatedSuccessfully,
                    isAccountCreatedSuccessfully) ||
                other.isAccountCreatedSuccessfully ==
                    isAccountCreatedSuccessfully) &&
            (identical(other.isEditing, isEditing) ||
                other.isEditing == isEditing));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name, imagePath,
      isAccountCreatedSuccessfully, isEditing);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AccountStateImplCopyWith<_$AccountStateImpl> get copyWith =>
      __$$AccountStateImplCopyWithImpl<_$AccountStateImpl>(this, _$identity);
}

abstract class _AccountState implements AccountState {
  const factory _AccountState(
      {final String id,
      final String name,
      final String imagePath,
      final bool isAccountCreatedSuccessfully,
      final bool isEditing}) = _$AccountStateImpl;

  @override
  String get id;
  @override
  String get name;
  @override
  String get imagePath;
  @override
  bool get isAccountCreatedSuccessfully;
  @override
  bool get isEditing;
  @override
  @JsonKey(ignore: true)
  _$$AccountStateImplCopyWith<_$AccountStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
