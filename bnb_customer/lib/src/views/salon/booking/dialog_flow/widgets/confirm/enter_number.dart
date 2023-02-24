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

    final ThemeData theme = _salonProfileProvider.salonTheme;
    bool defaultTheme = (theme == AppTheme.lightTheme);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          // AppLocalizations.of(context)?.availableMasters.toCapitalized() ?? 'Available masters', // TODO: LOCALIZATIONS
          'Your phone number',
          style: theme.textTheme.bodyText1!.copyWith(
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
                    // _authProvider.countryCode = val.dialCode ?? '';
                  },
                  onInit: (val) {
                    // _authProvider.countryCode = val?.dialCode ?? '';
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
            _createAppointmentProvider.nextPageView(1);
          },
          color: defaultTheme ? Colors.black : theme.primaryColor,
          textColor: defaultTheme ? Colors.white : Colors.black,
          height: 60,
          label: AppLocalizations.of(context)?.verify ?? 'Verify',

          // label: 'Next step',
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
