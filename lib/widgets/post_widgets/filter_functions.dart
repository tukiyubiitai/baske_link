// フラグタイムのウィジェットを生成するためのヘルパークラス
import 'package:flutter/material.dart';

import '../screen/post/team_post_page.dart';

class FilterFunctions {
  // フィルターチップを生成するメソッド
  static Iterable<Widget> getRecruitmentFilterChips(
      List<String> filters,
      List<FilterChipItemWidget> filterChipItems,
      Function(List<String>) updateFilters) sync* {
    // フィルターチップのリストを順に生成
    for (FilterChipItemWidget filterChipItem in filterChipItems) {
      yield FilterChip(
        // チップの背景色とラベルを設定
        backgroundColor: Colors.grey[200],
        label: Text(
          filterChipItem.name,
        ),
        // フィルターが選択されているかどうかを判定
        selected: filters.contains(filterChipItem.name),
        selectedColor: Colors.lightBlueAccent,
        // フィルターが選択されたときの処理
        onSelected: (bool selected) {
          // フィルターの状態を更新するために新しいリストを作成
          List<String> updatedFilters = List.from(filters);
          if (selected) {
            // 選択された場合はフィルターを追加
            updatedFilters.add(filterChipItem.name);
          } else {
            // 選択が解除された場合はフィルターを削除
            updatedFilters.removeWhere((String name) {
              return name == filterChipItem.name;
            });
          }
          // 外部で指定されたコールバック関数を使ってフィルターを更新
          updateFilters(updatedFilters);
          print(updatedFilters); // 更新されたフィルターを出力
        },
      );
    }
  }
}

/*
Iterable を使用して、filters リストと filterChipItems リストを順に生成しています。
このコードは、filterChipItems リスト内の各アイテムに対して順に処理を行い、
それぞれのアイテムに対して FilterChip ウィジェットを生成しています。
 */

/*
この一文はジェネレータと言われる　yield(イールド)

Function(List<String>) updateFilters) sync* {
  for (FilterChipItemWidget filterChipItem in filterChipItems) {
    yield FilterChip(
      // ...
    );
  }
}
 */
