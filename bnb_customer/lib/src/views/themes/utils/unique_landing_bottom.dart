// ignore_for_file: avoid_web_libraries_in_flutter

import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:js' as js;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UniquePortraitLandingBottom extends ConsumerWidget {
  const UniquePortraitLandingBottom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 1.5.sp,
          decoration: const BoxDecoration(
            color: Colors.white,
            gradient: LinearGradient(
              colors: [Color.fromARGB(43, 74, 74, 74), Color(0XFF4A4A4A), Color.fromARGB(43, 74, 74, 74)],
            ),
          ),
        ),
        SizedBox(height: 18.sp),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: DeviceConstraints.getResponsiveSize(context, 20.sp, 30.sp, 20.sp),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)?.termsAndConditions ?? 'Terms & Conditions',
                style: theme.textTheme.titleSmall!.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0XFF585858),
                ),
                textAlign: TextAlign.center,
              ),
              // const Spacer(),
              Text(
                AppLocalizations.of(context)?.privacyAndPolicy ?? 'Privacy Policy',
                style: theme.textTheme.titleSmall!.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0XFF585858),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        SizedBox(height: 12.sp),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: DeviceConstraints.getResponsiveSize(context, 10.w, 30.w, 60.w),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)?.poweredBy ?? 'Powered by ',
                style: theme.textTheme.titleSmall!.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0XFF908D8D),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(width: 2.sp),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    js.context.callMethod('open', ['https://www.glamiris.com/']);
                  },
                  child: Text(
                    'Glamiris',
                    style: theme.textTheme.titleSmall!.copyWith(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.secondary,
                      decoration: TextDecoration.underline,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20.sp),
      ],
    );
  }
}

class UniqueLandscapeLandingBottom extends ConsumerWidget {
  const UniqueLandscapeLandingBottom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: DeviceConstraints.getResponsiveSize(context, 70.sp, 30.sp, 70.sp),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 1.5.sp,
            decoration: const BoxDecoration(
              color: Colors.white,
              gradient: LinearGradient(
                colors: [Color.fromARGB(43, 74, 74, 74), Color(0XFF4A4A4A), Color.fromARGB(43, 74, 74, 74)],
              ),
            ),
          ),
          SizedBox(height: 18.sp),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context)?.termsAndConditions ?? 'Terms & Conditions',
                    style: theme.textTheme.titleSmall!.copyWith(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0XFF908D8D),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(width: 40.sp),
                  Text(
                    AppLocalizations.of(context)?.privacyAndPolicy ?? 'Privacy Policy',
                    style: theme.textTheme.titleSmall!.copyWith(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0XFF908D8D),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)?.poweredBy ?? 'Powered by ',
                    style: theme.textTheme.titleSmall!.copyWith(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0XFF908D8D),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(width: 2.sp),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        js.context.callMethod('open', ['https://www.glamiris.com/']);
                      },
                      child: Text(
                        'Glamiris',
                        style: theme.textTheme.titleSmall!.copyWith(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.secondary,
                          decoration: TextDecoration.underline,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
