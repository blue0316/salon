import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/views/themes/city_muse/city_muse_desktop/city_muse_desktop.dart';
import 'package:bbblient/src/views/themes/city_muse/city_muse_mobile/products.dart';
import 'package:bbblient/src/views/themes/city_muse/city_muse_mobile/service_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../controller/all_providers/all_providers.dart';
import '../../../../models/cat_sub_service/category_service.dart';
import '../../../../models/cat_sub_service/services_model.dart';
import '../../../../models/customer_web_settings.dart';
import '../../../../models/enums/status.dart';
import '../../../../models/products.dart';
import '../../../../models/salon_master/salon.dart';
import '../../../../utils/icons.dart';
import '../../../../utils/utils.dart';
import '../../../salon/booking/dialog_flow/booking_dialog_2.dart';
import '../../../salon/widgets/additional featured.dart';
import '../../../widgets/image.dart';
import '../../../widgets/widgets.dart';
import '../../components/contacts/widgets/contact_maps.dart';
import '../../images.dart';
import '../../utils/theme_type.dart';

class GlamMinimalPhone extends ConsumerStatefulWidget {
  const GlamMinimalPhone({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GlamMinamlPhoneState();
}

class _GlamMinamlPhoneState extends ConsumerState<GlamMinimalPhone> {
  final int _currentIndex = 0;
  int _currentProductIndex = 0;
  int _currentProductImageIndex = 0;
  int _currentServiceIndex = 0;
  bool isShowMenu = false;
  String? currentSelectedEntry;
  final List<String> tabs = ["All", "Hair", "Body care", "Face care"];
  final List<String> tabs2 = [
    "All",
    "Makeup",
    "Shaving",
    "Eyebrows & Eyelashes"
  ];
  String? selectedCatId = '';
  final PageController _pageController = PageController();

  int currentIndex = 0;
  int currentServiceIndex = 0;
  int currentReviewIndex = 0;
  bool isExpanded = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    ref
        .read(salonSearchProvider)
        .getAllSalonServices(ref.read(createAppointmentProvider));
    // ref.read(createAppointmentProvider);
  }

  List<Map<String, String>> getFeaturesList(String locale) {
    switch (locale) {
      case 'uk':
        return ukSalonFeatures;
      case 'es':
        return esSalonFeatures;
      case 'fr':
        return frSalonFeatures;
      case 'pt':
        return ptSalonFeatures;
      case 'ro':
        return roSalonFeatures;
      case 'ar':
        return arSalonFeatures;

      default:
        return salonFeatures;
    }
  }

  getFeature(String s, locale) {
    List<Map<String, String>> searchList = getFeaturesList(locale);

    for (Map registeredFeatures in searchList) {
      if (registeredFeatures.containsKey(s)) {
        return registeredFeatures[s];
      }
    }

    return s;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final _salonProfileProvider = ref.watch(salonProfileProvider);
    final _salonSearchProvider = ref.watch(salonSearchProvider);
    final _createAppointmentProvider = ref.watch(createAppointmentProvider);
    final controller = ref.watch(themeController);

    final SalonModel chosenSalon = _salonProfileProvider.chosenSalon;
    final DisplaySettings? displaySettings =
        _salonProfileProvider.themeSettings?.displaySettings;

    return Scaffold(
      key: scaffoldKey,
      drawer: const Drawer(
        width: double.infinity,
      ),
      appBar: AppBar(
        backgroundColor:
            _salonProfileProvider.salonTheme.appBarTheme.backgroundColor,
        leading: chosenSalon.salonLogo.isEmpty
            ? Padding(
                padding: EdgeInsets.only(left: 5.w),
                child: SizedBox(
                  height: 70.h,
                  width: 100.h,
                  child: Center(
                    child: Text(chosenSalon.salonName.initials,
                        style: TextStyle(
                            fontFamily: "VASQUZ",
                            color: _salonProfileProvider
                                .salonTheme.appBarTheme.titleTextStyle!.color,
                            fontWeight: FontWeight.bold,
                            fontSize: 14)),
                  ),
                ),
              )

            //  Padding(
            //     padding: const EdgeInsets.only(top: 8.0),
            //     child:
            //   )
            : CachedImage(
                url: chosenSalon.salonLogo,
              ),
        //       Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: SvgPicture.asset(
        //     "assets/test_assets/logo.svg",
        //     color: _salonProfileProvider
        //         .salonTheme.appBarTheme.titleTextStyle!.color,
        //   ),
        // ),
        actions: [
          GestureDetector(
            onTap: () {
              if (!_salonProfileProvider.isShowMenuMobile) {
                setState(() {
                  isShowMenu = true;
                });
                print('true');
                _salonProfileProvider.getWidgetForMobile('menu');
                _salonProfileProvider.changeShowMenuMobile(true);
              } else {
                setState(() {
                  isShowMenu = false;
                });
                _salonProfileProvider.changeShowMenuMobile(false);
                print('false');
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                _salonProfileProvider.isShowMenuMobile
                    ? "assets/test_assets/cancel_menu.svg"
                    : "assets/test_assets/menu.svg",
                color: _salonProfileProvider
                    .salonTheme.appBarTheme.titleTextStyle!.color,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: _salonProfileProvider.salonTheme.scaffoldBackgroundColor,
      body: _salonProfileProvider.isShowMenuMobile
          ? Container(
              width: double.infinity,
              color: _salonProfileProvider.salonTheme.scaffoldBackgroundColor,
              child: _salonProfileProvider.currentWidget)
          : ListView(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(50),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 2),
                    child: SizedBox(
                      //   width: 409,
                      height: 150,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Text(
                              chosenSalon.salonName.toTitleCase(),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.openSans(
                                color: _salonProfileProvider
                                    .salonTheme.textTheme.titleLarge!.color,
                                fontSize: 46,
                                //     fontFamily: 'Open Sans',
                                fontWeight: FontWeight.w600,
                                height: 1,
                              ),
                            ),
                          ),
                          // Expanded(
                          //   child: Text(
                          //     'by Ashley Marie',
                          //     textAlign: TextAlign.center,
                          //     style: GoogleFonts.ooohBaby(
                          //       //   color: const Color(0xFF0D0D0E),
                          //       fontSize: 30,
                          //       color: _salonProfileProvider
                          //           .salonTheme.textTheme.titleLarge!.color,
                          //       //  fontFamily: 'Oooh Baby',
                          //       fontWeight: FontWeight.w400,
                          //       height: 0,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Gap(54),
                if (chosenSalon.specializations != null &&
                    chosenSalon.specializations!.isNotEmpty &&
                    displaySettings!.showSpecialization)
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Wrap(
                        //verticalDirection: VerticalDirection.up,
                        alignment: WrapAlignment.start,
                        runSpacing: 7,
                        spacing: 10,
                        children: chosenSalon.specializations!
                            .map(
                              (e) => SpecializationBox(
                                name: e.toString(),
                              ),
                            )
                            .toList()),
                  ),
                const Gap(48),
                GestureDetector(
                  onTap: () {
                    const BookingDialogWidget222().show(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 12),
                    child: Row(
                      children: [
                        Text('BOOK NOW',
                            style: GoogleFonts.openSans(
                                color: _salonProfileProvider
                                    .salonTheme.colorScheme.secondary,
                                fontSize: 18,
                                fontWeight: FontWeight.w700)),
                        const Gap(10),
                        Image.asset(
                          'assets/test_assets/book_arrow.png',
                          height: 24,
                          width: 24,
                          color: _salonProfileProvider
                              .salonTheme.colorScheme.secondary,
                        ),
                      ],
                    ),
                  ),
                ),
                const Gap(18),
                (_salonProfileProvider.themeSettings?.backgroundImage != null &&
                        _salonProfileProvider.themeSettings?.backgroundImage !=
                            '')
                    ? CachedImage(
                        url: _salonProfileProvider
                            .themeSettings!.backgroundImage!,
                        width: size.width,
                        fit: BoxFit.fitWidth,
                      )
                    : Image.asset(
                        AppIcons.photoSlider,
                        width: size.width,
                        fit: BoxFit.fitWidth,
                      ),
                // Image.asset(
                //   'assets/test_assets/Background.png',
                //   width: double.infinity,
                //   fit: BoxFit.fitWidth,
                // ),

                if (chosenSalon.additionalFeatures.isNotEmpty &&
                    displaySettings!.showFeatures)
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) => FeaturesCheck(
                      title: getFeature(
                          _salonProfileProvider
                              .chosenSalon.additionalFeatures[index],
                          chosenSalon.locale),
                    ),
                    itemCount: chosenSalon.additionalFeatures.length,
                  ),
                Gap(100.h),
                if (chosenSalon.description.isNotEmpty &&
                    displaySettings!.showAbout) ...[
                  SizedBox.fromSize(size: Size.zero, key: controller.about),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0, right: 8.0),
                    child: Text(
                      'WHO ARE WE?',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.openSans(
                        color: _salonProfileProvider
                            .salonTheme.textTheme.displaySmall!.color,
                        fontSize: 40,
                        // fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w600,
                        height: 0.04,
                      ),
                    ),
                  ),
                  const Gap(20),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        chosenSalon.description.toCapitalized(),
                        textAlign: TextAlign.justify,
                        style: GoogleFonts.openSans(
                          color: _salonProfileProvider
                              .salonTheme.textTheme.titleSmall!.color,
                          fontSize: 16,
                          // fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                          letterSpacing: 0.16,
                        ),
                      ),
                    ),
                  ),
                  const Gap(20),
                  if (chosenSalon.profilePics.isNotEmpty)
                    CarouselSlider.builder(
                      options: CarouselOptions(
                        height: 315,
                        aspectRatio: 16 / 9,
                        viewportFraction: 1,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        enlargeFactor: 0.3,
                        onPageChanged: (value, reason) {
                          // setState(() {
                          //   currentIndex = value;
                          // });
                        },
                        scrollDirection: Axis.horizontal,
                      ),
                      itemCount: chosenSalon.profilePics.length,
                      itemBuilder:
                          (BuildContext context, int index, int realIndex) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20),
                          child: CachedImage(
                            url: chosenSalon.profilePics[index].toString(),
                            width: size.width,
                            fit: BoxFit.fitWidth,
                            height: 400,
                          ),
                        );
                      },
                    ),
                ],

                const Gap(24),

                if (chosenSalon.photosOfWorks != null &&
                    chosenSalon.photosOfWorks!.isNotEmpty &&
                    displaySettings!.showPhotosOfWork) ...[
                  SizedBox.fromSize(size: Size.zero, key: controller.works),
                  const Gap(120),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0, right: 8.0),
                    child: Text(
                      (AppLocalizations.of(context)?.portfolio ?? 'PORTFOLIO')
                          .toUpperCase(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.openSans(
                        color: _salonProfileProvider
                            .salonTheme.textTheme.displaySmall!.color,
                        fontSize: 40,
                        // fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w600,
                        height: 0.03,
                      ),
                    ),
                  ),
                  const Gap(30),
                  if (chosenSalon.photosOfWorks != null &&
                      chosenSalon.photosOfWorks!.isNotEmpty &&
                      displaySettings.showPhotosOfWork)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 450,
                        decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFF282828))),
                        child: CarouselSlider.builder(
                          options: CarouselOptions(
                            height: 450,
                            aspectRatio: 16 / 9,
                            viewportFraction: 1,
                            initialPage: 0,
                            enableInfiniteScroll: true,
                            reverse: false,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                const Duration(milliseconds: 800),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enlargeCenterPage: true,
                            enlargeFactor: 0,
                            onPageChanged: (value, reason) {
                              setState(() {
                                currentIndex = value;
                              });
                            },
                            scrollDirection: Axis.horizontal,
                          ),
                          itemCount: chosenSalon.photosOfWorks!.length,
                          itemBuilder:
                              (BuildContext context, int index, int realIndex) {
                            return Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: CachedImage(
                                      url: chosenSalon
                                          .photosOfWorks![index].image
                                          .toString(),
                                      width: size.width,
                                      fit: BoxFit.fitWidth,
                                      height: 296,
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 16),
                                    decoration: const ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                          // side: BorderSide(width: 1, color: Color(0xFF282828)),
                                          ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            chosenSalon.photosOfWorks![index]
                                                .description
                                                .toString(),
                                            style: GoogleFonts.openSans(
                                              //  color: const Color(0xFF282828),
                                              fontSize: 16,
                                              //  fontFamily: 'Onest',
                                              fontWeight: FontWeight.w400,
                                              height: 1.5,
                                              letterSpacing: 0.16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  Center(
                    child: SizedBox(
                      height: 30,
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: CircleAvatar(
                                radius: 5,
                                backgroundColor: currentIndex == index
                                    ? _salonProfileProvider
                                        .salonTheme.colorScheme.outlineVariant
                                    : _salonProfileProvider
                                        .salonTheme.colorScheme.outline,
                              ),
                            );
                          },
                          itemCount: chosenSalon.photosOfWorks!.length),
                    ),
                  ),
                  const Gap(130),
                ],

                if (displaySettings!.services.showServices) ...[
                  SizedBox.fromSize(size: Size.zero, key: controller.price),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0, right: 8.0),
                    child: Text(
                      (AppLocalizations.of(context)?.services ?? 'SERVICES')
                          .toUpperCase(),
                      style: GoogleFonts.openSans(
                        color: _salonProfileProvider
                            .salonTheme.textTheme.displaySmall!.color,
                        fontSize: 40,
                        //  fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                  ),
                  const Gap(50),

                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 8.0),
                    child: SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _createAppointmentProvider
                                .categoriesAvailable.length +
                            1,
                        itemBuilder: (context, index) {
                          List<CategoryModel> catList = [
                            CategoryModel(
                              categoryName: 'All',
                              categoryId: 'all',
                              translations: {
                                'en': 'All',
                                'es': 'Toda',
                                'pt': 'Todos',
                                'ro': 'Toate',
                                'uk': 'все',
                                'fr': 'Tout',
                              },
                            ),
                            ..._createAppointmentProvider.categoriesAvailable,
                          ];

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _currentServiceIndex = index;
                                selectedCatId = catList[index].categoryId;
                                print('selectedId $selectedCatId');
                                _pageController.animateToPage(
                                  index,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.ease,
                                );
                              });
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),

                              decoration: BoxDecoration(
                                border: _currentServiceIndex == index
                                    ? BorderDirectional(
                                        bottom: BorderSide(
                                          width: 2,
                                          color: _salonProfileProvider
                                              .salonTheme.colorScheme.secondary,
                                        ),
                                      )
                                    : null,
                              ),
                              //Change the tab's color
                              child: Center(
                                child: Text(
                                  '${catList[index].translations[AppLocalizations.of(context)?.localeName ?? 'en'] ?? catList[index].translations['en']}'
                                      .toTitleCase(),
                                  style: GoogleFonts.openSans(
                                    color: _salonProfileProvider
                                        .salonTheme.textTheme.bodyMedium!.color,
                                    fontSize: 16,
                                    // _currentIndex == index
                                    //     ? Colors.white
                                    //     : Colors.black, // Change the text color
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const Gap(30),
                  // Tab Content
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 400,
                      child: Builder(builder: (_) {
                        if (_currentServiceIndex == 0) {
                          List<ServiceModel> allServiceList = [];
                          for (List<ServiceModel> serviceList
                              in _createAppointmentProvider.servicesAvailable) {
                            allServiceList.addAll(serviceList);
                          }
                          final List<bool> isMenuVisible = List.generate(
                              allServiceList.length, (index) => false);
                          return CityMuseServiceTile(
                              allServiceList: allServiceList,
                              pageController: _pageController);
                        }

                        for (List<ServiceModel> serviceList
                            in _createAppointmentProvider.servicesAvailable) {
                          for (var ser in serviceList) {
                            // print(cat.categoryId);
                            if (selectedCatId == ser.categoryId) {
                              return CityMuseServiceTile(
                                  allServiceList: serviceList,
                                  pageController: _pageController);

                              //  ListView.builder(
                              //   controller: _pageController,
                              //   itemCount: serviceList.length,
                              //   itemBuilder: (context, index) {
                              //     return SizedBox(
                              //       height: 60,
                              //       child: Column(
                              //         children: [
                              //           GestureDetector(
                              //             onTap: () {
                              //               setState(() {
                              //                 isExpanded = !isExpanded;
                              //               });
                              //             },
                              //             child: Padding(
                              //               padding: const EdgeInsets.only(
                              //                   left: 12.0,
                              //                   right: 12,
                              //                   top: 20),
                              //               child: Container(
                              //                 height: 30,
                              //                 child: Row(
                              //                   children: [
                              //                     Text(
                              //                       serviceList[index]
                              //                                   .translations?[
                              //                               AppLocalizations.of(
                              //                                           context)
                              //                                       ?.localeName ??
                              //                                   'en'] ??
                              //                           serviceList[index]
                              //                                   .translations?[
                              //                               'en'] ??
                              //                           '',
                              //                       overflow: TextOverflow
                              //                           .ellipsis,
                              //                       style: GoogleFonts
                              //                           .openSans(
                              //                         color:
                              //                             _salonProfileProvider
                              //                                 .salonTheme
                              //                                 .textTheme
                              //                                 .displaySmall!
                              //                                 .color,
                              //                         fontSize: 18,
                              //                         //   fontFamily: 'Open Sans',
                              //                         fontWeight:
                              //                             FontWeight.w500,
                              //                         height: 0,
                              //                       ),
                              //                     ),
                              //                     Container(
                              //                       width: 24,
                              //                       height: 24,
                              //                       clipBehavior:
                              //                           Clip.antiAlias,
                              //                       decoration:
                              //                           const BoxDecoration(),
                              //                       child: SvgPicture.asset(
                              //                         "assets/test_assets/arrow_down.svg",
                              //                         color:
                              //                             _salonProfileProvider
                              //                                 .salonTheme
                              //                                 .textTheme
                              //                                 .displaySmall!
                              //                                 .color,
                              //                       ),
                              //                     ),
                              //                     const Spacer(),
                              //                     Text(
                              //                       (serviceList[index]
                              //                               .isPriceRange)
                              //                           ? "${getCurrency(chosenSalon.countryCode!)}${serviceList[index].priceAndDuration!.price ?? '0'}-${getCurrency(chosenSalon.countryCode!)}${serviceList[index].priceAndDurationMax!.price ?? '0'}"
                              //                           : (serviceList[
                              //                                       index]
                              //                                   .isPriceStartAt)
                              //                               ? "${getCurrency(chosenSalon.countryCode!)}${serviceList[index].priceAndDuration!.price ?? '0'}+"
                              //                               : "${getCurrency(chosenSalon.countryCode!)}${serviceList[index].priceAndDuration!.price ?? '0'}",
                              //                       textAlign:
                              //                           TextAlign.right,
                              //                       style: GoogleFonts
                              //                           .openSans(
                              //                         color:
                              //                             _salonProfileProvider
                              //                                 .salonTheme
                              //                                 .textTheme
                              //                                 .displaySmall!
                              //                                 .color,
                              //                         fontSize: 18,
                              //                         // fontFamily: 'Open Sans',
                              //                         fontWeight:
                              //                             FontWeight.w500,
                              //                         height: 0,
                              //                       ),
                              //                     ),
                              //                   ],
                              //                 ),
                              //                 decoration: const BoxDecoration(
                              //                     border: Border(
                              //                         bottom: BorderSide(
                              //                             color: Color(
                              //                                 0xff9f9f9f)))),
                              //               ),
                              //             ),
                              //           ),
                              //           Visibility(
                              //             visible: isExpanded,
                              //             child: Column(
                              //               children: [
                              //                 Row(
                              //                   mainAxisSize:
                              //                       MainAxisSize.min,
                              //                   mainAxisAlignment:
                              //                       MainAxisAlignment
                              //                           .center,
                              //                   crossAxisAlignment:
                              //                       CrossAxisAlignment
                              //                           .start,
                              //                   children: [
                              //                     Expanded(
                              //                       child: Padding(
                              //                         padding:
                              //                             const EdgeInsets
                              //                                     .only(
                              //                                 left: 12.0,
                              //                                 right: 12),
                              //                         child: SizedBox(
                              //                           //  width: 180,
                              //                           child: Text(
                              //                             serviceList[index]
                              //                                     .translations?[AppLocalizations.of(
                              //                                             context)
                              //                                         ?.localeName ??
                              //                                     'en'] ??
                              //                                 serviceList[index]
                              //                                         .translations?[
                              //                                     'en'] ??
                              //                                 '',
                              //                             style: GoogleFonts
                              //                                 .openSans(
                              //                               color: _salonProfileProvider
                              //                                   .salonTheme
                              //                                   .textTheme
                              //                                   .displaySmall!
                              //                                   .color,
                              //                               fontSize: 18,
                              //                               //   fontFamily: 'Open Sans',
                              //                               fontWeight:
                              //                                   FontWeight
                              //                                       .w500,
                              //                               height: 0,
                              //                             ),
                              //                           ),
                              //                         ),
                              //                       ),
                              //                     ),
                              //                     // const SizedBox(width: 6),
                              //                     SvgPicture.asset(
                              //                         "assets/test_assets/arrow_up.svg"),
                              //                     //  Spacer(),
                              //                     const Gap(20),
                              //                     Text(
                              //                       (serviceList[index]
                              //                               .isPriceRange)
                              //                           ? "${getCurrency(chosenSalon.countryCode!)}${serviceList[index].priceAndDuration!.price ?? '0'}-${getCurrency(chosenSalon.countryCode!)}${serviceList[index].priceAndDurationMax!.price ?? '0'}"
                              //                           : (serviceList[
                              //                                       index]
                              //                                   .isPriceStartAt)
                              //                               ? "${getCurrency(chosenSalon.countryCode!)}${serviceList[index].priceAndDuration!.price ?? '0'}+"
                              //                               : "${getCurrency(chosenSalon.countryCode!)}${serviceList[index].priceAndDuration!.price ?? '0'}",
                              //                       textAlign:
                              //                           TextAlign.right,
                              //                       style: GoogleFonts
                              //                           .openSans(
                              //                         color:
                              //                             _salonProfileProvider
                              //                                 .salonTheme
                              //                                 .textTheme
                              //                                 .displaySmall!
                              //                                 .color,
                              //                         fontSize: 15,
                              //                         // fontFamily: 'Open Sans',
                              //                         fontWeight:
                              //                             FontWeight.w500,
                              //                         height: 0,
                              //                       ),
                              //                     ),
                              //                     const Gap(10),
                              //                   ],
                              //                 ),
                              //                 // const Gap(10),
                              //                 // Image.asset("assets/hair.png"),
                              //                 // const Gap(10),
                              //                 Padding(
                              //                   padding:
                              //                       const EdgeInsets.only(
                              //                           left: 12.0,
                              //                           right: 12),
                              //                   child: Text(
                              //                       serviceList[index]
                              //                               .description ??
                              //                           '',
                              //                       style: GoogleFonts
                              //                           .openSans(
                              //                         fontSize: 16,
                              //                         fontWeight:
                              //                             FontWeight.w400,
                              //                         //color: const Color(0xff282828)
                              //                       )),
                              //                 )
                              //               ],
                              //             ),
                              //           )
                              //         ],
                              //       ),
                              //     );
                              //   },
                              //   // onPageChanged: (index) {
                              //   //   setState(() {
                              //   //     _currentIndex = index;
                              //   //   });
                              //   // },
                              // );
                            }
                          }
                        }
                        return const SizedBox();
                      }),
                    ),
                  ),
                  const Gap(40),
                  //const Gap(48),
                  GestureDetector(
                    onTap: () {
                      const BookingDialogWidget222().show(context);
                    },
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('BOOK NOW',
                                style: GoogleFonts.openSans(
                                    color: _salonProfileProvider
                                        .salonTheme.colorScheme.secondary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700)),
                            const Gap(10),
                            Image.asset(
                              'assets/test_assets/book_arrow.png',
                              height: 24,
                              width: 24,
                              color: _salonProfileProvider
                                  .salonTheme.colorScheme.secondary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Gap(120),
                ],

                if (displaySettings.product.showProduct &&
                    _salonProfileProvider.allProducts.isNotEmpty) ...[
                  SizedBox.fromSize(size: Size.zero, key: controller.shop),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0, right: 8.0),
                    child: Text(
                      (AppLocalizations.of(context)?.products ?? 'PRODUCTS')
                          .toUpperCase(),
                      style: GoogleFonts.openSans(
                        color: _salonProfileProvider
                            .salonTheme.textTheme.displaySmall!.color,
                        fontSize: 40,
                        //  fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                  ),
                  const Gap(12),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0, right: 8.0),
                    child: SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:
                            _salonProfileProvider.tabs.entries.length + 1,
                        itemBuilder: (context, index) {
                          List<ProductCategoryModel> catList = [
                            ProductCategoryModel(
                              'All',
                              'all',
                              {
                                'en': 'All',
                                'es': 'Toda',
                                'pt': 'Todos',
                                'ro': 'Toate',
                                'uk': 'все',
                                'fr': 'Tout',
                              },
                              'all',
                            ),
                            // ..._salonProfileProvider.allProductCategories,
                            ..._salonProfileProvider.tabs.entries
                                .map(
                                  (entry) => ProductCategoryModel(
                                    entry.key,
                                    'all',
                                    {
                                      'en': 'All',
                                      'es': 'Toda',
                                      'pt': 'Todos',
                                      'ro': 'Toate',
                                      'uk': 'все',
                                      'fr': 'Tout',
                                    },
                                    'all',
                                  ),
                                )
                                .toList(),
                          ];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _currentProductIndex = index;
                                _pageController.animateToPage(
                                  index,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.ease,
                                );
                              });
                              if (_currentProductIndex == 0) {
                                setState(() => currentSelectedEntry = null);
                              } else {
                                // for (var ent
                                //     in _salonProfileProvider.tabs.entries) {
                                setState(() => currentSelectedEntry =
                                    catList[index].categoryName);
                                //}
                                // _salonProfileProvider.tabs.entries.map(
                                //     (entry) => setState(() =>
                                //         currentSelectedEntry = entry.key));
                                // setState(() => currentSelectedEntry =
                                //     _salonProfileProvider
                                //         .tabs[index]!.first.productName);
                              }
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),

                              decoration: BoxDecoration(
                                border: _currentProductIndex == index
                                    ? BorderDirectional(
                                        // left: BorderSide(color: Color(0xFFE980B2)),
                                        // top: BorderSide(color: Color(0xFFE980B2)),
                                        //  right: BorderSide(color: Color(0xFFE980B2)),
                                        bottom: BorderSide(
                                          width: 2,
                                          color: _salonProfileProvider
                                              .salonTheme.colorScheme.secondary,
                                        ),
                                      )
                                    : null,
                              ),
                              //Change the tab's color
                              child: Center(
                                child: Text(
                                  catList[index]
                                      .categoryName
                                      .toString()
                                      .toCapitalized(),
                                  style: GoogleFonts.openSans(
                                    color: _salonProfileProvider
                                        .salonTheme.textTheme.bodyMedium!.color,
                                    // _currentIndex == index
                                    //     ? Colors.white
                                    //     : Colors.black, // Change the text color
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const Gap(30),
                  Builder(builder: (context) {
                    if (_currentProductIndex == 0) {
                      return Column(
                        children: [
                          CarouselSlider.builder(
                            options: CarouselOptions(
                              height: 515,
                              aspectRatio: 16 / 9,
                              viewportFraction: 1,
                              initialPage: 0,
                              enableInfiniteScroll: true,
                              reverse: false,
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 3),
                              autoPlayAnimationDuration:
                                  const Duration(milliseconds: 800),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enlargeCenterPage: true,
                              enlargeFactor: 0.3,
                              onPageChanged: (value, reason) {
                                setState(() {
                                  currentIndex = value;
                                  _currentProductImageIndex = value;
                                });
                              },
                              scrollDirection: Axis.horizontal,
                            ),
                            itemCount: _salonProfileProvider.allProducts.length,
                            itemBuilder: (BuildContext context, int index,
                                int realIndex) {
                              return AllProductWidget(
                                  salonProfileProvider: _salonProfileProvider,
                                  size: size,
                                  index: index,
                                  chosenSalon: chosenSalon);
                            },
                          ),
                          Center(
                            child: SizedBox(
                              height: 30,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: CircleAvatar(
                                        radius: 5,
                                        backgroundColor:
                                            _currentProductImageIndex == index
                                                ? _salonProfileProvider
                                                    .salonTheme
                                                    .colorScheme
                                                    .outlineVariant
                                                : _salonProfileProvider
                                                    .salonTheme
                                                    .colorScheme
                                                    .outline,
                                      ),
                                    );
                                  },
                                  itemCount:
                                      _salonProfileProvider.allProducts.length),
                            ),
                          ),
                        ],
                      );
                    }
                    if (_currentProductIndex != 0) {
                      return Column(
                        children: [
                          CarouselSlider.builder(
                            options: CarouselOptions(
                              height: 515,
                              aspectRatio: 16 / 9,
                              viewportFraction: 1,
                              initialPage: 0,
                              enableInfiniteScroll: true,
                              reverse: false,
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 3),
                              autoPlayAnimationDuration:
                                  const Duration(milliseconds: 800),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enlargeCenterPage: true,
                              enlargeFactor: 0.3,
                              onPageChanged: (value, reason) {
                                setState(() {
                                  currentIndex = value;
                                  _currentProductImageIndex = value;
                                });
                              },
                              scrollDirection: Axis.horizontal,
                            ),
                            itemCount: _salonProfileProvider
                                .tabs[currentSelectedEntry]?.length,
                            itemBuilder: (BuildContext context, int index,
                                int realIndex) {
                              return CityMuseProductTile(
                                chosenSalon: chosenSalon,
                                salonProfileProvider: _salonProfileProvider,
                                size: size,
                                index: index,
                                currentSelectedEntry: currentSelectedEntry!,
                              );
                            },
                          ),
                          Center(
                            child: SizedBox(
                              height: 30,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: CircleAvatar(
                                        radius: 5,
                                        backgroundColor:
                                            _currentProductImageIndex == index
                                                ? _salonProfileProvider
                                                    .salonTheme
                                                    .colorScheme
                                                    .outlineVariant
                                                : _salonProfileProvider
                                                    .salonTheme
                                                    .colorScheme
                                                    .outline,
                                      ),
                                    );
                                  },
                                  itemCount: _salonProfileProvider
                                      .tabs[currentSelectedEntry]?.length),
                            ),
                          ),
                        ],
                      );
                    }
                    return const SizedBox();
                  }),
                  const Gap(30),
                ],

                const Gap(120),

                if (displaySettings.showTeam &&
                    _createAppointmentProvider.salonMasters.isNotEmpty) ...[
                  SizedBox.fromSize(size: Size.zero, key: controller.team),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0, right: 8.0),
                    child: Text(
                      (AppLocalizations.of(context)?.team ?? 'TEAM')
                          .toUpperCase(),
                      style: GoogleFonts.openSans(
                        color: _salonProfileProvider
                            .salonTheme.textTheme.displaySmall!.color,
                        fontSize: 40,
                        //  fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                  ),
                  const Gap(20),
                  CarouselSlider.builder(
                    options: CarouselOptions(
                      height: 515,
                      scrollPhysics: const ClampingScrollPhysics(),
                      aspectRatio: 16 / 9,
                      viewportFraction: 1,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      enlargeFactor: 0,
                      onPageChanged: (value, reason) {
                        setState(() {
                          currentIndex = value;
                        });
                      },
                      scrollDirection: Axis.horizontal,
                    ),
                    itemCount: _createAppointmentProvider.salonMasters.length,
                    itemBuilder:
                        (BuildContext context, int index, int realIndex) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _salonProfileProvider.changeShowMenuMobile(true);
                            _salonProfileProvider.getWidgetForMobile('masters');

                            _salonProfileProvider.changeSelectedMasterView(
                                _createAppointmentProvider.salonMasters[index]);
                          });
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            (_createAppointmentProvider.salonMasters[index]
                                            .profilePicUrl !=
                                        null &&
                                    _createAppointmentProvider
                                            .salonMasters[index]
                                            .profilePicUrl !=
                                        '')
                                ? Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0, right: 10.0),
                                      child: Center(
                                          child: CachedImage(
                                        url:
                                            '${_createAppointmentProvider.salonMasters[index].profilePicUrl}',
                                        width: size.width / 1.1,
                                        fit: BoxFit.fitWidth,

                                        //height: 450,
                                      )),
                                    ),
                                  )
                                : Image.asset(
                                    _salonProfileProvider.themeType ==
                                            ThemeType.GlamMinimalLight
                                        ? ThemeImages.noTeamMember
                                        : ThemeImages.noTeamMemberDark,
                                    fit: BoxFit.cover,
                                  ),
                            const Gap(16),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, right: 8.0),
                                  child: Text(
                                    '${_createAppointmentProvider.salonMasters[index].personalInfo?.firstName} ${_createAppointmentProvider.salonMasters[index].personalInfo?.lastName}',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.openSans(
                                      color: _salonProfileProvider
                                          .salonTheme.colorScheme.secondary,
                                      fontSize: 20,
                                      // fontFamily: 'Open Sans',
                                      fontWeight: FontWeight.w600,
                                      height: 0,
                                    ),
                                  ),
                                ),
                                SvgPicture.asset(
                                    "assets/test_assets/arrow_side.svg"),
                              ],
                            ),
                            if (_createAppointmentProvider
                                    .salonMasters[index].title !=
                                null)
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 8.0),
                                child: Text(
                                  _createAppointmentProvider
                                      .salonMasters[index].title
                                      .toString(),
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.openSans(
                                    color: const Color(0xFF868686),
                                    fontSize: 16,
                                    //fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                  const Gap(102),
                ],
                if (_salonProfileProvider.salonReviews.isNotEmpty &&
                    displaySettings.reviews.showReviews) ...[
                  SizedBox.fromSize(size: Size.zero, key: controller.reviews),
                  const Gap(130),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0, right: 8.0),
                    child: Text(
                      (AppLocalizations.of(context)?.reviews ?? 'Reviews')
                          .toUpperCase(),
                      style: GoogleFonts.openSans(
                        color: _salonProfileProvider
                            .salonTheme.textTheme.displaySmall!.color,
                        fontSize: 40,
                        //  fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                  ),
                  const Gap(20),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0, right: 8.0),
                    child: Row(
                      children: [
                        Text(
                          getTotalRatings(_salonProfileProvider.salonReviews)
                              .toStringAsFixed(1)
                              .toString(),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.openSans(
                            color: _salonProfileProvider
                                .salonTheme.textTheme.displaySmall!.color,
                            fontSize: 16,
                            //    fontFamily: 'Onest',
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                        RatingBar.builder(
                          initialRating: getTotalRatings(_salonProfileProvider
                              .salonReviews), // reviewStars ?? 5,
                          minRating: 0,
                          direction: Axis.horizontal,
                          allowHalfRating: false,
                          itemSize: 15,
                          itemCount: 5,
                          updateOnDrag: true,
                          unratedColor: Colors.grey,
                          onRatingUpdate: (rating) {},
                          itemBuilder: (context, _) {
                            return Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Container(
                                width: 18,
                                height: 18,
                                decoration: ShapeDecoration(
                                  color: _salonProfileProvider
                                      .salonTheme.colorScheme.secondary,
                                  shape: const StarBorder(
                                    points: 5,
                                    innerRadiusRatio: 0.38,
                                    pointRounding: 0.70,
                                    valleyRounding: 0,
                                    rotation: 0,
                                    squash: 0,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const Gap(20),
                  CarouselSlider.builder(
                    options: CarouselOptions(
                      height: 515,
                      aspectRatio: 16 / 9,
                      viewportFraction: 1,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      enlargeFactor: 0,
                      onPageChanged: (value, reason) {
                        setState(() {
                          currentReviewIndex = value;
                        });
                      },
                      scrollDirection: Axis.horizontal,
                    ),
                    itemCount: _salonProfileProvider.salonReviews.length,
                    itemBuilder:
                        (BuildContext context, int index, int realIndex) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                        child: Container(
                          width: double.infinity,
                          height: 163,
                          padding: const EdgeInsets.all(20),
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1,
                                color: _salonProfileProvider
                                    .salonTheme.colorScheme.secondary,
                                //  Color(0xFFE980B2)
                              ),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      _salonProfileProvider
                                          .salonReviews[index].customerName,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.openSans(
                                        color: _salonProfileProvider
                                            .salonTheme.colorScheme.secondary,
                                        //Color(0xFFE980B2),
                                        fontSize: 20,
                                        // fontFamily: 'Open Sans',
                                        fontWeight: FontWeight.w600,
                                        height: 0,
                                      ),
                                    ),
                                    const SizedBox(width: 36),
                                    RatingBar.builder(
                                      initialRating: _salonProfileProvider
                                          .salonReviews[index]
                                          .rating, // reviewStars ?? 5,
                                      minRating: 0,
                                      direction: Axis.horizontal,
                                      allowHalfRating: false,
                                      itemSize: 15,
                                      itemCount: 5,
                                      updateOnDrag: true,
                                      unratedColor: Colors.grey,
                                      onRatingUpdate: (rating) {},
                                      itemBuilder: (context, _) {
                                        return Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Container(
                                            width: 18,
                                            height: 18,
                                            decoration: const ShapeDecoration(
                                              color: Color(0xFFE980B2),
                                              shape: StarBorder(
                                                points: 5,
                                                innerRadiusRatio: 0.38,
                                                pointRounding: 0.70,
                                                valleyRounding: 0,
                                                rotation: 0,
                                                squash: 0,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 14),
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  _salonProfileProvider
                                      .salonReviews[index].review,
                                  style: GoogleFonts.openSans(
                                    color: _salonProfileProvider
                                        .salonTheme.colorScheme.secondary,
                                    //Color(0xFFE980B2),
                                    fontSize: 16,
                                    //  fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.w500,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  Center(
                    child: SizedBox(
                      height: 30,
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: CircleAvatar(
                                radius: 5,
                                backgroundColor: currentReviewIndex == index
                                    ? _salonProfileProvider
                                        .salonTheme.colorScheme.outlineVariant
                                    : _salonProfileProvider
                                        .salonTheme.colorScheme.outline,
                              ),
                            );
                          },
                          itemCount: _salonProfileProvider.salonReviews.length),
                    ),
                  ),
                  const Gap(102),
                ],

                Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                  child: SizedBox(
                    width: 339,
                    child: Text(
                      'WRITE TO US',
                      style: GoogleFonts.openSans(
                        color: _salonProfileProvider
                            .salonTheme.textTheme.displaySmall!.color,
                        fontSize: 40,
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                  ),
                ),
                const Gap(20),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                  child: SizedBox(
                    width: 339,
                    child: Text(
                      'Write to us and we will get back to you as soon as possible',
                      style: GoogleFonts.openSans(
                        color: _salonProfileProvider
                            .salonTheme.textTheme.displaySmall!.color,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                        letterSpacing: 0.16,
                      ),
                    ),
                  ),
                ),
                const Gap(40),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                  child: Text(
                    'Full Name',
                    style: GoogleFonts.openSans(
                      color: _salonProfileProvider
                          .salonTheme.textTheme.displaySmall!.color,
                      fontSize: 14,
                      // fontFamily: 'Red Hat Display',
                      fontWeight: FontWeight.w700,
                      height: 0.08,
                      letterSpacing: 0.60,
                    ),
                  ),
                ),
                const Gap(10),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                  child: SizedBox(
                    height: 44,
                    child: TextField(
                      controller: _salonProfileProvider.nameController,
                      decoration: InputDecoration(
                          hintText: 'Full Name',
                          filled: _salonProfileProvider
                              .salonTheme.inputDecorationTheme.filled,
                          fillColor: _salonProfileProvider
                              .salonTheme.inputDecorationTheme.fillColor,
                          border: _salonProfileProvider
                              .salonTheme.inputDecorationTheme.border,
                          enabledBorder: _salonProfileProvider
                              .salonTheme.inputDecorationTheme.enabledBorder,
                          focusedBorder: _salonProfileProvider
                              .salonTheme.inputDecorationTheme.focusedBorder),
                    ),
                  ),
                ),
                const Gap(40),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                  child: Text(
                    'Phone',
                    style: GoogleFonts.openSans(
                      color: _salonProfileProvider
                          .salonTheme.textTheme.displaySmall!.color,
                      fontSize: 14,
                      // fontFamily: 'Red Hat Display',
                      fontWeight: FontWeight.w700,
                      height: 0.08,
                      letterSpacing: 0.60,
                    ),
                  ),
                ),
                const Gap(10),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                  child: SizedBox(
                    height: 44,
                    child: TextField(
                      controller: _salonProfileProvider.phoneController,
                      decoration: InputDecoration(
                          hintText: 'Phone',
                          filled: true,
                          fillColor: _salonProfileProvider
                              .salonTheme.inputDecorationTheme.fillColor,
                          border: _salonProfileProvider
                              .salonTheme.inputDecorationTheme.border,
                          enabledBorder: _salonProfileProvider
                              .salonTheme.inputDecorationTheme.enabledBorder,
                          focusedBorder: _salonProfileProvider
                              .salonTheme.inputDecorationTheme.focusedBorder),
                    ),
                  ),
                ),
                const Gap(30),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                  child: Text(
                    'Email',
                    style: GoogleFonts.openSans(
                      color: _salonProfileProvider
                          .salonTheme.textTheme.displaySmall!.color,
                      fontSize: 14,
                      // fontFamily: 'Red Hat Display',
                      fontWeight: FontWeight.w700,
                      height: 0.08,
                      letterSpacing: 0.60,
                    ),
                  ),
                ),
                const Gap(10),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                  child: SizedBox(
                    height: 44,
                    child: TextField(
                      controller: _salonProfileProvider.emailController,
                      decoration: InputDecoration(
                          hintText: 'Email',
                          filled: true,
                          fillColor: _salonProfileProvider
                              .salonTheme.inputDecorationTheme.fillColor,
                          border: _salonProfileProvider
                              .salonTheme.inputDecorationTheme.border,
                          enabledBorder: _salonProfileProvider
                              .salonTheme.inputDecorationTheme.enabledBorder,
                          focusedBorder: _salonProfileProvider
                              .salonTheme.inputDecorationTheme.focusedBorder),
                    ),
                  ),
                ),
                const Gap(40),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                  child: Text(
                    'Message',
                    style: GoogleFonts.openSans(
                      color: _salonProfileProvider
                          .salonTheme.textTheme.displaySmall!.color,
                      fontSize: 14,
                      // fontFamily: 'Red Hat Display',
                      fontWeight: FontWeight.w700,
                      height: 0.08,
                      letterSpacing: 0.60,
                    ),
                  ),
                ),
                const Gap(10),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                  child: SizedBox(
                    height: 200,
                    child: TextField(
                      controller: _salonProfileProvider.requestController,
                      maxLength: 8,
                      minLines: 7,
                      maxLines: 8,
                      decoration: InputDecoration(
                          hintText: 'Write to us',
                          filled: true,
                          fillColor: _salonProfileProvider
                              .salonTheme.inputDecorationTheme.fillColor,
                          border: _salonProfileProvider
                              .salonTheme.inputDecorationTheme.border,
                          enabledBorder: _salonProfileProvider
                              .salonTheme.inputDecorationTheme.enabledBorder,
                          focusedBorder: _salonProfileProvider
                              .salonTheme.inputDecorationTheme.focusedBorder),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _salonProfileProvider.sendEnquiryToSalonCityMuse(context,
                        salonId: chosenSalon.salonId);
                  },
                  child: _salonProfileProvider.enquiryStatus == Status.loading
                      ? const Center(
                          child: SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(
                              color: Color(0xFFE980B2),
                            ),
                          ),
                        )
                      : Padding(
                          padding:
                              const EdgeInsets.only(left: 18.0, right: 18.0),
                          child: Center(
                            child: Container(
                              width: double.infinity,
                              height: 50,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 13),
                              decoration: ShapeDecoration(
                                color: _salonProfileProvider
                                    .salonTheme.colorScheme.secondary,
                                //Color(0xFFE980B2),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(2)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(right: 8),
                                    // color: _salonProfileProvider.salonTheme.colorScheme.secondary,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'SEND MESSAGE',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontFamily: 'Open Sans',
                                            fontWeight: FontWeight.w700,
                                            height: 0,
                                          ),
                                        ),
                                        const Gap(20),
                                        SvgPicture.asset(
                                          'assets/test_assets/arrow_side.svg',
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                ),
                const Gap(120),
                if (displaySettings.showContact) ...[
                  SizedBox.fromSize(size: Size.zero, key: controller.contacts),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                    child: Text(
                      (AppLocalizations.of(context)?.contacts ?? 'Contacts')
                          .toUpperCase(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.openSans(
                        color: _salonProfileProvider
                            .salonTheme.textTheme.displaySmall!.color,
                        fontSize: 40,
                        //  fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                  ),
                  const Gap(30),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                    child: Text(
                      "Connect with us easily. Whether it's questions, collaborations, or just saying hello, we're here for you. Reach out via email, find us on social media, give us a call, or visit our address below.",
                      style: GoogleFonts.openSans(
                        color: _salonProfileProvider
                            .salonTheme.textTheme.titleSmall!.color,
                        fontSize: 16,
                        //  fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                        letterSpacing: 0.16,
                      ),
                    ),
                  ),
                  const Gap(52),
                  ContactCard(
                    contactTitle: 'Write To Us',
                    contactAsset: 'message.svg',
                    contactDescription: 'Start a conversations via email',
                    contactInfo: chosenSalon.email,
                    contactAction: () async {
                      final Uri emailLaunchUri = Uri(
                        scheme: 'mailto',
                        path: chosenSalon.email,
                        queryParameters: {'subject': 'Contact'},
                      );
                      launchUrl(emailLaunchUri);
                    },
                  ),
                  const Gap(24),
                  if (chosenSalon.phoneNumber.isNotEmpty)
                    ContactCard(
                      contactTitle: 'Call Us',
                      contactAsset: 'call.svg',
                      contactDescription: 'Today from 10 am to 7 pm',
                      contactAction: () {
                        Utils().launchCaller(
                            chosenSalon.phoneNumber.replaceAll("-", ""));
                      },
                      contactInfo: chosenSalon.phoneNumber,
                    ),
                  const Gap(24),
                  ContactCard(
                    contactTitle: 'Visit Us',
                    contactAsset: 'location.svg',
                    contactDescription: chosenSalon.address,
                    contactInfo: 'View on The Map',
                    contactAction: () async {
                      Uri uri = Uri.parse(
                          'https://www.google.com/maps/search/?api=1&query=${Uri.encodeFull(chosenSalon.address)}');

                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri);
                      } else {
                        showToast(
                            AppLocalizations.of(context)?.couldNotLaunch ??
                                "Could not launch");
                      }
                    },
                  ),
                  const Gap(24),
                  const ContactCard(
                    contactTitle: 'Social Media',
                    contactAsset: 'social_media.svg',
                    contactDescription: 'Salon address',
                    contactInfo: '',
                    contactAssetList: [
                      'instagram.svg',
                      'tiktok.svg',
                      'facebook.svg'
                    ],
                  ),
                ],

                const Gap(20),
                // Padding(
                //   padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                //   child: Image.asset(
                //     'assets/test_assets/map.png',
                //     width: double.infinity,
                //     fit: BoxFit.fitWidth,
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                  child: SizedBox(
                    height: 500.h,
                    width: double.infinity,
                    child: GoogleMaps(
                      salonModel: chosenSalon,
                    ),
                  ),
                ),
                const Gap(40),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                  child: Container(
                      height: 1,
                      width: double.infinity,
                      color: const Color(0xFFB8B2A6)),
                ),
                const Gap(40),
                Center(
                  child: Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text(
                          'Terms & Conditions',
                          style: TextStyle(
                            color: Color(0xFF585858),
                            fontSize: 13,
                            fontFamily: 'Onest',
                            fontWeight: FontWeight.w400,
                            height: 0.08,
                          ),
                        ),
                        SizedBox(width: 22),
                        Text(
                          'Privacy Policy',
                          style: TextStyle(
                            color: Color(0xFF585858),
                            fontSize: 13,
                            fontFamily: 'Onest',
                            fontWeight: FontWeight.w400,
                            height: 0.08,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: ' ',
                      //  style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        const TextSpan(
                            text: '© 2023 Glamiris.',
                            style: TextStyle(
                              color: Color(0xFF585858),
                            )),
                        TextSpan(
                            text: ' Powered by Glamiris!',
                            style: GoogleFonts.openSans(
                              fontWeight: FontWeight.bold,
                              color: _salonProfileProvider
                                  .salonTheme.colorScheme.secondary,
                              // Color(0xFFE980B2),
                            )),
                      ],
                    ),
                  ),
                ),
                const Gap(30),
              ],
            ),
    );
  }
}

