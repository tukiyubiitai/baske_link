import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/area_provider.dart';
import '../../screen/post/search_results_page.dart';
import '../post_widgets/dropdown_widget.dart';

class ModalBottomSheetContent extends StatefulWidget {
  final bool isEditing;

  const ModalBottomSheetContent({super.key, required this.isEditing});

  @override
  _ModalBottomSheetContentState createState() =>
      _ModalBottomSheetContentState();
}

class _ModalBottomSheetContentState extends State<ModalBottomSheetContent> {
  // String _selectedLocation = ""; // 選択した場所を保持する状態
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final areaModel = Provider.of<AreaProvider>(context, listen: false);

    return Container(
      margin: const EdgeInsets.only(top: 50),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.black38,
                  width: 1,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.clear),
                  ),
                  const Text(
                    "フィルター",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      areaModel.clearTags();
                      _textController.clear();
                    },
                    child: const Text(
                      "クリア",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        "エリア",
                        style: TextStyle(
                            color: Colors.orange,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    AreaDropdownMenuWidget(),
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
                  "場所を特定して投稿を探す",
                  style: TextStyle(
                      color: Colors.orange,
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
                    // print("これが選ばれたエリア $selectedValue");
                    await Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchResultsPage(
                          // selectedLocation: selectedValue,
                          keywordLocation: _textController.text,
                          isEditing: widget.isEditing,
                        ),
                      ),
                    );
                  },
                  child: const Text("検索する"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
