import 'package:basketball_app/views/account/user_settings_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/providers/account/account_notifier.dart';
import '../../state/providers/games/my_game_post_provider.dart';
import '../../state/providers/team/my_team_post_provider.dart';
import '../../widgets/account/user_actions_menu.dart';
import '../../widgets/account/user_profile_circle.dart';
import 'my_game_post.dart';
import 'my_team_post.dart';

//ユーザーのアカウントページ
class MyUserPage extends ConsumerStatefulWidget {
  const MyUserPage({super.key});

  @override
  ConsumerState<MyUserPage> createState() => _MyPageState();
}

class _MyPageState extends ConsumerState<MyUserPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  //プッシュ通知の設定
  void setupPushNotifications() async {
    final fcm = FirebaseMessaging.instance;

    //プッシュ通知の許可をリクエスト
    await fcm.requestPermission(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
    //フォアグラウンドでの通知の表示設定
    await fcm.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }

  @override
  void initState() {
    super.initState(); //プッシュ通知の設定
    setupPushNotifications();
    _tabController = TabController(
      length: 2, //タブの数
      vsync: this,
    );
  }

  // ユーザー設定ページへのナビゲーションを行う
  void navigateToUserSettingsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserSettingPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final myAccount = ref.read(accountNotifierProvider);
    double screenHeight = MediaQuery.of(context).size.height; // 画面の高さを取得

    // チーム投稿とゲーム投稿の状態を監視
    ref.watch(myTeamPostNotifierProvider(myAccount));
    ref.watch(myGamePostNotifierProvider(myAccount));

    return Scaffold(
      backgroundColor: Colors.indigo[900],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.indigo[900],
        actions: [
          UserActionsMenu(), //ログアウト、アカウント削除
        ],
      ),
      body: Column(
        children: [
          // プロフィール表示部分
          Container(
            width: double.infinity,
            height: screenHeight * 0.3,
            color: Colors.indigo[900],
            child: Column(
              children: [
                myAccount.imagePath != ""
                    //画像がある場合
                    ? AccountCircleWidget(
                        imagePath: myAccount.imagePath.toString(),
                        onEdit: () => navigateToUserSettingsPage(),
                      )
                    //画像がない場合
                    : NoImageAccountCircle(
                        onEdit: () => navigateToUserSettingsPage(),
                      ),
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
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                //チーム募集
                MyTeamPosts(),
                //練習試合募集
                MyGamePosts(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
