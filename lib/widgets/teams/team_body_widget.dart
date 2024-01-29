import 'package:flutter/material.dart';

import '../../models/account/account.dart';
import '../../models/posts/team_model.dart';
import '../../views/teams/details/team_detail_page.dart';
import '../tag_container.dart';
import '../under_line.dart';

/*
チームname
場所の詳細情報
年齢層
ターゲット層
 */
class PostBody extends StatelessWidget {
  final bool isTimelinePage;

  final TeamPost postData;

  final Account userData; //投稿者の名前

  PostBody(
      {super.key,
      required this.isTimelinePage,
      required this.postData,
      required this.userData});

  @override
  Widget build(BuildContext context) {
    print("postBodyが呼ばれた");
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              child: isTimelinePage
                  ? TextButton(
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => TeamPostDetailPage(
                        //       postId: postId,
                        //       postAccountData: postAccountData,
                        //     ),
                        //   ),
                        // );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TeamPostDetailPage(
                              postId: postData.id,
                              userData: userData,
                              postData: postData,
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
              Text(
                postData.teamAppeal.toString(),
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              )
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
                    ("対象者"),
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
              buildTagContainers(postData.targetList, Colors.blueAccent),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          // isTimelinePage
          //     ? Center(
          //         child:
          //             ElevatedButton(onPressed: () {}, child: Text("チーム詳細を見る")))
          //     : SizedBox(),

          UnderLine(),
        ],
      ),
    );
  }
}
