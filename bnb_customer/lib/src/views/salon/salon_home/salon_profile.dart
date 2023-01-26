// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/app_provider.dart';
import 'package:bbblient/src/controller/bnb/bnb_provider.dart';
import 'package:bbblient/src/controller/create_apntmnt_provider/create_appointment_provider.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/firebase/category_services.dart';
import 'package:bbblient/src/models/backend_codings/owner_type.dart';
import 'package:bbblient/src/models/cat_sub_service/category_service.dart';
import 'package:bbblient/src/models/cat_sub_service/services_model.dart';
import 'package:bbblient/src/models/enums/status.dart';
import 'package:bbblient/src/models/promotions/promotion_service.dart';
import 'package:bbblient/src/routes.dart';
import 'package:bbblient/src/utils/analytics.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/salon/booking/booking_date_time.dart';
import 'package:bbblient/src/views/salon/salon_home/salon_masters.dart';
import 'package:bbblient/src/views/salon/widgets/floating_button_booking.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import '../../../models/enums/profile_datails_tabs.dart';
import '../../../theme/app_main_theme.dart';
import '../widgets/salon_header.dart';
import 'salon_about.dart';
import 'salon_all_works.dart';
import 'salon_services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SalonPage extends ConsumerStatefulWidget {
  static const route = 'salon';
  final String salonId;

  final bool switchSalon;
  final String locale;
  final List<ServiceModel> chosenServices;
  final bool showBackButton;

  const SalonPage({Key? key, required this.salonId, this.locale = "uk", this.showBackButton = true, this.switchSalon = true, this.chosenServices = const []}) : super(key: key);
  @override
  _SaloonProfileState createState() => _SaloonProfileState();
}

class _SaloonProfileState extends ConsumerState<SalonPage> {
  final _mainScrollController = ScrollController();
  final ScrollController _scrollController = ScrollController();
  final PageController _pageController = PageController();
  late SalonProfileProvider _salonProfileProvider;
  int _activeTab = 0;
  bool choosen = false;
  List<CategoryModel>? categories;
  final ScrollController _listViewController = ScrollController();
  @override
  void initState() {
    // final _bnbProvider = ref.read(bnbProvider);
    // print(widget.locale);
    // _bnbProvider.changeLocale(locale: const Locale('uk'));
    final AppProvider _appProvider = ref.read(appProvider);
    super.initState();
    print('==========');

    _appProvider.selectSalonFirstRoute();

    printIt(_appProvider.firstRoute);
    final _salonSearchProvider = ref.read(salonSearchProvider);

    _salonSearchProvider.init(widget.salonId).then((value) => WidgetsBinding.instance.addPostFrameCallback((_) async {
          categories = value;
        }));
    _salonProfileProvider = ref.read(salonProfileProvider);
    _salonProfileProvider.init(widget.salonId).then((salon) => WidgetsBinding.instance.addPostFrameCallback((_) async {
          // here we set the time interval instead of the 15mins preset available
          await init(salon);
        }));
  }

