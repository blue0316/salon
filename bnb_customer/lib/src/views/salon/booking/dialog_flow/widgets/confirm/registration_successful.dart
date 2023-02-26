import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/authentication/auth_provider.dart';
import 'package:bbblient/src/controller/create_apntmnt_provider/create_appointment_provider.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/views/widgets/buttons.dart';
import 'package:bbblient/src/views/widgets/text_fields.dart';
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
          // AppLocalizations.of(context)?.availableMasters.toCapitalized() ?? 'Available masters', // TODO: LOCALIZATIONS
          'Verification was successful!',
          style: theme.textTheme.bodyText1!.copyWith(
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
          controller: _createAppointmentProvider.nameController,
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
        DefaultButton(
          borderRadius: 60,
          onTap: () {
            _createAppointmentProvider.nextPageView(3);
          },
          color: defaultTheme ? Colors.black : theme.primaryColor,
          textColor: defaultTheme ? Colors.white : Colors.black,
          height: 60,
          label: AppLocalizations.of(context)?.next ?? 'Next',

          // label: 'Next step',
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
