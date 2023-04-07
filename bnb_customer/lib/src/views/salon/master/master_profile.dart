// ignore_for_file: prefer_const_constructors

import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/create_apntmnt_provider/create_appointment_provider.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/salon/default_profile_view/widgets/header.dart';
import 'package:bbblient/src/views/salon/widgets/floating_button_booking.dart';
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

  const MasterProfile({
    Key? key,
    required this.masterModel,
    this.salonProfileImage = '',
    required this.salonModel,
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
    _createAppointmentProvider = ref.watch(createAppointmentProvider);

    return Scaffold(
      body: Container(
        color: Colors.pink,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Header(salonModel: _salonProfileProvider.chosenSalon),
                    Space(
                      factor: DeviceConstraints.getResponsiveSize(context, 2, 3, 5),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: DeviceConstraints.getResponsiveSize(context, 10.w, 50.w, 90.w),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: DeviceConstraints.getResponsiveSize(context, 0, 0, 25.w),
                            ),
                            child: Container(
                              height: 75.h,
                              width: double.infinity,
                              color: Colors.white,
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
                                        padding: const EdgeInsets.symmetric(vertical: 8),
                                        child: Container(
                                          width: 2.5,
                                          height: 18.h,
                                          decoration: BoxDecoration(color: const Color(0XFFEDEDED), borderRadius: BorderRadius.circular(50)),
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
                                                ((AppLocalizations.of(context)?.localeName == 'uk') ? masterDetailsTitlesUk[index] : masterDetailsTitles[index]).toUpperCase(),
                                                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                                      fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 18.sp, 20.sp),
                                                      color: AppTheme.textBlack,
                                                      fontWeight: _activeTab == index ? FontWeight.w800 : FontWeight.w600,
                                                      decoration: _activeTab == index ? TextDecoration.underline : null,
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
                              MasterAbout(master: widget.masterModel),
                              MasterAllWorks(master: widget.masterModel),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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