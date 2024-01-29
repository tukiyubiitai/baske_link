import 'package:cloud_firestore/cloud_firestore.dart';

import '../account/account.dart';

class TeamPost {
  final String id; // ユーザID
  final String postAccountId; // 投稿したユーザID
  final String prefecture; // エリア
  final String activityTime; // 活動時間
  final String teamName; // チーム名
  final Timestamp createdTime; // 投稿した日時
  final List<String> locationTagList; // 場所
  final List<String> targetList; // ターゲット層
  final List<String> ageList; // 年齢層
  final List<String>? prefectureAndLocation; // エリアと場所のリスト
  final String? teamAppeal; // チームの魅力や募集内容
  final String? cost; // 会費
  final String? goal; // 目標
  final String? memberCount; // メンバー数
  final String? imageUrl; // 画像URL
  final String? headerUrl; // ヘッダー画像URL
  final String? note; // 詳細ノート
  final String type; // 投稿の種類

  TeamPost({
    this.id = "",
    required this.postAccountId,
    required this.locationTagList,
    required this.prefecture,
    required this.activityTime,
    required this.teamName,
    required this.createdTime,
    required this.targetList,
    required this.ageList,
    required this.type,
    this.prefectureAndLocation,
    this.teamAppeal,
    this.cost,
    this.goal,
    this.memberCount,
    this.imageUrl,
    this.headerUrl,
    this.note,
  });

  // FirestoreのデータをTeamPostオブジェクトに変換するファクトリコンストラクタ
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
      prefectureAndLocation:
          List<String>.from(data['prefectureAndLocation'] ?? []),
      teamAppeal: data['teamAppeal'],
      cost: data['cost'],
      goal: data['goal'],
      memberCount: data['memberCount'],
      imageUrl: data['imageUrl'],
      headerUrl: data['headerUrl'],
      note: data['note'],
    );
  }
}

class TeamPostData {
  final List<TeamPost> posts;
  final List<Account> users;

  TeamPostData({required this.posts, required this.users});
}
