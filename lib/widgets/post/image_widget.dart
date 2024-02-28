import 'dart:io';

import 'package:flutter/material.dart';

class HeaderImageWidget extends StatelessWidget {
  final String? imageUrl;
  final File? image;
  final Function onTap;

  const HeaderImageWidget({
    Key? key,
    this.imageUrl,
    this.image,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        child: Container(
          width: double.infinity,
          height: 250,
          decoration: BoxDecoration(
            color: Colors.grey,
            image: imageUrl != null && imageUrl != ""
                ? DecorationImage(
                    image: NetworkImage(imageUrl!),
                    fit: BoxFit.cover,
                  )
                : image != null && image != ""
                    ? DecorationImage(
                        image: FileImage(image!),
                        fit: BoxFit.cover,
                      )
                    : null,
          ),
          child: Icon(
            Icons.add_a_photo_outlined,
            size: 64,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}

class NewHeaderImageWidget extends StatelessWidget {
  final String? imageUrl;
  final Function onTap;

  const NewHeaderImageWidget({
    Key? key,
    this.imageUrl,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        child: Container(
          width: double.infinity,
          height: 250,
          decoration: BoxDecoration(
            color: Colors.grey,
            image: imageUrl != null && imageUrl != ""
                ? DecorationImage(
                    image:
                        FileImage(File(imageUrl!.replaceFirst('file://', ''))),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: Icon(
            Icons.add_a_photo_outlined,
            size: 64,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}

class NewCircleImageWidget extends StatelessWidget {
  final String? imageUrl;
  final Function onTap;

  const NewCircleImageWidget({
    super.key,
    this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Stack(
        alignment: Alignment.center, // 子ウィジェットを中央に配置
        children: [
          CircleAvatar(
            backgroundColor: Colors.indigo,
            radius: 63,
            child: imageUrl != null && imageUrl != ""
                ? CircleAvatar(
                    backgroundImage:
                        FileImage(File(imageUrl!.replaceFirst('file://', ''))),
                    radius: 63,
                  )
                : Container(), // 画像がない場合は空のコンテナを表示
          ),
          Icon(
            Icons.add_a_photo_outlined,
            size: 45,
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}

class CircleImageWidget extends StatelessWidget {
  final String? imageUrl;
  final File? image;
  final Function onTap;

  const CircleImageWidget({
    super.key,
    this.imageUrl,
    this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Stack(
        alignment: Alignment.center, // 子ウィジェットを中央に配置
        children: [
          CircleAvatar(
            backgroundColor: Colors.indigo,
            radius: 63,
            child: imageUrl != null && imageUrl != ""
                ? CircleAvatar(
                    backgroundImage: NetworkImage(imageUrl!),
                    radius: 63,
                  )
                : image != null && image != ""
                    ? CircleAvatar(
                        backgroundImage: FileImage(image!),
                        radius: 63,
                      )
                    : Container(), // 画像がない場合は空のコンテナを表示
          ),
          Icon(
            Icons.add_a_photo_outlined,
            size: 45,
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}
