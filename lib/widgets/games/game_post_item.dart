import 'package:flutter/material.dart';

import '../../models/account/account.dart';
import '../../models/posts/game_model.dart';
import 'game_body.dart';
import 'game_header.dart';

class GamePostItem extends StatelessWidget {
  final GamePost postData;

  final String postId;
  final Account userData;

  const GamePostItem(
      {super.key,
      required this.postData,
      required this.postId,
      required this.userData});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.all(20),
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
              GameHeader(
                isTimelinePage: true,
                postData: postData,
              ),
              GameBody(
                isTimelinePage: true,
                postData: postData, postAccountData: userData,
                // widget.postAccountData,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
