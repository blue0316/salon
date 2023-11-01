import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/salon_master/master.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/themes/images.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'follow.dart';

class GentleTouchMasterView extends ConsumerStatefulWidget {
  final List<MasterModel> masters;
  final int initialIndex;
  const GentleTouchMasterView({
    Key? key,
    required this.masters,
    required this.initialIndex,
  }) : super(key: key);

  @override
  ConsumerState<GentleTouchMasterView> createState() => _GentleTouchMasterViewState();
}

class _GentleTouchMasterViewState extends ConsumerState<GentleTouchMasterView> {
  int indexToShow = 0;

  @override
  void initState() {
    super.initState();
    setState(() => indexToShow = widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    ThemeType themeType = _salonProfileProvider.themeType;
    final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.portrait);

    return !isPortrait
        ? SizedBox(
            height: 750.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: SizedBox(
                    width: size.width * 0.6, //  / 1.6,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 50.h, horizontal: 30.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Header(master: widget.masters[indexToShow]),
                          SizedBox(height: 35.sp),
                          Text(
                            (widget.masters[indexToShow].personalInfo!.description != null && widget.masters[indexToShow].personalInfo!.description!.isNotEmpty) ? '${widget.masters[indexToShow].personalInfo!.description}' : 'No description yet...',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: (themeType == ThemeType.GentleTouch) ? const Color(0XFF282828) : const Color(0xffdddddd),
                              fontSize: 18.sp,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Inter-Light',
                              letterSpacing: 0.2,
                            ),
                          ),
                          const Spacer(),
                          PreviousAndNext(
                            previous: () {
                              if (indexToShow > 0) {
                                setState(() => indexToShow -= 1);
                              }
                            },
                            next: () {
                              if (indexToShow < widget.masters.length - 1) {
                                setState(() => indexToShow += 1);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 0,
                  child: Container(
                    width: size.width * 0.37,
                    decoration: BoxDecoration(
                      color: (themeType == ThemeType.GentleTouch) ? Colors.white : Colors.black,
                      border: Border.all(color: Colors.black, width: 0.4),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: (widget.masters[indexToShow].profilePicUrl != null && widget.masters[indexToShow].profilePicUrl != '')
                              ? CachedImage(
                                  url: widget.masters[indexToShow].profilePicUrl!,
                                  fit: BoxFit.cover,
                                  width: size.width * 0.37,
                                )
                              : Image.asset(
                                  themeType == ThemeType.GentleTouch ? ThemeImages.noTeamMember : ThemeImages.noTeamMemberDark,
                                  fit: BoxFit.cover,
                                  width: size.width * 0.37,
                                ),
                        ),
                        FollowMaster(master: widget.masters[indexToShow]),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        : GentleTouchPortraitMasterView(
            masters: widget.masters,
            initialIndex: widget.initialIndex,
          );
  }
}

class GentleTouchPortraitMasterView extends ConsumerStatefulWidget {
  final List<MasterModel> masters;
  final int initialIndex;

  const GentleTouchPortraitMasterView({
    Key? key,
    required this.masters,
    required this.initialIndex,
  }) : super(key: key);

  @override
  ConsumerState<GentleTouchPortraitMasterView> createState() => GentleTouchPortraitMasterViewState();
}

class GentleTouchPortraitMasterViewState extends ConsumerState<GentleTouchPortraitMasterView> {
  int indexToShow = 0;

  @override
  void initState() {
    super.initState();
    setState(() => indexToShow = widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    ThemeType themeType = _salonProfileProvider.themeType;
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Header(master: widget.masters[indexToShow]),
          SizedBox(height: 20.sp),
          Container(
            height: size.height * 0.55,
            width: double.infinity,
            decoration: BoxDecoration(
              color: (themeType == ThemeType.GentleTouch) ? Colors.white : Colors.black,
              border: Border.all(color: Colors.black, width: 0.4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: (widget.masters[indexToShow].profilePicUrl != null && widget.masters[indexToShow].profilePicUrl != '')
                      ? CachedImage(
                          url: widget.masters[indexToShow].profilePicUrl!,
                          fit: BoxFit.cover,
                          width: size.width - 40.w,
                        )
                      : Image.asset(
                          themeType == ThemeType.GentleTouch ? ThemeImages.noTeamMember : ThemeImages.noTeamMemberDark,
                          width: size.width - 40.w,
                          fit: BoxFit.cover,
                        ),
                ),
                FollowMaster(master: widget.masters[indexToShow]),
              ],
            ),
          ),
          SizedBox(height: 30.sp),
          Text(
            (widget.masters[indexToShow].personalInfo!.description != null && widget.masters[indexToShow].personalInfo!.description!.isNotEmpty) ? '${widget.masters[indexToShow].personalInfo!.description}' : 'No description yet...',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: (themeType == ThemeType.GentleTouch) ? const Color(0XFF282828) : const Color(0xffdddddd),
              fontSize: 18.sp,
              fontWeight: FontWeight.normal,
              fontFamily: 'Inter-Light',
              letterSpacing: 0.2,
            ),
          ),
          SizedBox(height: 30.sp),
          PreviousAndNext(
            previous: () {
              if (indexToShow > 0) {
                setState(() => indexToShow -= 1);
              }
            },
            next: () {
              if (indexToShow < widget.masters.length - 1) {
                setState(() => indexToShow += 1);
              }
            },
          ),
        ],
      ),
    );
  }
}

class Header extends ConsumerWidget {
  final MasterModel master;
  const Header({Key? key, required this.master}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    ThemeType themeType = _salonProfileProvider.themeType;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => _salonProfileProvider.switchMasterView(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: const Color(0XFFB4B4B4),
                  size: 14.sp,
                ),
                Text(
                  'Back to the main page',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: const Color(0XFFB4B4B4),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Inter-Light',
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20.sp),
        Text(
          Utils().getNameMaster(master.personalInfo).toUpperCase(),
          style: theme.textTheme.bodyLarge?.copyWith(
            color: (themeType == ThemeType.GentleTouch) ? Colors.black : Colors.white,
            fontSize: DeviceConstraints.getResponsiveSize(context, 40.sp, 30.sp, 35.sp),
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
          ),
        ),
        SizedBox(height: 10.sp),
        Text(
          master.title ?? '',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: const Color(0XFFB4B4B4),
            fontSize: DeviceConstraints.getResponsiveSize(context, 18.sp, 18.sp, 18.sp),
            fontWeight: FontWeight.normal,
            fontFamily: 'Inter-Light',
          ),
        ),
      ],
    );
  }
}

class PreviousAndNext extends ConsumerWidget {
  final VoidCallback previous, next;

  const PreviousAndNext({Key? key, required this.previous, required this.next}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: previous,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: const Color(0XFFB4B4B4),
                  size: 14.sp,
                ),
                const SizedBox(width: 5),
                Text(
                  'Previous specialist',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: const Color(0XFFB4B4B4),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Inter-Light',
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: next,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Next specialist',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: const Color(0XFFB4B4B4),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Inter-Light',
                  ),
                ),
                const SizedBox(width: 5),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: const Color(0XFFB4B4B4),
                  size: 14.sp,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
