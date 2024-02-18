//投稿の編集と削除
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../dialogs/custom_dialogs.dart';
import '../dialogs/snackbar.dart';
import '../models/posts/game_model.dart';
import '../models/posts/team_model.dart';
import '../models/user_choice.dart';
import '../state/providers/account/account_notifier.dart';
import '../state/providers/games/game_post_provider.dart';
import '../state/providers/games/my_game_post_provider.dart';
import '../state/providers/team/my_team_post_provider.dart';
import '../state/providers/team/team_post_provider.dart';
import '../view_models/game_view_model.dart';
import '../view_models/post_view_model.dart';
import '../view_models/team_view_model.dart';
import '../views/games/game_post_page.dart';
import '../views/teams/team_post_page.dart';

class PostAction extends ConsumerStatefulWidget {
  final TeamPost? teamPostData;
  final GamePost? gamePostData;

  final bool isFromDetailPage; // このフラグを追加

  PostAction({
    Key? key,
    this.teamPostData,
    this.gamePostData,
    this.isFromDetailPage = false,
  }) : super(key: key);

  @override
  ConsumerState<PostAction> createState() => _TestActionState();
}

class _TestActionState extends ConsumerState<PostAction> {
  final postViewModel = PostViewModel();

  @override
  Widget build(BuildContext context) {
    final myAccount = ref.read(accountNotifierProvider);

    ref.watch(myTeamPostNotifierProvider(myAccount));
    ref.watch(teamPostNotifierProvider);

    ref.watch(myGamePostNotifierProvider(myAccount));

    ref.watch(gamePostNotifierProvider);

    return PopupMenuButton<Choice>(
      elevation: 50,
      color: Colors.white,
      icon: const Icon(
        Icons.edit,
        size: 25,
        color: Colors.white,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      onSelected: (Choice choice) {
        if (choice.title == '投稿削除') {
          _showDeleteConfirmationDialog();
        } else if (choice.title == "編集する") {
          if (widget.teamPostData != null) {
            // TeamPostの編集画面へ遷移
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return TeamPostPage(
                isEditing: true,
                postId: widget.teamPostData!.id,
              );
            }));
          } else if (widget.gamePostData != null) {
            // GamePostの編集画面へ遷移
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return GamePostPage(
                isEditing: true,
                postId: widget.gamePostData!.id, // GamePostのID
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

  //ダイアログ
  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
            title: "投稿削除",
            message: "本当に削除しますか？",
            confirmButtonText: "削除",
            onCancel: () => Navigator.of(context).pop(),
            // ダイアログを閉じる
            onConfirm: () async {
              try {
                //削除処理
                await _handlePostDeletion();
                Navigator.of(context).pop();
              } catch (e) {
                showSnackBar(
                  context: context,
                  text: "エラーが発生しました",
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                );
              }
            });
      },
    );
  }

  //削除処理
  Future<void> _handlePostDeletion() async {
    late bool result;
    try {
      if (widget.teamPostData != null) {
        //TeamPostの削除処理
        result =
            await TeamPostViewModel().deleteTeamPost(widget.teamPostData!, ref);
      } else if (widget.gamePostData != null) {
        // GamePostの削除処理
        result =
            await GamePostViewModel().deleteGamePost(widget.gamePostData!, ref);
      }
      if (result) {
        //画面遷移
        if (widget.isFromDetailPage) {
          // 詳細ページから来た場合は2回戻る
          Navigator.of(context).pop();
        }
        showSnackBar(
            context: context,
            text: "削除が完了しました",
            backgroundColor: Colors.white,
            textColor: Colors.black);
      }
    } catch (e) {
      print("投稿削除エラー　$e");
      showErrorSnackBar(context: ref.context, text: "削除に失敗しました ");
    }
  }
}
