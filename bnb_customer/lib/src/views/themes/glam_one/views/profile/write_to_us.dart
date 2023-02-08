import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/theme/glam_one.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/themes/glam_one/core/constants/image.dart';
import 'package:bbblient/src/views/themes/glam_one/views/profile/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bbblient/src/views/themes/glam_one/core/utils/custom_button.dart';

class WriteToUs extends StatefulWidget {
  const WriteToUs({Key? key}) : super(key: key);

  @override
  State<WriteToUs> createState() => _WriteToUsState();
}

class _WriteToUsState extends State<WriteToUs> {
  TextEditingController group2816Controller = TextEditingController();

  TextEditingController group2747Controller = TextEditingController();

  TextEditingController group2747OneController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.portrait);

    return Form(
      key: _formKey,
      child: Container(
        width: double.infinity,
        color: const Color(0XFFFFC692),
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
                style: GlamOneTheme.headLine2.copyWith(
                  color: Colors.black,
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
                      child: Image.asset(GlamOneImages.write1, fit: BoxFit.cover),
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
                                  style: GlamOneTheme.bodyText2.copyWith(color: Colors.black),
                                ),
                                TextSpan(
                                  text: "*",
                                  style: GlamOneTheme.bodyText2.copyWith(
                                    color: GlamOneTheme.deepOrange,
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
                                  style: GlamOneTheme.bodyText2.copyWith(color: Colors.black),
                                ),
                                TextSpan(
                                  text: "*",
                                  style: GlamOneTheme.bodyText2.copyWith(
                                    color: GlamOneTheme.deepOrange,
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
                                  style: GlamOneTheme.bodyText2.copyWith(color: Colors.black),
                                ),
                                TextSpan(
                                  text: "*",
                                  style: GlamOneTheme.bodyText2.copyWith(
                                    color: GlamOneTheme.deepOrange,
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
                        child: CustomButton(
                          height: 51,
                          width: (isPortrait) ? 350.w : 70.w,
                          text: "Submit an inquiry",
                          margin: const EdgeInsets.only(top: 30, bottom: 5),
                          variant: ButtonVariant.FillDeeporange300,
                        ),
                      ),
                    ],
                  ),
                  if (!isPortrait)
                    SizedBox(
                      height: 400.h,
                      width: 80.w,
                      child: Image.asset(GlamOneImages.write2, fit: BoxFit.cover),
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
