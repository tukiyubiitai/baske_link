import 'package:flutter/material.dart';

import '../../../models/account/account.dart';
import '../../../models/posts/game_model.dart';
import '../../../widgets/games/game_body.dart';
import '../../../widgets/games/game_header.dart';
import '../../../widgets/games/game_under.dart';

class GamePostDetailItems extends StatelessWidget {
  final GamePost posts; //投稿情報

  final Account postAccountData; //投稿者の名前

  final String postId;

  const GamePostDetailItems(
      {super.key,
      required this.posts,
      required this.postAccountData,
      required this.postId});

  // @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[900],
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Stack(
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
                        GameHeader(
                          isTimelinePage: false,
                          postData: posts,
                        ),
                        GameBody(
                          isTimelinePage: false,
                          postAccountData: postAccountData,
                          postData: posts,
                        ),
                        GameUnder(
                          postAccountData: postAccountData,
                          postData: posts,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
