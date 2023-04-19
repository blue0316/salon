import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/authentication/auth_provider.dart';
import 'package:bbblient/src/controller/create_apntmnt_provider/create_appointment_provider.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/appointment/appointment.dart';
import 'package:bbblient/src/models/appointment/serviceAndMaster.dart';
import 'package:bbblient/src/models/backend_codings/owner_type.dart';
import 'package:bbblient/src/models/cat_sub_service/services_model.dart';
import 'package:bbblient/src/models/customer/customer.dart';
import 'package:bbblient/src/models/enums/status.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/registration/authenticate/login.dart';
import 'package:bbblient/src/views/widgets/buttons.dart';
import 'package:bbblient/src/views/widgets/text_fields.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class EnterNumber extends ConsumerStatefulWidget {
  final TabController tabController;

  const EnterNumber({Key? key, required this.tabController}) : super(key: key);

  @override
  ConsumerState<EnterNumber> createState() => _EnterNumberState();
}

class _EnterNumberState extends ConsumerState<EnterNumber> {
  @override
  Widget build(BuildContext context) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final AuthProvider _authProvider = ref.watch(authProvider);
    final CreateAppointmentProvider _createAppointmentProvider = ref.watch(createAppointmentProvider);

    final _auth = ref.watch(authProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;
    bool defaultTheme = (theme == AppTheme.lightTheme);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          '${AppLocalizations.of(context)?.phoneNumber ?? 'Phone Number'} *',
          style: theme.textTheme.bodyLarge!.copyWith(
            fontSize: DeviceConstraints.getResponsiveSize(context, 20.sp, 20.sp, 20.sp),
            color: defaultTheme ? Colors.black : Colors.white,
          ),
        ),
        SizedBox(height: 20.h),
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
                  favorite: const ['+1', '+380'],
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
                    textSize: DeviceConstraints.getResponsiveSize(context, 20.sp, 20.sp, 20.sp),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Space(factor: 1.5),
        Text(
          AppLocalizations.of(context)?.mandatoryFields ?? '*Mandatory fields',
          style: theme.textTheme.bodyLarge!.copyWith(
            fontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 15.sp, 15.sp),
            color: defaultTheme ? AppTheme.textBlack : Colors.white,
          ),
        ),
        const Spacer(),
        DefaultButton(
          borderRadius: 60,
          onTap: () async {
            showToast(AppLocalizations.of(context)?.pleaseWait ?? "Please wait");

            // print('inside here 1 --- enableOTP = ${_salonProfileProvider.themeSettings?.displaySettings?.enableOTP}');

            /// Check if OTP is enabled on Web Settings
            // If Disabled:
            if (_salonProfileProvider.themeSettings?.displaySettings?.enableOTP == false) {
              // Go to pageview that has fields to update personal info
              _createAppointmentProvider.nextPageView(2); // PageView screen that contains name and email fields

              return;
            }

            // If user has logged in with another number and decides to use a new number to book
            if (_auth.currentCustomer?.personalInfo.phone != null && _auth.currentCustomer?.personalInfo.phone != _authProvider.phoneNoController.text) {
              // Log the former account out
              await FirebaseAuth.instance.signOut();
            }

            // If Enabled:
            if (_salonProfileProvider.themeSettings?.displaySettings?.enableOTP == true) {
              // send otp
              if (!_auth.userLoggedIn) {
                await _auth.verifyPhoneNumber(context: context);

                if (_auth.otpStatus != Status.failed) {
                  showTopSnackBar(
                    context,
                    CustomSnackBar.success(
                      message: AppLocalizations.of(context)?.otpSent ?? "Otp has been sent to your phone",
                      backgroundColor: theme.primaryColor,
                    ),
                  );
                  checkUser2(
                    context,
                    ref,
                    isLoggedIn: () {},
                    notLoggedIn: () {
                      _createAppointmentProvider.nextPageView(1);
                    },
                  ); // , appointmentModel: appointment);
                }
              } else {
                printIt('*********************');
                printIt('user is logged in');
                printIt('*********************');

                CustomerModel? currentCustomer = _auth.currentCustomer;
                if (currentCustomer != null) {
                  if (currentCustomer.personalInfo.firstName == '' || currentCustomer.personalInfo.email == null) {
                    // Customer Personal Info is missing name and email

                    // Go to pageview that has fields to update personal info
                    _createAppointmentProvider.nextPageView(2); // PageView screen that contains name and email fields
                  } else {
                    // Customer Personal Info has name and email

                    // Create Appointment
                    CustomerModel customer = CustomerModel(
                      customerId: currentCustomer.customerId,
                      personalInfo: currentCustomer.personalInfo,
                      registeredSalons: [],
                      createdAt: DateTime.now(),
                      avgRating: 3.0,
                      noOfRatings: 6,
                      profilePicUploaded: false,
                      profilePic: "",
                      profileCompleted: false,
                      quizCompleted: false,
                      preferredGender: "male",
                      preferredCategories: [],
                      locations: [],
                      fcmToken: "",
                      locale: "en",
                      favSalons: [],
                      referralLink: "",
                    );
                    if (_createAppointmentProvider.chosenSalon!.ownerType == OwnerType.singleMaster) {
                      await _createAppointmentProvider.createAppointment(
                        customerModel: customer,
                        context: context,
                      );
                    } else {
                      await _createAppointmentProvider.creatAppointmentSalonOwner(
                        customerModel: customer,
                        context: context,
                      );
                    }

                    // Go to PageView Order List Screen
                    _createAppointmentProvider.nextPageView(3);
                  }
                }
              }
            }
          },
          color: defaultTheme ? Colors.black : theme.primaryColor,
          textColor: defaultTheme ? Colors.white : Colors.black,
          height: 60,
          label: AppLocalizations.of(context)?.nextStep ?? 'Next Step',
          isLoading: _authProvider.otpStatus == Status.loading,
          loaderColor: defaultTheme ? Colors.white : Colors.black,
        ),
        SizedBox(height: 15.h),
        DefaultButton(
          borderRadius: 60,
          onTap: () => widget.tabController.animateTo(1),
          color: defaultTheme ? Colors.white : Colors.transparent,
          borderColor: defaultTheme ? Colors.black : theme.primaryColor,
          textColor: defaultTheme ? Colors.black : theme.primaryColor,
          height: 60,
          label: AppLocalizations.of(context)?.back ?? 'Back',
        ),
      ],
    );
  }
}
