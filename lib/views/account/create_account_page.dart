import 'dart:io';

import 'package:basketball_app/models/color/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../bottom_navigation.dart';
import '../../dialogs/snackbar.dart';
import '../../models/account/account.dart';
import '../../state/providers/providers.dart';
import '../../widgets/account/user_profile_circle.dart';
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

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accountState = ref.watch(accountManagerProvider);
    final bottomSpace = MediaQuery.of(context).viewInsets.bottom;

    // アカウント作成成功後の画面遷移
    ref.listen<AccountState>(accountManagerProvider, (_, state) {
      // isAccountCreatedSuccessfullyがtrueに変わった場合にのみ実行
      if (state.isAccountCreatedSuccessfully) {
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
        title: const Text("新規アカウント作成", style: TextStyle(color: Colors.white)),
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
                    child: _buildContent(context),
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
      onTap: () async => await ref
          .read(accountManagerProvider.notifier)
          .onSelectProfileImage(),
    );
  }

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

  Widget _buildSaveButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () async {
          ref
              .read(accountManagerProvider.notifier)
              .onUserNameChange(_nameController.text);
          await ref.read(accountManagerProvider.notifier).createAccount(ref);
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
      state = state.copyWith(isAccountCreatedSuccessfully: false);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => BottomTabNavigator(initialIndex: 3),
        ),
        (route) => false,
      );
      showSnackBar(
        context: context,
        text: "ユーザーが作成されました！",
        backgroundColor: Colors.white,
        textColor: Colors.black,
      );
    } else {
      return;
    }
  }
}
