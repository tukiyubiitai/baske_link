import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../account/account.dart';

part 'team_model.freezed.dart';

@freezed
class TeamPost with _$TeamPost {
  const factory TeamPost({
    @Default('') String id, // ユーザID
    required String postAccountId, // 投稿したユーザID
    required String prefecture, // エリア
    required String activityTime, // 活動時間
    required String teamName, // チーム名
    required Timestamp createdTime, // 投稿した日時
    required List<String> locationTagList, // 場所
    required List<String> targetList, // ターゲット層
    required List<String> ageList, // 年齢層
    @Default('') String teamAppeal, // チームの魅力や募集内容
    @Default('') String cost, // 会費
    @Default('') String goal, // 目標
    @Default('') String memberCount, // メンバー数
    @Default('') String headerUrl, // ヘッダー画像URL
    @Default('') String type, // 投稿の種類
    @Default('') String imagePath,
    @Default('') String oldImagePath,
    @Default('') String oldHeaderImagePath,
    @Default('') String note,
    @Default(false) bool isLoading,
    @Default(false) bool isTeamPostSuccessful,
  }) = _TeamPost;

  factory TeamPost.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return TeamPost(
      id: doc.id,
      postAccountId: data['post_account_id'] ?? '',
      locationTagList: List<String>.from(data['locationTagList'] ?? []),
      prefecture: data['prefecture'] ?? '',
      activityTime: data['activityTime'] ?? '',
      teamName: data['teamName'] ?? '',
      createdTime: data['created_time'],
      targetList: List<String>.from(data['target'] ?? []),
      ageList: List<String>.from(data['age'] ?? []),
      type: data['type'] ?? 'team',
      teamAppeal: data['teamAppeal'],
      cost: data['cost'],
      goal: data['goal'],
      memberCount: data['memberCount'],
      imagePath: data['imageUrl'],
      headerUrl: data['headerUrl'],
      note: data['note'],
    );
  }
}

@freezed
class TeamPostData with _$TeamPostData {
  const factory TeamPostData({
    required List<TeamPost> posts,
    required List<Account> users,
  }) = _TeamPostData;
}
