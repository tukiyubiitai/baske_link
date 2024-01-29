import 'package:flutter/material.dart';

import '../../models/app_colors.dart';

class ShowProgressIndicator extends StatelessWidget {
  final Color textColor;
  final Color indicatorColor;

  const ShowProgressIndicator({
    super.key,
    required this.textColor,
    required this.indicatorColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
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
