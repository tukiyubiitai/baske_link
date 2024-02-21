import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../account/account.dart';

part 'game_model.freezed.dart';

@freezed
class GamePost with _$GamePost {
  const factory GamePost({
    @Default('') String id,
    required String postAccountId,
    required List<String> locationTagList, //エリア
    required String prefecture, // 場所
    required int level, // レベル
    required String teamName, // チーム名
    required Timestamp createdTime, //投稿時間
    required String member, //構成メンバー
    required List<String> ageList, //年齢層
    required String type, //投稿種類
    @Default('') String imagePath,
    @Default('') String oldImagePath,
    @Default('') String note,
    @Default(false) bool isLoading,
    @Default(false) bool isGamePostSuccessful,
  }) = _GamePost;

  factory GamePost.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return GamePost(
      id: doc.id,
      postAccountId: data['post_account_id'] ?? '',
      locationTagList: List<String>.from(data['locationTagList'] ?? []),
      teamName: data['teamName'] ?? '',
      level: data['level'] ?? 0,
      prefecture: data['prefecture'] ?? '',
      createdTime: data['created_time'] ?? Timestamp.now(),
      member: data['member'] ?? '',
      ageList: List<String>.from(data['ageList'] ?? []),
      type: data['type'] ?? '',
      imagePath: data['imageUrl'],
      note: data['note'],
    );
  }
}

@freezed
class GamePostData with _$GamePostData {
  const factory GamePostData({
    required List<GamePost> posts,
    required Map<String, Account> users,
  }) = _GamePostData;
}
