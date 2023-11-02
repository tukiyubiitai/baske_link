import 'package:cloud_firestore/cloud_firestore.dart';

class TeamPost {
  final String id; //ユーザID
  final String postAccountId; //投稿したユーザID
  final String prefecture; // エリア

  final String activityTime; // 活動時間
  final String teamName; // チーム名
  final Timestamp createdTime; //投稿した日にちと時間

  final List<String> locationTagList; //　場所
  final List<String> targetList; //ターゲット層
  final List<String> ageList; //年齢層
  final List<String> prefectureAndLocation;

  final String? searchCriteria; //こんな人を探しています
  final String? cost; //会費
  final String? goal; // 目標
  final String? memberCount; // メンバー数
  final String? imageUrl; //画像
  final String? headerUrl; //ヘッダー画像
  final String? note; //詳細

  final String type; //投稿の種類

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
    required this.prefectureAndLocation,
    required this.type,
    this.searchCriteria,
    this.cost,
    this.goal,
    this.memberCount,
    this.imageUrl,
    this.headerUrl,
    this.note,
  });
}
