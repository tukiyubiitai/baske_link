import 'package:basketball_app/state/providers/providers.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/posts/area_model.dart';

// エリア
class AreaDropdownMenuWidget extends ConsumerWidget {
  final Color color;
  final String type;

  AreaDropdownMenuWidget({required this.color, required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController searchController = TextEditingController();
    final gameProvider = ref.watch(gamePostManagerProvider);
    final teamProvider = ref.watch(teamPostManagerProvider);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          hint: Text(
            'エリアを選択',
            style: TextStyle(
              fontSize: 14,
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
          items: prefectures
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(
                      item,
                      style: TextStyle(
                          fontSize: 14,
                          color: color,
                          fontWeight: FontWeight.bold),
                    ),
                  ))
              .toList(),
          value: type == 'game'
              ? gameProvider.prefecture.isNotEmpty
                  ? gameProvider.prefecture
                  : null
              : teamProvider.prefecture.isNotEmpty
                  ? teamProvider.prefecture
                  : null,
          onChanged: (value) {
            if (value != null) {
              if (type == 'game') {
                ref.read(gamePostManagerProvider.notifier).addPrefecture(value);
              } else {
                ref
                    .read(teamPostManagerProvider.notifier)
                    .onPrefectureChange(value);
              }
            }
          },
          buttonStyleData: ButtonStyleData(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: 58,
            width: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
          ),
          dropdownStyleData: const DropdownStyleData(
            maxHeight: 200,
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
          ),
          dropdownSearchData: DropdownSearchData(
            searchController: searchController,
            searchInnerWidgetHeight: 50,
            searchInnerWidget: Container(
              height: 50,
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 4,
                right: 8,
                left: 8,
              ),
              child: TextFormField(
                expands: true,
                maxLines: null,
                controller: searchController,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  hintText: 'Search for an item...',
                  hintStyle: const TextStyle(fontSize: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            searchMatchFn: (item, searchValue) {
              return item.value.toString().contains(searchValue);
            },
          ),
          onMenuStateChange: (isOpen) {
            if (!isOpen) {
              searchController.clear();
            }
          },
        ),
      ),
    );
  }
}
