import 'package:flutter/material.dart';

class AccountCircle extends StatelessWidget {
  final String imagePath;
  final Function()? onEdit;

  const AccountCircle({
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
            padding: EdgeInsets.only(top: 100, left: 115),
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
                icon: Icon(
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

class noImageAccountCircle extends StatelessWidget {
  final Function()? onEdit;

  const noImageAccountCircle({
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Stack(
        children: [
          Center(
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 3.0,
                ),
              ),
              child: Icon(
                Icons.person,
                size: 75,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 85, left: 210),
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.orange),
              child: IconButton(
                icon: Icon(
                  Icons.create,
                  size: 20,
                ),
                color: Colors.white,
                onPressed: onEdit,
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
            foregroundImage: AssetImage('assets/images/headerImage.jpg'),
          ),
        ),
      ],
    );
  }
}
