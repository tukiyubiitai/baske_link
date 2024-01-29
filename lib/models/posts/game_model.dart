import 'package:cloud_firestore/cloud_firestore.dart';

import '../account/account.dart';

class GamePost {
  final String id;
  final String postAccountId;
  final List<String> locationTagList; //エリア
  final String prefecture; // 場所
  final int level; // レベル
  final String teamName; // チーム名
  final Timestamp createdTime; //投稿時間
  final String member; //構成メンバー
  final List<String> ageList; //年齢層

  final String type; //投稿種類

  String? imageUrl; //画像
  String? note; //自由欄

  GamePost(
      {this.id = "",
      required this.postAccountId,
      required this.locationTagList,
      required this.teamName,
      required this.level,
      required this.prefecture,
      required this.createdTime,
      required this.member,
      required this.ageList,
      required this.type,
      this.imageUrl,
      this.note});

// FirestoreのデータをGamePostオブジェクトに変換するファクトリコンストラクタ
  // FirestoreのドキュメントからGamePostオブジェクトを生成するファクトリコンストラクタ
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
      imageUrl: data['imageUrl'],
      note: data['note'],
    );
  }
}

class GamePostData {
  final List<GamePost> posts;
  final Map<String, Account> users;

  GamePostData({required this.posts, required this.users});
}
