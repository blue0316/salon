import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/create_apntmnt_provider/create_appointment_provider.dart';
import 'package:bbblient/src/models/backend_codings/owner_type.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/salon/booking/widgets/confirmation.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'widgets/dayAndTime_section.dart';
import 'widgets/masters_section.dart';

class BookingDialogWidget<T> extends ConsumerStatefulWidget {
  const BookingDialogWidget({Key? key}) : super(key: key);

  Future<void> show(BuildContext context) async {
    await showDialog<T>(
      context: context,
      builder: (context) => this,
    );
  }

  @override
  ConsumerState<BookingDialogWidget<T>> createState() => _BookingDialogWidgetState<T>();
}

class _BookingDialogWidgetState<T> extends ConsumerState<BookingDialogWidget<T>> with SingleTickerProviderStateMixin {
  TabController? bookingTabController;
  late CreateAppointmentProvider createAppointment;

  @override
  void initState() {
    bookingTabController = TabController(vsync: this, length: 3);
    super.initState();
    setUpMasterPrice();
  }

  setUpMasterPrice() {
    createAppointment = ref.read(createAppointmentProvider);
    if (createAppointment.chosenMaster != null) {
      Future.delayed(const Duration(milliseconds: 300), () {
        createAppointment.chooseMaster(masterModel: createAppointment.chosenMaster!, context: context);
      });
    }
  }

  @override
  void dispose() {
    bookingTabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: DeviceConstraints.getResponsiveSize(
          context,
          0,
          mediaQuery.width / 6,
          mediaQuery.width / 6,
        ),
        vertical: DeviceConstraints.getResponsiveSize(context, 0, 50.h, 50.h),
      ),
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10), // , horizontal: 5),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),
                    Text(
                      (DeviceConstraints.getDeviceType(MediaQuery.of(context)) != DeviceScreenType.portrait) ? 'ONLINE BOOKING' : 'Online Booking',
                      style: AppTheme.bodyText1.copyWith(
                        fontSize: DeviceConstraints.getResponsiveSize(context, 25.sp, 25.sp, 40.sp),
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Gilroy',
                      ),
                    ),
                    const Spacer(flex: 2),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: Icon(
                          Icons.close_rounded,
                          color: AppTheme.lightGrey,
                          size: DeviceConstraints.getResponsiveSize(context, 20.h, 30.h, 30.h),
                        ),
                      ),
                    ),
                  ],
                ),

                const Space(factor: 2),
                // -- TAB BAR
                Expanded(
                  flex: 0,
                  child: Container(
                    width: DeviceConstraints.getResponsiveSize(
                      context,
                      double.infinity,
                      double.infinity - 15,
                      mediaQuery.width / 2.7,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 239, 239, 239),
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                      child: Center(
                        child: IgnorePointer(
                          child: TabBar(
                            controller: bookingTabController,
                            unselectedLabelColor: Colors.black,
                            labelColor: Colors.white,
                            labelStyle: AppTheme.bodyText1.copyWith(
                              fontSize: DeviceConstraints.getResponsiveSize(context, 15.h, 15.h, 15.sp),
                            ),
                            indicator: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.black,
                            ),
                            tabs: [
                              Tab(text: (createAppointment.chosenSalon!.ownerType == OwnerType.salon) ? 'Masters' : 'Services'),
                              const Tab(text: 'Day & Time'),
                              const Tab(text: 'Confirm'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30.h),

                // -- TAB BAR VIEW
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: TabBarView(
                      controller: bookingTabController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        // -- MASTERS --
                        DialogMastersSection(
                          tabController: bookingTabController!,
                          createAppointment: createAppointment,
                        ),

                        // -- DAY AND TIME --
                        DialogDateAndTimeSection(
                          tabController: bookingTabController!,
                          createAppointment: createAppointment,
                        ),

                        // -- CONFIRMATION --
                        const ConfirmationSection(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
