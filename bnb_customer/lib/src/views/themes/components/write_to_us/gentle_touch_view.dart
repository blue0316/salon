import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/enums/status.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/views/themes/components/widgets/button.dart';
import 'package:bbblient/src/views/themes/components/widgets/multiple_states_button.dart';
import 'package:bbblient/src/views/themes/images.dart';
import 'package:bbblient/src/views/themes/glam_one/views/profile/widgets/custom_text_form_field.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GentleTouchWriteToUsView extends ConsumerStatefulWidget {
  final SalonModel salonModel;
  const GentleTouchWriteToUsView({Key? key, required this.salonModel}) : super(key: key);

  @override
  ConsumerState<GentleTouchWriteToUsView> createState() => _GentleTouchWriteToUsViewState();
}

class _GentleTouchWriteToUsViewState extends ConsumerState<GentleTouchWriteToUsView> {
  @override
  Widget build(BuildContext context) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.portrait);
    final bool isTabDevice = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.landScape);
    ThemeType themeType = _salonProfileProvider.themeType;

    void submit() {
      _salonProfileProvider.sendEnquiryToSalon(context, salonId: widget.salonModel.salonId);
    }

    return isPortrait || isTabDevice
        ? PortraitView(salonModel: widget.salonModel)
        : SizedBox(
            height: 650.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 50.sp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          themeType != ThemeType.VintageCraft ? (AppLocalizations.of(context)?.writeToUsTitle ?? 'write to us').toUpperCase() : (AppLocalizations.of(context)?.writeToUsTitle ?? 'write to us').toTitleCase(),
                          textAlign: TextAlign.center,
                          style: theme.textTheme.displayMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: DeviceConstraints.getResponsiveSize(context, 20.sp, 30.sp, 50.sp),
                          ),
                        ),
                        SizedBox(height: 5.sp),
                        Text(
                          AppLocalizations.of(context)?.writeToUsTitleDesc ?? 'Write to us and we will get back to you as soon as possible',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        SizedBox(height: 30.sp),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 80.h,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      (AppLocalizations.of(context)?.firstName ?? "First name").toTitleCase(),
                                      style: theme.textTheme.bodyLarge?.copyWith(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                        // fontFamily: 'Inter-Light',
                                      ),
                                    ),
                                    SizedBox(height: 8.sp),
                                    Expanded(
                                      flex: 0,
                                      child: Container(
                                        color: themeType == ThemeType.GentleTouch ? const Color(0xFFF0E8DB) : const Color(0XFF1D1E20),
                                        child: CustomTextFormField(
                                          focusNode: FocusNode(),
                                          controller: _salonProfileProvider.nameController,
                                          contentPadding: 15.sp,

                                          hintText: (AppLocalizations.of(context)?.firstName ?? "First name").toTitleCase(),
                                          // margin: const EdgeInsets.only(top: 10),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 30.sp),
                            Expanded(
                              child: SizedBox(
                                height: 80.h,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      (AppLocalizations.of(context)?.lastName ?? "Last name").toTitleCase(),
                                      style: theme.textTheme.bodyLarge?.copyWith(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                        // fontFamily: 'Inter-Light',
                                      ),
                                    ),
                                    SizedBox(height: 8.sp),
                                    Expanded(
                                      flex: 0,
                                      child: Container(
                                        color: themeType == ThemeType.GentleTouch ? const Color(0xFFF0E8DB) : const Color(0XFF1D1E20),
                                        child: CustomTextFormField(
                                          focusNode: FocusNode(),
                                          controller: _salonProfileProvider.lastNameController,
                                          contentPadding: 15.sp,
                                          hintText: (AppLocalizations.of(context)?.lastName ?? "Last name").toTitleCase(),
                                          // margin: const EdgeInsets.only(top: 10),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.sp),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 80.h,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      (AppLocalizations.of(context)?.email ?? "email").toTitleCase(),
                                      style: theme.textTheme.bodyLarge?.copyWith(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                        // fontFamily: 'Inter-Light',
                                      ),
                                    ),
                                    SizedBox(height: 8.sp),
                                    Expanded(
                                      flex: 0,
                                      child: Container(
                                        color: themeType == ThemeType.GentleTouch ? const Color(0xFFF0E8DB) : const Color(0XFF1D1E20),
                                        child: CustomTextFormField(
                                          focusNode: FocusNode(),
                                          controller: _salonProfileProvider.emailController,
                                          contentPadding: 15.sp,
                                          hintText: (AppLocalizations.of(context)?.email ?? "email").toTitleCase(),

                                          // margin: const EdgeInsets.only(top: 10),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 30.sp),
                            Expanded(
                              child: SizedBox(
                                height: 80.h,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      (AppLocalizations.of(context)?.phone ?? "phone").toTitleCase(),
                                      style: theme.textTheme.bodyLarge?.copyWith(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                        // fontFamily: 'Inter-Light',
                                      ),
                                    ),
                                    SizedBox(height: 8.sp),
                                    Expanded(
                                      flex: 0,
                                      child: Container(
                                        color: themeType == ThemeType.GentleTouch ? const Color(0xFFF0E8DB) : const Color(0XFF1D1E20),
                                        child: CustomTextFormField(
                                          focusNode: FocusNode(),
                                          controller: _salonProfileProvider.phoneController,
                                          contentPadding: 15.sp,
                                          hintText: (AppLocalizations.of(context)?.phone ?? "phone").toTitleCase(),
                                          // margin: const EdgeInsets.only(top: 10),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.sp),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              (AppLocalizations.of(context)?.message ?? 'Message').toTitleCase(),
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                // fontFamily: 'Inter-Light',
                              ),
                            ),
                            SizedBox(height: 8.sp),
                            Expanded(
                              flex: 0,
                              child: Container(
                                color: themeType == ThemeType.GentleTouch ? const Color(0xFFF0E8DB) : const Color(0XFF1D1E20),
                                child: CustomTextFormField(
                                  focusNode: FocusNode(),
                                  controller: _salonProfileProvider.requestController,
                                  contentPadding: 15.sp,
                                  hintText: (AppLocalizations.of(context)?.writeToUsTitle ?? 'Write to us').toCapitalized(),
                                  maxLines: 4,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.sp),
                        const Spacer(),
                        _salonProfileProvider.enquiryStatus == Status.loading
                            ? Center(
                                child: SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: CircularProgressIndicator(color: theme.colorScheme.secondary),
                                ),
                              )
                            : SquareButton(
                                height: 50,
                                text: (AppLocalizations.of(context)?.sendMessage ?? "Send Message").toTitleCase(),
                                onTap: () => submit(),
                                buttonColor: theme.colorScheme.secondary,
                                borderColor: theme.colorScheme.secondary,
                                textColor: (themeType == ThemeType.GentleTouch || themeType == ThemeType.VintageCraft) ? const Color(0XFFFFFFFF) : Colors.black,
                                weight: FontWeight.w500,
                                borderRadius: 2,
                                showSuffix: false,
                              ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 150.sp),
                Expanded(
                  child: SizedBox(
                    height: 650.h,
                    child: (_salonProfileProvider.themeSettings?.backgroundImage != null && _salonProfileProvider.themeSettings?.backgroundImage != '')
                        ? CachedImage(
                            url: _salonProfileProvider.themeSettings!.backgroundImage!,
                            fit: BoxFit.cover,
                            color: themeType == ThemeType.VintageCraft ? Colors.grey[850] : null,
                            colorBlendMode: themeType == ThemeType.VintageCraft ? BlendMode.saturation : null,
                          )
                        : Image.asset(
                            themeType == ThemeType.VintageCraft
                                ? ThemeImages.vintageWriteToUs
                                : themeType == ThemeType.GentleTouch
                                    ? ThemeImages.glamLightNaturalHue
                                    : ThemeImages.darkGentleTouch, // gentleTouchWrite,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ],
            ),
          );
  }
}

class PortraitView extends ConsumerStatefulWidget {
  final SalonModel salonModel;
  const PortraitView({Key? key, required this.salonModel}) : super(key: key);

  @override
  ConsumerState<PortraitView> createState() => _PortraitViewState();
}

class _PortraitViewState extends ConsumerState<PortraitView> {
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    ThemeType themeType = _salonProfileProvider.themeType;

    void submit() {
      _salonProfileProvider.sendEnquiryToSalon(context, salonId: widget.salonModel.salonId);
    }

    return Padding(
      padding: EdgeInsets.only(
        right: DeviceConstraints.getResponsiveSize(context, 10.w, 10.w, 30.w),
      ),
      child: Column(
        crossAxisAlignment: themeType != ThemeType.VintageCraft ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            themeType != ThemeType.VintageCraft ? (AppLocalizations.of(context)?.writeToUsTitle ?? 'write to us').toUpperCase() : (AppLocalizations.of(context)?.writeToUsTitle ?? 'write to us').toTitleCase(),
            textAlign: TextAlign.center,
            style: theme.textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 50.sp,
            ),
          ),
          SizedBox(height: 5.sp),
          Text(
            AppLocalizations.of(context)?.writeToUsTitleDesc ?? 'Write to us and we will get back to you as soon as possible',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontSize: 18.sp,
              fontWeight: FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30.sp),
          SizedBox(
            height: 80.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  (AppLocalizations.of(context)?.firstName ?? "First name").toTitleCase(),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    // fontFamily: 'Inter',
                  ),
                ),
                SizedBox(height: 8.sp),
                Expanded(
                  flex: 0,
                  child: Container(
                    color: themeType == ThemeType.GentleTouch ? const Color(0xFFF0E8DB) : const Color(0XFF1D1E20),
                    child: CustomTextFormField(
                      focusNode: _focusNode,
                      controller: _salonProfileProvider.nameController,
                      contentPadding: 15.sp,
                      hintText: (AppLocalizations.of(context)?.firstName ?? "First name").toTitleCase(),

                      // margin: const EdgeInsets.only(top: 10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.sp),
          SizedBox(
            height: 80.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  (AppLocalizations.of(context)?.lastName ?? "Last name").toTitleCase(),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    // fontFamily: 'Inter',
                  ),
                ),
                SizedBox(height: 8.sp),
                Expanded(
                  flex: 0,
                  child: Container(
                    color: themeType == ThemeType.GentleTouch ? const Color(0xFFF0E8DB) : const Color(0XFF1D1E20),
                    child: CustomTextFormField(
                      focusNode: FocusNode(),
                      controller: _salonProfileProvider.lastNameController,
                      contentPadding: 15.sp,
                      hintText: (AppLocalizations.of(context)?.lastName ?? "Last name").toTitleCase(),
                      // margin: const EdgeInsets.only(top: 10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.sp),
          SizedBox(
            height: 80.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  (AppLocalizations.of(context)?.email ?? "email").toTitleCase(),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    // fontFamily: 'Inter',
                  ),
                ),
                SizedBox(height: 8.sp),
                Expanded(
                  flex: 0,
                  child: Container(
                    color: themeType == ThemeType.GentleTouch ? const Color(0xFFF0E8DB) : const Color(0XFF1D1E20),
                    child: CustomTextFormField(
                      focusNode: FocusNode(),
                      controller: _salonProfileProvider.emailController,
                      contentPadding: 15.sp,
                      hintText: (AppLocalizations.of(context)?.email ?? "email").toTitleCase(),

                      // margin: const EdgeInsets.only(top: 10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.sp),
          SizedBox(
            height: 80.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  (AppLocalizations.of(context)?.phone ?? "phone").toTitleCase(),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    // fontFamily: 'Inter',
                  ),
                ),
                SizedBox(height: 8.sp),
                Expanded(
                  flex: 0,
                  child: Container(
                    color: themeType == ThemeType.GentleTouch ? const Color(0xFFF0E8DB) : const Color(0XFF1D1E20),
                    child: CustomTextFormField(
                      focusNode: FocusNode(),
                      controller: _salonProfileProvider.phoneController,
                      contentPadding: 15.sp,
                      hintText: (AppLocalizations.of(context)?.phone ?? "phone").toTitleCase(),
                      // margin: const EdgeInsets.only(top: 10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.sp),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                (AppLocalizations.of(context)?.message ?? 'Message').toTitleCase(),
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8.sp),
              Expanded(
                flex: 0,
                child: Container(
                  color: themeType == ThemeType.GentleTouch ? const Color(0xFFF0E8DB) : const Color(0XFF1D1E20),
                  child: CustomTextFormField(
                    focusNode: FocusNode(),
                    controller: _salonProfileProvider.requestController,
                    contentPadding: 15.sp,
                    hintText: (AppLocalizations.of(context)?.writeToUsTitle ?? 'Write to us').toCapitalized(),
                    maxLines: 4,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 30.sp),
          _salonProfileProvider.enquiryStatus == Status.loading
              ? Center(
                  child: SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(color: theme.colorScheme.secondary),
                  ),
                )
              : Center(
                  child: MultipleStatesButton(
                    height: 50,
                    width: themeType == ThemeType.VintageCraft ? double.infinity : null,
                    text: (AppLocalizations.of(context)?.sendMessage ?? "Send Message").toTitleCase(),
                    onTap: () => submit(),
                    buttonColor: theme.colorScheme.secondary,
                    borderColor: theme.colorScheme.secondary,
                    textColor: (themeType == ThemeType.GentleTouch || themeType == ThemeType.VintageCraft) ? const Color(0XFFFFFFFF) : Colors.black,
                    weight: FontWeight.w500,
                    borderRadius: 2,
                    showSuffix: false,
                    isGradient: _salonProfileProvider.hasThemeGradient,
                  ),
                ),
        ],
      ),
    );
  }
}
