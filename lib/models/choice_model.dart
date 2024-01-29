import 'package:flutter/material.dart';

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

const List<Choice> userBlock = <Choice>[
  Choice(title: 'このユーザーをブロックする', icon: Icons.block),
  Choice(title: 'このユーザーを報告する', icon: Icons.report),
];

const List<Choice> postBlock = <Choice>[
  // Choice(title: 'この投稿をブロックする', icon: Icons.block),
  Choice(title: 'この投稿を報告する', icon: Icons.report),
];
