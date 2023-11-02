import 'package:flutter/material.dart';

import '../../models/account.dart';
import '../../models/game_model.dart';
import '../../models/team_model.dart';
import 'post_item_widget.dart';

class TeamPostWidget extends StatefulWidget {
  final Map<String, dynamic> data;
  final Map<String, Account> userData;
  final String id; // id を追加
  const TeamPostWidget(
      {super.key,
      required this.data,
      required this.id,
      required this.userData});

  @override
  State<TeamPostWidget> createState() => _TeamPostWidgetState();
}

class _TeamPostWidgetState extends State<TeamPostWidget> {
  Account? postAccount; // 投稿したアカウント情報
  @override
  void initState() {
    super.initState();
    // widget.data["post_account_id"] と一致するアカウント情報を userData マップから取得
    if (widget.userData.containsKey(widget.data["post_account_id"])) {
      postAccount = widget.userData[widget.data["post_account_id"]];
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> locationList = List<String>.from(widget.data["location"]);
    List<String> targetList = List<String>.from(widget.data["target"]);
    List<String> ageList = List<String>.from(widget.data["age"]);
    List<String> prefectureAndLocation = [
      ...locationList,
      widget.data["prefecture"]
    ];
    TeamPost post = TeamPost(
        id: widget.id,
        postAccountId: widget.data["post_account_id"],
        locationTagList: locationList,
        prefecture: widget.data["prefecture"],
        goal: widget.data["goal"],
        activityTime: widget.data["activityTime"],
        memberCount: widget.data["memberCount"],
        teamName: widget.data["teamName"],
        targetList: targetList,
        note: widget.data["note"],
        imageUrl: widget.data["imageUrl"],
        createdTime: widget.data["created_time"],
        searchCriteria: widget.data["searchCriteria"],
        ageList: ageList,
        cost: widget.data["cost"],
        headerUrl: widget.data["headerUrl"],
        prefectureAndLocation: prefectureAndLocation,
        type: 'team');
    return TeamListItemWidget(
      recruitment: widget.data,
      postId: post.id,
      postAccountData: postAccount as Account,
    ); // listItemウィ
  }
}

class GamePostWidget extends StatefulWidget {
  final Map<String, dynamic> data;
  final String id; // id を追加

  final Map<String, Account> userData;

  const GamePostWidget(
      {super.key,
      required this.data,
      required this.id,
      required this.userData});

  @override
  State<GamePostWidget> createState() => _GamePostWidgetState();
}

class _GamePostWidgetState extends State<GamePostWidget> {
  Account? postAccount; // 投稿したアカウント情報

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.userData.containsKey(widget.data["post_account_id"])) {
      postAccount = widget.userData[widget.data["post_account_id"]];
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> ageList = List<String>.from(widget.data["ageList"]);
    List<String> locationTageList =
        List<String>.from(widget.data["locationTagList"]);
    GamePost post = GamePost(
      id: widget.id,
      postAccountId: widget.data["post_account_id"],
      locationTagList: locationTageList,
      prefecture: widget.data["prefecture"],
      teamName: widget.data["teamName"],
      note: widget.data["note"],
      imageUrl: widget.data["imageUrl"],
      createdTime: widget.data["created_time"],
      ageList: ageList,
      level: widget.data["level"],
      member: widget.data["member"],
      type: 'game',
    );

    return GameListItemWidget(
      recruitment: widget.data,
      postId: post.id,
      postAccountData: postAccount as Account,
    );
  }
}
