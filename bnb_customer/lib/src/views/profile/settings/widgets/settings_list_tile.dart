import '../../../../theme/app_main_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsTile extends StatelessWidget {
  final String title;
  final String iconUrl;
  final Function onTapped;
  final Size size;

  const SettingsTile({
    Key? key,
    required this.title,
    required this.iconUrl,
    required this.onTapped,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h),
      child: InkWell(
        onTap: () => onTapped(),
        child: Ink(
          height: 64,
          width: size.width,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 40.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: AppTheme.coolerGrey,
                        child: SizedBox(
                          height: 16,
                          width: 16,
                          child: SvgPicture.asset(iconUrl),
                        ),
                      ),
                    ),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 25.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
