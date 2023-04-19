import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/create_apntmnt_provider/create_appointment_provider.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/views/salon/booking/dialog_flow/widgets/confirm/confirm.dart';
import 'package:bbblient/src/views/salon/booking/dialog_flow/widgets/service_tab/service_tab.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'widgets/day_and_time/day_and_time.dart';

class BookingDialogWidget222<T> extends ConsumerStatefulWidget {
  final bool master;
  const BookingDialogWidget222({Key? key, this.master = false}) : super(key: key);

  Future<void> show(BuildContext context) async {
    await showDialog<T>(
      context: context,
      builder: (context) => this,
    );
  }

  @override
  ConsumerState<BookingDialogWidget222<T>> createState() => _BookingDialogWidget222State<T>();
}

class _BookingDialogWidget222State<T> extends ConsumerState<BookingDialogWidget222<T>> with SingleTickerProviderStateMixin {
  TabController? bookingTabController;
  late CreateAppointmentProvider createAppointment11;

  @override
  void initState() {
    bookingTabController = TabController(vsync: this, length: 3);
    super.initState();
    setUpMasterPrice();
  }

  setUpMasterPrice() {
    createAppointment11 = ref.read(createAppointmentProvider);
    if (createAppointment11.chosenMaster != null) {
      Future.delayed(const Duration(milliseconds: 300), () {
        createAppointment11.chooseMaster(masterModel: createAppointment11.chosenMaster!, context: context);
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
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final CreateAppointmentProvider _createAppointmentProvider = ref.watch(createAppointmentProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;
    bool defaultTheme = (theme == AppTheme.lightTheme);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Dialog(
        backgroundColor: theme.dialogBackgroundColor,
        insetPadding: EdgeInsets.symmetric(
          horizontal: DeviceConstraints.getResponsiveSize(
            context,
            0,
            20, // mediaQuery.width / 5,
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
                        (DeviceConstraints.getDeviceType(MediaQuery.of(
                                  context,
                                )) !=
                                DeviceScreenType.portrait)
                            ? AppLocalizations.of(context)?.onlineBooking.toUpperCase() ?? 'ONLINE BOOKING'
                            : AppLocalizations.of(context)?.onlineBooking.toCapitalized() ?? 'Online Booking',
                        style: AppTheme.bodyText1.copyWith(
                          fontSize: DeviceConstraints.getResponsiveSize(context, 25.sp, 25.sp, 40.sp),
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',

                          color: defaultTheme ? AppTheme.textBlack : Colors.white,

                          // color: a.black,
                        ),
                      ),
                      const Spacer(flex: 2),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          _createAppointmentProvider.resetFlow();
                        },
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
                        color: defaultTheme ? const Color.fromARGB(255, 239, 239, 239) : const Color(0XFF202020),
                        borderRadius: BorderRadius.circular(60),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                        child: Center(
                          child: IgnorePointer(
                            child: Theme(
                              data: ThemeData(tabBarTheme: theme.tabBarTheme),
                              child: TabBar(
                                controller: bookingTabController,
                                labelStyle: theme.tabBarTheme.labelStyle!.copyWith(
                                  fontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 20.sp, 18.sp),
                                ),
                                unselectedLabelColor: defaultTheme ? Colors.black : Colors.white,
                                tabs: [
                                  Tab(
                                    text: AppLocalizations.of(context)?.services ?? 'Services',
                                  ),
                                  const Tab(
                                    text: 'Day & Time', // TODO - LOCALIZATIONS
                                  ),
                                  Tab(
                                    text: AppLocalizations.of(context)?.registration_line16 ?? 'Confirm',
                                  ),
                                ],
                              ),
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
                          // Service
                          ServiceTab(tabController: bookingTabController!),

                          // Day And Time
                          DayAndTime(tabController: bookingTabController!),

                          // Confirm
                          Confirmation(bookingTabController: bookingTabController!),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
