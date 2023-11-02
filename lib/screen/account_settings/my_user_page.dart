import 'package:basketball_app/models/game_model.dart';
import 'package:basketball_app/screen/post/post_detail_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/account.dart';
import '../../models/team_model.dart';
import '../../repository/posts_firebase.dart';
import '../../repository/users_firebase.dart';
import '../../utils/authentication.dart';
import '../../widgets/common_widgets/progress_dialog.dart';
import '../../widgets/user_widgets/account_circle.dart';
import '../../widgets/user_widgets/popup_menu.dart';
import 'user_settings_page.dart';

// 登録されたユーザの情報を表示する画面

class UserAccountPage extends StatefulWidget {
  const UserAccountPage({super.key});

  @override
  State<UserAccountPage> createState() => _UserAccountPageState();
}

class _UserAccountPageState extends State<UserAccountPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Account myAccount = Authentication.myAccount!;

  void setupPushNotifications() async {
    final fcm = FirebaseMessaging.instance;

    await fcm.requestPermission(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
    await fcm.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setupPushNotifications();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height; // 画面の高さを取得
    return Scaffold(
      backgroundColor: Colors.indigo[900],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.indigo[900],
        actions: [
          UserActionsMenu(),
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
                myAccount.imagePath != null && myAccount.imagePath != ""
                    ? AccountCircleWidget(
                        imagePath: myAccount.imagePath!,
                        onEdit: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AccountSettingsPage(),
                            ),
                          );
                        })
                    : NoImageAccountCircle(onEdit: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AccountSettingsPage(),
                          ),
                        );
                      }),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Text(
                    myAccount.name,
                    style: const TextStyle(
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
            labelStyle:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            unselectedLabelColor: Colors.grey,
            //選択されていない時の色
            controller: _tabController,
            tabs: const [
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
                StreamBuilder<QuerySnapshot>(
                    stream: UserFirestore.users
                        .doc(myAccount.id)
                        .collection("my_posts")
                        .orderBy("created_time", descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<String> myPostIds =
                            List.generate(snapshot.data!.docs.length, (index) {
                          return snapshot.data!.docs[index].id;
                        });
                        return FutureBuilder<List<TeamPost>?>(
                            future:
                                PostFirestore.getMyTeamPostFromIds(myPostIds),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                // データが読み込まれるまでローディング表示
                                return ShowProgressIndicator();
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
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 32.0,
                                        vertical: 8.0,
                                      ),
                                      trailing: PostsActions(
                                        postId: post.id,
                                        postType: 'team',
                                        accountId: post.postAccountId,
                                        imageUrl: post.imageUrl != null
                                            ? post.imageUrl
                                            : null,
                                        headerUrl: post.headerUrl != null
                                            ? post.headerUrl
                                            : null,
                                        editingType: "myAccount",
                                      ),
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.grey,
                                        backgroundImage: post.imageUrl !=
                                                    null &&
                                                post.imageUrl != ""
                                            ? NetworkImage(
                                                post.imageUrl as String)
                                            : const AssetImage(
                                                    'assets/images/headerImage.jpg')
                                                as ImageProvider,
                                        radius: 30,
                                      ),
                                      title: Text(
                                        post.teamName,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      subtitle: Text(
                                        formattedCreatedAt,
                                        style: const TextStyle(
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
                                              postAccountData: myAccount,
                                            ),
                                          ),
                                        );
                                      },
                                    );

                                    // 上部にボーダーを追加
                                    if (index != 0) {
                                      listItem = Column(
                                        children: [
                                          const Divider(
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
                                          const Divider(
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
                                return const Center(
                                  child: Text(
                                    "投稿がありません",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                );
                              }
                            });
                      } else {
                        // ストリームがデータをまだ受信していない場合の表示
                        return ShowProgressIndicator();
                      }
                    }),
                StreamBuilder<QuerySnapshot>(
                    stream: UserFirestore.users
                        .doc(myAccount.id)
                        .collection("my_game_posts")
                        .orderBy("created_time", descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<String> myPostIds =
                            List.generate(snapshot.data!.docs.length, (index) {
                          return snapshot.data!.docs[index].id;
                        });
                        return FutureBuilder<List<GamePost>?>(
                            future:
                                PostFirestore.getMyGamePostFromIds(myPostIds),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                // データが読み込まれるまでローディング表示
                                return ShowProgressIndicator();
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
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 32.0,
                                        vertical: 8.0,
                                      ),
                                      trailing: PostsActions(
                                        postId: gamePost.id,
                                        postType: 'game',
                                        accountId: gamePost.postAccountId,
                                        imageUrl: gamePost.imageUrl != null
                                            ? gamePost.imageUrl
                                            : null,
                                        editingType: "myAccount",
                                      ),
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.grey,
                                        backgroundImage: gamePost.imageUrl !=
                                                    null &&
                                                gamePost.imageUrl != ""
                                            ? NetworkImage(
                                                gamePost.imageUrl as String)
                                            : const AssetImage(
                                                    'assets/images/headerImage.jpg')
                                                as ImageProvider,
                                        radius: 30,
                                      ),
                                      title: Text(
                                        gamePost.teamName,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      subtitle: Text(
                                        formattedCreatedAt,
                                        style: const TextStyle(
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
                                              postAccountData: myAccount,
                                            ),
                                          ),
                                        );
                                      },
                                    );

                                    // 上部にボーダーを追加
                                    if (index != 0) {
                                      listItem = Column(
                                        children: [
                                          const Divider(
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
                                          const Divider(
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
                                return const Center(
                                  child: Text(
                                    "投稿がありません",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                );
                              }
                            });
                      } else {
                        // ストリームがデータをまだ受信していない場合の表示
                        return ShowProgressIndicator();
                      }
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
