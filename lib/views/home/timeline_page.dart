import 'package:flutter/material.dart';

import '../games/game_post_page.dart';
import '../games/game_recruitment_page.dart';
import '../teams/team_post_page.dart';
import '../teams/team_recruitment_page.dart';

class TimelinePage extends StatefulWidget {
  const TimelinePage({
    super.key,
  });

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TeamPostPage(
                                          isEditing: false,
                                        )),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo,
                              elevation: 0, // 影をなくす
                            ),
                            child: const Text(
                              'チーム投稿',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            onPressed: () {
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
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ],
          title: Text(
            'TimeLine',
            style: TextStyle(color: Colors.white),
          ),
          bottom: TabBar(
            labelColor: Colors.white,
            //選択されている時の色
            labelStyle:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            unselectedLabelColor: Colors.grey,
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
            TeamRecruitmentPage(),
            // TestRecruitmentPage(),
            //練習募集
            GameRecruitmentPage(),
          ],
        ),
      ),
    );
  }
}
