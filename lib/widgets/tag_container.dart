import 'package:flutter/material.dart';

Widget buildTagContainers(List<String> tags, Color color) {
  return Wrap(
    spacing: 3.0,
    runSpacing: 10.0,
    children: tags.map((tag) => TagContainer(text: tag, color: color)).toList(),
  );
}

Widget TagContainer({required String text, required Color color}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(50),
      border: Border.all(
        color: color,
        width: 0.8,
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 3.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    ),
  );
}
