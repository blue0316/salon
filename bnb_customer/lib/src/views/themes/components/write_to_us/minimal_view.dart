import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/enums/status.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/views/themes/components/widgets/button.dart';
import 'package:bbblient/src/views/themes/images.dart';
import 'package:bbblient/src/views/themes/glam_one/views/profile/widgets/custom_text_form_field.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MinimalWriteToUsView extends ConsumerStatefulWidget {
  final SalonModel salonModel;
  const MinimalWriteToUsView({Key? key, required this.salonModel}) : super(key: key);

  @override
  ConsumerState<MinimalWriteToUsView> createState() => _MinimalWriteToUsViewState();
}

class _MinimalWriteToUsViewState extends ConsumerState<MinimalWriteToUsView> {
  @override
  Widget build(BuildContext context) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    final bool isTab = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.tab);

    void submit() {
      _salonProfileProvider.sendEnquiryToSalon(context, salonId: widget.salonModel.salonId);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isTab)
          Center(
            child: Padding(
              padding: EdgeInsets.only(right: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w)),
              child: Text(
                (AppLocalizations.of(context)?.writeToUsAndWeWillHelpYouDecideOnTheService ?? "Write to us and we will help you decide on the service").toUpperCase(),
                textAlign: TextAlign.center,
                style: theme.textTheme.headline2?.copyWith(
                  color: theme.colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                  fontSize: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 50.sp),
                ),
              ),
            ),
          ),
        if (isTab) const SizedBox(height: 30),
        (!isTab)
            ? Padding(
                padding: EdgeInsets.only(right: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w)),
                child: Column(
                  children: [
                    SizedBox(
                      height: 300.h,
                      width: double.infinity,
                      child: Image.asset(
                        ThemeImages.wideLadyPic,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      (AppLocalizations.of(context)?.writeToUsAndWeWillHelpYouDecideOnTheService ?? "Write to us and we will help you decide on the service").toUpperCase(),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headline2?.copyWith(
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                        fontSize: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 50.sp),
                      ),
                    ),
                    const SizedBox(height: 40),
                    FormColumn(onTap: submit),
                  ],
                ),
              )
            : SizedBox(
                height: MediaQuery.of(context).size.height / 1.7, //  500.h,
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 60.h, 150.h, 0.h),
                        child: FormColumn(onTap: submit),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height / 1.7, // 500.h,
                        // width: MediaQuery.of(context).size.width / 1.8,
                        child: Image.asset(
                          ThemeImages.wideLadyPic, // .writeAboutBG,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ],
    );
  }
}

class FormColumn extends ConsumerWidget {
  final VoidCallback onTap;

  const FormColumn({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    return Column(
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
                ),
              ),
              TextSpan(
                text: " *",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.left,
        ),
        Expanded(
          flex: 0,
          child: CustomTextFormField(
            // width:  (isPortrait) ? 350.w : 100.w,
            focusNode: FocusNode(),
            controller: _salonProfileProvider.nameController,
            hintText: (AppLocalizations.of(context)?.name ?? "Name").toCapitalized(), // "Name",
            margin: const EdgeInsets.only(top: 10),
            contentPadding: 20,
          ),
        ),
        const SizedBox(height: 10),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: (AppLocalizations.of(context)?.phone ?? "Phone").toCapitalized(), // "Phone",
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onSecondaryContainer,
                  fontSize: 17.sp,
                ),
              ),
              TextSpan(
                text: " *",
                style: theme.textTheme.bodyMedium!.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.left,
        ),
        Expanded(
          flex: 0,
          child: CustomTextFormField(
            // width: (isPortrait) ? 350.w : 100.w,
            focusNode: FocusNode(),
            controller: _salonProfileProvider.phoneController,
            hintText: (AppLocalizations.of(context)?.phone ?? "Phone").toCapitalized(), // "Phone",
            contentPadding: 20,
            margin: const EdgeInsets.only(top: 10),
          ),
        ),
        const SizedBox(height: 10),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: AppLocalizations.of(context)?.email ?? "Email".toCapitalized(), // "Email",
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onSecondaryContainer,
                  fontSize: 17.sp,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.left,
        ),
        Expanded(
          flex: 0,
          child: CustomTextFormField(
            // width: (isPortrait) ? 350.w : 100.w,
            focusNode: FocusNode(),
            controller: _salonProfileProvider.requestController,
            hintText: (AppLocalizations.of(context)?.email ?? "Email").toCapitalized(), // "Email",
            contentPadding: 20,
            margin: const EdgeInsets.only(top: 10),
          ),
        ),
        const SizedBox(height: 10),
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
              : SquareButton(
                  height: 50,
                  text: (AppLocalizations.of(context)?.submitEnquiry ?? "Submit an Enquiry").toUpperCase(),
                  onTap: onTap,
                  buttonColor: theme.primaryColorDark,
                  borderColor: theme.primaryColorDark,
                  textColor: theme.cardColor,
                  borderRadius: 0,
                  showSuffix: false,
                ),
        ),
      ],
    );
  }
}
