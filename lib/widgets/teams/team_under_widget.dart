import 'package:basketball_app/utils/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../infrastructure/firebase/account_firebase.dart';
import '../../dialogs/dialogs.dart';
import '../../models/account/account.dart';
import '../../models/posts/team_model.dart';
import '../../state/providers/account/account_notifier.dart';
import '../../view_models/talk_room_view_model.dart';
import '../../bottom_navigation.dart';

/*
チーム目標
費用・会費
チーム詳細
投稿者
 */
class BuildUnder extends ConsumerStatefulWidget {
  final TeamPost postData;

  final Account userData; //投稿者の名前

  BuildUnder({
    required this.postData,
    required this.userData,
    super.key,
  });

  @override
  ConsumerState<BuildUnder> createState() => _BuildUnderState();
}

class _BuildUnderState extends ConsumerState<BuildUnder> {
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
    final myAccount = ref.read(accountNotifierProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "チーム目標",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.flag,
                    color: Colors.orange,
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              widget.postData.goal.toString() != ""
                  ? Text(
                      widget.postData.goal.toString(), // nullの場合のデフォルト値を指定
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
            height: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "費用・会費",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.currency_yen,
                    color: Colors.orange,
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              widget.postData.cost.toString() != ""
                  ? Text(
                      widget.postData.cost.toString(),
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.visible,
                      softWrap: true,
                      maxLines: 10, // テキストを自動的に折り返す
                    )
                  : Text(
                      "(未設定)",
                      style: TextStyle(fontSize: 15),
                    ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.black12, width: 1.0), // 下線
                  ),
                ),
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
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.black12, width: 1.0), // 下線
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0, left: 8.0),
                child: Text(
                  "投稿者",
                  style: TextStyle(
                      color: Colors.orange, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  widget.userData.imagePath != null &&
                          widget.userData.imagePath!.isNotEmpty
                      ? Container(
                          width: 60,
                          height: 60,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            radius: 50,
                            foregroundImage: NetworkImage(
                              widget.userData.imagePath!,
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
                    widget.userData.name,
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
                            //作成処理
                            await _createTalkRoom(myAccount.id);
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
          )
        ],
      ),
    );
  }

  Future<void> _createTalkRoom(String myUid) async {
    try {
      // 投稿者のpost_account_idからuserData(user情報)を取得
      final talkUserAccount = await AccountFirestore.fetchUserData(
        widget.postData.postAccountId,
      );

      // chatルーム作成する
      TalkRoomViewModel().initiateChatRoomCreation(
        talkUserAccount!,
        myUid,
        ref,
      );

      // トークページに遷移
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => BottomTabNavigator(
            initialIndex: 1,
            userId: myUid,
          ),
        ),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      handleError(e, context);
    }
  }
}
