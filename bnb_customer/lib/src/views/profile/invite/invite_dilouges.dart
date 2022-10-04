import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/icons.dart';
import '../../calendar/calender_dialogues.dart';
import '../../widgets/buttons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InviteSentDialouge extends StatelessWidget {
  const InviteSentDialouge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        height: 500.h,
        width: 340.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CancelButtonTopRight(),
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 36.h),
              child: SizedBox(
                height: 140.h,
                width: 184.w,
                child: Image.asset(AppIcons.inviteSentPNG),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                AppLocalizations.of(context)?.inviteSent ?? "Your invite has been sent successfully",
                style: Theme.of(context).textTheme.subtitle1,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 44),
              child: BnbMaterialButton(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return const InviteCanceledDialouge();
                        });
                  },
                  title: AppLocalizations.of(context)?.great ?? "Great",
                  minWidth: 240.w),
            )
          ],
        ),
      ),
    );
  }
}

class InviteCanceledDialouge extends StatelessWidget {
  const InviteCanceledDialouge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        height: 500.h,
        width: 340.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CancelButtonTopRight(),
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 36.h),
              child: SizedBox(
                height: 140.h,
                width: 184.w,
                child: Image.asset(AppIcons.userFoundAlreadyPNG),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                AppLocalizations.of(context)?.ooopsPersonInSystemAlready ??
                    "Ooops, we have that person in the system already",
                style: Theme.of(context).textTheme.subtitle1,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 44),
              child:
                  BnbMaterialButton(onTap: () {}, title: AppLocalizations.of(context)?.okey ?? "Okey", minWidth: 240.w),
            )
          ],
        ),
      ),
    );
  }
}
