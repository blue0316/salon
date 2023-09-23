import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/appointment/widgets/appointment_header.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'widgets/button.dart';
import 'widgets/theme_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReviewAppointments extends ConsumerStatefulWidget {
  const ReviewAppointments({Key? key}) : super(key: key);

  @override
  ConsumerState<ReviewAppointments> createState() => _ReviewAppointmentsState();
}

class _ReviewAppointmentsState extends ConsumerState<ReviewAppointments> {
  double rated = 0;
  bool ratingSelected = false;
  bool postAnonymously = false;

  @override
  Widget build(BuildContext context) {
    final _appointmentProvider = ref.watch(appointmentProvider);
    ThemeData theme = _appointmentProvider.salonTheme ?? AppTheme.customLightTheme;
    ThemeType themeType = _appointmentProvider.themeType ?? ThemeType.DefaultLight;

    return Scaffold(
      backgroundColor: scaffoldBGColor(themeType, theme),
      body: Column(
        children: [
          Header(
            salonName: _appointmentProvider.salon?.salonName ?? '',
            salonLogo: _appointmentProvider.salon?.salonLogo,
            salonAddress: _appointmentProvider.salon?.address,
            salonPhone: _appointmentProvider.salon?.phoneNumber,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: DeviceConstraints.getResponsiveSize(context, 25, 0, 0),
              ),
              child: SizedBox(
                // height: 700,
                width: double.infinity,
                // color: Colors.orange,

                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 50),
                      Text(
                        'Your Review',
                        style: theme.textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: DeviceConstraints.getResponsiveSize(context, 25.sp, 25.sp, 30.sp),
                          color: confirmationTextColor(themeType, theme),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20.sp),
                      Text(
                        '[Client Fist Name], how was your experience at [Salon Name]?',
                        style: theme.textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.normal,
                          fontSize: DeviceConstraints.getResponsiveSize(context, 20.sp, 20.sp, 20.sp),
                          color: confirmationTextColor(themeType, theme),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 40.sp),
                      RatingBar.builder(
                        initialRating: 0,
                        minRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                        onRatingUpdate: (rating) {
                          setState(() {
                            rated = rating;
                            ratingSelected = true;
                          });
                        },
                      ),
                      SizedBox(height: 25.sp),
                      if (!ratingSelected)
                        Text(
                          'select your star rating',
                          style: theme.textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.normal,
                            fontSize: DeviceConstraints.getResponsiveSize(context, 17.sp, 20.sp, 20.sp),
                            color: confirmationTextColor(themeType, theme),
                          ),
                        ),
                      if (ratingSelected)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 200.h,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.amber,
                            ),
                            SizedBox(height: 20.sp),
                            TextField(
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: DeviceConstraints.getResponsiveSize(context, 17.sp, 19.sp, 20.sp),
                                color: confirmationTextColor(themeType, theme),
                              ),
                              decoration: InputDecoration(
                                hintText: 'Client Name',
                                hintStyle: const TextStyle(fontFamily: 'Inter'),
                                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: textBorderColor(themeType, theme))),
                                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: textBorderColor(themeType, theme))),
                                border: UnderlineInputBorder(borderSide: BorderSide(color: textBorderColor(themeType, theme))),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Transform.scale(
                                  scale: 1.2.sp,
                                  child: Checkbox(
                                    checkColor: Colors.white,
                                    fillColor: MaterialStateProperty.all(theme.primaryColor),
                                    value: false,
                                    onChanged: (value) {
                                      setState(() {
                                        postAnonymously = !postAnonymously;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  'Post anonymously ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: DeviceConstraints.getResponsiveSize(context, 17.sp, 19.sp, 20.sp),
                                    color: confirmationTextColor(themeType, theme),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.sp),
                            TextField(
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: DeviceConstraints.getResponsiveSize(context, 17.sp, 19.sp, 20.sp),
                                color: confirmationTextColor(themeType, theme),
                              ),
                              decoration: InputDecoration(
                                hintText: 'Review comment',
                                hintStyle: const TextStyle(fontFamily: 'Inter'),
                                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: textBorderColor(themeType, theme))),
                                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: textBorderColor(themeType, theme))),
                                border: UnderlineInputBorder(borderSide: BorderSide(color: textBorderColor(themeType, theme))),
                              ),
                              maxLength: null,
                              maxLines: null,
                            ),
                            SizedBox(height: 50.sp),
                            Button(
                              onTap: () {},
                              text: 'Send Review',
                              buttonColor: confirmButton(themeType, theme),
                              textColor: buttonTextColor(themeType),
                              // isLoading: _appointmentProvider.createNoShowPolicyStatus == Status.loading,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
