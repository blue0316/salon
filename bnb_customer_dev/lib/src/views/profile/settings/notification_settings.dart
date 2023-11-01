import 'package:flutter/material.dart';

import '../../../theme/app_main_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({Key? key}) : super(key: key);

  @override
  _NotificationSettingsState createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  bool oneDaybefore = true;
  bool threeDaybefore = true;
  bool oneWeekbefore = true;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          AppLocalizations.of(context)?.notificationSettings ?? "Notification Settings",
          style: Theme.of(context).textTheme.bodyText1,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 80,
              child: Row(
                children: [
                  SizedBox(
                    width: size.width - 100,
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: AppLocalizations.of(context)?.notifyTheAppointment ?? "Notify the appointment ",
                            style: Theme.of(context).textTheme.bodyText2!.copyWith(color: AppTheme.textBlack)),
                        TextSpan(
                            text: AppLocalizations.of(context)?.oneDay ?? "one day ",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(color: AppTheme.textBlack, fontWeight: FontWeight.w600)),
                        TextSpan(
                            text: AppLocalizations.of(context)?.beforeTheDate ?? "before the date:",
                            style: Theme.of(context).textTheme.bodyText2!.copyWith(color: AppTheme.textBlack)),
                      ]),
                    ),
                  ),
                  Opacity(
                    opacity: 0.5,
                    child: SizedBox(
                      width: 51,
                      height: 31,
                      child: Switch.adaptive(
                          value: true,
                          activeColor: AppTheme.creamBrownLight,
                          onChanged: (val) {
                            // setState(() {
                            //   oneDaybefore = val;
                            // });
                          }),
                    ),
                  )
                ],
              ),
            ),
            const Divider(
              color: Colors.white,
              thickness: 1.5,
            ),
            SizedBox(
              height: 80,
              child: Row(
                children: [
                  SizedBox(
                    width: size.width - 100,
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: AppLocalizations.of(context)?.notifyTheAppointment ?? "Notify the appointment ",
                            style: Theme.of(context).textTheme.bodyText2!.copyWith(color: AppTheme.textBlack)),
                        TextSpan(
                            text: AppLocalizations.of(context)?.threeDay ?? "three day ",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(color: AppTheme.textBlack, fontWeight: FontWeight.w600)),
                        TextSpan(
                            text: AppLocalizations.of(context)?.beforeTheDate ?? "before the date:",
                            style: Theme.of(context).textTheme.bodyText2!.copyWith(color: AppTheme.textBlack)),
                      ]),
                    ),
                  ),
                  SizedBox(
                    width: 51,
                    height: 31,
                    child: Switch.adaptive(
                        value: threeDaybefore,
                        activeColor: AppTheme.creamBrownLight,
                        onChanged: (val) {
                          setState(() {
                            threeDaybefore = val;
                          });
                        }),
                  )
                ],
              ),
            ),
            const Divider(
              color: Colors.white,
              thickness: 1.5,
            ),
            SizedBox(
              height: 80,
              child: Row(
                children: [
                  SizedBox(
                    width: size.width - 100,
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: AppLocalizations.of(context)?.notifyTheAppointment ?? "Notify the appointment ",
                            style: Theme.of(context).textTheme.bodyText2!.copyWith(color: AppTheme.textBlack)),
                        TextSpan(
                            text: AppLocalizations.of(context)?.oneWeek ?? "one week ",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(color: AppTheme.textBlack, fontWeight: FontWeight.w600)),
                        TextSpan(
                            text: AppLocalizations.of(context)?.beforeTheDate ?? "before the date:",
                            style: Theme.of(context).textTheme.bodyText2!.copyWith(color: AppTheme.textBlack)),
                      ]),
                    ),
                  ),
                  SizedBox(
                    width: 51,
                    height: 31,
                    child: Switch.adaptive(
                        value: oneWeekbefore,
                        activeColor: AppTheme.creamBrownLight,
                        onChanged: (val) {
                          setState(() {
                            oneWeekbefore = val;
                          });
                        }),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
