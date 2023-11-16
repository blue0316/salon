import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/app_provider.dart';
import 'package:bbblient/src/controller/authentication/auth_provider.dart';
import 'package:bbblient/src/controller/create_apntmnt_provider/create_appointment_provider.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/firebase/customer.dart';
import 'package:bbblient/src/models/customer/customer.dart';
import 'package:bbblient/src/models/enums/status.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/mongodb/db_service.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/salon/booking/dialog_flow/widgets/colors.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:bbblient/src/views/widgets/buttons.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class EnterNumber extends ConsumerStatefulWidget {
  final String countryCodeName;
  final TabController tabController;

  const EnterNumber({Key? key, required this.tabController, required this.countryCodeName}) : super(key: key);

  @override
  ConsumerState<EnterNumber> createState() => _EnterNumberState();
}

class _EnterNumberState extends ConsumerState<EnterNumber> {
  String countryCode = '+380';
  bool noVerificationSpinner = false;

  @override
  void initState() {
    super.initState();
    findDialCode();
  }

  void findDialCode() {
    for (Map<String, String> map in codes) {
      if (map['code'] == widget.countryCodeName) {
        setState(() {
          countryCode = map['dial_code']!;
        });
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final AuthProviderController _authProvider = ref.watch(authProvider);
    final CreateAppointmentProvider _createAppointmentProvider = ref.watch(createAppointmentProvider);
    SalonModel salonModel = _salonProfileProvider.chosenSalon;
    final DatabaseProvider _dbProvider = ref.watch(dbProvider);

    final _auth = ref.watch(authProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;
    // bool defaultTheme = (theme == AppTheme.customLightTheme);
    ThemeType themeType = _salonProfileProvider.themeType;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)?.confirmNumber ?? 'Confirm number',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 17.sp, 18.sp),
            color: theme.colorScheme.tertiary,
            fontFamily: 'Inter-Medium',
          ),
        ),
        SizedBox(height: 10.sp),
        Text(
          AppLocalizations.of(context)?.pleaseEnterPhoneNumber ?? 'Please enter your phone number',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.normal,
            fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 17.sp, 18.sp),
            color: theme.colorScheme.tertiary.withOpacity(0.6),
            fontFamily: 'Inter-Medium',
          ),
        ),
        SizedBox(height: 40.h),
        Container(
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0XFF35373B), width: 0.5)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CountryCodePicker(
                onChanged: (val) {
                  _authProvider.countryCode = val.dialCode ?? '';
                  _authProvider.updateAuthCountryCode(val.dialCode ?? '');

                  setState(() => countryCode = val.dialCode ?? '');
                },
                onInit: (val) {
                  _authProvider.countryCode = val?.dialCode ?? '';
                  _authProvider.updateAuthCountryCode(val?.dialCode ?? '');
                  // setState(() => countryCode = val?.dialCode ?? '');
                },
                initialSelection: widget.countryCodeName,
                favorite: const ['+1', '+380'],
                showCountryOnly: false,
                showOnlyCountryWhenClosed: false,
                alignLeft: false,
                textStyle: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.normal,
                  fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 17.sp, 18.sp),
                  color: theme.colorScheme.tertiary,
                  fontFamily: 'Inter-Medium',
                ),
                showFlag: false,
                padding: EdgeInsets.zero,
                dialogTextStyle: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.normal,
                  fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 17.sp, 18.sp),
                  color: Colors.black,
                  fontFamily: 'Inter-Medium',
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: TextFormField(
                  controller: _authProvider.phoneNoController,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)?.phoneNumber.toCapitalized() ?? "Phone Number",
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    _authProvider.phoneNumber = val;
                    _authProvider.updateAuthPhoneNumber(val);
                  },
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 17.sp, 18.sp),
                    color: theme.colorScheme.tertiary,
                    fontFamily: 'Inter-Medium',
                  ),
                ),
              ),
            ],
          ),
        ),
        const Space(factor: 1.5),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Column(
            children: [
              DefaultButton(
                borderRadius: 60,
                onTap: () async {
                  if (_authProvider.phoneNoController.text.isEmpty) {
                    showToast(AppLocalizations.of(context)?.pleaseEnterPhoneNumber ?? 'Please enter your phone number');
                    return;
                  }

                  showToast(AppLocalizations.of(context)?.pleaseWait ?? "Please wait");

                  /// only run phone verfication if country code is US
                  if (salonModel.countryCode == 'US') {
                    /* 
                    1. GET PHONE NUMBER
                    2. SEND OTP CODE TO PHONE NUMBER
                    3. VERIFY OTP
                    4. CHECK IF CUSTOMER DATA EXISTS IN DATABASE
                    4a. IF TRUE, GO TO NEXT PAGE
                    4b. IF FALSE, ADD TO CUSTOMER COLLECTION THEN GO TO NEXT PAGE
                     
                    */

                    // SEND OTP TO NUMBER
                    await _auth.authenticatePhone(
                      context,
                      code: countryCode,
                      phone: _authProvider.phoneNoController.text,
                      otpSent: () {
                        _createAppointmentProvider.nextPageView(1);

                        showTopSnackBar(
                          context,
                          CustomSnackBar.success(
                            message: AppLocalizations.of(context)?.otpSent ?? "Otp has been sent to your phone",
                            backgroundColor: AppTheme.creamBrown,
                            textStyle: theme.textTheme.bodyLarge!.copyWith(
                              fontSize: DeviceConstraints.getResponsiveSize(context, 20.sp, 20.sp, 20.sp),
                              color: Colors.black,
                            ),
                          ),
                          displayDuration: const Duration(seconds: 2),
                        );
                      },
                    );
                  } else {
                    setState(() => noVerificationSpinner = true);

                    /*
                    SINCE WE ARE NOT RUNNING VERIFICATION FOR NON US COUNTRIES
                    1. CHECK IF CUSTOMER EXISTS ALREADY IN DB (PHONE NUMBER)
                    2. IF IT EXISTS, GO TO ORDER DETAILS (PAGEVIEW 3)
                    3. ELSE GO TO PAGEVIEW 2 TO CREATE NEW CUSTOMER
                    */

                    // CHECK IF CUSTOMER DATA EXISTS IN DATABASE
                    final CustomerModel? customer = await CustomerApi(mongodbProvider: _dbProvider).findCustomer(
                      '${_auth.countryCode}${_auth.phoneNoController.text.trim()}',
                    );

                    stylePrint(customer);

                    if (customer != null) {
                      printIt('customer exists');
                      _auth.setCurrentCustomer(customer);
                      _createAppointmentProvider.nextPageView(3); // CUSTOMER EXISTS - Go to PageView Order List Screen
                    } else {
                      printIt('customer does not exist');
                      _createAppointmentProvider.nextPageView(1); // Go to pageview that has fields to create customer
                    }

                    setState(() => noVerificationSpinner = false);
                  }
                },
                color: dialogButtonColor(themeType, theme),
                textColor: loaderColor(themeType),
                height: 60.h,
                borderColor: dialogButtonColor(themeType, theme),
                label: (salonModel.countryCode == 'US' ? (AppLocalizations.of(context)?.sendACode ?? 'Send a code') : AppLocalizations.of(context)?.next ?? 'Next').toCapitalized(),
                isLoading: (noVerificationSpinner == true) || _authProvider.authenticatePhoneStatus == Status.loading,
                loaderColor: loaderColor(themeType), // defaultTheme ? Colors.white : Colors.black,
                suffixIcon: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: loaderColor(themeType),
                  size: 18.sp,
                ),
                fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
