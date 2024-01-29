import 'package:flutter/material.dart';

class ImageCircle extends StatelessWidget {
  final String imagePath;

  final bool isTimelinePage;

  const ImageCircle({
    super.key,
    required this.imagePath,
    required this.isTimelinePage,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: isTimelinePage ? 110 : 130,
          height: isTimelinePage ? 110 : 130,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 3.0,
            ),
          ),
          child: CircleAvatar(
            radius: 63,
            foregroundImage: NetworkImage(imagePath),
          ),
        ),
      ],
    );
  }
}

class NoImageCircle extends StatelessWidget {
  final bool isTimelinePage;

  const NoImageCircle({required this.isTimelinePage, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: isTimelinePage ? 110 : 130,
          height: isTimelinePage ? 110 : 130,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 3.0,
            ),
          ),
          child: const CircleAvatar(
            radius: 63,
            foregroundImage: AssetImage('assets/images/headerImage.jpg'),
          ),
        ),
      ],
    );
  }
}
