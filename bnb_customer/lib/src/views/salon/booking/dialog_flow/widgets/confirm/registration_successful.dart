import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/authentication/auth_provider.dart';
import 'package:bbblient/src/controller/create_apntmnt_provider/create_appointment_provider.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/firebase/customer.dart';
import 'package:bbblient/src/models/customer/customer.dart';
import 'package:bbblient/src/models/enums/status.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
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
    final AuthProvider _authProvider = ref.watch(authProvider);
    final CreateAppointmentProvider _createAppointmentProvider = ref.watch(createAppointmentProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;
    ThemeType themeType = _salonProfileProvider.themeType;
    bool isLightTheme = (theme == AppTheme.customLightTheme);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)?.verificationSuccessful.toCapitalized() ?? 'Verification was successful!',
          style: theme.textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
            color: theme.colorScheme.tertiary,
            fontFamily: 'Inter',
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
                  fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
                  color: theme.colorScheme.tertiary.withOpacity(0.6),
                  fontFamily: 'Inter',
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
              fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
              color: theme.colorScheme.tertiary,
              fontFamily: 'Inter',
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
                  fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
                  color: theme.colorScheme.tertiary.withOpacity(0.6),
                  fontFamily: 'Inter',
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
              fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
              color: theme.colorScheme.tertiary,
              fontFamily: 'Inter',
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
                  fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
                  color: theme.colorScheme.tertiary.withOpacity(0.6),
                  fontFamily: 'Inter',
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
              fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
              color: theme.colorScheme.tertiary,
              fontFamily: 'Inter',
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
                textStyle: TextStyle(color: theme.colorScheme.tertiary), // defaultTheme ? Colors.black : Colors.white),
                showFlag: false,
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
                          fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
                          color: theme.colorScheme.tertiary.withOpacity(0.6),
                          fontFamily: 'Inter',
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
                      fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
                      color: theme.colorScheme.tertiary,
                      fontFamily: 'Inter',
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
                    //     fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
                    //     color: Colors.pink, // isLightTheme ? Colors.black : theme.colorScheme.tertiary.withOpacity(0.6),
                    //     fontFamily: 'Inter',
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
                            fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
                            color: theme.colorScheme.tertiary,
                            fontFamily: 'Inter',
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
                        fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
                        color: theme.colorScheme.tertiary.withOpacity(0.6),
                        fontFamily: 'Inter',
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
                    fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
                    color: theme.colorScheme.tertiary,
                    fontFamily: 'Inter',
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

            PersonalInfo _personalInfo;

            if (_salonProfileProvider.chosenSalon.countryCode == 'US') {
              CustomerModel? currentCustomer = _authProvider.currentCustomer;

              _personalInfo = PersonalInfo(
                phone: currentCustomer!.personalInfo.phone,
                firstName: firstNameController.text,
                lastName: lastNameController.text,
                description: currentCustomer.personalInfo.description ?? '',
                dob: currentCustomer.personalInfo.dob ?? DateTime.now().subtract(const Duration(days: 365 * 26)),
                email: emailController.text,
                sex: currentCustomer.personalInfo.sex ?? '',
              );

              await _authProvider.updateCustomerPersonalInfo(
                customerId: currentCustomer.customerId,
                personalInfo: _personalInfo,
                gender: dropdownvalue,
              );

              _createAppointmentProvider.nextPageView(3);
            } else {
              setState(() => loader = true);

              // CHECK IF WE HAVE THIS NUMBER IN OUT DB
              final CustomerModel? customer = await CustomerApi().findCustomer('$countryCode${phoneNumberController.text.trim()}');

              // IF IT EXISTS - GRAB CUSTOMER INFO
              if (customer != null) {
                // UPDATE CUSTOMER INFO
                PersonalInfo personalInfo = PersonalInfo(
                  phone: '$countryCode${phoneNumberController.text}',
                  firstName: firstNameController.text,
                  lastName: lastNameController.text,
                  email: emailController.text,
                  sex: pronounceController.text,
                );

                await CustomerApi().updatePersonalInfo(
                  customerId: customer.customerId,
                  personalInfo: personalInfo,
                );

                // SET AS CURRENT CUSTOMER
                _authProvider.setCurrentCustomer(customer);
                // Go to PageView Order List Screen
                _createAppointmentProvider.nextPageView(3);
              } else {
                // IF IT DOESN'T EXISTS - JUMP TO PAGE TO INPUT INFO
                // CREATE NEW CUSTOMER DOCUMENT

                final CustomerModel? createdCustomer = await CustomerApi().createNewCustomer(
                  personalInfo: PersonalInfo(
                    phone: '$countryCode${phoneNumberController.text}',
                    firstName: firstNameController.text,
                    lastName: lastNameController.text,
                    description: "",
                    dob: null,
                    email: emailController.text,
                    sex: pronounceController.text,
                  ),
                );

                if (createdCustomer != null) {
                  _authProvider.setCurrentCustomer(createdCustomer);

                  setState(() => loader = false);

                  _createAppointmentProvider.nextPageView(1);
                } else {
                  setState(() => loader = false);
                  return;
                }
              }
            }
          },
          color: dialogButtonColor(themeType, theme),
          textColor: loaderColor(themeType),
          height: 60,
          label: AppLocalizations.of(context)?.confirmMyDetails ?? "Confirm my details",
          isLoading: (_authProvider.updateCustomerPersonalInfoStatus == Status.loading) || loader,
          loaderColor: loaderColor(themeType),
          suffixIcon: Icon(
            Icons.arrow_forward_ios_rounded,
            color: loaderColor(themeType),
            size: 18.sp,
          ),
          fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
        ),
      ],
    );
  }
}
