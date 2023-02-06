import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/create_apntmnt_provider/create_appointment_provider.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/views/widgets/buttons.dart';
import 'package:bbblient/src/views/widgets/text_fields.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserDetailsVerification extends ConsumerWidget {
  const UserDetailsVerification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CreateAppointmentProvider _createAppointmentProvider = ref.watch(createAppointmentProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Space(factor: 1),

        // -- Your Name
        Text(
          "Your ${AppLocalizations.of(context)?.name.toCapitalized() ?? "Name"}*",
          style: AppTheme.bodyText1.copyWith(
            fontSize: 18.sp,
          ),
        ),

        const Space(factor: 1.3),

        BNBTextField(
          controller: _createAppointmentProvider.nameController,
          hint: AppLocalizations.of(context)?.pleaseEnterFirstName.toCapitalized() ?? "Enter first name",
          border: AppTheme.lightGrey,
          borderWidth: 0.7,
          vPadding: 20.h,
          // horizontal: DeviceConstraints.getResponsiveSize(context, 2.5, 2, 2),
        ),

        Space(factor: DeviceConstraints.getResponsiveSize(context, 2.5, 2, 2)),

        // -- Your phone number
        Text(
          "Your ${AppLocalizations.of(context)?.phoneNumber.toCapitalized() ?? "Phone Number"}*",
          style: AppTheme.bodyText1.copyWith(
            fontSize: 18.sp,
          ),
        ),

        const Space(factor: 1.3),

        BNBTextField(
          controller: _createAppointmentProvider.phoneController,
          hint: AppLocalizations.of(context)?.phoneNumber.toCapitalized() ?? "Phone Number",
          border: AppTheme.lightGrey,
          borderWidth: 0.7,
          vPadding: 20.h,
        ),

        Space(factor: DeviceConstraints.getResponsiveSize(context, 2.5, 2, 2)),

        // -- Your Email
        Text(
          "Your ${AppLocalizations.of(context)?.email.toCapitalized() ?? "Email"}",
          style: AppTheme.bodyText1.copyWith(
            fontSize: 18.sp,
          ),
        ),

        const Space(factor: 1.3),

        BNBTextField(
          controller: _createAppointmentProvider.emailController,
          hint: AppLocalizations.of(context)?.registration_line4.toCapitalized() ?? "Enter E-mail",
          border: AppTheme.lightGrey,
          borderWidth: 0.7,
          vPadding: 20.h,
        ),

        const Space(factor: 1.5),

        Text(
          "*Mandatory fields",
          style: AppTheme.bodyText2.copyWith(
            color: AppTheme.textBlack,
          ),
        ),

        const Spacer(),
        DefaultButton(
          borderRadius: 60,
          onTap: () => _createAppointmentProvider.verifyControllers(),
          color: Colors.black,
          height: 60,
          label: 'Next step',
        ),
        SizedBox(height: 20.h),
      ],
    );
  }
}
