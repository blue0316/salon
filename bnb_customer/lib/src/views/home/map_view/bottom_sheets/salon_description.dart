import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/views/salon/salon_home/salon_profile_copy.dart';
import 'package:bbblient/src/views/salon/salon_home/salon_profile.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jiffy/jiffy.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../models/salon_master/salon.dart';
import '../../../../theme/app_main_theme.dart';
import '../../../../utils/icons.dart';
import '../../../widgets/widgets.dart';

class SalonDescriptionDraggable extends StatelessWidget {
  const SalonDescriptionDraggable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        minChildSize: 0.3,
        initialChildSize: 0.62,
        maxChildSize: 0.75,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            decoration: const BoxDecoration(color: AppTheme.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(AppTheme.margin), topRight: Radius.circular(AppTheme.margin))),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 11.0, bottom: 20),
                  child: Container(
                    width: 80,
                    height: 4,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: const Color(0xffD7D6D6)),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(controller: scrollController, child: const SalonDescription()),
                ),
              ],
            ),
          );
        });
  }
}

class SalonDescription extends ConsumerWidget {
  const SalonDescription({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final _mapViewProvider = ref.watch(mapViewProvider);
    final SalonModel _salon = _mapViewProvider.selectedSalon!;
    final String _salonName = _salon.salonName;
    final String _salonDescription = _salon.description;
    final String _salonWebsite = _salon.salonWebSite ?? '';
    final String _address = _salon.address;
    final String _distance = "${_salon.distanceFromCenter ?? "N/A"} Km";

    final double _rating = _salon.rating;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => _mapViewProvider.toggleShow(),
                child: Container(alignment: Alignment.centerLeft, width: 55, child: const Icon(Icons.arrow_back_ios)),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    _salonName,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: 55,
                child: Text(
                  _distance,
                  style: Theme.of(context).textTheme.headline4,
                ),
              )
            ],
          ),
        ),
        const Space(
          factor: 2,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: SizedBox(
                    height: 100.sp,
                    width: 100.sp,
                    child: _salon.profilePics.isEmpty
                        ? SvgPicture.asset(
                            AppIcons.salonPlaceHolder,
                            fit: BoxFit.cover,
                          )
                        : CachedImage(url: _salon.profilePics[0])),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: SvgPicture.asset(AppIcons.locationMarkerSVG),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Flexible(
                        child: Text(
                          _address,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headline4!.copyWith(fontWeight: FontWeight.w400, color: AppTheme.textBlack),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      BnbRatings(rating: _rating, editable: false, starSize: 20),
                      const SizedBox(
                        width: 12,
                      ),
                      if (_salon.reviewCount != 0) ...[
                        Row(
                          children: [
                            const Icon(
                              Icons.person,
                              size: 18,
                              color: AppTheme.textBlack,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              _salon.reviewCount.toInt().toString(),
                              style: Theme.of(context).textTheme.headline4!.copyWith(fontWeight: FontWeight.w400, color: AppTheme.textBlack),
                            )
                          ],
                        ),
                      ]
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  WorkingDays(workingHoursMap: _mapViewProvider.workingHoursMap)
                ],
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          child: Text(
            _salonDescription,
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
        if (_salonWebsite != '')
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                SizedBox(
                  height: 20,
                  width: 20,
                  child: SvgPicture.asset(AppIcons.globalSVG),
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Text(
                    _salonWebsite,
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(color: AppTheme.textBlack),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          ),
        const Space(
          factor: 2,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // SizedBox(
            //   width: 140,
            //   child: Center(
            //     child: Text(
            //       "See Profile",
            //       style: Theme.of(context).textTheme.headline2!.copyWith(color: AppTheme.textBlack),
            //     ),
            //   ),
            // ),
            Material(
              child: InkWell(
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SalonPage(salonId: _mapViewProvider.selectedSalon!.salonId, switchSalon: true)));
                },
                child: Ink(
                    width: 140,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: AppTheme.creamBrown),
                    height: 50,
                    child: Center(
                      child: Text(AppLocalizations.of(context)?.book ?? "Book", style: Theme.of(context).textTheme.headline2),
                    )),
              ),
            )
          ],
        )
      ],
    );
  }
}

class WorkingDays extends StatefulWidget {
  final Map<int, String> workingHoursMap;

  const WorkingDays({required this.workingHoursMap, Key? key}) : super(key: key);

  @override
  _WorkingDaysState createState() => _WorkingDaysState();
}

class _WorkingDaysState extends State<WorkingDays> {
  bool showTodayOnly = true;

  Widget hourPalette(int weekday, String? hours, {bool showToggleButton = false}) {
    final String day = Jiffy(DateTime(01, 01, weekday)).EEEE;
    // DateFormat('EE').format(DateTime(01, 01, weekday));

    return GestureDetector(
      onTap: () {
        if (showToggleButton) onChangeView();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: AppTheme.margin / 2),
        child: Row(
          children: [
            SizedBox(
              width: 50,
              child: Text(day, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w400, color: AppTheme.textBlack, fontFamily: "Montserrat", fontSize: 13)),
            ),
            Text(hours ?? '', style: const TextStyle(fontFamily: "Montserrat", fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textBlack)),
            if (showToggleButton)
              const SizedBox(
                width: 8,
              ),
            if (showToggleButton)
              Icon(
                showTodayOnly ? CupertinoIcons.chevron_down : CupertinoIcons.chevron_up,
                size: 16,
              )
          ],
        ),
      ),
    );
  }

  onChangeView() => setState(() {
        showTodayOnly = !showTodayOnly;
      });

  @override
  Widget build(BuildContext context) {
    final int today = DateTime.now().weekday;
    return Container(
        padding: const EdgeInsets.only(left: 2),
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: showTodayOnly
              ? [
                  if (widget.workingHoursMap.containsKey(today)) hourPalette(today, widget.workingHoursMap[today], showToggleButton: true),
                ]
              : [for (int key in widget.workingHoursMap.keys) hourPalette(key, widget.workingHoursMap[key], showToggleButton: key == 1)],
        ));
  }
}
