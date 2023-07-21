import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/authentication/auth_provider.dart';
import 'package:bbblient/src/controller/create_apntmnt_provider/create_appointment_provider.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/customer/customer.dart';
import 'package:bbblient/src/models/enums/status.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/views/salon/booking/dialog_flow/widgets/colors.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:bbblient/src/views/widgets/buttons.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
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

  @override
  Widget build(BuildContext context) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final AuthProvider _authProvider = ref.watch(authProvider);
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
            fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
            color: theme.colorScheme.tertiary,
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
            ),
          ),
        ),

        SizedBox(height: 15.sp),

        Container(
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0XFF35373B), width: 0.5)),
          ),
          child: !isOther
              ? DropdownButtonHideUnderline(
                  child: DropdownButton(
                    dropdownColor: const Color(0XFF1F1F21),
                    hint: Text(
                      AppLocalizations.of(context)?.pronounce ?? 'Pronounce',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
                        color: theme.colorScheme.tertiary.withOpacity(0.6),
                      ),
                    ),

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
                  ),
                ),
        ),

        const Spacer(),
        DefaultButton(
          borderRadius: 60,
          onTap: () async {
            // bool enabledOTP = _salonProfileProvider.themeSettings?.displaySettings?.enableOTP ?? true;
            // Check if fields are filled
            if (firstNameController.text.isEmpty || emailController.text.isEmpty || lastNameController.text.isEmpty) {
              showToast(AppLocalizations.of(context)?.emptyFields ?? "Field cannot be empty, please fill the required fields");
              return;
            }

            CustomerModel? currentCustomer = _authProvider.currentCustomer;

            PersonalInfo _personalInfo;
            // bool success;

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
            );

            _createAppointmentProvider.nextPageView(3);

            // // Create Appointment
            // CustomerModel customer = CustomerModel(
            //   customerId: currentCustomer!.customerId,
            //   personalInfo: _personalInfo,
            //   registeredSalons: [],
            //   createdAt: DateTime.now(),
            //   avgRating: 3.0,
            //   noOfRatings: 6,
            //   profilePicUploaded: false,
            //   profilePic: "",
            //   profileCompleted: false,
            //   quizCompleted: false,
            //   preferredGender: "male",
            //   preferredCategories: [],
            //   locations: [],
            //   fcmToken: "",
            //   locale: "en",
            //   favSalons: [],
            //   referralLink: "",
            // );

            // if (enabledOTP == false) {
            //   // Since enableOTP is false, customer did not login

            //   _authProvider.setCurrentCustomerWithoutOTP(
            //     firstName: firstNameController.text,
            //     lastName: lastNameController.text,
            //     email: emailController.text,
            //   );

            //   currentCustomer = _authProvider.currentCustomerWithoutOTP;

            //   _personalInfo = PersonalInfo(
            //     phone: _authProvider.phoneNoController.text,
            //     firstName: firstNameController.text,
            //     lastName: lastNameController.text,
            //     email: emailController.text,
            //   );
            // } else {
            //   currentCustomer = _authProvider.currentCustomer;

            //   _personalInfo = PersonalInfo(
            //     phone: currentCustomer!.personalInfo.phone,
            //     firstName: firstNameController.text,
            //     lastName: lastNameController.text,
            //     description: currentCustomer.personalInfo.description ?? '',
            //     dob: currentCustomer.personalInfo.dob ?? DateTime.now().subtract(const Duration(days: 365 * 26)),
            //     email: emailController.text,
            //     sex: currentCustomer.personalInfo.sex ?? '',
            //   );
            // }

            // if (enabledOTP) {
            //   // update name and email of customer in customer collection
            //   success = await _authProvider.updateCustomerPersonalInfo(
            //     customerId: _authProvider.currentCustomer!.customerId,
            //     personalInfo: _personalInfo,
            //   );
            // } else {
            //   success = true;
            // }

            // _authProvider.updateCurrentCustomerToFinishBooking(customer);

            // if (success) {
            //   // Move to next screen
            //   _createAppointmentProvider.nextPageView(3);
            // } else {
            //   showToast(AppLocalizations.of(context)?.somethingWentWrongPleaseTryAgain ?? "Something went wrong, please try again");
            //   showToast("Something went wrong, please try again");
            // }
          },
          color: dialogButtonColor(themeType, theme),
          textColor: loaderColor(themeType),
          height: 60,
          label: AppLocalizations.of(context)?.confirmMyDetails ?? "Confirm my details",
          isLoading: (_authProvider.updateCustomerPersonalInfoStatus == Status.loading),
          loaderColor: loaderColor(themeType),
          suffixIcon: Icon(
            Icons.arrow_forward_ios_rounded,
            color: loaderColor(themeType),
            size: 18.sp,
          ),
          fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
        ),
        // SizedBox(height: 15.h),
        // DefaultButton(
        //   borderRadius: 60,
        //   onTap: () {
        //     _createAppointmentProvider.nextPageView(1);
        //   },
        //   color: dialogBackButtonColor(themeType, theme), // defaultTheme ? Colors.white :
        //   borderColor: theme.primaryColor, // defaultTheme ? Colors.black : theme.primaryColor,
        //   textColor: theme.colorScheme.tertiary, // defaultTheme ? Colors.black : theme.primaryColor,

        //   // color: defaultTheme ? Colors.white : Colors.transparent,
        //   // borderColor: defaultTheme ? Colors.black : theme.primaryColor,
        //   // textColor: defaultTheme ? Colors.black : theme.primaryColor,
        //   height: 60,
        //   label: AppLocalizations.of(context)?.back ?? 'Back',
        // ),
      ],
    );
  }
}
