import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/account/account.dart';
import '../../view_models/account_view_model.dart';
import '../../view_models/auth_view_model.dart';
import '../../view_models/game_view_model.dart';
import '../../view_models/map_view_model.dart';
import '../../view_models/message_view_model.dart';
import '../../view_models/post_view_model.dart';
import '../../view_models/talk_room_view_model.dart';
import '../../view_models/team_view_model.dart';

final authViewModelProvider = ChangeNotifierProvider((ref) {
  return AuthViewModel();
});

final mapViewModelProvider = ChangeNotifierProvider((ref) {
  return MapViewModel();
});

final postViewModel = ChangeNotifierProvider((ref) {
  return PostViewModel();
});

final teamPostViewModel = ChangeNotifierProvider((ref) {
  return TeamPostViewModel();
});

final gamePostViewModel = ChangeNotifierProvider((ref) {
  return GamePostViewModel();
});
final talkRoomViewModel = ChangeNotifierProvider((ref) {
  return TalkRoomViewModel();
});
final messageViewModel = ChangeNotifierProvider((ref) {
  return MessageViewModel();
});

final errorMessageProvider = StateProvider<String?>((ref) => null);

final accountManagerProvider =
    StateNotifierProvider<AccountManager, AccountState>((ref) {
  return AccountManager();
});
