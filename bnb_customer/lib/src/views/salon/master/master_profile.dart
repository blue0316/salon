// ignore_for_file: prefer_const_constructors

import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/create_apntmnt_provider/create_appointment_provider.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/cat_sub_service/category_service.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/views/salon/default_profile_view/salon_profile.dart';
import 'package:bbblient/src/views/salon/default_profile_view/widgets/header.dart';
import 'package:bbblient/src/views/salon/widgets/floating_button_booking.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bbblient/src/models/salon_master/master.dart';
import '../../../models/enums/profile_datails_tabs.dart';
import '../../../theme/app_main_theme.dart';
import 'master_about.dart';
import 'master_allworks.dart';
import 'master_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MasterProfile extends ConsumerStatefulWidget {
  // static const route = 'master';
  final SalonModel salonModel;
  final MasterModel masterModel;
  final String salonProfileImage;
  final List<CategoryModel> categories;

  const MasterProfile({
    Key? key,
    required this.masterModel,
    this.salonProfileImage = '',
    required this.salonModel,
    required this.categories,
  }) : super(key: key);

  @override
  _MasterProfileState createState() => _MasterProfileState();
}

class _MasterProfileState extends ConsumerState<MasterProfile> {
  final ScrollController _masterDetailsScrollController = ScrollController();
  final PageController _pageController = PageController();
  late CreateAppointmentProvider _createAppointmentProvider;
  late SalonProfileProvider _salonProfileProvider;
  int _activeTab = 0;

  @override
  void dispose() {
    super.dispose();
    _createAppointmentProvider.chosenServices.clear();
  }

  @override
  void initState() {
    super.initState();
    getReviews();
  }

  void getReviews() {
    _salonProfileProvider = ref.read(salonProfileProvider);
    _salonProfileProvider.getMasterReviews(masterId: widget.masterModel.masterId);
    // masterId: widget.masterModel!.masterId);
  }

  @override
  Widget build(BuildContext context) {
    final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.portrait);
    _createAppointmentProvider = ref.watch(createAppointmentProvider);
    final _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    bool isLightTheme = (theme == AppTheme.customLightTheme);

    return Scaffold(
      body: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
                child: (_salonProfileProvider.themeSettings?.backgroundImage != null && _salonProfileProvider.themeSettings?.backgroundImage != '')
                    ? CachedImage(
                        url: _salonProfileProvider.themeSettings!.backgroundImage!,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        AppIcons.photoSlider,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Header(
                          salonModel: _salonProfileProvider.chosenSalon,
                          goToLanding: () {},
                        ),
                        Space(
                          factor: DeviceConstraints.getResponsiveSize(context, 2, 2, 2.5),
                        ),
                        Expanded(
                          flex: 0,
                          child: Center(
                            child: MasterImageHeader(
                              master: widget.masterModel,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: DeviceConstraints.getResponsiveSize(context, 10.w, 40.w, 80.w),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if (!isPortrait)
                                    Expanded(
                                      flex: 0,
                                      child: GestureDetector(
                                        onTap: () => Navigator.pop(context),
                                        child: Container(
                                          height: 50.h,
                                          // width: 100.w,
                                          color: theme.canvasColor.withOpacity(0.5),
                                          margin: EdgeInsets.symmetric(
                                            horizontal: 0, // DeviceConstraints.getResponsiveSize(context, 5.w, 5.w, 10.w),
                                            vertical: 20.h,
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.arrow_back_rounded,
                                                  color: isLightTheme ? AppTheme.textBlack : Colors.white,
                                                  size: 20.sp,
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                  (AppLocalizations.of(context)?.back ?? "BACK").toUpperCase(),
                                                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                                        fontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 15.sp, 15.sp),
                                                        color: isLightTheme ? AppTheme.textBlack : Colors.white,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  // SpaceHorizontal(factor: 1),
                                  // Spacer(),
                                  Expanded(
                                    // flex: 2,
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: !isPortrait ? 30.w : 0),
                                        child: Container(
                                          height: 70.h,
                                          // width: 130, // double.infinity,
                                          color: theme.canvasColor.withOpacity(0.7),

                                          margin: EdgeInsets.symmetric(
                                            horizontal: DeviceConstraints.getResponsiveSize(context, 5.w, 5.w, 10.w),
                                            vertical: 20.h,
                                          ),
                                          child: Center(
                                            child: SizedBox(
                                              height: 30.h,
                                              width: double.infinity,
                                              child: Center(
                                                child: ListView.separated(
                                                  itemCount: masterDetailsTitles.length,
                                                  scrollDirection: Axis.horizontal,
                                                  shrinkWrap: true,
                                                  controller: _masterDetailsScrollController,
                                                  separatorBuilder: (_, index) => Padding(
                                                    padding: EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: DeviceConstraints.getResponsiveSize(context, 2.w, 5.w, 5.w),
                                                      // horizontal: DeviceConstraints.getResponsiveSize(context, 2.w, 3.w, 7.w),
                                                    ),
                                                    child: Container(
                                                      width: 1.5,
                                                      height: 25.h,
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[400], // isLightTheme ? Colors.white : Colors.grey,
                                                        borderRadius: BorderRadius.circular(50),
                                                      ),
                                                    ),
                                                  ),
                                                  itemBuilder: (_, index) {
                                                    return Center(
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              _pageController.jumpToPage(index);
                                                              _activeTab = index;
                                                            });
                                                          },
                                                          child: Text(
                                                            // ((AppLocalizations.of(context)?.localeName == 'uk') ? masterDetailsTitlesUk[index] : masterDetailsTitles[index]).toUpperCase(),
                                                            masterTitles(AppLocalizations.of(context)?.localeName ?? 'en')[index],
                                                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                                                  fontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 15.sp, 15.sp),
                                                                  color: _activeTab == index ? theme.primaryColor : unselectedTabColor(theme, isLightTheme),
                                                                  fontWeight: _activeTab == index ? FontWeight.w700 : FontWeight.w500,
                                                                  decoration: _activeTab == index ? TextDecoration.underline : null,
                                                                  letterSpacing: 0,
                                                                  fontFamily: "Inter",
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              ExpandablePageView(
                                padEnds: false,
                                key: const ValueKey("exp"),
                                physics: const NeverScrollableScrollPhysics(),
                                controller: _pageController,
                                onPageChanged: (ind) {
                                  setState(() {
                                    _activeTab = ind;
                                  });
                                },
                                children: [
                                  MasterServices(master: widget.masterModel),
                                  MasterAbout(
                                    master: widget.masterModel,
                                    categories: widget.categories,
                                  ),
                                  MasterAllWorks(master: widget.masterModel),
                                ],
                              ),
                              const Space(factor: 3),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: FloatingBar(
                master: true,
                masterModel: widget.masterModel,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


  //  const Align(
  //           alignment: Alignment.bottomCenter,
  //           child: FloatingBar(
  //             master: true,
  //             themeNo: 0,
  //           ),
  //         ),