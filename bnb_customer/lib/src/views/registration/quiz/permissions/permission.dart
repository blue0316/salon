import 'package:bbblient/src/models/enums/status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../theme/app_main_theme.dart';
import '../../../widgets/widgets.dart';

class PermissionDialoug extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String body;
  final String buttonText;
  final String skipText;
  final Function onApprove;
  final Function onSkip;
  final Status permissionStatus;
  const PermissionDialoug({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.body,
    required this.buttonText,
    required this.onApprove,
    required this.onSkip,
    required this.skipText,
    required this.permissionStatus,
  }) : super(key: key);

  @override
  _PermissionDialougState createState() => _PermissionDialougState();
}

class _PermissionDialougState extends State<PermissionDialoug> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Space(),
          Container(
              height: 274.h,
              width: 228.w,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(color: AppTheme.grey3, blurRadius: 10.0.sp, offset: const Offset(0, 4)),
              ]),
              child: Image.asset(widget.imageUrl)),
          Padding(
            padding: EdgeInsets.only(top: 54.0.h),
            child: Text(
              widget.title,
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 72.0, vertical: 24.h),
            child: Text(
              widget.body,
              style: Theme.of(context).textTheme.headline4!.copyWith(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 24.0.h),
            child: MaterialButton(
              onPressed: () => widget.onApprove(),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: AppTheme.creamBrown,
              minWidth: 240,
              height: 50,
              child: (widget.permissionStatus == Status.success)
                  ? const SizedBox(
                      height: 45,
                      width: 45,
                      child: Icon(Icons.check, color: AppTheme.white, size: 30),
                    )
                  : Text(
                      widget.buttonText,
                      style: Theme.of(context).textTheme.headline2,
                    ),
            ),
          ),
          TextButton(onPressed: () => widget.onSkip(), child: Text(widget.skipText))
        ],
      ),
    );
  }
}
