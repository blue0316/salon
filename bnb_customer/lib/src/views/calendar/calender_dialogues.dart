import 'package:bbblient/src/firebase/appointments.dart';
import 'package:bbblient/src/models/backend_codings/appointment.dart';
import 'package:bbblient/src/models/backend_codings/owner_type.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/keys.dart';
import 'package:bbblient/src/views/home/map_view/map_view_single_salon.dart';
import 'package:bbblient/src/views/review/make_review.dart';
import 'package:bbblient/src/views/widgets/buttons.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../models/appointment/appointment.dart';
import '../../theme/app_main_theme.dart';
import '../../utils/icons.dart';
import '../../utils/time.dart';
import '../../utils/utils.dart';
import '../widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

showAppointmentDetails(
  BuildContext context,
  AppointmentModel appointment,
  SalonModel? salon,
) {
  return showDialog(
      context: context,
      builder: (context) {
        final String _date = Time().getLocaleDate(appointment.appointmentStartTime, 'uk');
        final String _time = Time().getAppointmentStartEndTime(appointment)!;
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            width: 340.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 44.h,
                  decoration: const BoxDecoration(
                    color: AppTheme.lightBlack,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _date,
                          style: Theme.of(context).textTheme.headline3!.copyWith(fontSize: 16, color: Colors.white),
                        ),
                        Text(
                          _time,
                          style: Theme.of(context).textTheme.headline3!.copyWith(fontSize: 16, color: Colors.white, fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                ),
                Space(
                  height: 12.h,
                ),
                SizedBox(
                  height: 0.6.sh,
                  child: Scrollbar(
                    thumbVisibility: true,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 12.h),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 27.sp,
                                backgroundColor: AppTheme.creamBrownLight,
                                child: const Icon(
                                  Icons.info,
                                  size: 25,
                                  color: Colors.white,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 16.0.w),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (appointment.status == AppointmentStatus.requested) ...[
                                        Text(
                                          AppLocalizations.of(context)?.requested ?? '',
                                          style: Theme.of(context).textTheme.headline4!.copyWith(color: AppTheme.redishWarning),
                                          maxLines: 1,
                                        ),
                                      ],
                                      if (appointment.status == AppointmentStatus.cancelled) ...[
                                        if (appointment.updates.last == AppointmentUpdates.cancelledByCustomer) ...[
                                          Text(
                                            AppLocalizations.of(context)?.cancelledByYou ?? '',
                                            style: Theme.of(context).textTheme.headline4!.copyWith(color: AppTheme.redishPink),
                                            maxLines: 1,
                                          ),
                                        ],
                                        if (appointment.updates.last == AppointmentUpdates.cancelledBySalon) ...[
                                          Text(
                                            '${AppLocalizations.of(context)?.cancelledBy ?? ''} ${appointment.salonOwnerType == OwnerType.singleMaster ? {AppLocalizations.of(context)?.master ?? ''} : {AppLocalizations.of(context)?.salon ?? ''}}',
                                            style: Theme.of(context).textTheme.headline4!.copyWith(color: AppTheme.redishPink),
                                            maxLines: 1,
                                          ),
                                        ],
                                      ],
                                      if (appointment.status == AppointmentStatus.active) ...[
                                        Text(
                                          AppLocalizations.of(context)?.active ?? '--',
                                          style: Theme.of(context).textTheme.headline4!.copyWith(color: AppTheme.green),
                                          maxLines: 1,
                                        ),
                                      ],
                                      if (appointment.status == AppointmentStatus.completed) ...[
                                        Text(
                                          AppLocalizations.of(context)?.completed ?? 'Completed',
                                          style: Theme.of(context).textTheme.headline4!.copyWith(color: AppTheme.creamBrownLight),
                                          maxLines: 1,
                                        ),
                                      ],
                                      if (appointment.status == AppointmentStatus.checkedIn) ...[
                                        Text(
                                          AppLocalizations.of(context)?.checkedIn ?? 'Checked In',
                                          style: Theme.of(context).textTheme.headline4!.copyWith(color: AppTheme.textBlack),
                                          maxLines: 1,
                                        ),
                                      ],
                                      if (appointment.status == AppointmentStatus.noShow) ...[
                                        Text(
                                          AppLocalizations.of(context)?.missed ?? 'Missed',
                                          style: Theme.of(context).textTheme.headline4!.copyWith(color: AppTheme.redishPink),
                                          maxLines: 1,
                                        ),
                                      ],
                                      if (appointment.status == AppointmentStatus.pending) ...[
                                        Text(
                                          AppLocalizations.of(context)?.pending ?? 'Pending',
                                          style: Theme.of(context).textTheme.headline4!.copyWith(
                                                color: AppTheme.yellow,
                                              ),
                                          maxLines: 1,
                                        ),
                                      ],
                                      Text(
                                        AppLocalizations.of(context)?.status ?? "Status",
                                        style: Theme.of(context).textTheme.headline4!.copyWith(fontSize: 14),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Space(
                          height: 12.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 12.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 27.sp,
                                backgroundColor: AppTheme.creamBrownLight,
                                child: Padding(
                                  padding: EdgeInsets.all(16.r),
                                  child: SvgPicture.asset(AppIcons.getIconFromCategoryId(id: appointment.services.first.categoryId)),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 16.0.w),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      for (Service s in appointment.services)
                                        Text(
                                          s.translations[AppLocalizations.of(context)?.localeName.toString().toLowerCase()],
                                          style: Theme.of(context).textTheme.headline4!.copyWith(color: AppTheme.textBlack),
                                          maxLines: 1,
                                        ),
                                      Text(
                                        "${AppLocalizations.of(context)?.service} (${appointment.services.length})",
                                        style: Theme.of(context).textTheme.headline4!.copyWith(fontSize: 14),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 12.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                radius: 27.sp,
                                backgroundColor: AppTheme.creamBrownLight,
                                child: Padding(
                                  padding: EdgeInsets.all(16.r),
                                  child: SvgPicture.asset(AppIcons.priceTagSVG),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 16.0.w),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${appointment.priceAndDuration.price} ${Keys.uah}",
                                        style: Theme.of(context).textTheme.headline4!.copyWith(color: AppTheme.textBlack),
                                        maxLines: 1,
                                      ),
                                      Text(
                                        AppLocalizations.of(context)?.price ?? "Price",
                                        style: Theme.of(context).textTheme.headline4!.copyWith(fontSize: 14),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 12.h),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 27.sp,
                                backgroundColor: AppTheme.creamBrownLight,
                                child: Padding(
                                  padding: EdgeInsets.all(16.r),
                                  child: SvgPicture.asset(AppIcons.homeSVG),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 16.0.w),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        appointment.salon.name,
                                        style: Theme.of(context).textTheme.headline4!.copyWith(color: AppTheme.textBlack),
                                        maxLines: 1,
                                      ),
                                      Text(
                                        AppLocalizations.of(context)?.salon ?? "Salon",
                                        style: Theme.of(context).textTheme.headline4!.copyWith(fontSize: 14),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 12.h),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 27.sp,
                                backgroundColor: AppTheme.creamBrownLight,
                                child: Center(
                                  child: Padding(
                                      padding: EdgeInsets.all(10.r),
                                      child: const Icon(
                                        Icons.person,
                                        color: Colors.white,
                                      )),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 16.0.w),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        appointment.master!.name,
                                        style: Theme.of(context).textTheme.headline4!.copyWith(color: AppTheme.textBlack),
                                      ),
                                      Text(
                                        AppLocalizations.of(context)?.master ?? "Master",
                                        style: Theme.of(context).textTheme.headline4!.copyWith(fontSize: 14),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 12.h),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 27.sp,
                                backgroundColor: AppTheme.creamBrownLight,
                                child: Padding(
                                  padding: EdgeInsets.all(17.r),
                                  child: SvgPicture.asset(AppIcons.locationMarkerWhiteSVG),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 16.0.w),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        appointment.salon.address,
                                        style: Theme.of(context).textTheme.headline4!.copyWith(color: AppTheme.textBlack),
                                      ),
                                      Text(
                                        AppLocalizations.of(context)?.address ?? "Address",
                                        style: Theme.of(context).textTheme.headline4!.copyWith(fontSize: 14),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Space(
                          height: 12.h,
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    const Divider(
                      thickness: 2,
                      color: AppTheme.coolerGrey,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (salon != null) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => MapViewSingleSalon(salon: salon),
                                ),
                              );
                            } else {
                              showToast('error getting salon');
                            }
                          },
                          child: SizedBox(
                            height: 31.h,
                            width: 31.h,
                            child: SvgPicture.asset(AppIcons.locationMarkerSVG),
                          ),
                        ),
                        Container(
                          height: 40.h,
                          width: 2,
                          color: AppTheme.coolerGrey,
                        ),
                        GestureDetector(
                          onTap: () => Utils().launchCaller(appointment.salon.phoneNo),
                          child: SizedBox(
                            height: 31.h,
                            width: 31.h,
                            child: SvgPicture.asset(AppIcons.callBlackSVG),
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      thickness: 2,
                      color: AppTheme.coolerGrey,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16.h, left: 20.w, right: 20.w, bottom: 16.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (appointment.status == AppointmentStatus.active) ...[
                            appointment.appointmentStartTime.difference(DateTime.now()).inHours >= 0
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        showCancelDialog(context, appointment);
                                      },
                                      child: Text(
                                        AppLocalizations.of(context)?.cancel ?? "Cancel",
                                        style: Theme.of(context).textTheme.headline3!.copyWith(fontSize: 16.sp),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                          if (!appointment.masterReviewed && !appointment.salonReviewed) ...[
                            DateTime.now().difference(appointment.appointmentStartTime).inHours >= 0
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => MakeReview(
                                                      appointmentModel: appointment,
                                                    )));
                                      },
                                      child: Text(
                                        AppLocalizations.of(context)?.review ?? "Review",
                                        style: Theme.of(context).textTheme.headline3!.copyWith(fontSize: 18.sp),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6.0),
                            child: BnbMaterialButton(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              title: AppLocalizations.of(context)?.ok ?? "OK",
                              minWidth: 130,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      });
}

showCancelDialog(BuildContext context, AppointmentModel appointment) {
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Container(
              height: 426.h,
              width: 340.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  const CancelButtonTopRight(),
                  Padding(
                    padding: EdgeInsets.all(40.0.sp),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0.sp),
                          child: Image.asset(AppIcons.cancelArtPNG),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.h),
                          child: Text(
                            AppLocalizations.of(context)?.cancelVisitQuestion ?? "Are you sure you want to cancel your visit ?",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline3,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 16.h,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  AppLocalizations.of(context)?.no ?? "No",
                                  style: Theme.of(context).textTheme.headline3!.copyWith(fontSize: 18.sp),
                                ),
                              ),
                              BnbMaterialButton(
                                onTap: () async {
                                  EasyDebounce.debounce("cancel Booking", const Duration(milliseconds: 200), () async {
                                    String cancelled = await AppointmentApi().cancelAppointment(appointmentModel: appointment, context: context);
                                    if (cancelled == 'cancelled') {
                                      Duration? _difference = appointment.appointmentStartTime.difference(DateTime.now());
                                      int hours = _difference.inHours;
                                      if (hours >= 0 && hours <= 2) {
                                        Navigator.pop(context);
                                        showLessThenTwohoursCancelDialoge(context);
                                      } else if (hours >= 2 && hours <= 24) {
                                        Navigator.pop(context);
                                        showLessThen24hoursCancelDialoge(context);
                                      } else if (hours >= 24) {
                                        Navigator.pop(context);
                                        showMoreThen24hoursCancelDialoge(context);
                                      }
                                    } else {
                                      Navigator.pop(context);
                                      // showToast(AppLocalizations.of(context)?.errorCancelling ?? 'error cancelling');
                                    }
                                  });
                                },
                                title: AppLocalizations.of(context)?.yesCancel ?? "Yes Cancel",
                                minWidth: 100,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )),
        );
      });
}

