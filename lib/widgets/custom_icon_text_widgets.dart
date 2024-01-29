import 'package:flutter/material.dart';

class PostIconWithText extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  final FontWeight fontWeight; // text1のフォントウェイト

  const PostIconWithText(
      {super.key,
      required this.icon,
      required this.text,
      required this.color,
      required this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 25,
          color: Colors.orange,
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: fontWeight,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

class PostIconWithTwoText extends StatelessWidget {
  final IconData icon;
  final String text1;
  final String text2;

  const PostIconWithTwoText(
      {super.key,
      required this.icon,
      required this.text1,
      required this.text2});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start, // ここでspaceAroundを指定
      children: [
        Text(
          text1,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w100,
            color: Colors.black,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        Icon(
          icon,
          size: 25,
          color: Colors.orange,
        ),
        const SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(
            text2,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
            overflow: TextOverflow.visible,
            softWrap: true, // テキストを自動的に折り返す
          ),
        ),
      ],
    );
  }
}

class PostIconWithTextWithList extends StatelessWidget {
  final IconData icon;
  final String text;
  final List<String> list;

  final Color color;
  final FontWeight fontWeight;

  const PostIconWithTextWithList(
      {super.key,
      required this.icon,
      required this.text,
      required this.list,
      required this.color,
      required this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        Icon(
          icon,
          size: 25,
          color: Colors.orange,
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              list.take(3).join(", "),
              style: TextStyle(
                fontSize: 14,
                fontWeight: fontWeight,
                color: color,
              ),
            ),
            if (list.length > 3)
              Text(
                list.skip(3).join(", "),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: fontWeight,
                  color: color,
                ),
              ),
          ],
        )
      ],
    );
  }
}

class PostIconWithList extends StatelessWidget {
  final IconData icon;
  final List<String> list;

  final Color color;
  final FontWeight fontWeight; // text1のフォントウェイト

  const PostIconWithList(
      {super.key,
      required this.icon,
      required this.list,
      required this.color,
      required this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 25,
          color: Colors.orange,
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              list.take(3).join(", "),
              style: TextStyle(
                fontSize: 14,
                color: color,
                fontWeight: fontWeight,
              ),
            ),
            if (list.length > 3)
              Text(
                list.skip(3).join(", "),
                style: TextStyle(
                    fontSize: 14, color: color, fontWeight: fontWeight),
              ),
          ],
        )
      ],
    );
  }
}

class LevelTextWidgets extends StatelessWidget {
  final int level;

  const LevelTextWidgets({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    String text;
    List<Widget> stars = [];

    switch (level) {
      case 1:
        text = "初級";
        stars = [
          const Icon(Icons.star, color: Colors.indigo),
          const Icon(Icons.star_outline, color: Colors.grey),
          const Icon(Icons.star_outline, color: Colors.grey),
        ];
        break;
      case 2:
        text = "中級";
        stars = [
          const Icon(Icons.star, color: Colors.indigo),
          const Icon(Icons.star, color: Colors.indigo),
          const Icon(Icons.star_outline, color: Colors.grey),
        ];
        break;
      case 3:
        text = "上級";
        stars = [
          const Icon(Icons.star, color: Colors.indigo),
          const Icon(Icons.star, color: Colors.indigo),
          const Icon(Icons.star, color: Colors.indigo),
        ];
        break;
      default:
        text = "未設定";
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "($text)",
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        const SizedBox(
          width: 10,
        ),
        ...stars, // stars リスト内のアイコンを展開して表示
      ],
    );
  }
}