class FeaturesCheck extends ConsumerWidget {
  final String? title;
  const FeaturesCheck({Key? key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final theme = ref.watch(salonProfileProvider).salonTheme;
    return SizedBox(
      width: double.infinity,
      height: 70,
      //MediaQuery.of(context).size.width * (8/30),
      child: Container(
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(
          color: theme.colorScheme.secondary,
        ),
        child: Column(
          children: [
            const Gap(30),
            Padding(
              padding:
                  const EdgeInsets.only(left: 18.0, right: 8.0, bottom: 10),
              child: SizedBox(
                height: 30,
                width: double.infinity,
                child: Row(
                  // mainAxisSize: MainAxisSize.min,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset("assets/test_assets/check.svg"),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '$title',
                        style: GoogleFonts.openSans(
                          color: theme.textTheme.displaySmall!.color,
                          fontSize: 18,
                          // fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
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

class DesktopFeaturesCheck extends ConsumerWidget {
  final String? title;
  const DesktopFeaturesCheck({super.key, this.title});

  @override
  Widget build(BuildContext context, ref) {
    final theme = ref.watch(salonProfileProvider).salonTheme;
    return IntrinsicWidth(
      child: SizedBox(
        //  width: 250,
        height: 70,
        //MediaQuery.of(context).size.width * (8/30),
        child: Padding(
          padding: const EdgeInsets.only(left: 18.0, right: 8.0, bottom: 10),
          child: Row(
            // mainAxisSize: MainAxisSize.min,
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/test_assets/check.svg"),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '$title',
                  style: GoogleFonts.openSans(
                    color: theme.textTheme.displaySmall!.color,
                    fontSize: 18,
                    // fontFamily: 'Open Sans',
                    fontWeight: FontWeight.w600,
                    height: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SpecializationBox extends ConsumerWidget {
  final String? name;
  const SpecializationBox({Key? key, this.name}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final theme = ref.watch(salonProfileProvider).salonTheme;
    return IntrinsicWidth(
      child: Container(
        //  width: 95,
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: theme.colorScheme.secondaryContainer,
            ),
          ),
        ),
        child: Center(
          child: Text(
            name ?? '',
            textAlign: TextAlign.center,
            style: GoogleFonts.openSans(
              color: theme.textTheme.displaySmall!.color,
              fontSize: 14,
              //   fontFamily: 'Open Sans',
              fontWeight: FontWeight.w400,
              height: 0,
            ),
          ),
        ),
      ),
    );
  }
}

class ContactCard extends ConsumerWidget {
  final String? contactTitle;
  final String? contactDescription;
  final String? contactAsset;
  final List? contactAssetList;
  final String? contactInfo;
  final double width;
  final double titleFontSize;
  final double descriptionFontSize;
  final double infoFontSize;
  final Function()? contactAction;
  const ContactCard(
      {Key? key,
      this.contactAsset,
      this.titleFontSize = 16,
      this.infoFontSize = 14,
      this.descriptionFontSize = 14,
      this.width = double.infinity,
      this.contactAssetList,
      this.contactDescription,
      this.contactInfo,
      this.contactAction,
      this.contactTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final theme = ref.watch(salonProfileProvider).salonTheme;
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 18.0),
      child: Container(
        width: width,
        height: 142,
        padding: const EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
          bottom: 14,
        ),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 0.5,
              color: theme.textTheme.displayLarge!.color!,
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/test_assets/$contactAsset',
                      height: 20,
                      width: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$contactTitle',
                      style: GoogleFonts.openSans(
                        color: theme.textTheme.headlineSmall!.color,
                        fontSize: titleFontSize,
                        // fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    '$contactDescription',
                    style: GoogleFonts.openSans(
                      color: theme.textTheme.headlineSmall!.color,
                      fontSize: descriptionFontSize,
                      // fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1,
                    ),
                  ),
                ),
              ],
            ),
            if (contactInfo != '') const SizedBox(height: 20),
            if (contactInfo != '')
              GestureDetector(
                onTap: contactAction,
                child: IntrinsicWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$contactInfo',
                        style: GoogleFonts.openSans(
                          // decorationThickness: 2, // Optional: specify underline thickness

                          //decoration: TextDecoration.underline,
                          color: theme.textTheme.headlineSmall!.color,
                          fontSize: infoFontSize,
                          //  fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          //   textDecoration: TextDecoration.underline,
                          height: 0,
                        ),
                      ),
                      Container(
                        height: 1.5,
                        color: theme.textTheme.headlineSmall!.color,
                      )
                    ],
                  ),
                ),
              ),
            const Gap(10),
            if (contactAssetList != null && contactAssetList!.isNotEmpty)
              SizedBox(
                height: 50,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: contactAssetList!.length,
                    itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: SvgPicture.asset(
                              'assets/test_assets/${contactAssetList![index]}'),
                        )),
              )
          ],
        ),
      ),
    );
  }
}

class MenuSection extends ConsumerWidget {
  const MenuSection({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final controller = ref.watch(themeController);
    final salonProvider = ref.watch(salonProfileProvider);
    final _createAppointmentProvider = ref.watch(createAppointmentProvider);
    final DisplaySettings? displaySettings =
        salonProvider.themeSettings?.displaySettings;
    final SalonModel chosenSalon = salonProvider.chosenSalon;
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Gap(50),
              if (chosenSalon.description.isNotEmpty &&
                  displaySettings!.showAbout)
                AppBarMenu(
                  title: AppLocalizations.of(context)?.aboutUs ?? 'About Us',
                  action: () {
                    salonProvider.changeShowMenuMobile(false);
                    Scrollable.ensureVisible(
                      controller.about.currentContext!,
                      duration: const Duration(seconds: 2),
                      curve: Curves.ease,
                    );
                  },
                ),
              if (chosenSalon.photosOfWorks != null &&
                  chosenSalon.photosOfWorks!.isNotEmpty &&
                  displaySettings!.showPhotosOfWork) ...[
                const Gap(20),
                AppBarMenu(
                  title: AppLocalizations.of(context)?.portfolio ?? 'Portfolio',
                  action: () {
                    salonProvider.changeShowMenuMobile(false);
                    Scrollable.ensureVisible(
                      controller.works.currentContext!,
                      duration: const Duration(seconds: 2),
                      curve: Curves.ease,
                    );
                  },
                ),
              ],
              if (displaySettings!.services.showServices) ...[
                const Gap(20),
                AppBarMenu(
                    title: AppLocalizations.of(context)?.services ?? 'Services',
                    action: () {
                      salonProvider.changeShowMenuMobile(false);
                      Scrollable.ensureVisible(
                        controller.price.currentContext!,
                        duration: const Duration(seconds: 2),
                        curve: Curves.ease,
                      );
                    }),
              ],
              if (displaySettings.product.showProduct &&
                  salonProvider.allProducts.isNotEmpty) ...[
                const Gap(20),
                AppBarMenu(
                  title: AppLocalizations.of(context)?.products ?? 'Products',
                  action: () {
                    salonProvider.changeShowMenuMobile(false);
                    Scrollable.ensureVisible(
                      controller.shop.currentContext!,
                      duration: const Duration(seconds: 2),
                      curve: Curves.ease,
                    );
                  },
                ),
              ],
              if (displaySettings.showTeam &&
                  _createAppointmentProvider.salonMasters.isNotEmpty) ...[
                const Gap(20),
                AppBarMenu(
                  title: (AppLocalizations.of(context)?.team ?? 'Team'),
                  action: () {
                    salonProvider.changeShowMenuMobile(false);
                    Scrollable.ensureVisible(
                      controller.team.currentContext!,
                      duration: const Duration(seconds: 2),
                      curve: Curves.ease,
                    );
                  },
                ),
              ],
              if (salonProvider.salonReviews.isNotEmpty &&
                  displaySettings.reviews.showReviews) ...[
                const Gap(20),
                AppBarMenu(
                    title:
                        (AppLocalizations.of(context)?.reviews ?? 'Reviews')),
                const Gap(20),
                AppBarMenu(
                  title: 'Contacts',
                  action: () {
                    salonProvider.changeShowMenuMobile(false);
                    Scrollable.ensureVisible(
                      controller.contacts.currentContext!,
                      duration: const Duration(seconds: 2),
                      curve: Curves.ease,
                    );
                  },
                ),
              ],
              const Gap(20),
              AppBarMenu(
                title: 'Book now',
                action: () {
                  salonProvider.changeShowMenuMobile(false);
                },
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

// getWidget(value) {
//   switch (value) {
//     case 'menu':
//       currentWidget = const MenuSection();
//       break;
//     case 'masters':
//       currentWidget = const MastersView();
//       break;
//     default:
//       currentWidget = const MenuSection();
//       break;
//   }
// }

class MastersView extends ConsumerStatefulWidget {
  const MastersView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MastersViewState();
}

class _MastersViewState extends ConsumerState<MastersView> {
  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(salonProfileProvider).salonTheme;
    final salonProvider = ref.watch(salonProfileProvider);
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 18.0, right: 18),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(30),
              GestureDetector(
                onTap: () {
                  setState(() {
                    salonProvider.changeShowMenuMobile(false);
                    // getWidget("menu");
                  });
                  setState(() {
                    salonProvider.changeShowMenuMobile(false);
                  });
                },
                child: Row(
                  children: [
                    SvgPicture.asset('assets/test_assets/arrow_back.svg'),
                    Text(
                      ' Back to the main page',
                      style:
                          GoogleFonts.openSans(color: const Color(0xffb4b4b4)),
                    )
                  ],
                ),
              ),
              const Gap(20),
              Text(
                '${salonProvider.selectedViewMasterModel?.personalInfo?.firstName} ${salonProvider.selectedViewMasterModel?.personalInfo?.lastName}',
                style: GoogleFonts.openSans(
                    color: theme.textTheme.displaySmall!.color,
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),
              if (salonProvider.selectedViewMasterModel?.title != null)
                Text(
                  '${salonProvider.selectedViewMasterModel?.title}',
                  style: GoogleFonts.openSans(
                      color: const Color(0xff868686), fontSize: 20),
                ),
              const Gap(30),
              Container(
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Color(0xff868686)),
                          right: BorderSide(color: Color(0xff868686)),
                          left: BorderSide(color: Color(0xff868686)))),
                  width: double.infinity,
                  height: 373,
                  child: Column(
                    children: [
                      (salonProvider.selectedViewMasterModel!.profilePicUrl !=
                                  null &&
                              salonProvider
                                      .selectedViewMasterModel!.profilePicUrl !=
                                  '')
                          ? Expanded(
                              child: CachedImage(
                              url:
                                  '${salonProvider.selectedViewMasterModel!.profilePicUrl}',
                              width: MediaQuery.of(context).size.width / 0.8,
                              fit: BoxFit.fitWidth,
                            ))
                          : Image.asset(
                              salonProvider.themeType ==
                                      ThemeType.GlamMinimalLight
                                  ? ThemeImages.noTeamMember
                                  : ThemeImages.noTeamMemberDark,
                              width: MediaQuery.of(context).size.width / 0.8,
                              fit: BoxFit.fitWidth,
                            ),
                      const Gap(20),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/test_assets/instagram.svg',
                              height: 30,
                              width: 30,
                            ),
                            SvgPicture.asset(
                              'assets/test_assets/facebook.svg',
                              height: 30,
                              width: 30,
                            ),
                            SvgPicture.asset(
                              'assets/test_assets/pinterest.svg',
                              height: 30,
                              width: 30,
                            ),
                            SvgPicture.asset(
                              'assets/test_assets/tiktok.svg',
                              height: 30,
                              width: 30,
                            ),
                            SvgPicture.asset(
                              'assets/test_assets/twitter.svg',
                              height: 30,
                              width: 30,
                            ),
                          ],
                        ),
                      ),
                      const Gap(20),
                    ],
                  )),
              const Gap(30),
              Text(
                '${salonProvider.selectedViewMasterModel?.personalInfo?.description}',
                textAlign: TextAlign.start,
                style: GoogleFonts.openSans(
                  letterSpacing: 1,
                  height: 2,
                  color: theme.textTheme.titleSmall!.color,
                ),
              ),
              const Gap(30),
              SizedBox(
                height: 50,
                child: Row(
                  children: [
                    SvgPicture.asset('assets/test_assets/arrow_back.svg'),
                    Text(
                      ' Previous specialist',
                      style:
                          GoogleFonts.openSans(color: const Color(0xffb4b4b4)),
                    ),
                    const Spacer(),
                    Text(
                      ' Next specialist',
                      style:
                          GoogleFonts.openSans(color: const Color(0xffb4b4b4)),
                    ),
                    SvgPicture.asset('assets/test_assets/arrow_forward.svg'),
                  ],
                ),
              ),
              const Gap(30),
              Container(
                  height: 1,
                  width: double.infinity,
                  color: const Color(0xFFB8B2A6)),
              const Gap(30),
              Center(
                child: Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Terms & Conditions',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF585858),
                          fontSize: 13,
                          //fontFamily: 'Onest',
                          fontWeight: FontWeight.w400,
                          height: 0.08,
                        ),
                      ),
                      const SizedBox(width: 22),
                      Text(
                        'Privacy Policy',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF585858),
                          fontSize: 13,
                          //   fontFamily: 'Onest',
                          fontWeight: FontWeight.w400,
                          height: 0.08,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: RichText(
                  text: const TextSpan(
                    text: ' ',
                    //  style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                          text: '© 2023 Glamiris.',
                          style: TextStyle(
                            color: Color(0xFF585858),
                          )),
                      TextSpan(
                          text: ' Powered by Glamiris!',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE980B2),
                          )),
                    ],
                  ),
                ),
              ),
              const Gap(30),
            ],
          ),
        ),
      ),
    );
  }
}

class AppBarMenu extends ConsumerWidget {
  final String? title;
  final Function()? action;
  const AppBarMenu({super.key, this.title = 'About Us', this.action});

  @override
  Widget build(BuildContext context, ref) {
    final theme = ref.watch(salonProfileProvider).salonTheme;
    return GestureDetector(
      onTap: action,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          '$title',
          style:
              GoogleFonts.openSans(color: theme.textTheme.displaySmall!.color),
        ),
        decoration: const BoxDecoration(
            border:
                Border(bottom: BorderSide(color: Color(0xff9f9f9f), width: 1))),
      ),
    );
  }
}
