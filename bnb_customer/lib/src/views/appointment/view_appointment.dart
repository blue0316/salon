import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/firebase/salons.dart';
import 'package:bbblient/src/models/appointment/appointment.dart';
import 'package:bbblient/src/models/backend_codings/appointment.dart';
import 'package:bbblient/src/models/enums/status.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/routes.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/widgets/buttons.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'widgets/appointment_header.dart';
import 'widgets/row.dart';

class AppointmentViewDetails extends ConsumerStatefulWidget {
  static const route = "/appointments";
  final String appointmentDocId;

  const AppointmentViewDetails({Key? key, required this.appointmentDocId}) : super(key: key);

  @override
  ConsumerState<AppointmentViewDetails> createState() => _AppointmentViewDetailsState();
}

class _AppointmentViewDetailsState extends ConsumerState<AppointmentViewDetails> {
  AppointmentModel? appointment;
  SalonModel? salon;

  @override
  void initState() {
    super.initState();

    fetchDetails(); //appointments?id=yzoxnaZkcoWp0LxeM9hC
  }

  void fetchDetails() async {
    // Get Appointment
    appointment = await ref.read(appointmentProvider.notifier).fetchAppointment(
          appointmentID: widget.appointmentDocId,
        );

    // Get Salon
    salon = await SalonApi().getSalonFromId(appointment?.salon.id);

    // Get Salon Theme
    ref.read(appointmentProvider.notifier).getSalonTheme(salon?.salonId);
  }

  bool shouldShowConfirmButton(DateTime appointmentTime) {
    final currentTime = DateTime.now();
    final timeDifference = appointmentTime.difference(currentTime);
    return timeDifference.inHours < 25;
  }

