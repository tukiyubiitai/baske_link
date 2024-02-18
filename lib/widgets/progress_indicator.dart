import 'package:flutter/material.dart';

import '../models/color/app_colors.dart';

class ShowProgressIndicator extends StatelessWidget {
  final Color? textColor;
  final Color indicatorColor;

  const ShowProgressIndicator({
    super.key,
    this.textColor,
    required this.indicatorColor,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      CircularProgressIndicator(
        color: indicatorColor,
      ),
      const SizedBox(height: 16),
    ];

    // textColorがnullでない場合のみ、テキストウィジェットを追加する
    if (textColor != null) {
      children.add(
        Text(
          "ロード中...",
          style: TextStyle(color: textColor),
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    );
  }
}

class ScaffoldShowProgressIndicator extends StatelessWidget {
  final Color textColor;
  final Color indicatorColor;

  const ScaffoldShowProgressIndicator({
    super.key,
    required this.textColor,
    required this.indicatorColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.baseColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: indicatorColor,
            ),
            const SizedBox(height: 16),
            Text(
              "ロード中...",
              style: TextStyle(color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}
