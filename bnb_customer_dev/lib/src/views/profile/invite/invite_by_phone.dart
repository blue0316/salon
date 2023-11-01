import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../theme/app_main_theme.dart';
import '../../../utils/icons.dart';
import '../../widgets/buttons.dart';
import 'invite_dilouges.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InviteByPhone extends StatefulWidget {
  const InviteByPhone({Key? key}) : super(key: key);

  @override
  _InviteByPhoneState createState() => _InviteByPhoneState();
}

class _InviteByPhoneState extends State<InviteByPhone> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: SizedBox(
                    height: 15,
                    width: 15,
                    child: SvgPicture.asset(AppIcons.cancelSVG),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 26.h, bottom: 40.h),
              child: Text(
                AppLocalizations.of(context)?.inviteByPhoneNumber ?? "Invite by phone number",
                style: Theme.of(context).textTheme.headline2!.copyWith(
                      fontSize: 21,
                      fontWeight: FontWeight.w400,
                      color: AppTheme.textBlack,
                    ),
              ),
            ),
            //TODO please use phone no textform field from login page..
            // i used it but country code picker was giving error :sid
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: EdgeInsets.all(40.0.w),
              child: BnbMaterialButton(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return const InviteSentDialouge();
                        });
                  },
                  title: AppLocalizations.of(context)?.invite ?? "Invite",
                  minWidth: 320.w),
            )
          ],
        ),
      ),
    );
  }
}
