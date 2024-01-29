import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../../infrastructure/firebase/storage_firebase.dart';

class PostViewModel extends ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference get teamPosts => firestore.collection("teamPosts");

  CollectionReference get gamePosts => firestore.collection("gamePosts");

  CollectionReference get users => firestore.collection("users");

  //post関係の画像をアップロード
  Future<String?> uploadPostImage(
      String? imagePath, String defaultValue) async {
    // 新しい画像が追加された場合
    if (imagePath != null &&
        imagePath.isNotEmpty &&
        imagePath != defaultValue) {
      // 既存の画像があれば削除
      if (defaultValue.isNotEmpty) {
        await ImageManager.deleteImage(defaultValue);
      }
      String? directory = 'postImages';
      // 新しく画像をアップロードしてそのURLを返す
      return await ImageManager.uploadImage(imagePath, directory: directory);
    } else {
      // imagePathがnullまたは空文字列の場合は、デフォルト値を返す
      return defaultValue;
    }
  }

  //投稿削除
  Future<bool> deletePostsByPostId(String postId, String myAccountId,
      String type, String? imageUrl, String? headerUrl) async {
    // 画像削除の関数
    Future<void> deleteImage(String? imageUrl) async {
      if (imageUrl != null && imageUrl.isNotEmpty) {
        await ImageManager.deleteImage(imageUrl);
      }
    }

    // 画像削除
    await deleteImage(imageUrl);
    if (type == "team") {
      await deleteImage(headerUrl); // TeamPostsの場合のみheaderUrlを扱う
    }

    DocumentReference postRef;
    if (type == "team") {
      postRef = teamPosts.doc(postId);
    } else {
      postRef = gamePosts.doc(postId);
    }
    await postRef.delete();
    print('ユーザーの${type == "team" ? 'Team' : 'Game'}Postsを削除しました!');

    String subCollectionName = type == "team" ? "my_posts" : "my_game_posts";
    var userSubCollection =
        users.doc(myAccountId).collection(subCollectionName);
    var snapshots =
        await userSubCollection.where("post_id", isEqualTo: postId).get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
    print("$subCollectionNameから投稿を削除しました");

    return true; // 成功時にtrueを返す
  }
}
