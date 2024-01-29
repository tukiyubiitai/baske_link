import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/image_provider_utils.dart';
import '../../state/providers/account/account_state_notifier.dart';

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

class ProfileAvatar extends ConsumerWidget {
  final File? localImage;
  final String? networkImagePath;
  final VoidCallback onTap;

  const ProfileAvatar({
    Key? key,
    this.localImage,
    this.networkImagePath,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(accountStateNotifierProvider);
    final imageProvider =
        ImageProviderUtils.getUserImage(localImage, networkImagePath);
    final shouldShowDefault = localImage == null &&
        (networkImagePath == null || networkImagePath!.isEmpty);

    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        backgroundColor: shouldShowDefault ? Colors.indigo[900] : Colors.white,
        radius: 65,
        backgroundImage: shouldShowDefault ? null : imageProvider,
        child: const Icon(
          Icons.add_a_photo_outlined,
          size: 40,
          color: Colors.blue,
        ),
      ),
    );
  }
}
