import 'package:basketball_app/models/model/team_post.dart';
import 'package:basketball_app/screen/post/game_post_page.dart';
import 'package:basketball_app/screen/post/team_posts.dart';
import 'package:basketball_app/screen/timeline/search_results_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/model/account.dart';
import '../../models/model/game_post.dart';
import '../../utils/posts.dart';
import '../../utils/users.dart';
import '../../widgets/bottom_navigation.dart';
import '../../widgets/dropdown_widget.dart';
import '../../widgets/post_item_widget.dart';

class TimelinePage extends StatefulWidget {
  TimelinePage({
    Key? key,
  }) : super(key: key);

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  String _selectedLocation = ""; // 選択した場所を保持する状態
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height / 2;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.indigo[900],
        appBar: AppBar(
          backgroundColor: Colors.indigo[900],
          actions: [
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context); // ダイアログを閉じる
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TeamPostPage()),
                              );
                            },
                            child: Text('チーム投稿'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo,
                              elevation: 0, // 影をなくす
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context); // ダイアログを閉じる
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => GamePostPage()),
                              );
                            },
                            child: Text(
                              '練習試合相手募集',
                              style: TextStyle(fontSize: 12),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo,
                              elevation: 0, // 影をなくす
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Icon(Icons.add),
              style: ElevatedButton.styleFrom(
                primary: Colors.transparent, // ボタン自体の背景色を透明に設定
                elevation: 0, // 影をなくす
              ),
            ),
          ],
          title: const Text(
            'TimeLine',
          ),
          bottom: const TabBar(
            tabs: [
              Tab(
                child: Text(
                  "バスケメンバー募集",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Tab(
                child: Text(
                  "練習試合募集",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            //練習募集
            Scaffold(
              backgroundColor: Colors.indigo[900],
              floatingActionButton: FloatingActionButton(
                //絞り込み検索
                onPressed: () {
                  _selectedLocation = "";
                  _textController.clear();
                  showModalBottomSheet<String>(
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(builder:
                          (BuildContext context, Function setSheetState) {
                        return Container(
                          margin: EdgeInsets.only(top: 50),
                          decoration: BoxDecoration(
                            //モーダル自体の色
                            color: Colors.white,
                            //角丸にする
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                  color: Colors.black38,
                                  width: 1,
                                ))),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          icon: Icon(Icons.clear)),
                                      Text(
                                        "フィルター",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          setState(() {});
                                          await Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MyStatefulWidget(
                                                initialIndex: 1,
                                                userId: '',
                                              ),
                                            ),
                                            (route) =>
                                                false, // すべてのページを破棄するため、falseを返す
                                          );
                                        },
                                        child: Text(
                                          "クリア",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            "エリア",
                                            style: TextStyle(
                                                color: Colors.orange,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        AreaDropdownMenuWidget(
                                          onItemSelected: (area) {
                                            setSheetState(() {
                                              _selectedLocation =
                                                  area ?? ""; // 選択されたエリアをセット
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                            color: Colors.black12, width: 1.0),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16.0, top: 10),
                                    child: Text(
                                      "場所を特定して投稿を探す",
                                      style: TextStyle(
                                          color: Colors.orange,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    width: 300,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextField(
                                        controller: _textController,
                                        decoration: InputDecoration(
                                          hintText: '札幌市など...',
                                          contentPadding: EdgeInsets.all(10),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                            color: Colors.black12, width: 1.0),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Center(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        await Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                SearchResultsPage(
                                              selectedLocation:
                                                  _selectedLocation,
                                              keywordLocation:
                                                  _textController.text,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text("検索する"),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      });
                    },
                  );
                },
                child: Icon(Icons.manage_search),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                        stream:
                            PostFirestore.teamPosts // 場所が選択されていない場合は全ての投稿を表示
                                .orderBy("created_time", descending: true)
                                .snapshots(),
                        builder: (context, postSnapshot) {
                          if (postSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            // データが読み込まれていない状態
                            return Center(
                              child: CircularProgressIndicator(), // ローディング中の表示
                            );
                          } else if (postSnapshot.hasError) {
                            print(postSnapshot.error);

                            // エラーが発生した場合
                            return Center(
                              child: Text(
                                "データの読み込み中にエラーが発生しました ${postSnapshot.error}",
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          } else if (!postSnapshot.hasData ||
                              postSnapshot.data!.docs.isEmpty) {
                            // データが存在しない場合
                            return Center(
                              child: Text(
                                "何も投稿がありません",
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          } else {
                            List<String> postAccountIds = [];
                            postSnapshot.data!.docs.forEach((doc) {
                              Map<String, dynamic> data =
                                  doc.data() as Map<String, dynamic>;
                              if (!postAccountIds
                                  .contains(data["post_account_id"])) {
                                postAccountIds.add(data["post_account_id"]);
                              }
                            });
                            return FutureBuilder<Map<String, Account>?>(
                                future: UserFirestore.getPostUserMap(
                                    postAccountIds),
                                builder: (context, userSnapshot) {
                                  if (userSnapshot.hasData &&
                                      userSnapshot.connectionState ==
                                          ConnectionState.done) {
                                    return ListView.builder(
                                      itemCount: postSnapshot.data!.docs.length,
                                      // データの長さを指定
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        Map<String, dynamic> data = postSnapshot
                                            .data!.docs[index]
                                            .data() as Map<String, dynamic>;
                                        List<String> targetList =
                                            List<String>.from(data["target"]);
                                        List<String> ageList =
                                            List<String>.from(data["age"]);
                                        List<String> concatenatedList =
                                            ageList + targetList;

                                        TeamPost post = TeamPost(
                                            id: postSnapshot
                                                .data!.docs[index].id,
                                            postAccountId:
                                                data["post_account_id"],
                                            location: data["location"],
                                            prefecture: data["prefecture"],
                                            goal: data["goal"],
                                            activityTime: data["activityTime"],
                                            memberCount: data["memberCount"],
                                            teamName: data["teamName"],
                                            targetList: targetList,
                                            note: data["note"],
                                            imageUrl: data["imageUrl"],
                                            createdTime: data["created_time"],
                                            searchCriteria:
                                                data["searchCriteria"],
                                            ageList: ageList,
                                            cost: data["cost"],
                                            headerUrl: data["headerUrl"],
                                            targetAndAgeList: concatenatedList);
                                        print(post);
                                        Account postAccount = userSnapshot
                                            .data![post.postAccountId]!;
                                        return TeamListItemWidget(
                                          postAccount: postAccount,
                                          recruitment: data,
                                        ); // listItemウィジェットを返す
                                      },
                                    );
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                });
                          }
                        }),
                  ),
                ],
              ),
            ),
            //チーム募集
            Scaffold(
              backgroundColor: Colors.indigo[900],
              floatingActionButton: FloatingActionButton(
                onPressed: () {},
                child: Icon(Icons.manage_search),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                        stream:
                            PostFirestore.gamePosts // 場所が選択されていない場合は全ての投稿を表示
                                .orderBy("created_time", descending: true)
                                .snapshots(),
                        builder: (context, postSnapshot) {
                          if (postSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            // データが読み込まれていない状態
                            return Center(
                              child: CircularProgressIndicator(), // ローディング中の表示
                            );
                          } else if (postSnapshot.hasError) {
                            print(postSnapshot.error);
                            // エラーが発生した場合
                            return Center(
                              child: Text(
                                "データの読み込み中にエラーが発生しました ${postSnapshot.error}",
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          } else if (!postSnapshot.hasData ||
                              postSnapshot.data!.docs.isEmpty) {
                            // データが存在しない場合
                            return Center(
                              child: Text(
                                "何も投稿がありません",
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          } else {
                            List<String> postAccountIds = [];
                            postSnapshot.data!.docs.forEach((doc) {
                              Map<String, dynamic> data =
                                  doc.data() as Map<String, dynamic>;
                              if (!postAccountIds
                                  .contains(data["post_account_id"])) {
                                postAccountIds.add(data["post_account_id"]);
                              }
                            });
                            return FutureBuilder<Map<String, Account>?>(
                                future: UserFirestore.getPostUserMap(
                                    postAccountIds),
                                builder: (context, userSnapshot) {
                                  if (userSnapshot.hasData &&
                                      userSnapshot.connectionState ==
                                          ConnectionState.done) {
                                    return ListView.builder(
                                      itemCount: postSnapshot.data!.docs.length,
                                      // データの長さを指定
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        Map<String, dynamic> data = postSnapshot
                                            .data!.docs[index]
                                            .data() as Map<String, dynamic>;
                                        List<String> ageList =
                                            List<String>.from(data["age"]);
                                        GamePost post = GamePost(
                                          id: postSnapshot.data!.docs[index].id,
                                          postAccountId:
                                              data["post_account_id"],
                                          location: data["location"],
                                          prefecture: data["prefecture"],
                                          teamName: data["teamName"],
                                          note: data["note"],
                                          imageUrl: data["imageUrl"],
                                          createdTime: data["created_time"],
                                          ageList: ageList,
                                          level: data["level"],
                                          member: data["member"],
                                        );
                                        print(post);
                                        Account postAccount = userSnapshot
                                            .data![post.postAccountId]!;
                                        return GameListItemWidget(
                                          postAccount: postAccount,
                                          recruitment: data,
                                        ); // listItemウィジェットを返す
                                      },
                                    );
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                });
                          }
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
