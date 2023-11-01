import 'package:bbblient/src/utils/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SaloonContainerSimmer extends StatelessWidget {
  const SaloonContainerSimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
          height: 120.0,
          child: Row(
            children: [
              SizedBox(
                height: 120,
                width: 108.w,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
                  child: SvgPicture.asset(
                    AppIcons.salonPlaceHolder,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Column(
                children: const [],
              )
            ],
          )),
    );
  }
}