  @override
  Widget build(BuildContext context) {
    // AppointmentModel appointment
    final _appointmentProvider = ref.watch(appointmentProvider);
    ThemeData theme = _appointmentProvider.salonTheme ?? AppTheme.customLightTheme;

    return Scaffold(
      body: _appointmentProvider.appointmentStatus == Status.loading
          ? const Center(child: CircularProgressIndicator())
          : _appointmentProvider.appointmentStatus == Status.failed
              ? const ErrorScreen()
              : Column(
                  children: [
                    Header(
                      salonName: salon?.salonName ?? '',
                      salonLogo: salon?.salonLogo,
                      salonAddress: salon?.address,
                      salonPhone: salon?.phoneNumber,
                    ),
                    const SizedBox(height: 56),
                    Expanded(
                      child: Container(
                        height: 700,
                        width: double.infinity,
                        color: Colors.orange,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                height: 500,
                                width: double.infinity,
                                color: Colors.black,
                              ),
                              Container(
                                height: 500,
                                width: double.infinity,
                                color: Colors.teal,
                              ),
                              Container(
                                height: 400,
                                width: double.infinity,
                                color: Colors.green,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.symmetric(
                    //     vertical: 20.0,
                    //     horizontal: DeviceConstraints.getResponsiveSize(context, 10.w, 20.w, 70.w),
                    //   ),
                    //   child: Container(
                    //     decoration: BoxDecoration(
                    //       color: Colors.white,
                    //       border: Border.all(width: 0.5, color: Colors.black),
                    //       borderRadius: BorderRadius.circular(10),
                    //     ),
                    //     child: (appointment != null)
                    //         ? Padding(
                    //             padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
                    //             child: Column(
                    //               crossAxisAlignment: CrossAxisAlignment.center,
                    //               mainAxisAlignment: MainAxisAlignment.start,
                    //               children: [
                    //                 AppointmentDetailRow(
                    //                   title: 'Date',
                    //                   value: '${appointment?.appointmentDate}',
                    //                 ),
                    //                 AppointmentDetailRow(
                    //                   title: 'Time',
                    //                   value: '${appointment?.appointmentTime}',
                    //                 ),
                    //                 AppointmentDetailRow(
                    //                   title: 'Price',
                    //                   value: '${appointment?.priceAndDuration.price}',
                    //                 ),
                    //                 AppointmentDetailRow(
                    //                   title: 'Duration',
                    //                   value: '${appointment?.priceAndDuration.duration} minutes',
                    //                 ),
                    //                 Space(factor: DeviceConstraints.getResponsiveSize(context, 3, 2, 1)),
                    //                 Text(
                    //                   'Customer Details'.toUpperCase(),
                    //                   style: TextStyle(
                    //                     color: Colors.black,
                    //                     fontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 18.sp, 25.sp),
                    //                     fontWeight: FontWeight.w600,
                    //                   ),
                    //                 ),
                    //                 const SizedBox(height: 20),

                    //                 AppointmentDetailRow(
                    //                   title: 'Name',
                    //                   value: '${appointment?.customer?.name}',
                    //                 ),
                    //                 AppointmentDetailRow(
                    //                   title: 'Phone number',
                    //                   value: '${appointment?.customer?.phoneNumber}',
                    //                 ),
                    //                 // const SizedBox(height: 20),
                    //                 Space(factor: DeviceConstraints.getResponsiveSize(context, 3, 2, 1)),

                    //                 Text(
                    //                   'Master'.toUpperCase(),
                    //                   style: TextStyle(
                    //                     color: Colors.black,
                    //                     fontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 18.sp, 25.sp),
                    //                     fontWeight: FontWeight.w600,
                    //                   ),
                    //                 ),
                    //                 const SizedBox(height: 20),

                    //                 AppointmentDetailRow(
                    //                   title: 'Name',
                    //                   value: '${appointment?.master?.name}',
                    //                 ),
                    //                 AppointmentDetailRow(
                    //                   title: 'Phone number',
                    //                   value: '${appointment?.customer?.phoneNumber}',
                    //                 ),
                    //                 const Spacer(),

                    //                 if (appointment?.status == AppointmentStatus.cancelled)
                    //                   Text(
                    //                     'Your appointment has been cancelled!',
                    //                     style: TextStyle(
                    //                       color: AppTheme.creamBrown,
                    //                       fontSize: DeviceConstraints.getResponsiveSize(context, 18.sp, 20.sp, 25.sp),
                    //                     ),
                    //                     textAlign: TextAlign.center,
                    //                   ),
                    //                 if (appointment?.status == AppointmentStatus.cancelled) const SizedBox(height: 20),
                    //                 Column(
                    //                   children: [
                    //                     if (appointment?.subStatus == AppointmentSubStatus.confirmed)
                    //                       Text(
                    //                         'Your appointment has been confirmed!',
                    //                         style: TextStyle(
                    //                           color: AppTheme.creamBrown,
                    //                           fontSize: DeviceConstraints.getResponsiveSize(context, 18.sp, 20.sp, 25.sp),
                    //                         ),
                    //                         textAlign: TextAlign.center,
                    //                       ),
                    //                     if (appointment?.subStatus != AppointmentSubStatus.confirmed && shouldShowConfirmButton(appointment!.appointmentStartTime))
                    //                       DefaultButton(
                    //                         label: 'CONFIRM APPOINTMENT',
                    //                         borderRadius: 30,
                    //                         color: Colors.white,
                    //                         borderColor: Colors.black,
                    //                         textColor: Colors.black,
                    //                         onTap: () => _appointmentProvider.updateAppointmentSubStatus(
                    //                           appointmentID: widget.appointmentDocId,
                    //                           callback: () {
                    //                             fetchDetails();
                    //                           },
                    //                         ),
                    //                         isLoading: _appointmentProvider.updateSubStatus == Status.loading,
                    //                       ),
                    //                     const SizedBox(height: 10),
                    //                     if (appointment?.status != AppointmentStatus.cancelled)
                    //                       DefaultButton(
                    //                         label: 'CANCEL APPOINTMENT',
                    //                         borderRadius: 30,
                    //                         color: Colors.black,
                    //                         textColor: Colors.white,
                    //                         onTap: () => _appointmentProvider.cancelAppointment(
                    //                           appointmentID: widget.appointmentDocId,
                    //                           callback: () {
                    //                             fetchDetails();
                    //                           },
                    //                         ),
                    //                       ),
                    //                   ],
                    //                 ),
                    //               ],
                    //             ),
                    //           )
                    //         : Center(
                    //             child: Text(
                    //               'Appointment does not exists',
                    //               style: TextStyle(
                    //                 color: AppTheme.creamBrown,
                    //                 fontSize: DeviceConstraints.getResponsiveSize(context, 18.sp, 20.sp, 25.sp),
                    //               ),
                    //               textAlign: TextAlign.center,
                    //             ),
                    //           ),
                    //   ),
                    // ),
                  ],
                ),
    );
  }
}
