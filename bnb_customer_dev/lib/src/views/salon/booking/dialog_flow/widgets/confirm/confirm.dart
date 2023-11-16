import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/create_apntmnt_provider/create_appointment_provider.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/salon/booking/dialog_flow/widgets/confirm/enter_number.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'order_details.dart';
import 'registration_successful.dart';
import 'verify_otp.dart';

class Confirmation extends ConsumerStatefulWidget {
  final TabController bookingTabController;
  const Confirmation({Key? key, required this.bookingTabController}) : super(key: key);

  @override
  ConsumerState<Confirmation> createState() => _ConfirmationState();
}

class _ConfirmationState extends ConsumerState<Confirmation> {
  @override
  Widget build(BuildContext context) {
    final CreateAppointmentProvider _createAppointmentProvider = ref.watch(createAppointmentProvider);
    final _salonProfileProvider = ref.watch(salonProfileProvider);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: DeviceConstraints.getResponsiveSize(context, 17.w, 20.w, 20.w),
      ),
      child: Column(
        children: [
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _createAppointmentProvider.confirmationPageController,
              children: [
                EnterNumber(
                  tabController: widget.bookingTabController,
                  countryCodeName: _salonProfileProvider.chosenSalon.countryCode ?? 'US',
                ),
                if (_salonProfileProvider.chosenSalon.countryCode == 'US') const VerifyOtp(),
                const RegistrationSuccessful(),
                OrderDetails(tabController: widget.bookingTabController),
              ],
            ),
          )
        ],
      ),
    );
  }
}


// if no deposit
// - book appointment

// if there's deposit
// - pay deposit


// on transaction listen
// - create card sub collection in customer
// - if card referencfe is present (not null), add card


// card no
// card exp
// card ref
// card type
// merchant ref
// stored credential use