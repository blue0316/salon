import 'dart:math';

import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/authentication/auth_provider.dart';
import 'package:bbblient/src/controller/create_apntmnt_provider/create_appointment_provider.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/backend_codings/owner_type.dart';
import 'package:bbblient/src/models/customer/customer.dart';
import 'package:bbblient/src/models/enums/status.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/views/widgets/buttons.dart';
import 'package:bbblient/src/views/widgets/text_fields.dart';
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
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final AuthProvider _authProvider = ref.watch(authProvider);
    final CreateAppointmentProvider _createAppointmentProvider = ref.watch(createAppointmentProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;
    bool defaultTheme = (theme == AppTheme.lightTheme);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)?.verificationSuccessful.toCapitalized() ?? 'Verification was successful!',
          style: theme.textTheme.bodyLarge!.copyWith(
            fontSize: DeviceConstraints.getResponsiveSize(context, 20.sp, 20.sp, 20.sp),
            color: defaultTheme ? Colors.black : Colors.white,
          ),
        ),

        const Space(factor: 2),

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
          controller: nameController,
          hint: AppLocalizations.of(context)?.pleaseEnterFirstName.toCapitalized() ?? "Enter first name",
          borderWidth: 0.7,
          vPadding: 20.h,
          textColor: defaultTheme ? Colors.black : Colors.white,
          borderColor: defaultTheme ? AppTheme.lightGrey : Colors.white,
          onChanged: (String val) {
            _authProvider.firstName = val;
          },
        ),

        Space(factor: DeviceConstraints.getResponsiveSize(context, 2.5, 2, 2)),

        // -- Your Email
        Text(
          "Your ${AppLocalizations.of(context)?.email.toCapitalized() ?? "Email"}",
          style: theme.textTheme.bodyLarge?.copyWith(
            fontSize: 18.sp,
            color: defaultTheme ? AppTheme.textBlack : Colors.white,
          ),
        ),

        const Space(factor: 1.3),

        BNBTextField(
          controller: emailController,
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
          style: theme.textTheme.bodyMedium?.copyWith(
            color: defaultTheme ? AppTheme.textBlack : Colors.white,
          ),
        ),
        const Spacer(),
        DefaultButton(
          borderRadius: 60,
          onTap: () async {
            bool enabledOTP = _salonProfileProvider.themeSettings?.displaySettings?.enableOTP ?? true;
            // Check if fields are filled
            if (nameController.text.isEmpty || emailController.text.isEmpty) {
              showToast(AppLocalizations.of(context)?.emptyFields ?? "Field cannot be empty, please fill the required fields");
              return;
            }

            CustomerModel? currentCustomer;
            PersonalInfo _personalInfo;
            bool success;

            if (enabledOTP == false) {
              // Since enableOTP is false, customer did not login

              _authProvider.setCurrentCustomerWithoutOTP(firstName: nameController.text, email: emailController.text);

              currentCustomer = _authProvider.currentCustomerWithoutOTP;

              _personalInfo = PersonalInfo(
                phone: _authProvider.phoneNoController.text,
                firstName: nameController.text,
                lastName: '',
                email: emailController.text,
              );
            } else {
              currentCustomer = _authProvider.currentCustomer;

              _personalInfo = PersonalInfo(
                phone: currentCustomer!.personalInfo.phone,
                firstName: nameController.text,
                lastName: currentCustomer.personalInfo.lastName,
                description: currentCustomer.personalInfo.description ?? '',
                dob: currentCustomer.personalInfo.dob ?? DateTime.now().subtract(const Duration(days: 365 * 26)),
                email: emailController.text,
                sex: currentCustomer.personalInfo.sex ?? '',
              );
            }

            if (enabledOTP) {
              // update name and email of customer in customer collection
              success = await _authProvider.updateCustomerPersonalInfo(
                customerId: _authProvider.currentCustomer!.customerId,
                personalInfo: _personalInfo,
              );
            } else {
              success = true;
            }

            // Create Appointment
            CustomerModel customer = CustomerModel(
              customerId: currentCustomer!.customerId,
              personalInfo: _personalInfo,
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

            // _authProvider.updateCurrentCustomerToFinishBooking(customer);

            if (success) {
              // Move to next screen
              _createAppointmentProvider.nextPageView(3);
            } else {
              showToast(AppLocalizations.of(context)?.somethingWentWrongPleaseTryAgain ?? "Something went wrong, please try again");
              showToast("Something went wrong, please try again");
            }
          },
          color: defaultTheme ? Colors.black : theme.primaryColor,
          textColor: defaultTheme ? Colors.white : Colors.black,
          height: 60,
          label: AppLocalizations.of(context)?.nextStep ?? 'Next Step',
          isLoading: (_authProvider.updateCustomerPersonalInfoStatus == Status.loading),
          loaderColor: defaultTheme ? Colors.white : Colors.black,
        ),
        SizedBox(height: 15.h),
        DefaultButton(
          borderRadius: 60,
          onTap: () {
            _createAppointmentProvider.nextPageView(1);
          },
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
