import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/posts/team_model.dart';
import '../post/post_profile_circles.dart';

/*
画像
ヘッダー画像
エリア
更新日
 */
class PostHeader extends StatelessWidget {
  final bool isTimelinePage; // 追加のパラメータ

  final TeamPost postData;

  PostHeader({required this.isTimelinePage, required this.postData, super.key});

  @override
  Widget build(BuildContext context) {
    DateTime createAtDateTime = postData.createdTime.toDate();
    String formattedCreatedAt =
        DateFormat('yyyy/MM/dd').format(createAtDateTime);
    print("ヘッダーが呼ばれた");

    print("これが画像：${postData.headerUrl}");
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
            child: postData.headerUrl != null && postData.headerUrl != ""
                // ? Image.network(
                //     postData.headerUrl.toString(),
                //     width: double.infinity,
                //     height: isTimelinePage ? 150 : 200,
                //     fit: BoxFit.cover,
                //   )
                ? Image(
                    image: NetworkImage(postData.headerUrl.toString()),
                    width: double.infinity,
                    height: isTimelinePage ? 150 : 200,
                    fit: BoxFit.cover,
                    frameBuilder: (BuildContext context, Widget child,
                        int? frame, bool wasSynchronouslyLoaded) {
                      if (wasSynchronouslyLoaded || frame != null) {
                        return child;
                      } else {
                        // 画像の読み込み中に表示するウィジェット
                        return Center(
                            child: CircularProgressIndicator(
                          color: Colors.blue,
                        ));
                      }
                    },
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      print("${exception}${stackTrace}");
                      // エラー時の処理
                      return Text('画像を読み込めませんでした,${exception}${stackTrace}');
                    },
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
                color: Colors.indigo,
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
              postData.imageUrl != null && postData.imageUrl != ""
                  ? ImageCircle(
                      imagePath: postData.imageUrl.toString(),
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
