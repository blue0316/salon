import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/firebase/salons.dart';
import 'package:bbblient/src/models/appointment/appointment.dart';
import 'package:bbblient/src/models/backend_codings/appointment.dart';
import 'package:bbblient/src/models/enums/status.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/routes.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'details/services_details.dart';
import 'details/your_details.dart';
import 'widgets/appointment_header.dart';
import 'widgets/button.dart';
import 'widgets/calendar_buttons.dart';
import 'widgets/date_time_price.dart';
import 'widgets/theme_colors.dart';

class AppointmentViewDetails extends ConsumerStatefulWidget {
  static const route = "/appointments";
  final String appointmentDocId;

  const AppointmentViewDetails({Key? key, required this.appointmentDocId}) : super(key: key);

  @override
  ConsumerState<AppointmentViewDetails> createState() => _AppointmentViewDetailsState();
}

class _AppointmentViewDetailsState extends ConsumerState<AppointmentViewDetails> {
  AppointmentModel? appointment;

  @override
  void initState() {
    super.initState();

    fetchDetails();
  }

  void fetchDetails() async {
    // Get Appointment
    appointment = await ref.read(appointmentProvider.notifier).fetchAppointment(
          appointmentID: widget.appointmentDocId,
        );

    // // Get Salon
    // salon = await SalonApi().getSalonFromId(appointment?.salon.id);

    // Get Salon Theme
    // ref.read(appointmentProvider.notifier).getSalonTheme(salon?.salonId);
  }

  bool shouldShowConfirmButton(DateTime appointmentTime) {
    final currentTime = DateTime.now();
    final timeDifference = appointmentTime.difference(currentTime);
    return timeDifference.inHours < 25;
  }

  final ScrollController serviceController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final _appointmentProvider = ref.watch(appointmentProvider);
    ThemeData theme = _appointmentProvider.salonTheme ?? AppTheme.customLightTheme;
    ThemeType themeType = _appointmentProvider.themeType ?? ThemeType.DefaultLight;

    return Scaffold(
      backgroundColor: scaffoldBGColor(themeType, theme),
      body: _appointmentProvider.appointmentStatus == Status.loading
          ? const Center(child: CircularProgressIndicator())
          : _appointmentProvider.appointmentStatus == Status.failed
              ? ErrorScreen(
                  backgroundColor: boxColor(themeType, theme), // isLightTheme ? const Color(0XFFEFEFEF) : theme.colorScheme.background,
                  textColor: confirmationTextColor(themeType, theme), // isLightTheme ? Colors.black : Colors.white,
                )
              : (appointment != null)
                  ? Column(
                      children: [
                        Header(
                          salonName: _appointmentProvider.salon?.salonName ?? '',
                          salonLogo: _appointmentProvider.salon?.salonLogo,
                          salonAddress: _appointmentProvider.salon?.address,
                          salonPhone: _appointmentProvider.salon?.phoneNumber,
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: DeviceConstraints.getResponsiveSize(context, 25, 0, 0),
                            ),
                            child: SizedBox(
                              // height: 700,
                              width: double.infinity,
                              // color: Colors.orange,

                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 30),
                                    Text(
                                      'Appointment confirmation',
                                      style: theme.textTheme.bodyLarge!.copyWith(
                                        fontWeight: FontWeight.w400,
                                        fontSize: DeviceConstraints.getResponsiveSize(context, 20.sp, 30.sp, 40.sp),
                                        color: confirmationTextColor(themeType, theme),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    AddToCalendars(
                                      appointment: appointment!,
                                      appointmentID: widget.appointmentDocId,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 20.0,
                                        horizontal: DeviceConstraints.getResponsiveSize(context, 10.w, 20.w, 70.w),
                                      ),
                                      child: Container(
                                        // height: 700,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          // color: Colors.yellow,
                                          border: Border.all(
                                            color: const Color(0XFF999999),
                                            width: 0.5,
                                          ),
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          vertical: DeviceConstraints.getResponsiveSize(context, 25, 20, 60.0),
                                          horizontal: DeviceConstraints.getResponsiveSize(context, 15, 30, 50),
                                        ),
                                        child: Column(
                                          children: [
                                            DateTimePrice(
                                              appointment: appointment!,
                                              salonModel: _appointmentProvider.salon!,
                                            ),
                                            YourDetails(
                                              appointment: appointment!,
                                            ),
                                            ServiceDetailsSection(
                                              salon: _appointmentProvider.salon!,
                                              appointment: appointment,
                                              listViewController: serviceController,
                                            ),
                                            Wrap(
                                              direction: Axis.horizontal,
                                              crossAxisAlignment: WrapCrossAlignment.center,
                                              runAlignment: WrapAlignment.center,
                                              spacing: 10,
                                              runSpacing: 10,
                                              children: [
                                                if (appointment?.status != AppointmentStatus.cancelled)
                                                  Button(
                                                    text: 'Cancel Appointment',
                                                    onTap: () => _appointmentProvider.cancelAppointment(
                                                      appointmentID: widget.appointmentDocId,
                                                      callback: () {
                                                        fetchDetails();
                                                      },
                                                    ),
                                                    isLoading: _appointmentProvider.cancelAppointmentStatus == Status.loading,
                                                    loaderColor: transparentLoaderColor(themeType, theme),
                                                    borderColor: theme.primaryColor,
                                                    textColor: borderColor(themeType, theme),
                                                  ),
                                                const SizedBox(width: 20),
                                                if (appointment?.subStatus != AppointmentSubStatus.confirmed && shouldShowConfirmButton(appointment!.appointmentStartTime))
                                                  Button(
                                                    text: 'Confirm Appointment',
                                                    buttonColor: confirmButton(themeType, theme),
                                                    textColor: buttonTextColor(themeType),
                                                    onTap: () => _appointmentProvider.updateAppointmentSubStatus(
                                                      appointmentID: widget.appointmentDocId,
                                                      callback: () {
                                                        fetchDetails();
                                                      },
                                                    ),
                                                    isLoading: _appointmentProvider.updateSubStatus == Status.loading,
                                                    loaderColor: loaderColor(themeType, theme),
                                                  ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  : Center(
                      child: Text(
                        'Appointment does not exists',
                        style: TextStyle(
                          color: AppTheme.creamBrown,
                          fontSize: DeviceConstraints.getResponsiveSize(context, 18.sp, 20.sp, 25.sp),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
    );
  }
}
