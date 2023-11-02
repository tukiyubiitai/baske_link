import 'package:basketball_app/models/model/game_model.dart';
import 'package:basketball_app/screen/post/post_detail_page.dart';
import 'package:basketball_app/utils/posts_firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/model/account.dart';
import '../../models/model/team_model.dart';
import '../../utils/authentication.dart';
import '../../utils/users_firebase.dart';
import '../../widgets/account_circle.dart';
import '../../widgets/popup_menu.dart';
import 'account_settings_page.dart';

// 登録されたユーザの情報を表示する画面

class UserAccountPage extends StatefulWidget {
  @override
  State<UserAccountPage> createState() => _UserAccountPageState();
}

class _UserAccountPageState extends State<UserAccountPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Account myAccount;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myAccount = Authentication.myAccount!;
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height; // 画面の高さを取得
    myAccount = Authentication.myAccount!;
    return Scaffold(
      backgroundColor: Colors.indigo[900],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.indigo[900],
        actions: [
          PopupMenu(),
        ],
      ),
      body: Column(
        children: [
          // 画面の10分の3の高さを持つContainer
          Container(
            width: double.infinity, // Containerを横幅いっぱいに表示
            height: screenHeight * 0.3, // Containerの高さを指定してます
            color: Colors.indigo[900],
            child: Column(
              children: [
                myAccount.imagePath != ""
                    ? AccountCircle(
                        imagePath: myAccount.imagePath!,
                        onEdit: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AccountSettingsPage(),
                            ),
                          );
                        })
                    : noImageAccountCircle(onEdit: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AccountSettingsPage(),
                          ),
                        );
                      }),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Text(
                    myAccount.name,
                    style: TextStyle(
                        fontSize: 22.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w900),
                  ),
                ),
              ],
            ),
          ),
          // タブ
          TabBar(
            labelColor: Colors.white,
            //選択されている時の色
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            unselectedLabelColor: Colors.grey,
            //選択されていない時の色
            controller: _tabController,
            tabs: [
              Tab(
                text: 'メンバー募集投稿',
              ),
              Tab(text: '練習試合募集'),
            ],
          ),
          // タブの内容
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Container(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: UserFirestore.users
                          .doc(myAccount.id)
                          .collection("my_posts")
                          .orderBy("created_time", descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<String> myPostIds = List.generate(
                              snapshot.data!.docs.length, (index) {
                            return snapshot.data!.docs[index].id;
                          });
                          return FutureBuilder<List<TeamPost>?>(
                              future:
                                  PostFirestore.getMyTeamPostFromIds(myPostIds),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  // データが読み込まれるまでローディング表示
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (snapshot.hasError) {
                                  // エラーが発生した場合
                                  return Center(
                                    child: Text("Error: ${snapshot.error}"),
                                  );
                                } else if (snapshot.hasData &&
                                    snapshot.data!.isNotEmpty) {
                                  // データが正常に取得された場合
                                  return ListView.builder(
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, index) {
                                      TeamPost post = snapshot.data![index];
                                      DateTime createAtDateTime =
                                          post.createdTime.toDate();
                                      String formattedCreatedAt =
                                          DateFormat('yyyy/MM/dd')
                                              .format(createAtDateTime);

                                      Widget listItem = ListTile(
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 32.0,
                                          vertical: 8.0,
                                        ),
                                        trailing: Text(
                                          formattedCreatedAt,
                                          style: TextStyle(
                                            color: Colors.white38,
                                            fontSize: 13,
                                          ),
                                        ),
                                        leading: CircleAvatar(
                                          backgroundColor: Colors.grey,
                                          backgroundImage: post.imageUrl != ""
                                              ? NetworkImage(
                                                  post.imageUrl as String)
                                              : null,
                                          radius: 30,
                                          child: post.imageUrl == ""
                                              ? Icon(
                                                  Icons.person,
                                                  size: 40,
                                                  color: Colors.white,
                                                )
                                              : null,
                                        ),
                                        title: Text(
                                          post.teamName,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                        subtitle: Text(
                                          post.prefecture,
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  TeamPostDetailPage(
                                                postId: post.id,
                                              ),
                                            ),
                                          );
                                        },
                                      );

                                      // 上部にボーダーを追加
                                      if (index != 0) {
                                        listItem = Column(
                                          children: [
                                            Divider(
                                              color: Colors.grey,
                                              height: 1.0,
                                              thickness: 1.0,
                                            ),
                                            listItem,
                                          ],
                                        );
                                      }

                                      // 最後のアイテムで下部のボーダーも追加
                                      if (index == snapshot.data!.length - 1) {
                                        listItem = Column(
                                          children: [
                                            listItem,
                                            Divider(
                                              color: Colors.grey,
                                              height: 1.0,
                                              thickness: 1.0,
                                            ),
                                          ],
                                        );
                                      }

                                      return listItem;
                                    },
                                  );
                                } else {
                                  // データが空の場合
                                  return Center(
                                    child: Text("投稿がありません"),
                                  );
                                }
                              });
                        } else {
                          // ストリームがデータをまだ受信していない場合の表示
                          return Center(
                            child:
                                CircularProgressIndicator(), // データが読み込まれるまでローディング表示
                          );
                        }
                      }),
                ),
                Container(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: UserFirestore.users
                          .doc(myAccount.id)
                          .collection("my_game_posts")
                          .orderBy("created_time", descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<String> myPostIds = List.generate(
                              snapshot.data!.docs.length, (index) {
                            return snapshot.data!.docs[index].id;
                          });
                          return FutureBuilder<List<GamePost>?>(
                              future:
                                  PostFirestore.getMyGamePostFromIds(myPostIds),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  // データが読み込まれるまでローディング表示
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (snapshot.hasError) {
                                  // エラーが発生した場合
                                  return Center(
                                    child: Text("Error: ${snapshot.error}"),
                                  );
                                } else if (snapshot.hasData &&
                                    snapshot.data!.isNotEmpty) {
                                  // データが正常に取得された場合
                                  return ListView.builder(
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, index) {
                                      GamePost gamePost = snapshot.data![index];
                                      DateTime createAtDateTime =
                                          gamePost.createdTime.toDate();
                                      String formattedCreatedAt =
                                          DateFormat('yyyy/MM/dd')
                                              .format(createAtDateTime);

                                      Widget listItem = ListTile(
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 32.0,
                                          vertical: 8.0,
                                        ),
                                        trailing: Text(
                                          formattedCreatedAt,
                                          style: TextStyle(
                                            color: Colors.white38,
                                            fontSize: 13,
                                          ),
                                        ),
                                        leading: CircleAvatar(
                                          backgroundColor: Colors.grey,
                                          backgroundImage: gamePost.imageUrl !=
                                                  ""
                                              ? NetworkImage(
                                                  gamePost.imageUrl as String)
                                              : null,
                                          radius: 30,
                                          child: gamePost.imageUrl == ""
                                              ? Icon(
                                                  Icons.person,
                                                  size: 40,
                                                  color: Colors.white,
                                                )
                                              : null,
                                        ),
                                        title: Text(
                                          gamePost.teamName,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                        subtitle: Text(
                                          gamePost.prefecture,
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  GamePostDetailPage(
                                                postId: gamePost.id,
                                              ),
                                            ),
                                          );
                                        },
                                      );

                                      // 上部にボーダーを追加
                                      if (index != 0) {
                                        listItem = Column(
                                          children: [
                                            Divider(
                                              color: Colors.grey,
                                              height: 1.0,
                                              thickness: 1.0,
                                            ),
                                            listItem,
                                          ],
                                        );
                                      }

                                      // 最後のアイテムで下部のボーダーも追加
                                      if (index == snapshot.data!.length - 1) {
                                        listItem = Column(
                                          children: [
                                            listItem,
                                            Divider(
                                              color: Colors.grey,
                                              height: 1.0,
                                              thickness: 1.0,
                                            ),
                                          ],
                                        );
                                      }

                                      return listItem;
                                    },
                                  );
                                } else {
                                  // データが空の場合
                                  return Center(
                                    child: Text("投稿がありません"),
                                  );
                                }
                              });
                        } else {
                          // ストリームがデータをまだ受信していない場合の表示
                          return Center(
                            child:
                                CircularProgressIndicator(), // データが読み込まれるまでローディング表示
                          );
                        }
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
