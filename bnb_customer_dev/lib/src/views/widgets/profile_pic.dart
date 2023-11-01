import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../utils/icons.dart';

class ProfilePic extends StatelessWidget {
  final String pic;
  final double size;
  final Color backgroundColor;

  const ProfilePic({Key? key, required this.pic, this.size = 100, required this.backgroundColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: (size / 2) + 2,
      backgroundColor: backgroundColor,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(1000),
        child: pic != ''
            ? SizedBox(
                height: size,
                width: size,
                child: CachedNetworkImage(
                  imageUrl: pic,
                ),
              )
            : SvgPicture.asset(
                AppIcons.profilePicPlaceHolder,
                fit: BoxFit.cover,
                height: size,
                width: size,
              ),
      ),
    );
  }
}
