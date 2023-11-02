import 'package:cloud_firestore/cloud_firestore.dart';

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
}
