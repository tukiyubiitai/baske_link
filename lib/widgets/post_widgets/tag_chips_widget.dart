import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/tag_provider.dart';
import 'dropdown_widget.dart';

class TgaChips extends StatelessWidget {
  const TgaChips({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AreaDropdownMenuWidget(),
            Expanded(
              child: Consumer<TagProvider>(builder: (context, model, child) {
                return TextField(
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  controller: TextEditingController(),
                  maxLength: 6,
                  // 新しいコントローラーを作成
                  decoration: InputDecoration(
                    counterStyle: const TextStyle(color: Colors.white54),
                    labelText: '完了でタグを追加...渋谷区など',
                    labelStyle:
                        const TextStyle(color: Colors.white54, fontSize: 15),
                    border: const OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color:
                            model.showErrorBorder ? Colors.red : Colors.white,
                      ), // 枠線の色を透明に設定
                    ),
                  ),

                  onSubmitted: (String text) {
                    if (text.trim().isNotEmpty) {
                      // テキストが空白でない場合のみ処理
                      if (model.tagStrings.length < 6) {
                        model.update();
                        // タグ数が6未満の場合のみ追加
                        model.addTag(text);
                        TextEditingController().clear();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(
                              'タグは6個以上は作成できません',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      }
                    }
                  },
                );
              }),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Consumer<TagProvider>(
                builder: (context, model, child) {
                  return Wrap(
                    spacing: 3.0, // Chip同士の間隔を設定
                    children: model.tagStrings
                        .map(
                          (tag) => Chip(
                            backgroundColor: Colors.blue, // 背景色を青に設定
                            label: Text(
                              tag,
                              style: const TextStyle(color: Colors.white),
                            ),
                            onDeleted: () {
                              model.removeTag(model.tagStrings.indexOf(tag));
                            },
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
