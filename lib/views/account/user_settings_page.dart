import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../infrastructure/firebase/storage_firebase.dart';
import '../../../infrastructure/image_processing/image_processing_utils.dart';
import '../../../models/app_colors.dart';
import '../../../utils/error_handler.dart';
import '../../../utils/image_utils.dart';
import '../../../utils/loading_manager.dart';
import '../../dialogs/snackbar_utils.dart';
import '../../models/account/account_state.dart';
import '../../state/providers/account/account_state_notifier.dart';
import '../../state/providers/global_loader.dart';
import '../../state/providers/providers.dart';
import '../../widgets/account/custom_text_fields.dart';
import '../../widgets/account/user_profile_circle.dart';
import '../../widgets/bottom_navigation.dart';
import '../../widgets/common_widgets/back_button_widget.dart';
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
  final loadingManager = LoadingManager(); //ローディング

  @override
  void initState() {
    _nameController = TextEditingController(
        text: ref.read(accountStateNotifierProvider).name); //初期値としてユーザー名を設定
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.read(accountStateNotifierProvider); // アカウントの状態を監視
    final loader = ref.watch(globalLoaderProvider); // ローディング状態を監視
    final bottomSpace = MediaQuery.of(context).viewInsets.bottom;
    final errorMessage = ref.watch(errorMessageProvider); //エラーを監視

    //エラーメッセージが更新された際にユーザーに通知
    if (errorMessage != null) {
      ErrorHandler.showAndResetError(errorMessage, context, ref);
    }

    // アカウント作成成功後の画面遷移
    ref.listen<AccountState>(accountStateNotifierProvider, (_, state) {
      _handleAccountCreation(state);
    });

    // ローディング中でない場合、UIを表示
    return loader == false
        ? Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: AppColors.baseColor,
            appBar: AppBar(
              leading: backButton(context),
              elevation: 0,
              backgroundColor: AppColors.baseColor,
              title: const Text(
                "アカウント編集",
                style: TextStyle(color: Colors.white),
              ),
            ),
            body: Stack(
              children: [
                // 背景コンテナ
                _buildBackgroundContainer(),
                SingleChildScrollView(
                  reverse: true,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: bottomSpace),
                    // 主要コンテンツ
                    child: _buildContent(),
                  ),
                ),
              ],
            ),
          )
        : ScaffoldShowProgressIndicator(
            textColor: AppColors.secondary,
            indicatorColor: AppColors.secondary,
          ); //ローディング中はインジケータを表示
  }

  // 背景コンテナ
  Widget _buildBackgroundContainer() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(60),
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
      networkImagePath: ref.read(accountStateNotifierProvider).imagePath,
      onTap: () => _showBottomSheetMenu(context),
    );
  }

  //ユーザー名
  Widget _buildNameTextField() {
    return SizedBox(
      width: 300,
      child: CustomTextFiled(
        controller: _nameController,
        func: (value) => ref
            .read(accountStateNotifierProvider.notifier)
            .onUserNameChange(value),
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
                      image, ref.read(accountStateNotifierProvider).imagePath)
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
                        await processImageAction(context, true);
                      }),
              ListTile(
                  title: const Text('画像を変更または追加'),
                  leading: const Icon(Icons.image),
                  onTap: () async {
                    Navigator.of(context).pop();
                    await processImageAction(context, false);
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
        .read(accountStateNotifierProvider.notifier)
        .onUserNameChange(_nameController.text);
    await ref
        .read(accountViewModelProvider.notifier)
        .updateUserAccount(isImageDeleted, ref);
  }

  //画面遷移
  void _handleAccountCreation(AccountState state) {
    if (state.isEditing) {
      print("画面遷移されない");
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
      ref.read(accountStateNotifierProvider.notifier).onUserIsEditing(false);
    }
    print("呼ばれた");
  }

  // 画像の削除または追加を行う処理
  Future<void> processImageAction(BuildContext context, bool isDeleting) async {
    try {
      loadingManager.startLoading(ref);
      if (isDeleting) {
        // 画像削除の処理
        if (ref.read(accountStateNotifierProvider).imagePath != null) {
          await ImageManager.deleteImage(
              ref.read(accountStateNotifierProvider).imagePath.toString());
        }
        image = null;
        // myAccount.imagePath = "";
        ref.read(accountStateNotifierProvider.notifier).onUserImageChange("");
        isImageDeleted = true;
      } else {
        // 画像追加の処理
        var result = await cropImage();
        if (result != null) {
          image = File(result.path);
          ref
              .read(accountStateNotifierProvider.notifier)
              .onUserImageChange(image!.path);
        }
      }
    } finally {
      loadingManager.stopLoading(ref);
    }
  }
}
