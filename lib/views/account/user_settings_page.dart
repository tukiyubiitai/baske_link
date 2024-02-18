import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/image_utils.dart';
import '../../bottom_navigation.dart';
import '../../dialogs/snackbar.dart';
import '../../models/account/account.dart';
import '../../models/color/app_colors.dart';
import '../../state/providers/providers.dart';
import '../../widgets/account/user_profile_circle.dart';
import '../../widgets/progress_indicator.dart';

//ユーザー編集ページ
class UserSettingPage extends ConsumerStatefulWidget {
  const UserSettingPage({super.key});

  @override
  ConsumerState<UserSettingPage> createState() => _UserSettingPageState();
}

class _UserSettingPageState extends ConsumerState<UserSettingPage> {
  File? image; //ユーザーが選択したプロフィール画像
  late TextEditingController _nameController;
  bool isImageDeleted = false; //画像を削除したどうか

  @override
  void initState() {
    _nameController = TextEditingController(
        text: ref.read(accountManagerProvider).name); //初期値としてユーザー名を設定
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accountState = ref.watch(accountManagerProvider);
    final bottomSpace = MediaQuery.of(context).viewInsets.bottom;

    // アカウント更新成功後の画面遷移
    ref.listen<AccountState>(accountManagerProvider, (_, state) {
      // isAccountCreatedSuccessfullyがtrueに変わった場合にのみ実行
      if (state.updateIsEditing) {
        _handleAccountCreation(state);
      }
    });

    // ローディング中でない場合、UIを表示
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.baseColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.baseColor,
        title: const Text("アカウント編集", style: TextStyle(color: Colors.white)),
      ),
      body: accountState.isLoading
          ? ScaffoldShowProgressIndicator(
              textColor: AppColors.secondary,
              indicatorColor: AppColors.secondary,
            )
          : Stack(
              children: [
                _buildBackgroundContainer(),
                SingleChildScrollView(
                  reverse: true,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: bottomSpace),
                    child: _buildContent(),
                  ),
                ),
              ],
            ),
    );
  }

  // 背景コンテナ
  Widget _buildBackgroundContainer() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(60),
            topRight: Radius.circular(60),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 10,
              offset: const Offset(0, 1),
            ),
          ],
        ),
      ),
    );
  }

  // 主要コンテンツ
  Widget _buildContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          //プロフィール画像
          _buildProfileAvatar(),
          const SizedBox(height: 30),
          //ユーザー名
          _buildNameTextField(),
          //更新ボタン
          _buildUpdateButton(),
        ],
      ),
    );
  }

  //プロフィール画像
  Widget _buildProfileAvatar() {
    return ProfileAvatar(
      localImage: image,
      networkImagePath: ref.read(accountManagerProvider).imagePath,
      onTap: () => _showBottomSheetMenu(context),
    );
  }

  //ユーザー名
  Widget _buildNameTextField() {
    return SizedBox(
      width: 300,
      child: TextField(
        controller: _nameController,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        maxLength: 10,
        decoration: InputDecoration(
          hintText: "ユーザー名 (必須)",
          hintStyle: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.normal),
        ),
      ),
    );
  }

  //更新ボタン
  Widget _buildUpdateButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () => _updateUserAccount(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.indigo[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          "更新する",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // 画像の追加・削除のためのボトムシートメニューを表示
  void _showBottomSheetMenu(BuildContext context) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        builder: (builder) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ImageUtils.shouldShowDefaultImage(
                      image, ref.read(accountManagerProvider).imagePath)
                  ? const SizedBox()
                  : ListTile(
                      title: const Text(
                        '画像を削除',
                        style: TextStyle(color: Colors.red),
                      ),
                      leading: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onTap: () async {
                        Navigator.of(context).pop();
                        await ref
                            .read(accountManagerProvider.notifier)
                            .processImageAction(true);
                      }),
              ListTile(
                  title: const Text('画像を変更または追加'),
                  leading: const Icon(Icons.image),
                  onTap: () async {
                    Navigator.of(context).pop();
                    File? selectedImage = await ref
                        .read(accountManagerProvider.notifier)
                        .processImageAction(false);
                    if (selectedImage != null) {
                      setState(() {
                        image = selectedImage;
                      });
                    }
                  }),
              const SizedBox(
                height: 30,
              ),
            ],
          );
        });
  }

  //ユーザー更新処理
  Future<void> _updateUserAccount() async {
    ref
        .read(accountManagerProvider.notifier)
        .onUserNameChange(_nameController.text);
    await ref
        .read(accountManagerProvider.notifier)
        .updateUserAccount(isImageDeleted, ref);
  }

  //画面遷移
  void _handleAccountCreation(AccountState state) {
    if (state.updateIsEditing) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => BottomTabNavigator(initialIndex: 3),
        ),
        (route) => false,
      );
      showSnackBar(
        context: ref.context,
        text: "ユーザーが作成されました！",
        backgroundColor: Colors.white,
        textColor: Colors.black,
      );
    } else {
      return;
    }
  }
}
