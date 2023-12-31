import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/salon_master/master.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/themes/glam_one/core/utils/prev_and_next.dart';
import 'package:bbblient/src/views/themes/images.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:bbblient/src/views/themes/vintage_craft/desktop/team.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'portrait.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GentleTouchTeam extends ConsumerStatefulWidget {
  final SalonModel salonModel;

  const GentleTouchTeam({Key? key, required this.salonModel}) : super(key: key);

  @override
  ConsumerState<GentleTouchTeam> createState() => _GentleTouchTeamState();
}

class _GentleTouchTeamState extends ConsumerState<GentleTouchTeam> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  int tabInitial = 3;
  int portraitInitial = 1;

  @override
  Widget build(BuildContext context) {
    final _createAppointmentProvider = ref.watch(createAppointmentProvider);

    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    final bool isTab = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.tab);
    final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.portrait);
    ThemeType themeType = _salonProfileProvider.themeType;

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.only(
          left: DeviceConstraints.getResponsiveSize(context, 20.w, 50.w, 50.w),
          right: DeviceConstraints.getResponsiveSize(context, 20.w, 50.w, 50.w),
          top: DeviceConstraints.getResponsiveSize(context, 40.h, 80.h, 100.h),
          bottom: DeviceConstraints.getResponsiveSize(context, 140.h, 180.h, 200.h),
        ),
        child: Column(
          crossAxisAlignment: themeType != ThemeType.VintageCraft ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            themeType != ThemeType.VintageCraft
                ? Text(
                    (AppLocalizations.of(context)?.team ?? 'Team').toUpperCase(),
                    style: theme.textTheme.displayMedium?.copyWith(
                      fontSize: DeviceConstraints.getResponsiveSize(context, 50.sp, 50.sp, 60.sp),
                    ),
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        (AppLocalizations.of(context)?.team ?? 'Team').toTitleCase(),
                        style: theme.textTheme.displayMedium?.copyWith(
                          fontSize: DeviceConstraints.getResponsiveSize(context, 50.sp, 50.sp, 60.sp),
                        ),
                      ),
                      if (!isPortrait)
                        Align(
                          alignment: Alignment.centerRight,
                          child: PrevAndNextButtons(
                            backOnTap: isTab
                                ? () {
                                    if (tabInitial < 3) return;
                                    setState(() {
                                      tabInitial -= 3;
                                    });

                                    itemScrollController.jumpTo(index: tabInitial);

                                    // => controller!.previousPage()
                                  }
                                : () {
                                    if (portraitInitial < 1) return;
                                    setState(() {
                                      portraitInitial -= 1;
                                    });

                                    itemScrollController.jumpTo(index: portraitInitial);
                                  },
                            forwardOnTap: isTab
                                ? () {
                                    itemScrollController.jumpTo(index: tabInitial);

                                    setState(() {
                                      tabInitial += 3;
                                    });
                                    //  => controller!.nextPage()
                                  }
                                : () {
                                    itemScrollController.jumpTo(index: portraitInitial);
                                    setState(() {
                                      portraitInitial += 1;
                                    });
                                  },
                            leftFontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 15.sp, 18.sp),
                            rightFontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 15.sp, 18.sp),
                          ),
                        ),
                    ],
                  ),
            Space(factor: isPortrait ? 2 : 3),
            isPortrait
                ? TeamPortraitView(
                    items: [
                      AppLocalizations.of(context)?.all ?? 'All',
                      ..._salonProfileProvider.tabs.keys.toList(),
                    ],
                  )
                : Center(
                    child: SizedBox(
                      // height: size.height * 0.4, // DeviceConstraints.getResponsiveSize(context, 230.h, 230.h, 210.h),
                      height: 460.h,

                      child: ScrollablePositionedList.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _createAppointmentProvider.salonMasters.length,
                        itemBuilder: (context, index) {
                          // Get All Salon Masters
                          List<MasterModel> _filteredMasters = _createAppointmentProvider.salonMasters;

                          if (_filteredMasters.isNotEmpty) {
                            return themeType != ThemeType.VintageCraft
                                ? GentleTouchTeamMember(
                                    name: Utils().getNameMaster(_filteredMasters[index].personalInfo),
                                    masterTitle: _filteredMasters[index].title ?? '',

                                    // services: masterCategories,
                                    image: _filteredMasters[index].profilePicUrl,
                                    master: _filteredMasters[index],
                                  )
                                : VintageCraftTeamMember(
                                    name: Utils().getNameMaster(_filteredMasters[index].personalInfo),
                                    masterTitle: _filteredMasters[index].title ?? '',
                                    image: _filteredMasters[index].profilePicUrl,
                                    master: _filteredMasters[index],
                                  );
                          } else {
                            return const SizedBox();
                          }
                        },
                        scrollDirection: Axis.horizontal,
                        itemScrollController: itemScrollController,
                        itemPositionsListener: itemPositionsListener,
                      ),
                    ),
                  ),
            if (!isPortrait) SizedBox(height: 20.sp),
            if (!isPortrait && themeType != ThemeType.VintageCraft)
              Align(
                alignment: Alignment.centerRight,
                child: PrevAndNextButtons(
                  backOnTap: isTab
                      ? () {
                          if (tabInitial < 3) return;
                          setState(() {
                            tabInitial -= 3;
                          });

                          itemScrollController.jumpTo(index: tabInitial);

                          // => controller!.previousPage()
                        }
                      : () {
                          if (portraitInitial < 1) return;
                          setState(() {
                            portraitInitial -= 1;
                          });

                          itemScrollController.jumpTo(index: portraitInitial);
                        },
                  forwardOnTap: isTab
                      ? () {
                          itemScrollController.jumpTo(index: tabInitial);

                          setState(() {
                            tabInitial += 3;
                          });
                          //  => controller!.nextPage()
                        }
                      : () {
                          itemScrollController.jumpTo(index: portraitInitial);
                          setState(() {
                            portraitInitial += 1;
                          });
                        },
                  leftFontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 15.sp, 18.sp),
                  rightFontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 15.sp, 18.sp),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class GentleTouchTeamMember extends ConsumerStatefulWidget {
  final String? name, image;
  final MasterModel master;
  final String? masterTitle;
  final bool showDesc;

  const GentleTouchTeamMember({
    Key? key,
    required this.name,
    required this.masterTitle,
    required this.image,
    required this.master,
    this.showDesc = false,
  }) : super(key: key);

  @override
  ConsumerState<GentleTouchTeamMember> createState() => _GentleTouchTeamMemberState();
}

