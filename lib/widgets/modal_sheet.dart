import 'package:basketball_app/state/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../dialogs/snackbar.dart';
import '../views/games/game_search_results_page.dart';
import '../views/teams/team_search_results_page.dart';
import 'area_dropdown_menu_widget.dart';

class ModalBottomSheetContent extends ConsumerStatefulWidget {
  final String type;

  const ModalBottomSheetContent({super.key, required this.type});

  @override
  ConsumerState<ModalBottomSheetContent> createState() =>
      _ModalBottomSheetContentState();
}

class _ModalBottomSheetContentState
    extends ConsumerState<ModalBottomSheetContent> {
  final TextEditingController _textController = TextEditingController();

  //検索ボタンの処理
  Future<void> onSearchButtonPressed() async {
    if (_textController.text.isEmpty &&
        (ref.read(teamPostManagerProvider).prefecture.isEmpty) &&
        (ref.read(gamePostManagerProvider).prefecture.isEmpty)) {
      return showErrorSnackBar(context: context, text: '何も入力されていません');
    }
    if (widget.type == "team") {
      final selectedValue = ref.read(teamPostManagerProvider).prefecture;
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TeamSearchResultsPage(
            selectedLocation: selectedValue,
            keywordLocation: _textController.text,
          ),
        ),
      );
    } else if (widget.type == "game") {
      final selectedValue = ref.read(gamePostManagerProvider).prefecture;
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => GameSearchResultsPage(
            selectedLocation: selectedValue,
            keywordLocation: _textController.text,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(teamPostManagerProvider);
    ref.watch(gamePostManagerProvider);

    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.clear,
                    size: 30,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "絞り込み検索",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          "エリア",
                          style: TextStyle(
                              color: Colors.indigo,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      AreaDropdownMenuWidget(
                        color: Colors.blue,
                        type: widget.type,
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.black12, width: 1.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 16.0, top: 10),
                  child: Text(
                    "活動場所を特定して投稿を探す",
                    style: TextStyle(
                        color: Colors.indigo,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  width: 300,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: '札幌市など...',
                        contentPadding: const EdgeInsets.all(10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.black12, width: 1.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      await onSearchButtonPressed();
                    },
                    child: const Text(
                      "検索する",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
