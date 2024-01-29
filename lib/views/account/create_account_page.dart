import 'dart:io';

import 'package:basketball_app/models/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../infrastructure/image_processing/image_processing_utils.dart';
import '../../../models/account/account_state.dart';
import '../../../utils/error_handler.dart';
import '../../../utils/loading_manager.dart';
import '../../dialogs/snackbar_utils.dart';
import '../../state/providers/account/account_state_notifier.dart';
import '../../state/providers/global_loader.dart';
import '../../state/providers/providers.dart';
import '../../widgets/account/custom_text_fields.dart';
import '../../widgets/account/user_profile_circle.dart';
import '../../widgets/bottom_navigation.dart';
import '../../widgets/progress_indicator.dart';

///新規アカウント作成ページUI
class CreateAccount extends ConsumerStatefulWidget {
  const CreateAccount({super.key});

  @override
  ConsumerState<CreateAccount> createState() => _TestCreateAccountState();
}

class _TestCreateAccountState extends ConsumerState<CreateAccount> {
  TextEditingController _nameController = TextEditingController();
  File? image; //ユーザーが選択したプロフィール画像

  final loadingManager = LoadingManager(); //ローディング

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomSpace = MediaQuery.of(context).viewInsets.bottom;
    ref.watch(accountStateNotifierProvider); // アカウントの状態を監視
    final loader = ref.watch(globalLoaderProvider); // ローディング状態を監視
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
              elevation: 0,
              backgroundColor: AppColors.baseColor,
              title: const Text(
                "新規アカウント作成",
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
                    child: _buildContent(context),
                  ),
                ),
              ],
            ),
          )
        : ScaffoldShowProgressIndicator(
            textColor: AppColors.secondary,
            indicatorColor: AppColors.secondary,
          );
    // ローディング中はインジケータを表示
  }

  // 背景コンテナ
  Widget _buildBackgroundContainer() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(60),
            topLeft: Radius.circular(60),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 10, offset: const Offset(0, 1), // 影の位置調整
            ),
          ],
        ),
      ),
    );
  }

  // 主要コンテンツ
  Widget _buildContent(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          //プロフィール画像
          _buildProfileAvatar(context),
          const SizedBox(height: 30),
          //ユーザー名入力
          _buildNameTextField(),
          //保存ボタン
          _buildSaveButton(context),
        ],
      ),
    );
  }

  Widget _buildProfileAvatar(BuildContext context) {
    return ProfileAvatar(
      localImage: image,
      onTap: () async => await onSelectProfileImage(context),
    );
  }

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

  Widget _buildSaveButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () async {
          await ref
              .read(accountViewModelProvider.notifier)
              .createUserAccount(ref);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.baseColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          "保存する",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  //画面遷移
  void _handleAccountCreation(AccountState state) {
    if (state.isAccountCreatedSuccessfully) {
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
    }
  }

  //プロフィール画像の設定
  Future<void> onSelectProfileImage(BuildContext context) async {
    try {
      //ロード開始
      loadingManager.startLoading(ref);
      var result = await cropImage();
      if (result != null) {
        image = File(result.path);
        //画像をaccountStateに保存
        ref
            .read(accountStateNotifierProvider.notifier)
            .onUserImageChange(image!.path);
      }
    } finally {
      //ロード終了
      loadingManager.stopLoading(ref);
    }
  }
}