  init(salon) async {
    // Time().timeSlotSize = Duration(minutes: salon!.timeSlotsInterval!);
    // Time().timeSlotSizeInt = salon!.timeSlotsInterval!;
    // await Time().setTimeSlot(salon!.timeSlotsInterval);
    categories = await CategoryServicesApi().getCategories();
    final _createAppointmentProvider = ref.read(createAppointmentProvider);
    final repository = ref.watch(bnbProvider);

    repository.changeLocale(locale: Locale(widget.locale));
    if (widget.switchSalon) {
      _createAppointmentProvider.setSalon(
        salonModel: salon,
        context: context,
        servicesFromSearch: widget.chosenServices,
      );
      await _salonProfileProvider.getSalonReviews(salonId: widget.salonId);
      Future.delayed(const Duration(milliseconds: 1000), () async {
        if (mounted) {
          if (_createAppointmentProvider.chosenServices.isNotEmpty) {
            setState(() {});
            await Future.delayed(const Duration(milliseconds: 300), () {
              _mainScrollController.animateTo(300, duration: const Duration(milliseconds: 800), curve: Curves.ease);
            });
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _mainScrollController.dispose();
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  _reportTabChange(i) {
    String currentPage = "";
    switch (i) {
      case 0:
        {
          currentPage = "salonServices";
          break;
        }
      case 1:
        {
          currentPage = "salonAbout";
          break;
        }
      case 2:
        {
          (_salonProfileProvider.chosenSalon.ownerType == OwnerType.salon) ? currentPage = "salonMasters" : currentPage = "salonAllWorks";
          break;
        }
      case 3:
        {
          currentPage = "salonAllWorks";
          break;
        }
    }
    Analytics.getInstance().logEvent(name: "Tab opened : $currentPage");
  }

  @override
  Widget build(BuildContext context) {
    final _salonSearchProvider = ref.watch(salonSearchProvider);
    final CreateAppointmentProvider _createAppointmentProvider = ref.watch(createAppointmentProvider);
    final BnbProvider _bnbProvider = ref.watch(bnbProvider);

    return Scaffold(
      body: SafeArea(
          top: false,
          bottom: false,
          child: _salonProfileProvider.loadingStatus == Status.loading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : _salonProfileProvider.loadingStatus == Status.failed
                  ? const ErrorScreen()
                  : Stack(
                      children: [
                        SingleChildScrollView(
                          controller: _mainScrollController,
                          child: Column(
                            children: [
                              SaloonHeader(
                                salonModel: _salonProfileProvider.chosenSalon,
                              ),
                              // if (_salonProfileProvider
                              //     .chosenSalon.photosOfWork.isNotEmpty)
                              //   SalonBestWorks(
                              //     salonModel: _salonProfileProvider.chosenSalon,
                              //   ),
                              Space(height: DeviceConstraints.getResponsiveSize(context, 40, 40, 40)),
                              Loader(
                                //status: Status.loading,
                                status: Status.success,
                                iconPadding: const EdgeInsets.only(top: 100, bottom: 100),
                                child: Column(
                                  children: [
                                    // Padding(
                                    //   padding: EdgeInsets.only(
                                    //     left: DeviceConstraints.getResponsiveSize(context, 16, 24, 32),
                                    //   ),
                                    //   child: Row(
                                    //     mainAxisAlignment: MainAxisAlignment.start,
                                    //     children: [
                                    //       Text(
                                    //         "Promotions",
                                    //         textAlign: TextAlign.left,
                                    //         style: GoogleFonts.epilogue(
                                    //           fontSize: DeviceConstraints.getResponsiveSize(context, 16, 16, 20),
                                    //           fontWeight: FontWeight.w500,
                                    //           color: Color(0xff89959F),
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                    // Padding(
                                    //   padding: EdgeInsets.only(
                                    //     top: DeviceConstraints.getResponsiveSize(context, 16, 16, 24),
                                    //     bottom: DeviceConstraints.getResponsiveSize(context, 16, 16, 24),
                                    //     left: DeviceConstraints.getResponsiveSize(context, 16, 24, 32),
                                    //   ),
                                    //   child: PromotionScroll(),
                                    // ),
                                    // SERVICES - ABOUT - MASTERS - ALL WORKS
                                    Padding(
                                      padding: EdgeInsets.zero,
                                      child: SizedBox(
                                        height: 45.h,
                                        child: ListView.builder(
                                          itemCount: (_salonProfileProvider.chosenSalon.ownerType == OwnerType.salon) ? saloonDetailsTitles.length : masterDetailsTitles.length,
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          controller: _scrollController,
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
                                                    color: _activeTab == index ? Color.fromARGB(255, 239, 239, 239) : Theme.of(context).scaffoldBackgroundColor,
                                                    borderRadius: BorderRadius.circular(50),
                                                  ),
                                                  child: Center(
                                                    child: Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                                                      child: Text(
                                                        (_salonProfileProvider.chosenSalon.ownerType == OwnerType.salon)
                                                            ? (AppLocalizations.of(context)?.localeName == 'uk')
                                                                ? saloonDetailsTitlesUK[index]
                                                                : saloonDetailsTitles[index].toCapitalized()
                                                            : (AppLocalizations.of(context)?.localeName == 'uk')
                                                                ? masterDetailsTitlesUk[index]
                                                                : masterDetailsTitles[index].toCapitalized(),
                                                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                                              color: _activeTab == index ? AppTheme.textBlack : AppTheme.lightGrey,
                                                              fontWeight: _activeTab == index ? FontWeight.w600 : FontWeight.w500,
                                                            ),
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
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: DeviceConstraints.getResponsiveSize(context, 17.w, 0, 0)),
                                      child: ExpandablePageView(
                                        padEnds: false,
                                        key: ValueKey("exp"),
                                        controller: _pageController,
                                        onPageChanged: (i) {
                                          _reportTabChange(i);
                                          setState(() {
                                            _activeTab = i;
                                          });
                                        },
                                        children: [
                                          // Text(categories!.length.toString()),
                                          SalonServices(
                                            key: const ValueKey("services"),
                                            salonModel: _salonProfileProvider.chosenSalon,
                                            categories: _salonSearchProvider.categories,
                                          ),
                                          SalonAbout(
                                            salonModel: _salonProfileProvider.chosenSalon,
                                          ),
                                          if (_salonProfileProvider.chosenSalon.ownerType == OwnerType.salon) ...[
                                            SaloonMasters(
                                              salonModel: _salonProfileProvider.chosenSalon,
                                            ),
                                          ],
                                          SaloonAllWorks(
                                            salonModel: _salonProfileProvider.chosenSalon,
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 80.h,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            key: const ValueKey("book-key"),
                            onTap: () {
                              if (_createAppointmentProvider.chosenServices.isNotEmpty) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(settings: RouteSettings(name: "Foo1"), builder: (_) => const BookingDateTime()),
                                );
                              } else {
                                Utils().vibrateNegatively();
                                showToast(
                                    // AppLocalizations.of(context)
                                    //       ?.pleaseChooseAService ??
                                    "Please choose a servicess");
                              }
                            },
                            child: Container(
                              width: 0.5.sw,
                              height: 60.h,
                              decoration: const BoxDecoration(
                                color: AppTheme.creamBrown,
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(28)),
                              ),
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context)?.bookNow ?? "Book Now",
                                  style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // if (widget.showBackButton)
                        //   Positioned(
                        //     top: DeviceConstraints.getResponsiveSize(context, 10, 20, 30),
                        //     left: DeviceConstraints.getResponsiveSize(context, 10, 20, 30),
                        //     child: const SafeArea(
                        //       child: BackButtonGlassMorphic(),
                        //     ),
                        //   ),
                        // Positioned(
                        //   top: DeviceConstraints.getResponsiveSize(context, 10, 20, 30),
                        //   right: DeviceConstraints.getResponsiveSize(context, 10, 20, 30),
                        //   child: SafeArea(
                        //       child: GestureDetector(
                        //     onTap: () async {
                        //       checkUser(context, ref, () => _bnbProvider.toggleFav(_salonProfileProvider.chosenSalon.salonId));
                        //     },
                        //     child: Container(
                        //         height: DeviceConstraints.getResponsiveSize(context, 32, 40, 48),
                        //         width: DeviceConstraints.getResponsiveSize(context, 32, 40, 48),
                        //         decoration: BoxDecoration(color: Colors.white38, borderRadius: BorderRadius.circular(8)),
                        //         child: Padding(
                        //           padding: EdgeInsets.all(
                        //             DeviceConstraints.getResponsiveSize(context, 4, 6, 8),
                        //           ),
                        //           child: _bnbProvider.checkForFav(_salonProfileProvider.chosenSalon.salonId) ? SvgPicture.asset(AppIcons.heartfilledSVG) : SvgPicture.asset(AppIcons.heartemptySVG),
                        //         )),
                        //   )),
                        // ),
                        const Align(alignment: Alignment.bottomCenter, child: FloatingBar())
                      ],
                    )),
    );
  }
}

class PromotionLoading extends StatelessWidget {
  const PromotionLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 5,
      width: 5,
    );
  }
}

class PromotionCard extends StatelessWidget {
  final PromotionModel? promotionModel;
  const PromotionCard({Key? key, this.promotionModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: DeviceConstraints.getResponsiveSize(context, 150, 165, 200),
      width: DeviceConstraints.getResponsiveSize(context, 228, 265, 327),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/promotion_card_client.png"),
          fit: BoxFit.fill,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 16, left: 12, bottom: 19),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    promotionModel!.promotionTitle != null
                        ? promotionModel!.promotionTitle!
                        : promotionModel!.promotionType == PromotionType.last_minute
                            ? "Last Minute"
                            : "",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.epilogue(
                      fontSize: DeviceConstraints.getResponsiveSize(context, 14, 16, 18),
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    )),
                Space(
                  height: 7.h,
                ),
                Text(
                  "Discount: ${promotionModel!.promotionDiscount} ${promotionModel!.discountUnit == "PCT(%)" ? '%' : '₴'}",
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: Color(0xff89959F),
                        fontSize: DeviceConstraints.getResponsiveSize(context, 12, 14, 16),
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Applies to" + getPromotionType(type: promotionModel!.promotionType!),
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: Colors.white,
                        fontSize: DeviceConstraints.getResponsiveSize(context, 12, 14, 16),
                        fontWeight: FontWeight.w500,
                      ),
                ),
                Space(
                  height: 12.h,
                ),
                Text(
                  "Valid until.${Jiffy(promotionModel!.endDate).format("dd MMM yyyy")}",
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: Color(0xff89959F),
                        fontSize: DeviceConstraints.getResponsiveSize(context, 10, 12, 14),
                      ),
                ),
              ],
            )
          ],
        ),
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

    print('Gotten here ??');

    return SizedBox(
      height: DeviceConstraints.getResponsiveSize(context, 155, 185, 210),
      child: ListView.builder(
        controller: _promotionListController,
        shrinkWrap: true,
        primary: false,
        itemCount: _createAppointmentProvider.salonPromotions.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          PromotionModel _promo = _createAppointmentProvider.salonPromotions[index];
          print('--------------------------');
          print(_promo);

          return Padding(
            padding: EdgeInsets.only(right: DeviceConstraints.getResponsiveSize(context, 15, 18, 24)),
            child: GestureDetector(
              // onTap: () {
              //   setState(() {
              //     currentCard = index;
              //   });
              // },
              child: PromotionCard(
                promotionModel: _promo,
              ),
            ),
          );
        },
      ),
    );
  }
}

String getPromotionType({required String type}) {
  switch (type) {
    case PromotionType.service:
      return "Service(s)";
    case PromotionType.service_set:
      return "Service Set";
    case PromotionType.visit:
      return "Visit";
    case PromotionType.last_minute:
      return "Last Minute";
    case PromotionType.happy_hour:
      return "Happy Hour";

    default:
      return "No Promotion";
  }
}

//class BottomButton extends StatelessWidget {
//   final void Function() onTap;
//   final bool showBackButton;
//   const BottomButton({Key? key, required this.onTap, this.showBackButton=false}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       bottom: 0,
//       right: 0,
//       child: Container(
//         height: 60.h,
//         color: showBackButton?Colors.black.withOpacity(0.1):null,
//         child: Row(
//           children: [
//             GestureDetector(
//               onTap: () => Navigator.of(context).pop(),
//               child: Ink(
//                   height: double.infinity,
//                   width: 0.5.sw,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Icon(CupertinoIcons.back),
//                       const SizedBox(
//                         width: 5,
//                       ),
//                       Text(AppLocalizations.of(context)?.back ?? "Back",
//                           style: Theme.of(context)
//                               .textTheme
//                               .bodyText1!
//                               .copyWith(fontWeight: FontWeight.w600)),
//                     ],
//                   )),
//             ),
//             GestureDetector(
//               onTap: onTap,
//               child: Ink(
//                 width: 0.5.sw,
//                 decoration: const BoxDecoration(
//                     color: AppTheme.creamBrown,
//                     borderRadius:
//                         BorderRadius.only(topLeft: Radius.circular(28))),
//                 child: Center(
//                   child: Text(
//                     AppLocalizations.of(context)?.bookNow ?? "Book Now",
//                     style: Theme.of(context)
//                         .textTheme
//                         .subtitle1!
//                         .copyWith(color: Colors.white),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