showCalenderEmpty(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Container(
              height: 538,
              width: 340,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const CancelButtonTopRight(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 51.0, vertical: 41),
                    child: Image.asset(AppIcons.calendarEmptyPNG),
                  ),
                  Text(
                    AppLocalizations.of(context)?.calenderEmpty ?? "Your calendar is\nempty yet",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    width: 240,
                    child: Text(
                      AppLocalizations.of(context)?.allAppointmentsHere ?? "Choose a service and a master. All your booked apointments will be here.",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline3!.copyWith(fontSize: 13, fontWeight: FontWeight.w300),
                    ),
                  ),
                  const SizedBox(
                    height: 44,
                  ),
                  MaterialButton(
                    onPressed: () {},
                    color: AppTheme.creamBrown,
                    height: 52,
                    minWidth: 240,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      AppLocalizations.of(context)?.goToCategories ?? "Go to categories",
                      style: Theme.of(context).textTheme.headline3!.copyWith(color: Colors.white, fontSize: 18.sp),
                    ),
                  ),
                ],
              ),
            ));
      });
}

showMoreThen24hoursCancelDialoge(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Container(
              height: 428,
              width: 340,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const CancelButtonTopRight(),
                  Padding(
                    padding: const EdgeInsets.only(right: 51.0, left: 51, top: 21, bottom: 40),
                    child: SizedBox(
                      height: 80,
                      width: 80,
                      child: Image.asset(AppIcons.thumbUpPNG),
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)?.twentyFourHoursMoreBeforeTheAppointment ?? "More than 24 hours before the appointment",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    width: 240,
                    child: Text(
                      AppLocalizations.of(context)?.priorWarningThanks ?? "It’s a pity your plans have changed. Thank you for a prior warning. You just put a coin in your karma bank !",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline3!.copyWith(fontSize: 13, fontWeight: FontWeight.w300),
                    ),
                  ),
                  const SizedBox(
                    height: 44,
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: AppTheme.creamBrown,
                    height: 52,
                    minWidth: 240,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      AppLocalizations.of(context)?.okey ?? "Okey",
                      style: Theme.of(context).textTheme.headline3!.copyWith(color: Colors.white, fontSize: 18.sp),
                    ),
                  ),
                ],
              ),
            ));
      });
}

