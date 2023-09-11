import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/create_apntmnt_provider/create_appointment_provider.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/salon_master/master.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/salon/booking/dialog_flow/widgets/confirm/confirm.dart';
import 'package:bbblient/src/views/salon/booking/dialog_flow/widgets/service_tab/service_tab.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'widgets/day_and_time/day_and_time.dart';

class BookingDialogWidget222<T> extends ConsumerStatefulWidget {
  final bool master;
  final MasterModel? masterModel;

  const BookingDialogWidget222({Key? key, this.master = false, this.masterModel}) : super(key: key);

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
    ThemeType themeType = _salonProfileProvider.themeType;

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
                      GestureDetector(
                        onTap: () {
                          if (_createAppointmentProvider.confirmationPageIndex != null) {
                            // START OF CONFIRMATION PAGE VIEW
                            if (_createAppointmentProvider.confirmationPageIndex == 0) {
                              bookingTabController?.animateTo(_createAppointmentProvider.bookingFlowPageIndex - 1);
                              _createAppointmentProvider.changeBookingFlowIndex(decrease: true);

                              return;
                            }

                            /// VERIFY OTP PAGE
                            if (_createAppointmentProvider.confirmationPageIndex! > 0) {
                              _createAppointmentProvider.nextPageView(0);

                              return;
                            }

                            _createAppointmentProvider.nextPageView(_createAppointmentProvider.confirmationPageIndex! - 1);

                            return;
                          }

                          if (_createAppointmentProvider.bookingFlowPageIndex == 0) {
                            Navigator.pop(context);
                            return;
                          }
                          bookingTabController?.animateTo(_createAppointmentProvider.bookingFlowPageIndex - 1);
                          _createAppointmentProvider.changeBookingFlowIndex(decrease: true);
                        },
                        child: Padding(
                          padding: EdgeInsets.only(left: 20.sp),
                          child: Icon(
                            Icons.arrow_back_ios_rounded,
                            color: theme.colorScheme.tertiary.withOpacity(0.6),
                            size: DeviceConstraints.getResponsiveSize(context, 20.sp, 20.sp, 20.sp),
                          ),
                        ),
                      ),
                      const Spacer(flex: 2),
                      GestureDetector(
                        // onTap: () => const ThankYou().show(context),
                        child: Text(
                          (AppLocalizations.of(context)?.onlineBooking ?? 'ONLINE BOOKING').toUpperCase(),
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontSize: DeviceConstraints.getResponsiveSize(context, 18.sp, 18.sp, 20.sp),
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Inter-Medium',
                            color: theme.colorScheme.onBackground,
                          ),
                        ),
                      ),
                      const Spacer(flex: 2),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          _createAppointmentProvider.resetFlow();
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: 20.sp),
                          child: Icon(
                            Icons.close_rounded,
                            color: theme.colorScheme.tertiary.withOpacity(0.6),
                            size: DeviceConstraints.getResponsiveSize(context, 20.sp, 22.sp, 24.sp),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Space(factor: 2),
                  // -- TAB BAR
                  Expanded(
                    flex: 0,
                    child: SizedBox(
                      height: 50.sp,
                      width: DeviceConstraints.getResponsiveSize(
                        context,
                        mediaQuery.width / 1.1,
                        double.infinity - 15,
                        mediaQuery.width / 2.7,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 6.sp, horizontal: 10.sp),
                        child: Center(
                          child: IgnorePointer(
                            child: TabBar(
                              controller: bookingTabController,
                              labelStyle: theme.tabBarTheme.labelStyle!.copyWith(
                                fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
                                fontWeight: FontWeight.normal,
                                letterSpacing: 0.5,
                                color: tabTitleColor(themeType, theme), //  isLightTheme ? Colors.black : Colors.white,
                                fontFamily: 'Inter',
                              ),
                              labelColor: tabTitleColor(themeType, theme), // isLightTheme ? Colors.black : Colors.white,
                              indicatorColor: theme.primaryColor,
                              indicatorSize: TabBarIndicatorSize.label,
                              tabs: [
                                Tab(
                                  text: AppLocalizations.of(context)?.services ?? 'Services',
                                ),
                                Tab(
                                  text: AppLocalizations.of(context)?.dayAndTime ?? 'Day & Time',
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
                          ServiceTab(
                            tabController: bookingTabController!,
                            master: widget.master,
                            masterModel: widget.masterModel,
                          ),

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

Color? tabTitleColor(ThemeType themeType, ThemeData theme) {
  switch (themeType) {
    case ThemeType.GlamMinimalLight:
      return Colors.black;
    case ThemeType.GlamMinimalDark:
      return Colors.white;
    case ThemeType.GlamLight:
      return Colors.black;
    case ThemeType.Glam:
      return Colors.white;
    case ThemeType.DefaultLight:
      return Colors.black;

    default:
      return theme.colorScheme.tertiary;
  }
}
