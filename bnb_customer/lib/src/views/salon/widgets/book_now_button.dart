import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BookNowButton extends StatelessWidget {
  const BookNowButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.h,
      width: 1.sw,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Flexible(flex: 1, child: SizedBox()),
          Flexible(
              flex: 1,
              child: Container(
                decoration: const BoxDecoration(
                    color: AppTheme.creamBrown, borderRadius: BorderRadius.only(topLeft: Radius.circular(28))),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)?.bookNow ?? "Book Now",
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
