import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/enums/status.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';

import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/views/themes/components/widgets.dart/button.dart';
import 'package:bbblient/src/views/themes/images.dart';
import 'package:bbblient/src/views/themes/glam_one/views/profile/widgets/custom_text_form_field.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WriteToUs extends ConsumerStatefulWidget {
  final SalonModel salonModel;

  const WriteToUs({Key? key, required this.salonModel}) : super(key: key);

  @override
  ConsumerState<WriteToUs> createState() => _WriteToUsState();
}

class _WriteToUsState extends ConsumerState<WriteToUs> {
  @override
  Widget build(BuildContext context) {
    final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.portrait);
    final bool isLandScape = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.landScape);

    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    final String? themeNo = _salonProfileProvider.theme;

    return Form(
      key: _salonProfileProvider.formKey,
      child: Container(
        width: double.infinity,
        color: theme.cardColor,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w),
            vertical: 100,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                // "Write to us and we will help you decide on the service".toUpperCase(),
                AppLocalizations.of(context)?.writeToUsAndWeWillHelpYouDecideOnTheService ?? "Write to us and we will help you decide on the service",
                textAlign: TextAlign.center,
                style: theme.textTheme.headline2?.copyWith(
                  color: theme.colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                  fontSize: DeviceConstraints.getResponsiveSize(context, 30.sp, 45.sp, 60.sp),
                ),
              ),
              const SizedBox(height: 60),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (!isPortrait && !isLandScape)
                    SizedBox(
                      height: 400.h,
                      width: DeviceConstraints.getResponsiveSize(context, 0, 100.w, 80.w),
                      child: ClipRRect(
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
                          const SizedBox(height: 20),
                          Align(
                            alignment: Alignment.center,
                            child: _salonProfileProvider.enquiryStatus == Status.loading
                                ? Center(
                                    child: SizedBox(
                                      height: 30,
                                      width: 30,
                                      child: CircularProgressIndicator(
                                        color: theme.primaryColorDark,
                                      ),
                                    ),
                                  )
                                : SquareButton(
                                    height: 50,
                                    // width: (isPortrait) ? 350.w : null, // DeviceConstraints.getResponsiveSize(context, 0, 120.w, 70.w),
                                    text: AppLocalizations.of(context)?.submitEnquiry ?? "Submit an Enquiry",
                                    onTap: () => _salonProfileProvider.sendEnquiryToSalon(context, salonId: widget.salonModel.salonId),
                                    buttonColor: theme.primaryColorDark,
                                    borderColor: theme.primaryColorDark,
                                    borderRadius: (themeNo == '2') ? 0 : 25,
                                  ),
                            // child: CustomButton(
                            //   height: 51,
                            //   width: (isPortrait) ? 350.w : 70.w,
                            //   text: "Submit an Enquiry",
                            //   margin: const EdgeInsets.only(top: 30, bottom: 5),
                            //   variant: ButtonVariant.FillDeeporange300,

                            // ),

                            //  (_salonProfileProvider.chosenSalon.selectedTheme == 2)
                            //       ?
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (!isPortrait && !isLandScape)
                    SizedBox(
                      height: 400.h,
                      width: DeviceConstraints.getResponsiveSize(context, 0, 100.w, 80.w),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: (widget.salonModel.photosOfWork.isNotEmpty && widget.salonModel.photosOfWork[1] != '')
                            ? CachedImage(
                                url: widget.salonModel.photosOfWork[1],
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                ThemeImages.write2,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
