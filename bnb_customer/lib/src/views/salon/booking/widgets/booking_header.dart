import 'dart:ui';

import 'package:bbblient/src/utils/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookingHeader extends StatelessWidget {
  final bool small;
  const BookingHeader({Key? key, required this.small}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: small ? 254.h : 432.h,
      width: 1.sw,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox(
              height: 458.h,
              width: 1.sw,
              child: Image.asset(
                AppIcons.masterPicDefaultPNG,
                fit: BoxFit.cover,
              )),
          Positioned(
            bottom: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(40),
                topLeft: Radius.circular(40),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18.0, sigmaY: 18.0),
                child: Container(
                  height: 100.h,
                  width: 1.sw,
                  decoration: const BoxDecoration(
                    color: Colors.white12,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -1,
            child: Container(
              height: 38.h,
              width: 1.sw,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(
                    40,
                  ),
                  topRight: Radius.circular(
                    40,
                  ),
                ),
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
          ),
          Positioned(
            bottom: 55.h,
            left: 40.w,
            child: Text(
              // todo
              "--",
              style: Theme.of(context).textTheme.headline2!.copyWith(
                    fontSize: 20,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
