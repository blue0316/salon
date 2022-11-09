// ignore_for_file: prefer_const_constructors

import 'dart:ui';
import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/create_apntmnt_provider/create_appointment_provider.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/promotions/promotion_service.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/salon/booking/booking_date_time.dart';
import 'package:bbblient/src/views/salon/widgets/book_now_button.dart';
import 'package:bbblient/src/views/salon/widgets/floating_button_booking.dart';
import 'package:bbblient/src/views/widgets/buttons.dart';

import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bbblient/src/models/salon_master/master.dart';
import '../../../models/enums/profile_datails_tabs.dart';
import '../../../theme/app_main_theme.dart';
import '../widgets/master_profile_header.dart';
import 'master_about.dart';
import 'master_allworks.dart';
import 'master_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MasterProfile extends ConsumerStatefulWidget {
  // static const route = 'master';

  final MasterModel masterModel;
  final String salonProfileImage;

  const MasterProfile({
    Key? key,
    required this.masterModel,
    this.salonProfileImage = '',
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
    _salonProfileProvider.getMasterReviews(
      masterId: widget.masterModel.masterId);
        // masterId: widget.masterModel!.masterId);
  }

  @override
  Widget build(BuildContext context) {
    _createAppointmentProvider = ref.watch(createAppointmentProvider);
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                MasterHeader(
                  masterModel: widget.masterModel!,
                ),
                Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.only(left: 0.0.w, top: 28.h, bottom: 25.h),
                      child: SizedBox(
                        height: 55.h,
                        child: ListView.builder(
                          itemCount: masterDetailsTitles.length,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          controller: _masterDetailsScrollController,
                          itemBuilder: (_, index) {
                            return Padding(
                              padding: EdgeInsets.only(right: 4.w),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _pageController.jumpToPage(index);
                                    _activeTab = index;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: _activeTab == index
                                        ? Colors.white
                                        : Theme.of(context)
                                            .scaffoldBackgroundColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.0.w, vertical: 12.h),
                                      child: Text(
                                        (AppLocalizations.of(context)
                                                    ?.localeName ==
                                                'uk')
                                            ? masterDetailsTitlesUk[index]
                                            : masterDetailsTitles[index],
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2!
                                            .copyWith(
                                                color: _activeTab == index
                                                    ? AppTheme.textBlack
                                                    : AppTheme.lightGrey,
                                                fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    ///Promotions
                    // Container(
                    //   color: Colors.red,
                    // ),
                    // PromotionScroll(),
                    ExpandablePageView(
                      controller: _pageController,
                      onPageChanged: (ind) {
                        setState(() {
                          _activeTab = ind;
                        });
                      },
                      children: [
                        MasterServices(
                          master: widget.masterModel,
                          // master: widget.masterModel!,
                        ),
                        MasterAbout(
                          master: widget.masterModel,
                          // master: widget.masterModel!,
                        ),
                        MasterAllWorks(
                          master: widget.masterModel,
                          // master: widget.masterModel!,
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: GestureDetector(
              onTap: () {
                if (_createAppointmentProvider.chosenServices.isNotEmpty) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const BookingDateTime()));
                } else {
                  Utils().vibrateNegatively();
                  showToast(
                      AppLocalizations.of(context)?.pleaseChooseAService ??
                          "Please choose a service");
                }
              },
              child: const BookNowButton(),
            ),
          ),
          const Positioned(
            top: 10,
            left: 10,
            child: SafeArea(
              child: BackButtonGlassMorphic(),
            ),
          ),
          const Align(alignment: Alignment.bottomCenter, child: FloatingBar()),
        ],
      ),
    );
  }
}

class PromotionLoading extends StatelessWidget {
  const PromotionLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 30,
      width: 30,
    );
  }
}

class PromotionCard extends StatelessWidget {
  const PromotionCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140.h,
      width: 218.w,
      child: Container(
        // height: 140.h,
        // width: 218.w,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/promotion_card_client.png"),
            fit: BoxFit.cover,
          ),
        ),
        // child: Column(),
      ),
    );
  }
}

class PromotionScroll extends ConsumerWidget {
  const PromotionScroll({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    // final _bnbProvider = ref.watch(bnbProvider);
    final _createAppointmentProvider = ref.watch(createAppointmentProvider);

    ScrollController _promotionListController = ScrollController();

    if (_createAppointmentProvider.salonPromotions.isEmpty) {
      return const Center(child: PromotionLoading());
    }

    return SizedBox(
      height: 145.h,
      child: Expanded(
        child: ListView.builder(
          controller: _promotionListController,
          shrinkWrap: true,
          primary: false,
          
          itemCount: _createAppointmentProvider.salonPromotions.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return PromotionCard();
          },
        ),
      ),
    );
  }
}
