import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/authentication/auth_provider.dart';
import 'package:bbblient/src/controller/create_apntmnt_provider/create_appointment_provider.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/enums/appointment_status.dart';
import 'package:bbblient/src/models/enums/status.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/views/registration/authenticate/login.dart';
import 'package:bbblient/src/views/widgets/buttons.dart';
import 'package:bbblient/src/views/widgets/dialogues/dialogue_function.dart';
import 'package:bbblient/src/views/widgets/text_fields.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class UserDetailsVerification extends ConsumerWidget {
  const UserDetailsVerification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var sizeHeight = MediaQuery.of(context).size.height;
    final CreateAppointmentProvider _createAppointmentProvider = ref.watch(createAppointmentProvider);
    final AuthProvider _authProvider = ref.watch(authProvider);
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;
    bool defaultTheme = theme == AppTheme.lightTheme;

    return SingleChildScrollView(
      child: SizedBox(
        height: DeviceConstraints.getResponsiveSize(context, sizeHeight * 0.8, sizeHeight * 0.65, sizeHeight * 0.65),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Space(factor: 1),

            // -- Your Name
            Text(
              "Your ${AppLocalizations.of(context)?.name.toCapitalized() ?? "Name"}*",
              style: AppTheme.bodyText1.copyWith(
                fontSize: 18.sp,
                color: defaultTheme ? AppTheme.textBlack : Colors.white,
              ),
            ),

            const Space(factor: 1.3),

            BNBTextField(
              controller: _createAppointmentProvider.nameController,
              hint: AppLocalizations.of(context)?.pleaseEnterFirstName.toCapitalized() ?? "Enter first name",
              borderWidth: 0.7,
              vPadding: 20.h,
              textColor: defaultTheme ? Colors.black : Colors.white,
              borderColor: defaultTheme ? AppTheme.lightGrey : Colors.white,

              onChanged: (String val) {
                _authProvider.firstName = val;
              },

              // horizontal: DeviceConstraints.getResponsiveSize(context, 2.5, 2, 2),
            ),

            Space(factor: DeviceConstraints.getResponsiveSize(context, 2.5, 2, 2)),

            // -- Your phone number
            Text(
              "Your ${AppLocalizations.of(context)?.phoneNumber.toCapitalized() ?? "Phone Number"}*",
              style: AppTheme.bodyText1.copyWith(
                fontSize: 18.sp,
                color: defaultTheme ? AppTheme.textBlack : Colors.white,
              ),
            ),

            const Space(factor: 1.3),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                border: Border.all(
                  color: defaultTheme ? Colors.black : Colors.white,
                  width: 0.7,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CountryCodePicker(
                      onChanged: (val) {
                        _authProvider.countryCode = val.dialCode ?? '';
                      },
                      onInit: (val) {
                        _authProvider.countryCode = val?.dialCode ?? '';
                      },
                      initialSelection: 'UA',
                      favorite: const ['+380', 'Uk'],
                      showCountryOnly: false,
                      showOnlyCountryWhenClosed: false,
                      alignLeft: false,
                      textStyle: TextStyle(color: defaultTheme ? Colors.black : Colors.white),
                      showFlag: false,
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: BNBTextField(
                        controller: _authProvider.phoneNoController,
                        hint: AppLocalizations.of(context)?.phoneNumber.toCapitalized() ?? "Phone Number",
                        vPadding: 0, // 20.h,
                        border: InputBorder.none,
                        textColor: defaultTheme ? Colors.black : Colors.white,
                        onChanged: (val) {
                          _authProvider.phoneNumber = val;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Space(factor: DeviceConstraints.getResponsiveSize(context, 2.5, 2, 2)),

            // -- Your Email
            Text(
              "Your ${AppLocalizations.of(context)?.email.toCapitalized() ?? "Email"}",
              style: AppTheme.bodyText1.copyWith(
                fontSize: 18.sp,
                color: defaultTheme ? AppTheme.textBlack : Colors.white,
              ),
            ),

            const Space(factor: 1.3),

            BNBTextField(
              controller: _createAppointmentProvider.emailController,
              hint: AppLocalizations.of(context)?.registration_line4.toCapitalized() ?? "Enter E-mail",
              borderWidth: 0.7,
              vPadding: 20.h,
              textColor: defaultTheme ? Colors.black : Colors.white,
              borderColor: defaultTheme ? AppTheme.lightGrey : Colors.white,
              onChanged: (String val) {
                // _authProvider.firstName =
              },
            ),

            const Space(factor: 1.5),

            Text(
              "*Mandatory fields",
              style: AppTheme.bodyText2.copyWith(
                color: defaultTheme ? AppTheme.textBlack : Colors.white,
              ),
            ),

            const Spacer(),
            // GestureDetector(
            //   onTap: () {
            //     print('@@@@@@@@@@@@@@@@@@@@');
            //     print(_createAppointmentProvider.countryCode);
            //     print('@@@@@@@@@@@@@@@@@@@@');
            //   },
            //   child: Container(
            //     height: 100,
            //     width: 300,
            //     color: Colors.green,
            //   ),
            // ),
            DefaultButton(
              borderRadius: 60,
              onTap: () async {
                // if (_authProvider.otpStatus == Status.loading) {
                //   showToast(AppLocalizations.of(context)?.pleaseWait ?? "Please wait");
                // }

                if (!_authProvider.userLoggedIn && _createAppointmentProvider.nameController.text.isEmpty) {
                  showToast(AppLocalizations.of(context)?.invalid_phone_number ?? 'Input name please');
                  return;
                }

                if (!_authProvider.userLoggedIn && _authProvider.phoneNoController.text.isEmpty) {
                  showToast(AppLocalizations.of(context)?.invalid_phone_number ?? 'Input phone No');
                  return;
                }
                if (!_authProvider.userLoggedIn && (_authProvider.phoneNumber.length < 8 || _authProvider.phoneNumber.length > 10)) {
                  showToast(AppLocalizations.of(context)?.invalid_phone_number ?? 'Invalid phone No');
                  return;
                }

                print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
                print(!_authProvider.userLoggedIn);
                print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
                // _createAppointmentProvider.verifyControllers(context, _authProvider);

                if (!_authProvider.userLoggedIn) {
                  print('not logged in at this point');
                  await _authProvider.verifyPhoneNumber(context: context);
                  showTopSnackBar(
                    context,
                    CustomSnackBar.success(
                      message: AppLocalizations.of(context)?.otpSent ?? "Otp has been sent to your phone",
                      backgroundColor: AppTheme.creamBrown,
                    ),
                  );
                  checkUser(context, ref, () {
                    //_auth.createAppointmentProvider(_createAppointment);
                    // _createAppointment.createAppointment(
                    //     customerModel: _auth.currentCustomer!,
                    //     context: context);
                  }, appointmentModel: _createAppointmentProvider.appointmentModel!);
                } else {
                  showToast(AppLocalizations.of(context)?.pleaseWait ?? "Please wait");
                  bool moveAhead = _createAppointmentProvider.checkSlotsAndMaster(context: context);
                  checkUser(context, ref, () async {
                    if (moveAhead) {
                      _authProvider.createAppointmentProvider(_createAppointmentProvider);
                      _createAppointmentProvider.createAppointment(
                        customerModel: _authProvider.currentCustomer!,
                        context: context,
                      );
                      bool _success = await _createAppointmentProvider.finishBooking(
                        context: context,
                        customerModel: _authProvider.currentCustomer!,
                      );

                      if (_success) {
                        // setState(() {
                        //   // _status = Status.success;
                        // });
                        showMyDialog(
                          context: context,
                          child: SizedBox(
                            height: 300.h,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  AppLocalizations.of(context)?.success ?? "Success",
                                  style: AppTheme.appointmentSubtitle,
                                ),
                                const Gap(10),
                                SizedBox(height: 150.h, width: 150.w, child: Image.asset(AppIcons.bookingConfirmedPNG)),
                                const Gap(10),
                                Text(
                                  (_createAppointmentProvider.appointmentModel?.status ?? "") == AppointmentStatus.requested
                                      ? AppLocalizations.of(context)?.requestConfirmed ?? "Request Confirmed"
                                      : AppLocalizations.of(
                                            context,
                                          )?.bookingConfirmed ??
                                          "Your booking has been confirmed",
                                  textAlign: TextAlign.center,
                                  style: AppTheme.appointmentTitleStyle,
                                ),
                                const Gap(15),
                                BnbMaterialButton(
                                  key: const Key("great-key"),
                                  onTap: () {
                                    // print(object)
                                    // if (_appProvider.firstRoute != null) {
                                    //   printIt("Going back to : ${_appProvider.firstRoute}");
                                    //   // context.pop();
                                    //   // context.push(
                                    //   //     '${NavigatorPage.redirect}${_appProvider.firstRoute!}');
                                    //   html.window.open("https://bowandbeautiful.com${_appProvider.firstRoute}", "_self");
                                    // } else {
                                    Navigator.of(context).popUntil((Route<dynamic> route) => route.isFirst);
                                    // }
                                  },
                                  title: AppLocalizations.of(context)?.great ?? 'Great',
                                  minWidth: 150.w,
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    } else {
                      // print('falseeeee');
                    }
                  }, appointmentModel: _createAppointmentProvider.appointmentModel!);
                }

                _createAppointmentProvider.nextPageView(2);
              },
              color: defaultTheme ? Colors.black : theme.primaryColor,
              textColor: defaultTheme ? Colors.white : Colors.black,
              height: 60,
              label: AppLocalizations.of(context)?.next ?? 'Next',

              // label: 'Next step',
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
