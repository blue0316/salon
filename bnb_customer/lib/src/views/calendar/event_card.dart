import 'dart:math';

import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/appointment/appointment.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/time.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/calendar/calender_dialogues.dart';
import 'package:bbblient/src/views/home/map_view/map_view_single_salon.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../theme/app_main_theme.dart';
import '../../utils/icons.dart';

class EventCard extends ConsumerWidget {
  final AppointmentModel appointment;
  const EventCard({required this.appointment, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final String? _time = Time().getAppointmentStartEndTime(appointment);
    final String? _serviceName = appointment.services.first.translations![AppLocalizations.of(context)?.localeName.toString().toLowerCase()];

    final String _categoryIcon = AppIcons.getIconFromCategoryId(id: appointment.services.first.categoryId!);
    final String _salonName = appointment.salon.name;
    final _salonSearchProvider = ref.watch(salonSearchProvider);

    return Container(
      margin: const EdgeInsets.only(
        left: 12.0,
        right: 12,
        bottom: 24,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              _time ?? "",
              style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 16.sp),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            width: min(0.7.sw, 450),
            child: Column(
              children: [
                Container(
                  height: 44.h,
                  decoration: const BoxDecoration(
                    color: AppTheme.lightBlack,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "${_serviceName ?? ""}... (${appointment.services.length}) ",
                            style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: DeviceConstraints.getResponsiveSize(context, 16, 17, 18), color: Colors.white),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          height: 20.sp,
                          width: 20.sp,
                          child: SvgPicture.asset(_categoryIcon),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _salonName,
                          style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: DeviceConstraints.getResponsiveSize(context, 14, 15, 16)),
                        ),
                        // Text(_salonAddress, style: Theme.of(context).textTheme.headline4!.copyWith(fontSize: 14)),
                        const SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                SalonModel? salon = await _salonSearchProvider.getSalonWithDistance(salonId: appointment.salon.id);
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
                                height: 20,
                                width: 20,
                                child: SvgPicture.asset(AppIcons.locationMarkerBrownSVG),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Utils().launchCaller(appointment.salon.phoneNo),
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: SvgPicture.asset(AppIcons.phoneBrownSVG),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                              width: 20,
                            ),
                            Material(
                              child: InkWell(
                                onTap: () async {
                                  SalonModel? salon = await _salonSearchProvider.getSalonWithDistance(salonId: appointment.salon.id);
                                  showAppointmentDetails(context, appointment, salon);
                                },
                                customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                child: Ink(
                                  height: 30,
                                  width: 120.h,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: AppTheme.creamBrown),
                                  child: Center(
                                    child: Text(
                                      AppLocalizations.of(context)?.seeDetails ?? "See Details",
                                      style: Theme.of(context).textTheme.headline2!.copyWith(fontSize: 5),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