showLessThen24hoursCancelDialoge(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Container(
              height: 478,
              width: 340,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const CancelButtonTopRight(),
                  Padding(
                    padding: const EdgeInsets.only(right: 51.0, left: 51, top: 21, bottom: 40),
                    child: SizedBox(
                      height: 80,
                      width: 80,
                      child: Image.asset(AppIcons.thumbDownPNG),
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)?.twentyFourHoursLessBeforeTheAppointment ?? "Less than 24 hours before the appointment",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    width: 240,
                    child: Text(
                      AppLocalizations.of(context)?.thanksForCanceling ?? "Life is unpredictable, we know. Thanks for canceling. If next time you do it at least 1 day before – you'll put a coin in your karma bank and others will have a chance to book a service instead of you 🙂",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline3!.copyWith(fontSize: 13, fontWeight: FontWeight.w300),
                    ),
                  ),
                  const SizedBox(
                    height: 44,
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: AppTheme.creamBrown,
                    height: 52,
                    minWidth: 240,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      AppLocalizations.of(context)?.okey ?? "Okey",
                      style: Theme.of(context).textTheme.headline3!.copyWith(color: Colors.white, fontSize: 18.sp),
                    ),
                  ),
                ],
              ),
            ));
      });
}

showLessThenTwohoursCancelDialoge(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Container(
              height: 478,
              width: 340,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const CancelButtonTopRight(),
                  Padding(
                    padding: const EdgeInsets.only(right: 51.0, left: 51, top: 21, bottom: 40),
                    child: SizedBox(
                      height: 80,
                      width: 80,
                      child: Image.asset(AppIcons.thumbDownPNG),
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)?.twoHoursBeforeTheAppointment ?? "Two or less hours before the appointment",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    width: 240,
                    child: Text(
                      AppLocalizations.of(context)?.mostPeopleCancelLastMinute ?? "Most people cancel at the last minute in two cases: either they forgot or something happened. So we hope you are safe and sound. If you forgot, make sure you turn your notification on. Take care and try to warn your master earlier next time!",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline3!.copyWith(fontSize: 13, fontWeight: FontWeight.w300),
                    ),
                  ),
                  const SizedBox(
                    height: 44,
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: AppTheme.creamBrown,
                    height: 52,
                    minWidth: 240,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      AppLocalizations.of(context)?.okey ?? "Okey",
                      style: Theme.of(context).textTheme.headline3!.copyWith(color: Colors.white, fontSize: 18.sp),
                    ),
                  ),
                ],
              ),
            ));
      });
}

saloonChangedDialoge(
  BuildContext context,
) {
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Container(
              height: 478,
              width: 340,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const CancelButtonTopRight(),
                  Padding(
                    padding: const EdgeInsets.only(right: 51.0, left: 51, top: 21, bottom: 40),
                    child: SizedBox(
                      height: 80,
                      width: 80,
                      child: Image.asset(AppIcons.appointmentCancelledPNG),
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)?.salonOrMasterDeletedYourAppointment ?? "Salon/Master canceled your appointment.",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: AppTheme.creamBrown,
                    height: 52,
                    minWidth: 240,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      AppLocalizations.of(context)?.okey ?? "Okey",
                      style: Theme.of(context).textTheme.headline3!.copyWith(color: Colors.white, fontSize: 18.sp),
                    ),
                  ),
                ],
              ),
            ));
      });
}

class CancelButtonTopRight extends StatelessWidget {
  const CancelButtonTopRight({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: SizedBox(
            height: 10,
            width: 10,
            child: SvgPicture.asset(AppIcons.cancelGreySVG),
          ),
        ),
      ],
    );
  }
}
