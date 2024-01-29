import 'package:flutter/material.dart';
import '../../models/account/account.dart';
import '../../models/posts/game_model.dart';
import '../../views/games/details/game_post_detail.dart';
import '../custom_icon_text_widgets.dart';
import '../tag_container.dart';

class GameBody extends StatelessWidget {
  final GamePost postData;

  final bool isTimelinePage;
  final Account postAccountData;

  GameBody(
      {super.key,
      required this.isTimelinePage,
      required this.postAccountData,
      required this.postData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SizedBox(
          //   height: 10,
          // ),
          // Center(
          //   child: Container(
          //     child: Text(
          //       teamName,
          //       style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          //     ),
          //     decoration: BoxDecoration(
          //       border: Border(
          //         bottom: BorderSide(
          //           color: Colors.black, // 下線の色
          //           width: 0.8,
          //
          Center(
            child: Container(
              child: isTimelinePage
                  ? TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GamePostDetailPage(
                              postData: postData,
                              userData: postAccountData,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        postData.teamName,
                        style: TextStyle(
                            fontSize: postData.teamName.length >= 10 ? 26 : 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                    )
                  : Text(
                      postData.teamName,
                      style: TextStyle(
                          fontSize: postData.teamName.length >= 10 ? 26 : 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isTimelinePage ? Colors.blue : Colors.transparent,
                    width: 0.8,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Column(
            children: [
              // Text(
              //   appealText,
              //   styl
            ],
          ),
          SizedBox(
            height: 15,
          ),
          //新しく追加
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    ("活動場所"),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Icon(
                    Icons.location_on,
                    color: Colors.orange,
                    size: 24,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          buildTagContainers(
              postData.locationTagList, Colors.indigo[900] as Color),
          SizedBox(
            height: 10,
          ),
          //下線
          isTimelinePage
              ? SizedBox()
              : Text(
                  "基本情報: ",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
          SizedBox(
            height: 5,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    ("年齢層"),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Icon(
                    Icons.person_add_alt_1,
                    color: Colors.orange,
                    size: 24,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          buildTagContainers(postData.ageList, Colors.blueAccent),
          SizedBox(
            height: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    ("チームレベル"),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Icon(
                    Icons.groups,
                    color: Colors.orange,
                    size: 24,
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              LevelTextWidgets(level: postData.level),
            ],
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
