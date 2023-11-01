import 'package:bbblient/src/models/appointment/notification.dart';
import 'package:bbblient/src/utils/time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../theme/app_main_theme.dart';
import '../../utils/icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

 final  margin = EdgeInsets.only(top: 16.0.h, left: 16.h, right: 16.h);
  final padding  = EdgeInsets.only(top: 16.0.h, left: 16.h, bottom: 16.h);

class NotificationUpcomingAppointment extends StatelessWidget {
  final NotificationModel notif;
  const NotificationUpcomingAppointment({Key? key, required this.notif}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.creamBrownLight, width: 2.5)),
      child: Padding(
        padding: padding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              backgroundColor: AppTheme.creamBrownLight.withOpacity(0.25),
              radius: 26,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(height: 25, width: 25, child: SvgPicture.asset(AppIcons.calenderBrownSVG)),
                  ),
                  // Align(
                  //   alignment: Alignment.center,
                  //   child: SizedBox(
                  //     height: 20,
                  //     width: 20,
                  //     child: Center(
                  //       child: Padding(
                  //         padding: const EdgeInsets.only(top: 5.0),
                  //         child: Text(
                  //           "99",
                  //           style: Theme.of(context).textTheme.headline2!.copyWith(fontSize: 11),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
            Expanded(
              child: Container(
                // width: 0.6.sw,
                margin: EdgeInsets.only(left: 12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: notif.bodyTranslations?[AppLocalizations.of(context)?.localeName ?? 'en'],
                            style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w400, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationAppointmentSuccessful extends StatelessWidget {
  const NotificationAppointmentSuccessful({Key? key, required this.notif}) : super(key: key);
  final NotificationModel notif;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: padding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
                backgroundColor: AppTheme.lightGrey.withOpacity(0.25),
                radius: 26,
                child: const Icon(
                  Icons.check_circle,
                  color: AppTheme.lightGrey,
                  size: 25,
                )),
            Expanded(
              child: Container(
                // width: 0.6.sw,
                margin: EdgeInsets.only(left: 12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notif.titleTranslations?[AppLocalizations.of(context)?.localeName ?? 'en'],
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    Text(
                      notif.bodyTranslations?[AppLocalizations.of(context)?.localeName ?? 'en'],
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w400, fontSize: 13),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Row(
                      children: [
                        SizedBox(height: 16, width: 16, child: SvgPicture.asset(AppIcons.recentOutlinedSVG)),
                        SizedBox(
                          width: 4.w,
                        ),
                        Text(
                          Time().getTimeFromDate(notif.triggerTime),
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w400, fontSize: 14),
                        ),
                        const Text(" - "),
                        Text(
                          Time().getFormattedDate2(notif.triggerTime),
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w400, fontSize: 14),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationAppointmentCancelled extends StatelessWidget {
  const NotificationAppointmentCancelled({Key? key, required this.notif}) : super(key: key);
  final NotificationModel notif;

  @override
  Widget build(BuildContext context) {
    return Container(margin: margin,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: padding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
                backgroundColor: AppTheme.redishWarning.withOpacity(0.25),
                radius: 26,
                child: SizedBox(
                  height: 25,
                  width: 25,
                  child: SvgPicture.asset(AppIcons.exclaimSVG),
                )),
            Expanded(
              child: Container(
                // width: 0.6.sw,
                margin: EdgeInsets.only(left: 12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notif.titleTranslations?[AppLocalizations.of(context)?.localeName ?? 'en'],
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    Text(
                      notif.bodyTranslations?[AppLocalizations.of(context)?.localeName ?? 'en'],
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w400, fontSize: 13),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Row(
                      children: [
                        SizedBox(height: 16, width: 16, child: SvgPicture.asset(AppIcons.recentOutlinedSVG)),
                        SizedBox(
                          width: 4.w,
                        ),
                        Text(
                          Time().getTimeFromDate(notif.triggerTime),
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w400, fontSize: 14),
                        ),
                        const Text(" - "),
                        Text(
                          Time().getFormattedDate2(notif.triggerTime),
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w400, fontSize: 14),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationBonusUpdate extends StatelessWidget {
  final NotificationModel notif;
  const NotificationBonusUpdate({Key? key, required this.notif}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(margin: margin,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: padding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
                backgroundColor: AppTheme.oliveLight.withOpacity(0.25),
                radius: 26,
                child: SvgPicture.asset(AppIcons.inviteFriendsGreenSVG)),
            Expanded(
              child: Container(
                // width: 0.6.sw,
                margin: EdgeInsets.only(left: 12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: notif.titleTranslations?[AppLocalizations.of(context)?.localeName ?? 'en'],
                            style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w400, fontSize: 14),
                          ),
                          TextSpan(
                            text: notif.bodyTranslations?[AppLocalizations.of(context)?.localeName ?? 'en'],
                            style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w700, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Row(
                      children: [
                        SizedBox(height: 16, width: 16, child: SvgPicture.asset(AppIcons.recentOutlinedSVG)),
                        SizedBox(
                          width: 4.w,
                        ),
                        Text(
                          Time().getTimeFromDate(notif.triggerTime),
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w400, fontSize: 14),
                        ),
                        const Text(" - "),
                        Text(
                          Time().getFormattedDate2(
                            notif.triggerTime,
                          ),
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w400, fontSize: 14),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            // IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert_rounded))
          ],
        ),
      ),
    );
  }
}
