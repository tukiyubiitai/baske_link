import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/posts/game_model.dart';
import '../post/post_profile_circles.dart';

class GameHeader extends StatelessWidget {
  final GamePost postData;
  final bool isTimelinePage; // 追加のパラメータ

  GameHeader({required this.isTimelinePage, required this.postData, super.key});

  @override
  Widget build(BuildContext context) {
    print(postData);
    DateTime createAtDateTime = postData.createdTime.toDate();
    String formattedCreatedAt =
        DateFormat('yyyy/MM/dd').format(createAtDateTime);
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5), // 透明度を調整して画像を暗くします
              BlendMode.srcATop,
            ),
            child: postData.imagePath != ""
                ? Image.network(
                    postData.imagePath.toString(),
                    width: double.infinity,
                    height: isTimelinePage ? 150 : 200,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    'assets/images/headerImage.jpg',
                    width: double.infinity,
                    height: isTimelinePage ? 150 : 200,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 40,
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10)),
                color: Colors.orange,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  postData.prefecture,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                "更新日：$formattedCreatedAt",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        Padding(
          padding: isTimelinePage
              ? EdgeInsets.only(left: 15.0, top: 80) //timeline
              : EdgeInsets.only(left: 15.0, top: 140), //detail
          // padding: EdgeInsets.only(left: 15.0, top: 140),
          child: Row(
            children: [
              postData.imagePath != ""
                  ? ImageCircle(
                      imagePath: postData.imagePath.toString(),
                      isTimelinePage: isTimelinePage,
                    )
                  : NoImageCircle(
                      isTimelinePage: isTimelinePage,
                    ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
