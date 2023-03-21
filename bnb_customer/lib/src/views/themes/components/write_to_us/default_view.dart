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
import 'package:bbblient/src/views/themes/glam_one/views/profile/widgets/custom_text_form_field.dart';
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
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        (themeType == ThemeType.GlamLight && isTab)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    (AppLocalizations.of(context)?.weWillHelpYou ?? "We will help you").toUpperCase(),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headline2?.copyWith(
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.w600,
                      fontSize: DeviceConstraints.getResponsiveSize(context, 30.sp, 45.sp, 60.sp),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.only(left: 80.w),
                    child: Text(
                      (AppLocalizations.of(context)?.decideOnTheService ?? "decide on the service").toUpperCase(),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headline2?.copyWith(
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                        fontSize: DeviceConstraints.getResponsiveSize(context, 30.sp, 45.sp, 60.sp),
                      ),
                    ),
                  ),
                ],
              )
            : Center(
                child: Text(
                  ('Not sure? Ask Us').toUpperCase(),
                  // (AppLocalizations.of(
                  //           context,
                  //         )?.writeToUsAndWeWillHelpYouDecideOnTheService ??
                  //         "Write to us and we will help you decide on the service")
                  //     .toUpperCase(),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headline2?.copyWith(
                    color: theme.colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                    fontSize: DeviceConstraints.getResponsiveSize(context, 30.sp, 45.sp, 50.sp),
                  ),
                ),
              ),
        const SizedBox(height: 60),
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
                padding: EdgeInsets.symmetric(horizontal: (!isPortrait && !isLandScape) ? 20.w : 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: (AppLocalizations.of(context)?.name ?? "Name").toCapitalized(), // "Name",
                                style: theme.textTheme.subtitle2?.copyWith(
                                  color: theme.colorScheme.onSecondaryContainer,
                                  fontSize: 15.sp,
                                ),
                              ),
                              TextSpan(
                                text: " *",
                                style: theme.textTheme.bodyText2?.copyWith(
                                  color: theme.primaryColor,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.left,
                        ),
                        CustomTextFormField(
                          // width:  (isPortrait) ? 350.w : 100.w,
                          focusNode: FocusNode(),
                          controller: _salonProfileProvider.nameController,
                          hintText: (AppLocalizations.of(context)?.name ?? "Name").toCapitalized(), // "Name",
                          margin: const EdgeInsets.only(top: 10),
                          contentPadding: 20,
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: (AppLocalizations.of(context)?.phone ?? "Phone").toCapitalized(), // "Phone",
                                style: theme.textTheme.subtitle2?.copyWith(
                                  color: theme.colorScheme.onSecondaryContainer,
                                  fontSize: 15.sp,
                                ),
                              ),
                              TextSpan(
                                text: " *",
                                style: theme.textTheme.bodyText2!.copyWith(
                                  color: theme.primaryColor,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.left,
                        ),
                        CustomTextFormField(
                          // width: (isPortrait) ? 350.w : 100.w,
                          focusNode: FocusNode(),
                          controller: _salonProfileProvider.phoneController,
                          hintText: (AppLocalizations.of(context)?.phone ?? "Phone").toCapitalized(), // "Phone",
                          contentPadding: 20,
                          margin: const EdgeInsets.only(top: 10),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: AppLocalizations.of(context)?.request ?? "Request".toCapitalized(), // "Email",
                                style: theme.textTheme.subtitle2?.copyWith(
                                  color: theme.colorScheme.onSecondaryContainer,
                                  fontSize: 15.sp,
                                ),
                              ),
                              TextSpan(
                                text: " *",
                                style: theme.textTheme.bodyText2?.copyWith(
                                  color: theme.primaryColor,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.left,
                        ),
                        CustomTextFormField(
                          // width: (isPortrait) ? 350.w : 100.w,
                          focusNode: FocusNode(),
                          controller: _salonProfileProvider.requestController,
                          hintText: (AppLocalizations.of(context)?.request ?? "Request").toCapitalized(), // "Email",
                          contentPadding: 20,
                          margin: const EdgeInsets.only(top: 10),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
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
                                  height: 50,
                                  // width: (isPortrait) ? 350.w : null, // DeviceConstraints.getResponsiveSize(context, 0, 120.w, 70.w),
                                  text: (themeType == ThemeType.GlamBarbershop || themeType == ThemeType.Barbershop) ? (AppLocalizations.of(context)?.submitEnquiry ?? "Submit an Enquiry").toUpperCase() : AppLocalizations.of(context)?.submitEnquiry ?? "Submit an Enquiry",
                                  onTap: () => _salonProfileProvider.sendEnquiryToSalon(context, salonId: widget.salonModel.salonId),
                                  buttonColor: theme.primaryColorDark,
                                  borderColor: theme.primaryColorDark,
                                  borderRadius: (themeType == ThemeType.GlamBarbershop || themeType == ThemeType.Barbershop) ? 0 : 25,
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
