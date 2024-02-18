import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../infrastructure/firebase/account_firebase.dart';
import '../../../utils/error_handler.dart';
import '../../dialogs/dialogs.dart';
import '../../models/account/account.dart';
import '../../models/posts/game_model.dart';
import '../../state/providers/account/account_notifier.dart';
import '../../view_models/talk_room_view_model.dart';
import '../../bottom_navigation.dart';

/*
メンバー
note
アカウント情報
 */
class GameUnder extends ConsumerStatefulWidget {
  final GamePost postData;
  final Account postAccountData;

  const GameUnder(
      {required this.postAccountData, required this.postData, super.key});

  @override
  ConsumerState<GameUnder> createState() => _GameUnderState();
}

class _GameUnderState extends ConsumerState<GameUnder> {
  @override
  void initState() {
    super.initState();
    if (widget.postData.postAccountId == ref.read(accountNotifierProvider).id) {
      isEdited = true;
    }
    //postUserがブロックリストに入っているかチェック
    checkIfBlocked();
  }

  //ブロックチェック
  Future<void> checkIfBlocked() async {
    bool blocked = await AccountFirestore().isBlocked(
        ref.read(accountNotifierProvider).id, widget.postData.postAccountId);
    setState(() {
      isBlockUser = blocked;
      print(isBlockUser);
    });
  }

  bool isBlockUser = false;

  bool _expanded = false;

  bool isEdited = false; //編集モードだとtrue

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    ("メンバー構成"),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Icon(
                    Icons.account_circle,
                    color: Colors.orange,
                    size: 24,
                  ),
                ],
              ),
              widget.postData.member.toString() != ""
                  ? Text(
                      widget.postData.member.toString(), // nullの場合のデフォルト値を指定
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.visible,
                      softWrap: true,
                      maxLines: 10,
                    )
                  : Text(
                      "(未設定)",
                      style: TextStyle(fontSize: 15),
                    ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          ExpansionPanelList(
            elevation: 0,
            // animationDuration: Duration(milliseconds: 2000),
            children: [
              ExpansionPanel(
                backgroundColor: Colors.grey[100],
                headerBuilder: (context, isExpanded) {
                  return ListTile(
                    title: Text(
                      'チーム詳細',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                  );
                },
                body: widget.postData.note.toString() != ""
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                child: Text(
                                  widget.postData.note.toString(),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                  overflow: TextOverflow.visible,
                                  softWrap: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 30.0),
                        child: Text(
                          "(未設定)",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                isExpanded: _expanded,
                canTapOnHeader: true,
              ),
            ],
            // dividerColor: Colors.white,
            expansionCallback: (panelIndex, isExpanded) {
              _expanded = !_expanded;
              setState(() {});
            },
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0, left: 8.0),
            child: Row(
              children: [
                Text(
                  "投稿者",
                  style: TextStyle(
                      color: Colors.orange, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              widget.postAccountData.imagePath != null &&
                      widget.postAccountData.imagePath!.isNotEmpty
                  ? Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        foregroundImage: NetworkImage(
                          widget.postAccountData.imagePath!,
                        ),
                      ),
                    )
                  : Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: const CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage(
                          'assets/images/basketball_icon.png', // 代替画像のパス
                        ),
                      ),
                    ),
              SizedBox(
                width: 10,
              ),
              Text(
                widget.postAccountData.name,
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
              )
            ],
          ),
          // SizedBox(
          //   height: 20,
          // ),
          Center(
            child: TextButton(
              onPressed: () async {
                // ボタンが押されたときの処理

                // ダイアログを表示
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CustomAlertDialog(
                      title: "トークルームを作成",
                      message: "投稿ユーザーとのトークルームを作成してもよろしいですか？",
                      confirmButtonText: "はい",
                      onCancel: () {
                        Navigator.of(context).pop(); // ダイアログを閉じる
                      },
                      onConfirm: () async {
                        await _createTalkRoom();
                      },
                    );
                  },
                );
              },
              child: isEdited || isBlockUser
                  ? const SizedBox()
                  : const Text(
                      "メッセージを送ってみる",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
            ),
          ),
          isBlockUser
              ? Center(
                  child: const Text(
                    "このユーザーはブロックリストに入っています",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                )
              : const SizedBox(),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Future<void> _createTalkRoom() async {
    try {
      final talkUserAccount =
          await AccountFirestore.fetchUserData(widget.postData.postAccountId);
      final myUid = ref.read(accountNotifierProvider).id;

      // chatルーム作成する
      TalkRoomViewModel().initiateChatRoomCreation(
        talkUserAccount!,
        myUid,
        ref,
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) =>
              BottomTabNavigator(initialIndex: 1, userId: myUid),
        ),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      handleError(e, ref.context);
    }
  }
}
