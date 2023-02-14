import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/theme/glam_one.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/themes/components/widgets.dart/button.dart';
import 'package:bbblient/src/views/themes/images.dart';
import 'package:bbblient/src/views/themes/glam_one/views/profile/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WriteToUs extends ConsumerStatefulWidget {
  const WriteToUs({Key? key}) : super(key: key);

  @override
  ConsumerState<WriteToUs> createState() => _WriteToUsState();
}

class _WriteToUsState extends ConsumerState<WriteToUs> {
  TextEditingController group2816Controller = TextEditingController();

  TextEditingController group2747Controller = TextEditingController();

  TextEditingController group2747OneController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.portrait);

    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    final int? themeNo = _salonProfileProvider.chosenSalon.selectedTheme;

    return Form(
      key: _formKey,
      child: Container(
        width: double.infinity,
        color: theme.cardColor,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: DeviceConstraints.getResponsiveSize(context, 20.w, 50.w, 50.w),
            vertical: 100,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Write to us and we will help you decide on the service".toUpperCase(),
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
                  if (!isPortrait)
                    SizedBox(
                      height: 400.h,
                      width: 80.w,
                      child: Image.asset(ThemeImages.write1, fit: BoxFit.cover),
                    ),
                  Column(
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
                                  text: "Name",
                                  style: theme.textTheme.subtitle2?.copyWith(fontSize: 15.sp),
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
                            width: (isPortrait) ? 350.w : 100.w,
                            focusNode: FocusNode(),
                            controller: group2816Controller,
                            hintText: "Name",
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
                                  text: "Phone",
                                  style: theme.textTheme.subtitle2?.copyWith(fontSize: 15.sp),
                                ),
                                TextSpan(
                                  text: " *",
                                  style: GlamOneTheme.bodyText2.copyWith(
                                    color: theme.primaryColor,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.left,
                          ),
                          CustomTextFormField(
                            width: (isPortrait) ? 350.w : 100.w,
                            focusNode: FocusNode(),
                            controller: group2816Controller,
                            hintText: "Phone",
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
                                  text: "Email",
                                  style: theme.textTheme.subtitle2?.copyWith(fontSize: 15.sp),
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
                            width: (isPortrait) ? 350.w : 100.w,
                            focusNode: FocusNode(),
                            controller: group2816Controller,
                            hintText: "Email",
                            contentPadding: 20,
                            margin: const EdgeInsets.only(top: 10),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.center,
                        child: SquareButton(
                          height: 51,
                          width: (isPortrait) ? 350.w : 70.w,
                          text: "Submit an inquiry",
                          onTap: () {},
                          buttonColor: theme.primaryColorDark,
                          borderColor: theme.primaryColorDark,
                          borderRadius: (themeNo == 2) ? 0 : 25,
                        ),
                        // child: CustomButton(
                        //   height: 51,
                        //   width: (isPortrait) ? 350.w : 70.w,
                        //   text: "Submit an inquiry",
                        //   margin: const EdgeInsets.only(top: 30, bottom: 5),
                        //   variant: ButtonVariant.FillDeeporange300,

                        // ),

                        //  (_salonProfileProvider.chosenSalon.selectedTheme == 2)
                        //       ?
                      ),
                    ],
                  ),
                  if (!isPortrait)
                    SizedBox(
                      height: 400.h,
                      width: 80.w,
                      child: Image.asset(ThemeImages.write2, fit: BoxFit.cover),
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
