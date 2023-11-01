import 'package:flutter/material.dart';

import '../../theme/app_main_theme.dart';
import '../home_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationPermission extends StatefulWidget {
  const NotificationPermission({Key? key}) : super(key: key);

  @override
  _NotificationPermissionState createState() => _NotificationPermissionState();
}

class _NotificationPermissionState extends State<NotificationPermission> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              height: 320,
              width: 290,
              child: Image.asset(
                'assets/images/notifications.png',
                fit: BoxFit.cover,
              )),
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Text(
              AppLocalizations.of(context)?.getNotified ?? "Get notified",
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 72.0, vertical: 24),
            child: Text(
              AppLocalizations.of(context)?.turnOnNotifs ?? "turn on notifications to receive notifications about your bookings and activity",
              style: Theme.of(context).textTheme.headline4!.copyWith(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: MaterialButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: AppTheme.creamBrown,
              minWidth: 240,
              height: 60,
              child: Text(
                AppLocalizations.of(context)?.allow ?? "Allow",
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
          ),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context)?.notNow ?? "Not Now"))
        ],
      ),
    );
  }
}
