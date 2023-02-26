import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/views/home_page.dart';
import 'package:bbblient/src/views/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BookingRes extends StatelessWidget {
  final bool? isSuccess;
  const BookingRes({Key? key, this.isSuccess}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isSuccess!) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Image.asset(
                      AppIcons.done1GIF,
                      height: 180,
                      width: 180,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      "${AppLocalizations.of(context)?.appointment ?? 'booking'} ${AppLocalizations.of(context)?.done ?? 'done'}",
                      style: AppTheme.bodyText1,
                    )
                  ],
                ),
              ],
            )
          ],
          if (!isSuccess!) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Image.asset(
                      AppIcons.failGIF,
                      height: 180,
                      width: 180,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      AppLocalizations.of(context)?.errorOccurred ?? 'Network Error !!!',
                      style: AppTheme.bodyText1,
                    )
                  ],
                ),
              ],
            )
          ],
          const SizedBox(
            height: 200,
          ),
          BnbMaterialButton(
            onTap: () {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomePage()), (route) => false);
            },
            title: AppLocalizations.of(context)?.okey ?? "Okey",
            minWidth: 230,
          )
        ],
      ),
    );
  }
}
