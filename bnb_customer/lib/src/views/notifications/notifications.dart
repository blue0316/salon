import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/backend_codings/notification_type.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/notifications/notification_type_widgets.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../utils/icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserNotifications extends ConsumerStatefulWidget {
  const UserNotifications({Key? key}) : super(key: key);

  @override
  _UserNotificationsState createState() => _UserNotificationsState();
}

class _UserNotificationsState extends ConsumerState<UserNotifications> {
  @override
  Widget build(BuildContext context) {
    final _bnbProvider = ref.watch(bnbProvider);
    return Scaffold(
        body: SafeArea(
      child: ConstrainedContainer(
maxWidth: 800,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
                expandedHeight: 150.h,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: Text(
                  AppLocalizations.of(context)?.notifications ?? "Notifications",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                centerTitle: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 40.h,
                            width: 40.h,
                            child: SvgPicture.asset(AppIcons.notifBellBrownSVG),
                          ),
                        ],
                      )),
                )),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  if (_bnbProvider.notifications[index].notificationSubType == NotificationSubType.appointmentUpcoming) {
                    return NotificationUpcomingAppointment(notif: _bnbProvider.notifications[index]);
                  }
                  if (_bnbProvider.notifications[index].notificationSubType == NotificationSubType.appointmentCreated) {
                    return NotificationAppointmentSuccessful(notif: _bnbProvider.notifications[index]);
                  }
                  if (_bnbProvider.notifications[index].notificationType == NotificationType.referral) {
                    return NotificationBonusUpdate(notif: _bnbProvider.notifications[index]);
                  }
                  if (_bnbProvider.notifications[index].notificationSubType == NotificationSubType.appointmentCancelled) {
                    return NotificationAppointmentCancelled(notif: _bnbProvider.notifications[index]);
                  }
                },
                childCount: _bnbProvider.notifications.length,
              ),
            ),
            if (_bnbProvider.notifications.isEmpty) ...[
              SliverList(
                delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 24.h),
                    child: Column(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 1.sw,
                              height: 94.h,
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 0.4.sw),
                                    child: Text(AppLocalizations.of(context)?.noNotificationsYet ?? "No Notifications Yet"),
                                  )
                                ],
                              ),
                            ),
                            Positioned(
                                top: -12,
                                left: 12,
                                child: SizedBox(height: 90.w, width: 90.w, child: Image.asset(AppIcons.noNotificationBellPNG)))
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Text(
                            AppLocalizations.of(context)?.allNotificationsHere ??
                                "All your notifications will be here: from upcoming appointments to bonuses updates",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                      ],
                    ),
                  );
                }, childCount: 1),
              ),
            ]
          ],
        ),
      ),
    ));
  }
}
