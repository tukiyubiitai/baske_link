// import 'package:basketball_app/presentation/pages/teams/team_post_page.dart';
// import 'package:basketball_app/presentation/widgets/progress_indicator.dart';
// import 'package:basketball_app/team_post_model_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// class TeamPostState extends ConsumerWidget {
//   final bool isEditing; //編集モード
//   final String? postId; //編集する投稿のID
//
//   const TeamPostState({required this.isEditing, this.postId, super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final PostAsyncValue =
//         ref.watch(postStateNotifierProvider(postId, isEditing));
//
//     return Scaffold(
//       backgroundColor: Colors.indigo[900],
//       body: PostAsyncValue.when(
//         error: (e, stack) {
//           debugPrint(e.toString());
//           return Center(child: Text('エラーが発生しました: $e'));
//         },
//         loading: () => ShowProgressIndicator(
//           textColor: Colors.white,
//           indicatorColor: Colors.white,
//         ),
//         data: (post) {
//           return TeamPostPage();
//         },
//       ),
//     );
//   }
// }
