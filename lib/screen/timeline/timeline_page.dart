import 'package:basketball_app/screen/post/game_post_page.dart';
import 'package:basketball_app/screen/post/team_post_page.dart';
import 'package:basketball_app/widgets/post_widgets/post_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/account.dart';
import '../../providers/area_provider.dart';
import '../../providers/tag_provider.dart';
import '../../repository/posts_firebase.dart';
import '../../repository/users_firebase.dart';
import '../../widgets/common_widgets/progress_dialog.dart';
import '../../widgets/common_widgets/snackbar_utils.dart';
import '../../widgets/search_widgets/modal_sheet.dart';

class TimelinePage extends StatefulWidget {
  const TimelinePage({
    super.key,
  });

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  void _clearTags() {
    final tagModel = Provider.of<TagProvider>(context, listen: false);
    final areaModel = Provider.of<AreaProvider>(context, listen: false);
    areaModel.clearTags();
    tagModel.clearTags();
  }

  @override
  Widget build(BuildContext context) {
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
                              _clearTags();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const TeamPostPage(
                                          isEditing: false,
                                        )),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo,
                              elevation: 0, // 影をなくす
                            ),
                            child: const Text('チーム投稿'),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _clearTags();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const GamePostPage(
                                          isEditing: false,
                                        )),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              elevation: 0, // 影をなくす
                            ),
                            child: const Text(
                              '練習試合相手募集',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent, // ボタン自体の背景色を透明に設定
                elevation: 0, // 影をなくす
              ),
              child: const Icon(Icons.add),
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
            //チームメイト募集
            Scaffold(
              backgroundColor: Colors.indigo[900],
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.indigoAccent,
                //絞り込み検索
                onPressed: () {
                  _clearTags();
                  showModalBottomSheet<String>(
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(builder:
                          (BuildContext context, Function setSheetState) {
                        return ModalBottomSheetContent(
                          isEditing: false,
                        );
                      });
                    },
                  );
                },
                child: const Icon(Icons.manage_search),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                        stream: PostFirestore.teamPosts
                            .orderBy("created_time", descending: true)
                            .snapshots(),
                        builder: (context, postSnapshot) {
                          if (postSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            // データが読み込まれていない状態
                            return ShowProgressIndicator();
                          } else if (postSnapshot.hasError) {
                            showErrorSnackBar(
                                context: context, text: 'エラーが発生しました');

                            // エラーが発生した場合
                            return Center(
                              child: Text(
                                "データの読み込み中にエラーが発生しました ${postSnapshot.error}",
                                style: const TextStyle(color: Colors.white),
                              ),
                            );
                          } else if (!postSnapshot.hasData ||
                              postSnapshot.data!.docs.isEmpty) {
                            // データが存在しない場合
                            return const Center(
                              child: Text(
                                "何も投稿がありません",
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          } else {
                            //投稿を繰り返し取得しpost_account_idを取得する
                            List<String> postAccountIds = [];
                            for (var doc in postSnapshot.data!.docs) {
                              Map<String, dynamic> data =
                                  doc.data() as Map<String, dynamic>;
                              if (!postAccountIds
                                  .contains(data["post_account_id"])) {
                                postAccountIds.add(data["post_account_id"]);
                              }
                            }
                            return FutureBuilder<Map<String, Account>?>(
                                future: UserFirestore.getPostUserMap(
                                    postAccountIds),
                                builder: (context, userSnapshot) {
                                  //ユーザー情報の取得が完了しているかどうかをチェック
                                  if (userSnapshot.hasData &&
                                      userSnapshot.connectionState ==
                                          ConnectionState.done) {
                                    Map<String, Account>? userData =
                                        userSnapshot.data;
                                    return ListView.builder(
                                      itemCount: postSnapshot.data!.docs.length,
                                      // データの長さを指定
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        Map<String, dynamic> data = postSnapshot
                                            .data!.docs[index]
                                            .data() as Map<String, dynamic>;
                                        return TeamPostWidget(
                                          data: data,
                                          id: postSnapshot.data!.docs[index].id,
                                          userData:
                                              userData as Map<String, Account>,
                                        );
                                      },
                                    );
                                  } else {
                                    return ShowProgressIndicator();
                                  }
                                });
                          }
                        }),
                  ),
                ],
              ),
            ),
            //練習募集
            Scaffold(
              backgroundColor: Colors.indigo[900],
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.orange,
                onPressed: () {
                  _clearTags();
                  showModalBottomSheet<String>(
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(builder:
                          (BuildContext context, Function setSheetState) {
                        return ModalBottomSheetContent(
                          isEditing: true,
                        );
                      });
                    },
                  );
                },
                child: const Icon(Icons.manage_search),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                        stream: PostFirestore.gamePosts
                            .orderBy("created_time", descending: true)
                            .snapshots(),
                        builder: (context, postSnapshot) {
                          if (postSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            // データが読み込まれていない状態
                            return ShowProgressIndicator();
                          } else if (postSnapshot.hasError) {
                            // エラーが発生した場合
                            return Center(
                              child: Text(
                                "データの読み込み中にエラーが発生しました ${postSnapshot.error}",
                                style: const TextStyle(color: Colors.white),
                              ),
                            );
                          } else if (!postSnapshot.hasData ||
                              postSnapshot.data!.docs.isEmpty) {
                            // データが存在しない場合
                            return const Center(
                              child: Text(
                                "何も投稿がありません",
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          } else {
                            List<String> postAccountIds = [];
                            for (var doc in postSnapshot.data!.docs) {
                              Map<String, dynamic> data =
                                  doc.data() as Map<String, dynamic>;
                              if (!postAccountIds
                                  .contains(data["post_account_id"])) {
                                postAccountIds.add(data["post_account_id"]);
                              }
                            }
                            return FutureBuilder<Map<String, Account>?>(
                                future: UserFirestore.getPostUserMap(
                                    postAccountIds),
                                builder: (context, userSnapshot) {
                                  if (userSnapshot.hasData &&
                                      userSnapshot.connectionState ==
                                          ConnectionState.done) {
                                    Map<String, Account>? userData =
                                        userSnapshot.data;
                                    return ListView.builder(
                                      itemCount: postSnapshot.data!.docs.length,
                                      // データの長さを指定
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        Map<String, dynamic> data = postSnapshot
                                            .data!.docs[index]
                                            .data() as Map<String, dynamic>;
                                        return GamePostWidget(
                                          data: data,
                                          id: postSnapshot.data!.docs[index].id,
                                          userData:
                                              userData as Map<String, Account>,
                                        );
                                      },
                                    );
                                  } else {
                                    return ShowProgressIndicator();
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
