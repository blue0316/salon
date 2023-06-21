import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/enums/status.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'dart:math' as math;
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/views/themes/components/widgets/button.dart';
import 'package:bbblient/src/views/themes/components/widgets/oval_button.dart';
import 'package:bbblient/src/views/themes/images.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DefaultWriteToUsView extends ConsumerStatefulWidget {
  final SalonModel salonModel;
  const DefaultWriteToUsView({Key? key, required this.salonModel}) : super(key: key);

  @override
  ConsumerState<DefaultWriteToUsView> createState() => _DefaultWriteToUsViewState();
}

class _DefaultWriteToUsViewState extends ConsumerState<DefaultWriteToUsView> {
  @override
  Widget build(BuildContext context) {
    final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.portrait);
    final bool isLandScape = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.landScape);
    final bool isTab = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.tab);

    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    ThemeType themeType = _salonProfileProvider.themeType;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // (themeType == ThemeType.GlamLight && isTab)
        // ?
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'write to us and ${(AppLocalizations.of(context)?.weWillHelpYou ?? "We will help you")} ${AppLocalizations.of(context)?.decideOnTheService ?? "decide on the service"}'.toUpperCase(),
              textAlign: TextAlign.center,
              style: theme.textTheme.displayMedium?.copyWith(
                color: theme.colorScheme.secondary,
                fontWeight: FontWeight.w500,
                fontSize: DeviceConstraints.getResponsiveSize(context, 30.sp, 35.sp, 55.sp),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(left: 0), // 80.w),
            //   child: Text(
            //     (AppLocalizations.of(context)?.decideOnTheService ?? "decide on the service").toUpperCase(),
            //     textAlign: TextAlign.center,
            //     style: theme.textTheme.displayMedium?.copyWith(
            //       color: theme.colorScheme.secondary,
            //       fontWeight: FontWeight.w500,
            //       fontSize: DeviceConstraints.getResponsiveSize(context, 30.sp, 35.sp, 55.sp),
            //     ),
            //   ),
            // ),
          ],
        ),

        // : Center(
        //     child: Text(
        //       ('Not sure? Ask Us').toUpperCase(),
        //       // (AppLocalizations.of(
        //       //           context,
        //       //         )?.writeToUsAndWeWillHelpYouDecideOnTheService ??
        //       //         "Write to us and we will help you decide on the service")
        //       //     .toUpperCase(),
        //       textAlign: TextAlign.center,
        //       style: theme.textTheme.displayMedium?.copyWith(
        //         color: theme.colorScheme.secondary,
        //         fontWeight: FontWeight.w500,
        //     fontSize: DeviceConstraints.getResponsiveSize(context, 40.sp, 45.sp, 65.sp),
        //       ),
        //     ),
        //   ),
        SizedBox(height: 60.sp),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (!isPortrait && !isLandScape)
              Transform.rotate(
                angle: math.pi / 1.03, // 3.5,
                child: SizedBox(
                  height: 400.h,
                  width: DeviceConstraints.getResponsiveSize(context, 0, 100.w, 80.w),
                  child: themeType != ThemeType.Barbershop
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: (widget.salonModel.photosOfWork.isNotEmpty && widget.salonModel.photosOfWork[0] != '')
                              ? CachedImage(
                                  url: widget.salonModel.photosOfWork[0],
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  ThemeImages.write1,
                                  fit: BoxFit.cover,
                                ),
                        )
                      : const SizedBox(),
                ),
              ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: (!isPortrait && !isLandScape) ? 20.w : 10.sp),
                child: Column(
                  children: [
                    SizedBox(
                      // color: Colors.green,
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: (AppLocalizations.of(context)?.name ?? "Name").toCapitalized(), // "Name",
                                        style: theme.textTheme.titleSmall?.copyWith(
                                          color: theme.colorScheme.onSecondaryContainer,
                                          fontSize: 17.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      TextSpan(
                                        text: " *",
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          color: theme.primaryColorDark,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 4.sp),
                                Container(
                                  height: 50.sp,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: (themeType == ThemeType.GlamBarbershop || themeType == ThemeType.Barbershop) ? Colors.white : Colors.black,
                                      width: 1,
                                    ),
                                    borderRadius: (themeType == ThemeType.GlamBarbershop || themeType == ThemeType.Barbershop) ? null : BorderRadius.circular(50.sp),
                                  ),
                                  child: Center(
                                    child: TextFormField(
                                      controller: _salonProfileProvider.nameController,
                                      decoration: InputDecoration(
                                        hintText: (AppLocalizations.of(context)?.name ?? "Name").toCapitalized(), // "Name",
                                        hintStyle: TextStyle(
                                          color: (themeType == ThemeType.GlamBarbershop || themeType == ThemeType.Barbershop) ? const Color(0XFF787878) : const Color(0XFF333333),
                                          fontWeight: FontWeight.w400,
                                        ),
                                        contentPadding: EdgeInsets.only(left: 30.sp, right: 30.sp, bottom: 10.sp),
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // const SizedBox(height: 15),
                          Expanded(
                            flex: 0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: (AppLocalizations.of(context)?.phone ?? "Phone").toCapitalized(), // "Phone",
                                        style: theme.textTheme.titleSmall?.copyWith(
                                          color: theme.colorScheme.onSecondaryContainer,
                                          fontSize: 17.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      TextSpan(
                                        text: " *",
                                        style: theme.textTheme.titleSmall!.copyWith(
                                          color: theme.primaryColorDark,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 4.sp),
                                Container(
                                  height: 50.sp,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: (themeType == ThemeType.GlamBarbershop || themeType == ThemeType.Barbershop) ? Colors.white : Colors.black,
                                      width: 1,
                                    ),
                                    borderRadius: (themeType == ThemeType.GlamBarbershop || themeType == ThemeType.Barbershop) ? null : BorderRadius.circular(50.sp),
                                  ),
                                  child: Center(
                                    child: TextFormField(
                                      controller: _salonProfileProvider.phoneController,
                                      decoration: InputDecoration(
                                        hintText: (AppLocalizations.of(context)?.phone ?? "Phone").toCapitalized(), // "Phone",
                                        hintStyle: TextStyle(
                                          color: (themeType == ThemeType.GlamBarbershop || themeType == ThemeType.Barbershop) ? const Color(0XFF787878) : const Color(0XFF333333),
                                          fontWeight: FontWeight.w400,
                                        ),
                                        contentPadding: EdgeInsets.only(left: 30.sp, right: 30.sp, bottom: 10.sp),
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // const SizedBox(height: 15),
                          Expanded(
                            flex: 0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: AppLocalizations.of(context)?.request ?? "Request".toCapitalized(), // "Email",
                                        style: theme.textTheme.titleSmall?.copyWith(
                                          color: theme.colorScheme.onSecondaryContainer,
                                          fontSize: 17.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      TextSpan(
                                        text: " *",
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          color: theme.primaryColorDark,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 4.sp),
                                Container(
                                  height: 50.sp,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: (themeType == ThemeType.GlamBarbershop || themeType == ThemeType.Barbershop) ? Colors.white : Colors.black,
                                      width: 1,
                                    ),
                                    borderRadius: (themeType == ThemeType.GlamBarbershop || themeType == ThemeType.Barbershop) ? null : BorderRadius.circular(50.sp),
                                  ),
                                  child: Center(
                                    child: TextFormField(
                                      controller: _salonProfileProvider.requestController,
                                      decoration: InputDecoration(
                                        hintText: (AppLocalizations.of(context)?.request ?? "Request").toCapitalized(), // "Email",
                                        hintStyle: TextStyle(
                                          color: (themeType == ThemeType.GlamBarbershop || themeType == ThemeType.Barbershop) ? const Color(0XFF787878) : const Color(0XFF333333),
                                          fontWeight: FontWeight.w400,
                                        ),
                                        contentPadding: EdgeInsets.only(left: 30.sp, right: 30.sp, bottom: 10.sp),
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.sp),
                    Align(
                      alignment: Alignment.center,
                      child: _salonProfileProvider.enquiryStatus == Status.loading
                          ? Center(
                              child: SizedBox(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(color: theme.primaryColorDark),
                              ),
                            )
                          : themeType == ThemeType.GlamLight
                              ? OvalButton(
                                  text: 'Submit',
                                  onTap: () => _salonProfileProvider.sendEnquiryToSalon(
                                    context,
                                    salonId: widget.salonModel.salonId,
                                  ),
                                )
                              : SquareButton(
                                  height: 50.sp,
                                  // width: (isPortrait) ? 350.w : null, // DeviceConstraints.getResponsiveSize(context, 0, 120.w, 70.w),
                                  text: (themeType == ThemeType.GlamBarbershop || themeType == ThemeType.Barbershop) ? (AppLocalizations.of(context)?.submitEnquiry ?? "Submit an Enquiry").toUpperCase() : AppLocalizations.of(context)?.submitEnquiry ?? "Submit an Enquiry",
                                  onTap: () => _salonProfileProvider.sendEnquiryToSalon(context, salonId: widget.salonModel.salonId),
                                  buttonColor: theme.primaryColorDark,
                                  borderColor: theme.primaryColorDark,
                                  borderRadius: (themeType == ThemeType.GlamBarbershop || themeType == ThemeType.Barbershop) ? 0 : 25,
                                  textColor: (themeType == ThemeType.GlamBarbershop || themeType == ThemeType.Barbershop) ? Colors.black : Colors.white,
                                  showSuffix: (themeType == ThemeType.GlamBarbershop || themeType == ThemeType.Barbershop) ? true : false,
                                  weight: FontWeight.normal,
                                ),
                    ),
                  ],
                ),
              ),
            ),
            if (!isPortrait && !isLandScape)
              Transform.rotate(
                angle: -math.pi / 1.03,
                child: SizedBox(
                  height: 400.h,
                  width: DeviceConstraints.getResponsiveSize(context, 0, 100.w, 80.w),
                  child: themeType != ThemeType.Barbershop
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: (widget.salonModel.photosOfWork.isNotEmpty && widget.salonModel.photosOfWork.length > 1 && widget.salonModel.photosOfWork[1] != '')
                              ? CachedImage(
                                  url: widget.salonModel.photosOfWork[1],
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  ThemeImages.write2,
                                  fit: BoxFit.cover,
                                ),
                        )
                      : const SizedBox(),
                ),
              ),
          ],
        ),

        // Section Divider
        if (themeType == ThemeType.GlamLight)
          Space(
            factor: DeviceConstraints.getResponsiveSize(context, 3, 4, 6),
          ),

        if (themeType == ThemeType.GlamLight)
          const Divider(
            color: Colors.black,
            thickness: 1,
          ),
      ],
    );
  }
}