class _GentleTouchTeamMemberState extends ConsumerState<GentleTouchTeamMember> {
  bool isHovered = false;

  void onEntered(bool isHovered) => setState(() {
        this.isHovered = isHovered;
      });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final _createAppointmentProvider = ref.watch(createAppointmentProvider);

    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    ThemeType themeType = _salonProfileProvider.themeType;

    return Padding(
      padding: const EdgeInsets.only(right: 20, top: 2, bottom: 2, left: 2),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (event) => onEntered(true),
        onExit: (event) => onEntered(false),
        child: GestureDetector(
          onTap: () {
            // _createAppointmentProvider.setMaster(
            //   masterModel: widget.master,
            //   categories: _salonSearchProvider.categories,
            // );
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => UniqueMasterProfile(
            //       masterModel: widget.master,
            //     ),
            //   ),
            // );
          },
          child: Container(
            width: DeviceConstraints.getResponsiveSize(
              context,
              (size.width - 40.w),
              (size.width - 100.w),
              ((size.width - 100.w - 60) / 3),
            ),
            decoration: BoxDecoration(
              color: (themeType == ThemeType.GentleTouch) ? Colors.white : Colors.black,
              border: Border.all(color: (themeType == ThemeType.GentleTouch) ? Colors.black : const Color(0XFF868686), width: 0.4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: (themeType == ThemeType.GentleTouch) ? Colors.white : Colors.black,
                        border: Border(
                          bottom: BorderSide(
                            color: (themeType == ThemeType.GentleTouch) ? Colors.black : const Color(0XFF868686),
                            width: 0.4,
                          ),
                        ) // Border.all(color: Colors.black, width: 0.4),
                        ),
                    child: (widget.image != null && widget.image != '')
                        ? CachedImage(url: widget.image!, fit: BoxFit.cover)
                        : Image.asset(
                            themeType == ThemeType.GentleTouch ? ThemeImages.noTeamMember : ThemeImages.noTeamMemberDark,
                            fit: BoxFit.fitHeight,
                          ),
                  ),
                ),
                SizedBox(height: 12.sp),
                Text(
                  (widget.name ?? '').toTitleCase(),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: (themeType == ThemeType.GentleTouch) ? Colors.black : Colors.white,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter-Light',
                  ),
                  maxLines: 1,
                ),
                // SizedBox(height: 5.sp),
                if (widget.masterTitle!.isNotEmpty) SizedBox(height: 5.sp),
                Text(
                  (widget.masterTitle ?? '').toTitleCase(),
                  style: theme.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w300,
                    fontSize: 15.sp,
                    color: const Color(0XFF868686),
                    fontFamily: 'Inter-Light',
                  ),
                ),

                (widget.masterTitle!.isNotEmpty && (isHovered || widget.showDesc)) ? SizedBox(height: 10.sp) : SizedBox(height: 5.sp),

                if (isHovered || widget.showDesc)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.sp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.master.personalInfo?.description != null && widget.master.personalInfo!.description!.isNotEmpty)
                          Text(
                            (widget.master.personalInfo?.description ?? '').toTitleCase(),
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: (themeType == ThemeType.GentleTouch) ? Colors.black : Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Inter-Light',
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        if (widget.master.personalInfo?.description != null && widget.master.personalInfo!.description!.isNotEmpty) SizedBox(height: 15.sp),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: GentleTouchTeamButton(
                                text: "  ${AppLocalizations.of(context)?.learnMore ?? "Learn More"}  ",
                                onTap: () {
                                  _salonProfileProvider.switchMasterView(
                                    index: _createAppointmentProvider.salonMasters.indexWhere(
                                      (element) => element == widget.master,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.sp),
                      ],
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

class GentleTouchTeamButton extends ConsumerStatefulWidget {
  final String text;
  final VoidCallback onTap;
  final bool isGradient;

  const GentleTouchTeamButton({
    Key? key,
    required this.text,
    required this.onTap,
    this.isGradient = false,
  }) : super(key: key);

  @override
  ConsumerState<GentleTouchTeamButton> createState() => _GentleTouchTeamButtonState();
}

class _GentleTouchTeamButtonState extends ConsumerState<GentleTouchTeamButton> {
  bool isHovered = false;

  void onEntered(bool isHovered) => setState(() {
        this.isHovered = isHovered;
      });

  @override
  Widget build(BuildContext context) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    ThemeType themeType = _salonProfileProvider.themeType;
    final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.portrait);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (event) => onEntered(true),
      onExit: (event) => onEntered(false),
      child: ElevatedButton(
        child: Text(
          AppLocalizations.of(context)?.learnMore ?? 'Learn More',
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.normal,
            color: !isPortrait
                ? (themeType == ThemeType.GentleTouch)
                    ? (!isHovered ? Colors.black : Colors.white)
                    : (!isHovered ? Colors.white : Colors.black)
                : Colors.black,
            fontFamily: "Inter-Light",
          ),
        ),
        style: ElevatedButton.styleFrom(
          minimumSize: Size(150.h, 50.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1.5)),
          backgroundColor: isPortrait
              ? Colors.white
              : !isHovered
                  ? Colors.transparent
                  : theme.colorScheme.secondary,
          shadowColor: Colors.transparent,
          side: isHovered
              ? null
              : BorderSide(
                  color: (themeType == ThemeType.GentleTouch) ? Colors.black : const Color(0XFF868686),
                  width: 0.8,
                ),
        ),
        onPressed: widget.onTap,
      ),
    );
  }
}

Gradient? buttonGradient(ThemeType type, ThemeData theme, {double? opacity}) {
  switch (type) {
    case ThemeType.GentleTouch:
      return LinearGradient(
        begin: const Alignment(-0.6, -0.4),
        end: const Alignment(2, 1),
        colors: [theme.colorScheme.secondary, Colors.white],
      );

    case ThemeType.GentleTouchDark:
      return LinearGradient(
        begin: const Alignment(-0.6, -0.4),
        end: const Alignment(2, 1),
        colors: [theme.colorScheme.secondary.withOpacity(opacity ?? 1), Colors.white],
      );

    default:
      return null;
  }
}
