import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileListTile extends StatelessWidget {
  final String title;
  final String iconUrl;
  final Function onTapped;
  const ProfileListTile({
    Key? key,
    required this.title,
    required this.iconUrl,
    required this.onTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTapped(),
      child: Ink(
        height: 84,
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white, width: 1))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0, left: 20),
                  child: CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.white,
                    child: Center(
                        child: SizedBox(
                      height: 20,
                      width: 20,
                      child: SvgPicture.asset(iconUrl),
                    )),
                  ),
                ),
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 25.sp,
                )),
          ],
        ),
      ),
    );
  }
}
