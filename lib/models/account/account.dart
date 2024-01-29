import 'package:freezed_annotation/freezed_annotation.dart';

part 'account.freezed.dart';

// class Account {
//   String id;
//   String name;
//   String? myToken;
//   String? imagePath;
//
//   List<String>? blockList;
//
//   Account({
//     required this.id,
//     required this.name,
//     this.myToken,
//     this.imagePath,
//     this.blockList,
//   });
// }

@freezed
class Account with _$Account {
  const factory Account({
    @Default('') String id,
    @Default('') String name,
    @Default('') String myToken,
    @Default('') String imagePath,
    @Default([]) List<String> blockList,
  }) = _Account;
}
