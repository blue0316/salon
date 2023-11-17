import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/app_provider.dart';
import 'package:bbblient/src/controller/authentication/auth_provider.dart';
import 'package:bbblient/src/controller/create_apntmnt_provider/create_appointment_provider.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/firebase/customer.dart';
import 'package:bbblient/src/models/customer/customer.dart';
import 'package:bbblient/src/models/enums/status.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/views/salon/booking/dialog_flow/widgets/colors.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:bbblient/src/views/widgets/buttons.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegistrationSuccessful extends ConsumerStatefulWidget {
  const RegistrationSuccessful({Key? key}) : super(key: key);

  @override
  ConsumerState<RegistrationSuccessful> createState() => _RegistrationSuccessfulState();
}

class _RegistrationSuccessfulState extends ConsumerState<RegistrationSuccessful> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController pronounceController = TextEditingController();

  // Initial Selected Value
  String dropdownvalue = 'He/Him';

  // List of items in our dropdown menu
  var items = [
    'He/Him',
    'She/Her',
    'They/Them',
    'Other',
  ];

  bool isOther = false;
  String countryCode = '+380';
  bool loader = false;

  @override
  Widget build(BuildContext context) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final AuthProviderController _authProvider = ref.watch(authProvider);
    final CreateAppointmentProvider _createAppointmentProvider = ref.watch(createAppointmentProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;
    ThemeType themeType = _salonProfileProvider.themeType;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)?.verificationSuccessful.toCapitalized() ?? 'Verification was successful!',
          style: theme.textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 17.sp, 18.sp),
            color: theme.colorScheme.tertiary,
            fontFamily: 'Inter-Medium',
          ),
        ),
        const Space(factor: 1),
        const Space(factor: 1.3),
        Container(
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0XFF35373B), width: 0.5)),
          ),
          child: TextFormField(
            controller: firstNameController,
            decoration: InputDecoration(
              label: Text(
                AppLocalizations.of(context)?.firstName ?? 'First name',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 17.sp, 18.sp),
                  color: theme.colorScheme.tertiary.withOpacity(0.6),
                  fontFamily: 'Inter-Medium',
                ),
              ),
              // hintText: "First name",
              border: InputBorder.none,
            ),
            keyboardType: TextInputType.text,
            onChanged: (val) {
              _authProvider.firstName = val;
            },
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 17.sp, 18.sp),
              color: theme.colorScheme.tertiary,
              fontFamily: 'Inter-Medium',
            ),
          ),
        ),
        SizedBox(height: 15.sp),
        Container(
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0XFF35373B), width: 0.5)),
          ),
          child: TextFormField(
            controller: lastNameController,
            decoration: InputDecoration(
              label: Text(
                AppLocalizations.of(context)?.lastName.toCapitalized() ?? "Last Name",
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 17.sp, 18.sp),
                  color: theme.colorScheme.tertiary.withOpacity(0.6),
                  fontFamily: 'Inter-Medium',
                ),
              ),
              // hintText: AppLocalizations.of(context)?.lastName.toCapitalized() ?? "Last Name",
              border: InputBorder.none,
            ),
            keyboardType: TextInputType.text,
            onChanged: (val) {
              _authProvider.lastName = val;
            },
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 17.sp, 18.sp),
              color: theme.colorScheme.tertiary,
              fontFamily: 'Inter-Medium',
            ),
          ),
        ),
        SizedBox(height: 15.sp),
        Container(
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0XFF35373B), width: 0.5)),
          ),
          child: TextFormField(
            controller: emailController,
            decoration: InputDecoration(
              label: Text(
                AppLocalizations.of(context)?.email.toCapitalized() ?? "Email",
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 17.sp, 18.sp),
                  color: theme.colorScheme.tertiary.withOpacity(0.6),
                  fontFamily: 'Inter-Medium',
                ),
              ),

              // hintText: AppLocalizations.of(context)?.email.toCapitalized() ?? "Email",
              border: InputBorder.none,
            ),
            keyboardType: TextInputType.text,
            onChanged: (val) {
              // _authProvider.firstName = val;
            },
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 17.sp, 18.sp),
              color: theme.colorScheme.tertiary,
              fontFamily: 'Inter-Medium',
            ),
          ),
        ),
        if (_salonProfileProvider.chosenSalon.countryCode != 'US') SizedBox(height: 15.sp),
        if (_salonProfileProvider.chosenSalon.countryCode != 'US')
          Row(
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
                initialSelection: 'UA',
                favorite: const ['+1', '+380'],
                showCountryOnly: false,
                showOnlyCountryWhenClosed: false,
                alignLeft: false,
                textStyle: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.normal,
                  fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 17.sp, 18.sp),
                  color: theme.colorScheme.tertiary.withOpacity(0.6),
                  fontFamily: 'Inter-Medium',
                ),
                showFlag: false,
                dialogTextStyle: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.normal,
                  fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 17.sp, 18.sp),
                  color: Colors.black,
                  fontFamily: 'Inter-Medium',
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Color(0XFF35373B), width: 0.5)),
                  ),
                  child: TextFormField(
                    controller: phoneNumberController,
                    decoration: InputDecoration(
                      label: Text(
                        AppLocalizations.of(context)?.phoneNumber.toCapitalized() ?? "Phone number",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 17.sp, 18.sp),
                          color: theme.colorScheme.tertiary.withOpacity(0.6),
                          fontFamily: 'Inter-Medium',
                        ),
                      ),
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.text,
                    onChanged: (val) {
                      // _authProvider.firstName = val;
                    },
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 17.sp, 18.sp),
                      color: theme.colorScheme.tertiary,
                      fontFamily: 'Inter-Medium',
                    ),
                  ),
                ),
              ),
            ],
          ),
        SizedBox(height: 15.sp),
        Container(
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0XFF35373B), width: 0.5)),
          ),
          child: !isOther
              ? DropdownButtonHideUnderline(
                  child: DropdownButton(
                    dropdownColor: dropdownBackgroundColor(themeType, theme), //  const Color(0XFF1F1F21),
                    // hint: Text(
                    //   AppLocalizations.of(context)?.pronounce ?? 'Pronounce',
                    //   style: theme.textTheme.bodyMedium?.copyWith(
                    //     fontWeight: FontWeight.w400,
                    //     fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp,17.sp, 18.sp),
                    //     color: Colors.pink, // isLightTheme ? Colors.black : theme.colorScheme.tertiary.withOpacity(0.6),
                    //     fontFamily: 'Inter-Medium',
                    //   ),
                    // ),

                    // Initial Value
                    value: dropdownvalue,

                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),

                    items: items.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(
                          items,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 17.sp, 18.sp),
                            color: theme.colorScheme.tertiary,
                            fontFamily: 'Inter-Medium',
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue == 'Other') {
                        setState(() {
                          isOther = true;
                        });

                        return;
                      }

                      setState(() {
                        dropdownvalue = newValue!;
                        isOther = false;
                        pronounceController.text = newValue;
                      });
                    },
                  ),
                )
              : TextFormField(
                  controller: pronounceController,
                  decoration: InputDecoration(
                    label: Text(
                      AppLocalizations.of(context)?.pronounce ?? 'Pronounce',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 17.sp, 18.sp),
                        color: theme.colorScheme.tertiary.withOpacity(0.6),
                        fontFamily: 'Inter-Medium',
                      ),
                    ),
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    // _authProvider.firstName = val;
                  },
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 17.sp, 18.sp),
                    color: theme.colorScheme.tertiary,
                    fontFamily: 'Inter-Medium',
                  ),
                ),
        ),
        const Spacer(),
        DefaultButton(
          borderRadius: 60,
          onTap: () async {
            // Check if fields are filled
            if (firstNameController.text.isEmpty || emailController.text.isEmpty || lastNameController.text.isEmpty) {
              showToast(AppLocalizations.of(context)?.emptyFields ?? "Field cannot be empty, please fill the required fields");
              return;
            }

            CustomerModel createNewCustomer = CustomerModel(
              customerId: "",
              personalInfo: PersonalInfo(
                phone: '${_authProvider.countryCode}${_authProvider.phoneNumber}',
                firstName: firstNameController.text,
                lastName: lastNameController.text,
                description: '',
                dob: DateTime.now(),
                email: emailController.text,
                pronoun: dropdownvalue,
              ),
              registeredSalons: [_salonProfileProvider.chosenSalon.salonId],
              createdAt: DateTime.now(),
              avgRating: 0,
              noOfRatings: 0,
              profilePicUploaded: false,
              profilePic: "",
              profileCompleted: false,
              quizCompleted: false,
              preferredCategories: [],
              locations: [],
              fcmToken: "",
              locale: 'en',
              favSalons: [_salonProfileProvider.chosenSalon.salonId],
              referralLink: "",
            );

            // if (_salonProfileProvider.chosenSalon.countryCode == 'US') {
            await _authProvider.createCustomerMongo(newCustomer: createNewCustomer);

            if (_authProvider.updateCustomerPersonalInfoStatus == Status.success) {
              if (_salonProfileProvider.chosenSalon.countryCode == 'US') {
                _createAppointmentProvider.nextPageView(3);
              } else {
                _createAppointmentProvider.nextPageView(2);
              }
            } else {
              showToast(AppLocalizations.of(context)?.somethingWentWrongPleaseTryAgain ?? 'Something went wrong, please try again');
            }
          },
          color: dialogButtonColor(themeType, theme),
          borderColor: dialogButtonColor(themeType, theme),
          textColor: loaderColor(themeType),
          height: 60.h,
          label: (AppLocalizations.of(context)?.confirmMyDetails ?? "Confirm my details").toCapitalized(),
          isLoading: (_authProvider.updateCustomerPersonalInfoStatus == Status.loading) || loader,
          loaderColor: loaderColor(themeType),
          suffixIcon: Icon(
            Icons.arrow_forward_ios_rounded,
            color: loaderColor(themeType),
            size: 18.sp,
          ),
          fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 17.sp, 18.sp),
        ),
      ],
    );
  }
}
