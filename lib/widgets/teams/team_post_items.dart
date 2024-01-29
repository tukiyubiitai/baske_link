import 'package:basketball_app/widgets/teams/team_body_widget.dart';
import 'package:basketball_app/widgets/teams/team_header_widget.dart';
import 'package:flutter/material.dart';

import '../../models/account/account.dart';
import '../../models/posts/team_model.dart';

class TeamPostItem extends StatefulWidget {
  final TeamPost postData;
  final String postId;
  final Account userData;

  const TeamPostItem(
      {super.key,
      required this.postData,
      required this.postId,
      required this.userData});

  @override
  State<TeamPostItem> createState() => _TeamPostItemState();
}

class _TeamPostItemState extends State<TeamPostItem> {
  @override
  Widget build(BuildContext context) {
    print("teamPostItemが呼ばれた");
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.all(20),
          // height: MediaQuery.of(context).size.height * 0.9,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              PostHeader(
                isTimelinePage: true,
                postData: widget.postData,
              ),
              PostBody(
                isTimelinePage: true,
                postData: widget.postData,
                userData: widget.userData,
              )
            ],
          ),
        ),
      ],
    );
  }
}
