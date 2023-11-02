import 'package:basketball_app/screen/post/team_post_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/area_provider.dart';
import '../../providers/tag_provider.dart';
import '../../repository/posts_firebase.dart';
import '../../repository/users_firebase.dart';
import '../../screen/authentication/authentication_page.dart';
import '../../screen/post/game_post_page.dart';
import '../../utils/authentication.dart';
import '../common_widgets/snackbar_utils.dart';

class UserActionsMenu extends StatelessWidget {
  const UserActionsMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Choice>(
      color: Colors.white,
      icon: const Icon(
        Icons.more_horiz,
        size: 25,
      ),
      elevation: 50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      onSelected: (Choice choice) {
        if (choice.title == 'ログアウト') {
          showConfirmationDialog(context, 'ログアウト', '本当にログアウトしますか？', () async {
            await Authentication.signOut(context: context);
            showSnackBar(
                context: context,
                text: 'ログアウトしました',
                backgroundColor: Colors.white,
                textColor: Colors.black);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginAndSignupPage(),
              ),
            );
          });
        } else if (choice.title == 'アカウント削除') {
          showConfirmationDialog(
              context, 'アカウント削除', '本当にアカウントを削除しますか？\n投稿したデータもすべて削除されます',
              () async {
            await UserFirestore().deleteCurrentUser();
            showSnackBar(
                context: context,
                text: 'アカウントを削除しました',
                backgroundColor: Colors.white,
                textColor: Colors.black);

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginAndSignupPage(),
              ),
              (route) => false, // すべてのページを破棄するため、falseを返す
            );
          });
        }
      },
      itemBuilder: (BuildContext context) {
        return userChoices.map((Choice choice) {
          return PopupMenuItem<Choice>(
            value: choice,
            child: Row(
              children: [
                Icon(
                  choice.icon,
                  color: choice.title == 'ログアウト' ? Colors.black : Colors.red,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  choice.title,
                  style: TextStyle(
                    color: choice.title == 'ログアウト' ? Colors.black : Colors.red,
                  ),
                ),
              ],
            ),
          );
        }).toList();
      },
    );
  }

  void showConfirmationDialog(BuildContext context, String title,
      String message, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black87,
          title: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
          content: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              child: const Text('キャンセル'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('確認'),
              onPressed: () {
                onConfirm();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class Choice {
  const Choice({required this.title, required this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> userChoices = <Choice>[
  Choice(title: 'ログアウト', icon: Icons.logout),
  Choice(title: 'アカウント削除', icon: Icons.cancel),
];

const List<Choice> postsChoices = <Choice>[
  Choice(title: '編集する', icon: Icons.edit),
  Choice(title: '投稿削除', icon: Icons.delete),
];

class PostsActions extends StatefulWidget {
  final String postId;
  final String postType;
  final String _accountId;
  final String? imageUrl;
  final String? headerUrl;
  final String editingType;

  PostsActions(
      {super.key,
      required this.postId,
      required this.postType,
      required String accountId,
      this.imageUrl,
      this.headerUrl,
      required this.editingType})
      : _accountId = accountId;

  @override
  State<PostsActions> createState() => _PostsActionsState();
}

class _PostsActionsState extends State<PostsActions> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Choice>(
      elevation: 50,
      color: Colors.white,
      icon: const Icon(
        Icons.edit,
        size: 25,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      onSelected: (Choice choice) {
        if (choice.title == '投稿削除') {
          showConfirmationDialog(context, '投稿削除', '本当に投稿を削除しますか？', () async {
            //投稿がどの投稿かを選別する
            if (widget.postType == "team") {
              String imageUrl = widget.imageUrl ?? '';
              String headerUrl = widget.headerUrl ?? '';
              //投稿と画像を削除
              await PostFirestore().deleteTeamPostsByPostId(
                  widget.postId, widget._accountId, imageUrl, headerUrl);
              if (widget.editingType == "detailPage") {
                //detailPageから呼ばれた場合は画面更新と画面遷移が必要
                setState(() {});
                Navigator.of(context).pop();
              }
            } else {
              String gameUrl = widget.imageUrl ?? '';
              //投稿と画像を削除
              await PostFirestore().deleteGamePostsByPostId(
                  widget.postId, widget._accountId, gameUrl);
              if (widget.editingType == "detailPage") {
                //detailPageから呼ばれた場合は画面更新と画面遷移が必要
                setState(() {});
                Navigator.of(context).pop();
              }
            }
          });
        } else if (choice.title == "編集する") {
          _clearTags(); //既存のタグを削除する
          if (widget.postType == "team") {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return TeamPostPage(
                isEditing: true,
                postId: widget.postId,
              );
            }));
          } else {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return GamePostPage(
                isEditing: true,
                postId: widget.postId,
              );
            }));
          }
        }
      },
      itemBuilder: (BuildContext context) {
        return postsChoices.map((Choice choice) {
          return PopupMenuItem<Choice>(
            value: choice,
            child: Row(
              children: [
                Icon(
                  choice.icon,
                  color: choice.title == '編集する' ? Colors.black : Colors.red,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  choice.title,
                  style: TextStyle(
                    color: choice.title == '編集する' ? Colors.black : Colors.red,
                  ),
                ),
              ],
            ),
          );
        }).toList();
      },
    );
  }

  void _clearTags() {
    final tagModel = Provider.of<TagProvider>(context, listen: false);
    final areaModel = Provider.of<AreaProvider>(context, listen: false);
    areaModel.clearTags();
    tagModel.clearTags();
  }

  void showConfirmationDialog(BuildContext context, String title,
      String message, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            title,
            style: const TextStyle(color: Colors.black),
          ),
          content: Text(
            message,
            style: const TextStyle(color: Colors.black),
          ),
          actions: [
            TextButton(
              child: const Text(
                'キャンセル',
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                '確認',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                onConfirm();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
