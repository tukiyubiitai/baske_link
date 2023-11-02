import 'package:flutter/material.dart';

class AccountCircleWidget extends StatelessWidget {
  final String imagePath;
  final Function()? onEdit;

  const AccountCircleWidget({
    super.key,
    required this.imagePath,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Stack(
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 3.0,
              ),
            ),
            child: CircleAvatar(
              radius: 65,
              foregroundImage: NetworkImage(imagePath),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100, left: 115),
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.orange,
              ),
              child: IconButton(
                color: Colors.white,
                onPressed: onEdit,
                icon: const Icon(
                  Icons.create,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NoImageAccountCircle extends StatelessWidget {
  final Function()? onEdit;

  const NoImageAccountCircle({
    super.key,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Stack(
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 3.0,
              ),
            ),
            child: const CircleAvatar(
              radius: 65,
              foregroundImage: AssetImage("assets/images/basketball_icon.png"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100, left: 115),
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.orange,
              ),
              child: IconButton(
                color: Colors.white,
                onPressed: onEdit,
                icon: const Icon(
                  Icons.create,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ImageCircle extends StatelessWidget {
  final String imagePath;

  const ImageCircle({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 3.0,
            ),
          ),
          child: CircleAvatar(
            radius: 65,
            foregroundImage: NetworkImage(imagePath),
          ),
        ),
      ],
    );
  }
}

class NoImageCircle extends StatelessWidget {
  const NoImageCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 3.0,
            ),
          ),
          child: const CircleAvatar(
            radius: 65,
            foregroundImage: AssetImage('assets/images/headerImage.jpg'),
          ),
        ),
      ],
    );
  }
}
