import 'package:flutter/material.dart';

import '../../../models/account/account.dart';
import '../../../models/posts/team_model.dart';
import '../../../widgets/teams/team_body_widget.dart';
import '../../../widgets/teams/team_header_widget.dart';
import '../../../widgets/teams/team_under_widget.dart';

class TeamPostDetailItem extends StatelessWidget {
  final TeamPost postData; //投稿情報

  final Account userData; //投稿者の名前

  final String postId;

  const TeamPostDetailItem(
      {super.key,
      required this.postData,
      required this.userData,
      required this.postId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[900],
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                // margin: const EdgeInsets.all(20),
                // height: MediaQuery.of(context).size.height * 0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
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
                      isTimelinePage: false,
                      postData: postData,
                    ),
                    PostBody(
                      isTimelinePage: false,
                      postData: postData,
                      userData: userData,
                    ),
                    BuildUnder(
                      postData: postData,
                      userData: userData,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
