import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../dialogs/snackbar_utils.dart';
import '../state/providers/post/tag_area_notifier.dart';

class TagChipsField extends ConsumerStatefulWidget {
  final Color color;

  const TagChipsField({required this.color, super.key});

  @override
  ConsumerState<TagChipsField> createState() => _TagChipsState();
}

class _TagChipsState extends ConsumerState<TagChipsField> {
  @override
  Widget build(BuildContext context) {
    final _focusNode = FocusNode();
    final TextEditingController _tagsController = TextEditingController();
    final tagProvider = ref.watch(tagAreaStateProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text.rich(
              TextSpan(
                text: "詳しい活動場所のタグ",
                style: const TextStyle(fontSize: 17.0, color: Colors.black),
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Text.rich(
              TextSpan(
                text: "必須",
                style: const TextStyle(fontSize: 13.0, color: Colors.red),
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Text.rich(
              TextSpan(
                text: "必須",
                style: const TextStyle(fontSize: 13.0, color: Colors.white),
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Wrap(
                spacing: 3.0, // Chip同士の間隔を設定
                children: tagProvider
                    .map(
                      (tag) => Chip(
                        backgroundColor: widget.color, // 背景色を青に設定
                        label: Text(
                          tag,
                          style: const TextStyle(color: Colors.white),
                        ),
                        onDeleted: () {
                          // model.removeTag(model.tagStrings.indexOf(tag));
                          ref
                              .read(tagAreaStateProvider.notifier)
                              .removeTag(tagProvider.indexOf(tag));

                          setState(() {});
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
        Focus(
          onFocusChange: (hasFocus) {
            if (_tagsController.text.trim().isNotEmpty) {
              // テキストが空白でない場合のみ処理
              if (tagProvider.length < 6 && _tagsController.text.length <= 6) {
                // タグ数が6未満の場合のみ追加
                ref
                    .read(tagAreaStateProvider.notifier)
                    .addTag(_tagsController.text);
                setState(() {});
                _tagsController.clear();
              } else {
                showErrorSnackBar(context: context, text: 'タグは6個以上は作成できません');
              }
            }
          },
          child: TextField(
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
            controller: _tagsController,
            maxLength: 6,
            maxLines: 1,
            focusNode: _focusNode,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white12,
              prefixIcon: const Icon(
                Icons.add,
                color: Colors.orange,
              ),
              counterStyle: const TextStyle(color: Colors.black),
              labelText: '完了でタグを6個まで追加できます',
              labelStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 15),
              // border: const OutlineInputBorder(),
              // enabledBorder: OutlineInputBorder(
              //   borderSide: BorderSide(
              //     color: Colors.black,
              //   ), // 枠線の色を透明に設定
              // ),
            ),
            onSubmitted: (String text) {
              if (text.trim().isNotEmpty) {
                // テキストが空白でない場合のみ処理
                if (tagProvider.length < 6 &&
                    _tagsController.text.length <= 6) {
                  // タグ数が6未満の場合のみ追加
                  ref.read(tagAreaStateProvider.notifier).addTag(text);

                  setState(() {});
                  _tagsController.clear();
                } else {
                  showErrorSnackBar(context: context, text: 'タグは6個以上は作成できません');
                }
              }
            },
          ),
        ),
      ],
    );
  }
}
