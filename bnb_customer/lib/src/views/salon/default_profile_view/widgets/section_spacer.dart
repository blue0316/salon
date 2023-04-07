import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SectionSpacer extends StatelessWidget {
  final String title;

  const SectionSpacer({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Space(factor: DeviceConstraints.getResponsiveSize(context, 1, 1.5, 3)),
        Text(
          title.toUpperCase(),
          style: Theme.of(context).textTheme.displayLarge!.copyWith(
                fontSize: DeviceConstraints.getResponsiveSize(context, 20.sp, 25.sp, 30.sp),
                color: Colors.white,
              ),
        ),
        Space(factor: DeviceConstraints.getResponsiveSize(context, 1, 1, 2)),
      ],
    );
  }
}
