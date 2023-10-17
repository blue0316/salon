import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marquee/marquee.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../controller/all_providers/all_providers.dart';
import '../../../../models/cat_sub_service/category_service.dart';
import '../../../../models/cat_sub_service/services_model.dart';
import '../../../../models/customer_web_settings.dart';
import '../../../../models/enums/status.dart';
import '../../../../models/products.dart';
import '../../../../models/review.dart';
import '../../../../models/salon_master/master.dart';
import '../../../../models/salon_master/salon.dart';
import '../../../../utils/currency/currency.dart';
import '../../../../utils/icons.dart';
import '../../../../utils/utils.dart';
import '../../../salon/booking/dialog_flow/booking_dialog_2.dart';
import '../../../salon/widgets/additional featured.dart';
import '../../../widgets/image.dart';
import '../../../widgets/widgets.dart';
import '../../components/contacts/widgets/contact_maps.dart';
import '../../images.dart';
import '../city_muse_mobile/city_muse_mobile.dart';

class GlamMinimalDesktop extends ConsumerStatefulWidget {
  const GlamMinimalDesktop({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GlamMinimalDesktopState();
}

class _GlamMinimalDesktopState extends ConsumerState<GlamMinimalDesktop> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  int currentIndex = 0;
  bool isHovered = false;

  final List<String> tabs = ["All", "Hair", "Body care", "Face care"];
  final List<String> tabs2 = [
    "All",
    "Makeup",
    "Shaving",
    "Eyebrows & Eyelashes"
  ];

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

  String? currentSelectedEntry;

  int hoveredIndex = -1;
  String? selectedCatId = '';

  void _onEnter(int index) {
    setState(() {
      hoveredIndex = index;
    });
  }

  void _onExit(int index) {
    setState(() {
      hoveredIndex = -1;
    });
  }

  int _currentProductIndex = 0;

  int _selectedProductIndex = 0;
  ProductModel? selectedProduct;
  // _salonProfileProvider.allProducts[0];
  List<ServiceModel> services = [];

  @override
  void initState() {
    super.initState();
    ref
        .read(salonSearchProvider)
        .getAllSalonServices(ref.read(createAppointmentProvider));
    // ref.read(createAppointmentProvider);
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(themeController);
    final size = MediaQuery.of(context).size;
    final _salonProfileProvider = ref.watch(salonProfileProvider);
    final _salonSearchProvider = ref.watch(salonSearchProvider);
    final _createAppointmentProvider = ref.watch(createAppointmentProvider);

    final SalonModel chosenSalon = _salonProfileProvider.chosenSalon;
    final DisplaySettings? displaySettings =
        _salonProfileProvider.themeSettings?.displaySettings;

    double height = MediaQuery.of(context).size.height;
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: SingleChildScrollView(
          child: Row(
            children: [
              const Gap(50),
              chosenSalon.salonLogo.isEmpty
                  ? Padding(
                      padding: EdgeInsets.only(left: 5.w),
                      child: SizedBox(
                        height: 70.h,
                        width: 100.h,
                        child: Center(
                          child: Text(chosenSalon.salonName.initials,
                              style: TextStyle(
                                  fontFamily: "VASQUZ",
                                  color: _salonProfileProvider.salonTheme
                                      .appBarTheme.titleTextStyle!.color,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                        ),
                      ),
                    )
                  //  const SizedBox()
                  // Text(_salonProfileProvider.extractFirstLetters(chosenSalon.salonName,),  style: GoogleFonts.openSans(color: _salonProfileProvider
                  //       .salonTheme.appBarTheme.titleTextStyle!.color,fontWeight: FontWeight.bold, fontSize: 14))
                  : SizedBox(
                      child: CircleAvatar(
                      radius: 20,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedImage(
                          url: chosenSalon.salonLogo,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ))
              //  Text(_salonProfileProvider.extractFirstLetters(chosenSalon.salonName,),  style: GoogleFonts.openSans(color: _salonProfileProvider
              //         .salonTheme.appBarTheme.titleTextStyle!.color,fontWeight: FontWeight.bold, fontSize: 14))
            ],
          ),
        ),
        backgroundColor:
            _salonProfileProvider.salonTheme.appBarTheme.backgroundColor,
        actions: [
          SingleChildScrollView(
            child: Row(
              children: [
                if (chosenSalon.description.isNotEmpty &&
                    displaySettings!.showAbout)
                  AppBarMenu(
                    title: AppLocalizations.of(context)?.aboutUs ?? 'About Us',
                    action: () {
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
                  const Gap(32),
                  AppBarMenu(
                    title:
                        AppLocalizations.of(context)?.portfolio ?? 'Portfolio',
                    action: () {
                      Scrollable.ensureVisible(
                        controller.works.currentContext!,
                        duration: const Duration(seconds: 2),
                        curve: Curves.ease,
                      );
                    },
                  ),
                ],
                if (displaySettings!.services.showServices) ...[
                  const Gap(32),
                  AppBarMenu(
                    title: AppLocalizations.of(context)?.services ?? 'Services',
                    action: () {
                      Scrollable.ensureVisible(
                        controller.price.currentContext!,
                        duration: const Duration(seconds: 2),
                        curve: Curves.ease,
                      );
                    },
                  ),
                ],
                if (displaySettings.product.showProduct &&
                    _salonProfileProvider.allProducts.isNotEmpty) ...[
                  const Gap(32),
                  AppBarMenu(
                    title: AppLocalizations.of(context)?.products ?? 'Products',
                    action: () {
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
                  const Gap(32),
                  AppBarMenu(
                    title: AppLocalizations.of(context)?.team ?? 'Team',
                    action: () {
                      Scrollable.ensureVisible(
                        controller.team.currentContext!,
                        duration: const Duration(seconds: 2),
                        curve: Curves.ease,
                      );
                    },
                  ),
                ],
                if (_salonProfileProvider.salonReviews.isNotEmpty &&
                    displaySettings.reviews.showReviews) ...[
                  const Gap(32),
                  AppBarMenu(
                    title: AppLocalizations.of(context)?.reviews ?? 'Reviews',
                    action: () {
                      Scrollable.ensureVisible(
                        controller.reviews.currentContext!,
                        duration: const Duration(seconds: 2),
                        curve: Curves.ease,
                      );
                    },
                  ),
                ],
                const Gap(32),
                AppBarMenu(
                  title: AppLocalizations.of(context)?.contacts ?? 'Contacts',
                  action: () {
                    Scrollable.ensureVisible(
                      controller.contacts.currentContext!,
                      duration: const Duration(seconds: 2),
                      curve: Curves.ease,
                    );
                  },
                ),
                const Gap(62),
              ],
            ),
          ),
        ],
        //backgroundColor: Colors.white,
      ),
      backgroundColor: _salonProfileProvider.salonTheme.scaffoldBackgroundColor,
      body: _salonProfileProvider.isShowMenuDesktop
          ? Container(
              width: double.infinity,
              color: _salonProfileProvider.salonTheme.scaffoldBackgroundColor,
              child: _salonProfileProvider.currentWidget)
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: height,
                          //color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Gap(175),
                              SizedBox(
                                // width: 537,
                                height: 200,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 113.0),
                                        child: Text(
                                          chosenSalon.salonName.toTitleCase(),
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.openSans(
                                            color: _salonProfileProvider
                                                .salonTheme
                                                .textTheme
                                                .titleLarge!
                                                .color,
                                            fontSize: screenSize.width * 0.05,
                                            //80,
                                            //     fontFamily: 'Open Sans',
                                            fontWeight: FontWeight.w600,
                                            height: 1,
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Expanded(
                                    //   child: Text(
                                    //     'by Ashley Marie',
                                    //     textAlign: TextAlign.right,
                                    //     style: GoogleFonts.ooohBaby(
                                    //       color: _salonProfileProvider
                                    //           .salonTheme
                                    //           .textTheme
                                    //           .displaySmall!
                                    //           .color,
                                    //       fontSize: screenSize.width * 0.02,
                                    //       //  fontFamily: 'Oooh Baby',
                                    //       fontWeight: FontWeight.w400,
                                    //       height: 0,
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                              const Gap(50),
                              if (chosenSalon.specializations != null &&
                                  chosenSalon.specializations!.isNotEmpty &&
                                  displaySettings.showSpecialization)
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 80.0, right: 30),
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
                              const Gap(50),
                              GestureDetector(
                                onTap: () {
                                  const BookingDialogWidget222().show(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 120.0, right: 12),
                                  child: Row(
                                    children: [
                                      Text('BOOK NOW',
                                          style: GoogleFonts.openSans(
                                              color: _salonProfileProvider
                                                  .salonTheme
                                                  .colorScheme
                                                  .secondary,
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
                            ],
                          ),
                        ),
                      ),
                      // Expanded(
                      //     child: Image.asset(
                      //   'assets/test_assets/Background1.png',
                      //   height: height,
                      //   fit: BoxFit.cover,
                      // )),
                      (_salonProfileProvider.themeSettings?.backgroundImage !=
                                  null &&
                              _salonProfileProvider
                                      .themeSettings?.backgroundImage !=
                                  '')
                          ? Expanded(
                              child: CachedImage(
                                url: _salonProfileProvider
                                    .themeSettings!.backgroundImage!,
                                fit: BoxFit.cover,
                                height: height,
                              ),
                            )
                          : Expanded(
                              child: Image.asset(AppIcons.photoSlider,
                                  height: height, fit: BoxFit.cover)),
                    ],
                  ),
                  if (chosenSalon.additionalFeatures.isNotEmpty &&
                      displaySettings.showFeatures)
                    IntrinsicHeight(
                      child: Container(
                          width: double.infinity,
                          // height: 482,
                          decoration: BoxDecoration(
                            color: _salonProfileProvider
                                .salonTheme.colorScheme.secondary,
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 100.0, right: 30),
                            child: Center(
                              child: Wrap(
                                  children: chosenSalon.additionalFeatures
                                      .map((e) => DesktopFeaturesCheck(
                                            title: getFeature(
                                                e, chosenSalon.locale),
                                          ))
                                      .toList()
                                  // const [
                                  //   DesktopFeaturesCheck(),
                                  //   DesktopFeaturesCheck(),
                                  //   DesktopFeaturesCheck(),
                                  //   DesktopFeaturesCheck(),
                                  //   DesktopFeaturesCheck(),
                                  //   DesktopFeaturesCheck(),
                                  //   DesktopFeaturesCheck(),
                                  //   DesktopFeaturesCheck(),
                                  //   DesktopFeaturesCheck(),
                                  // ],
                                  ),
                            ),
                          )),
                    ),
                  const Gap(100),
                  if (chosenSalon.description.isNotEmpty &&
                      displaySettings.showAbout)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Gap(100),
                        SizedBox.fromSize(
                            size: Size.zero, key: controller.about),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Gap(50),
                              Text(
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
                              const Gap(220),
                            ],
                          ),
                        ),
                        //  const Gap(50),
                        const Spacer(),
                        Expanded(
                          flex: 2,
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
                        const Gap(50),
                      ],
                    ),
                  const Gap(60),
                  if (chosenSalon.profilePics.isNotEmpty)
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
                          padding:
                              const EdgeInsets.only(left: 100.0, right: 80),
                          child: CachedImage(
                            url: chosenSalon.profilePics[index].toString(),
                            width: size.width / 1.2,
                            fit: BoxFit.fill,
                            height: 800,
                          ),
                        );
                      },
                    ),
                  const Gap(50),
                  Container(
                    height: 40,
                    decoration: const BoxDecoration(
                        border: Border(
                            top: BorderSide(
                              color: Color(0xff9F9F9F),
                            ),
                            bottom: BorderSide(color: Color(0xff9F9F9F)))),
                    child: Marquee(
                      text: ' 🌑  ${chosenSalon.salonName.toTitleCase()} ',
                      style: GoogleFonts.openSans(
                        fontSize: 15.0,
                        color: _salonProfileProvider
                            .salonTheme.textTheme.displaySmall!.color,
                      ),

                      scrollAxis: Axis.horizontal,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      blankSpace: 20.0, // Adjust the spacing as needed
                      velocity: 40.0, // Adjust the scrolling speed
                      startPadding: 20.0, // Adjust the initial padding
                      accelerationDuration: const Duration(seconds: 1),
                      accelerationCurve: Curves.easeInOut,
                      decelerationDuration: const Duration(milliseconds: 500),
                      decelerationCurve: Curves.easeInOut,
                    ),
                  ),
                  const Gap(100),
                  if (chosenSalon.photosOfWorks != null &&
                      chosenSalon.photosOfWorks!.isNotEmpty &&
                      displaySettings.showPhotosOfWork) ...[
                    SizedBox.fromSize(size: Size.zero, key: controller.works),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 100.0,
                      ),
                      child: Text(
                        (AppLocalizations.of(context)?.portfolio ?? 'PORTFOLIO')
                            .toUpperCase(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                          color: _salonProfileProvider
                              .salonTheme.textTheme.displaySmall!.color,
                          fontSize: 60,
                          // fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w600,
                          height: 0.03,
                        ),
                      ),
                    ),
                    const Gap(50),
                    Padding(
                      padding: const EdgeInsets.only(left: 100.0),
                      child: Wrap(
                          //verticalDirection: VerticalDirection.up,
                          alignment: WrapAlignment.start,
                          runSpacing: 7,
                          spacing: 10,
                          children: chosenSalon.photosOfWorks!.map((e) {
                            bool isHovered =
                                chosenSalon.photosOfWorks!.indexOf(e) ==
                                    hoveredIndex;
                            return MouseRegion(
                              onEnter: (_) => _onEnter(
                                  chosenSalon.photosOfWorks!.indexOf(e)),
                              onExit: (_) {
                                _onExit(chosenSalon.photosOfWorks!.indexOf(e));
                                setState(() {
                                  isHovered = false;
                                });
                              },
                              child: Container(
                                width: 339,
                                height: 300,

                                //clipBehavior: Clip.antiAlias,
                                child: Column(
                                  children: [
                                    CachedImage(
                                      url: e.image.toString(),
                                      width: size.width / 1.2,
                                      fit: BoxFit.fitWidth,
                                      height: 296,
                                    ),
                                    //       Visibility(
                                    //         visible: isHovered,
                                    //         child: Container(

                                    //         //  height: 200,
                                    //           width: double.infinity,
                                    //           padding: const EdgeInsets.symmetric(
                                    //               horizontal: 14, vertical: 16),
                                    //           decoration:  ShapeDecoration(
                                    //              color:Colors.white,
                                    // //               _salonProfileProvider
                                    // // .salonTheme.scaffoldBackgroundColor,
                                    //             shape: RoundedRectangleBorder(

                                    //               side: BorderSide(
                                    //                   width: 0.5,
                                    //                   color: Color(0xFF282828)),
                                    //             ),
                                    //           ),
                                    //           child: Expanded(
                                    //             child: Text(
                                    //               e.description.toString(),
                                    //               style: GoogleFonts.openSans(
                                    //                color: _salonProfileProvider
                                    // .salonTheme.textTheme.displaySmall!.color,
                                    //                 fontSize: 14,
                                    //                 //  fontFamily: 'Onest',
                                    //                 fontWeight: FontWeight.w400,
                                    //                 height: 1.5,
                                    //                 letterSpacing: 0.16,
                                    //               ),
                                    //             ),
                                    //           ),
                                    //         ),
                                    //       ),
                                  ],
                                ),

                                decoration: const BoxDecoration(
                                    //color:Colors.white,
                                    //   image: DecorationImage(
                                    //     image:
                                    // ),
                                    ),
                              ),
                            );
                          }).toList()),
                    ),
                    const Gap(100),
                  ],
                  SizedBox.fromSize(size: Size.zero, key: controller.price),
                  if (displaySettings.services.showServices) ...[
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 100.0,
                      ),
                      child: Text(
                        (AppLocalizations.of(context)?.services ?? 'SERVICES')
                            .toUpperCase(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                          color: _salonProfileProvider
                              .salonTheme.textTheme.displaySmall!.color,
                          fontSize: 60,
                          // fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w600,
                          height: 0.03,
                        ),
                      ),
                    ),
                    const Gap(50),
                    if (_createAppointmentProvider
                        .categoriesAvailable.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 100.0, right: 8.0),
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
                                ..._createAppointmentProvider
                                    .categoriesAvailable,
                              ];

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _currentIndex = index;
                                    selectedCatId = catList[index].categoryId;
                                    print('selectedId $selectedCatId');
                                    _pageController.animateToPage(
                                      index,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.ease,
                                    );
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),

                                  decoration: BoxDecoration(
                                    border: _currentIndex == index
                                        ? BorderDirectional(
                                            bottom: BorderSide(
                                              width: 2,
                                              color: _salonProfileProvider
                                                  .salonTheme
                                                  .colorScheme
                                                  .secondary,
                                              // color:
                                              //  Color(0xFFE980B2)
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
                                        color: _salonProfileProvider.salonTheme
                                            .textTheme.bodyMedium!.color,
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 400,
                        width: double.infinity,
                        child: Builder(
                          builder: (_) {
                            List<ServiceModel> allServiceList = [];
                            if (_currentIndex == 0) {
                              for (List<ServiceModel> serviceList
                                  in _createAppointmentProvider
                                      .servicesAvailable) {
                                allServiceList.addAll(serviceList);
                              }
                              return Column(
                                children: [
                                  Expanded(
                                    child: ListView.builder(
                                        controller: _pageController,
                                        //  shrinkWrap: true,
                                        itemCount: allServiceList.length,
                                        itemBuilder: (context, index) {
                                          return CityMuseServiceTab(
                                              serviceList:
                                                  allServiceList[index],
                                              salonProfileProvider:
                                                  _salonProfileProvider,
                                              chosenSalon: chosenSalon);
                                        }),
                                  ),
                                ],
                              );
                            }

                            for (List<ServiceModel> serviceList
                                in _createAppointmentProvider
                                    .servicesAvailable) {
                              for (var ser in serviceList) {
                                // print(cat.categoryId);
                                if (selectedCatId == ser.categoryId) {
                                  return Column(
                                    children: [
                                      Expanded(
                                        child: ListView.builder(
                                            controller: _pageController,
                                            //  shrinkWrap: true,
                                            itemCount: serviceList.length,
                                            itemBuilder: (context, index) {
                                              return CityMuseServiceTab(
                                                  serviceList:
                                                      serviceList[index],
                                                  salonProfileProvider:
                                                      _salonProfileProvider,
                                                  chosenSalon: chosenSalon);
                                            }),
                                      ),
                                    ],
                                  );
                                } else {}
                              }
                            }

                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ),
                    const Gap(40),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          const BookingDialogWidget222().show(context);
                        },
                        child: Center(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 120.0, right: 12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
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
                    ),
                    const Gap(70),
                  ],
                  //PRODUCT
                  if (displaySettings.product.showProduct &&
                      _salonProfileProvider.allProducts.isNotEmpty) ...[
                    SizedBox.fromSize(size: Size.zero, key: controller.shop),
                    Padding(
                      padding: const EdgeInsets.only(left: 100.0, right: 8.0),
                      child: Text(
                        (AppLocalizations.of(context)?.products ?? 'PRODUCTS')
                            .toUpperCase(),
                        style: GoogleFonts.openSans(
                          color: _salonProfileProvider
                              .salonTheme.textTheme.displaySmall!.color,
                          fontSize: 60,
                          //  fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 100.0, right: 8.0),
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
                                        'en': entry.key,
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
                                  selectedCatId = catList[index].categoryId;
                                  print('selectedId $selectedCatId');
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
                                }
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),

                                decoration: BoxDecoration(
                                  border: _currentProductIndex == index
                                      ? BorderDirectional(
                                          bottom: BorderSide(
                                            width: 2,
                                            color: _salonProfileProvider
                                                .salonTheme
                                                .colorScheme
                                                .secondary,
                                            //color: Color(0xFFE980B2)
                                          ),
                                        )
                                      : null,
                                ),
                                //Change the tab's color
                                child: Center(
                                  child: Text(
                                    '${catList[index].translations![AppLocalizations.of(context)?.localeName ?? 'en'] ?? catList[index].translations!['en']}'
                                        .toTitleCase(),
                                    style: GoogleFonts.openSans(
                                      color: _salonProfileProvider.salonTheme
                                          .textTheme.bodyMedium!.color,
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
                    const Gap(40),
                    SizedBox(
                      height: 600,
                      //width: 1000,
                      child: Builder(builder: (context) {
                        selectedProduct = _salonProfileProvider
                            .allProducts[_selectedProductIndex];
                        if (_currentProductIndex == 0) {
                          return Padding(
                            padding:
                                const EdgeInsets.only(left: 100.0, right: 8.0),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 488,
                                  child: Column(
                                    children: [
                                      if (selectedProduct!
                                                  .productImageUrlList ==
                                              null ||
                                          selectedProduct!
                                              .productImageUrlList!.isEmpty ||
                                          selectedProduct!
                                                  .productImageUrlList![0] ==
                                              null ||
                                          selectedProduct!
                                              .productImageUrlList![0]!
                                              .isEmpty) ...[
                                        Expanded(
                                          child: Text(
                                            AppLocalizations.of(context)
                                                    ?.photoNA ??
                                                'Photo N/A',
                                            style: GoogleFonts.openSans(
                                              //   color: const Color(0xFF0D0D0E),
                                              fontSize: 18,
                                              // fontFamily: 'Open Sans',
                                              fontWeight: FontWeight.w600,
                                              height: 0,
                                            ),
                                          ),
                                        )
                                      ] else ...[
                                        Center(
                                            child: CachedImage(
                                          url:
                                              '${selectedProduct!.productImageUrlList![0]}',
                                          width: 488,
                                          height: 530,
                                        )),
                                      ],
                                      const Gap(10),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5.0, right: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              selectedProduct!.productName ??
                                                  '',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.openSans(
                                                color: _salonProfileProvider
                                                    .salonTheme
                                                    .textTheme
                                                    .displaySmall!
                                                    .color,
                                                //   color: const Color(0xFF0D0D0E),
                                                fontSize: 18,
                                                // fontFamily: 'Open Sans',
                                                fontWeight: FontWeight.w600,
                                                height: 0,
                                              ),
                                            ),
                                            // const Spacer(),
                                            Text(
                                              '${getCurrency(chosenSalon.countryCode!)}${selectedProduct!.clientPrice ?? ''}',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.openSans(
                                                //      color: const Color(0xFF868686),
                                                fontSize: 18,
                                                //    fontFamily: 'Open Sans',
                                                fontWeight: FontWeight.w600,
                                                height: 0,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 350,
                                        child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: _salonProfileProvider
                                                .allProducts.length,
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              // print(
                                              //     'all products ${_salonProfileProvider.allProducts[index].productImageUrlList![0]}');
                                              // print(
                                              //     'all products ${_salonProfileProvider.allProducts[index].productImageUrlList}');

                                              return GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    selectedProduct =
                                                        _salonProfileProvider
                                                            .allProducts[index];
                                                    _selectedProductIndex =
                                                        index;
                                                  });
                                                  setState(() {});
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    children: [
                                                      if (_salonProfileProvider
                                                                  .allProducts[
                                                                      index]
                                                                  .productImageUrlList ==
                                                              null ||
                                                          _salonProfileProvider
                                                              .allProducts[
                                                                  index]
                                                              .productImageUrlList!
                                                              .isEmpty ||
                                                          _salonProfileProvider
                                                                      .allProducts[
                                                                          index]
                                                                      .productImageUrlList![
                                                                  0] ==
                                                              null ||
                                                          _salonProfileProvider
                                                              .allProducts[
                                                                  index]
                                                              .productImageUrlList![
                                                                  0]!
                                                              .isEmpty) ...[
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            SizedBox(
                                                              width: 285,
                                                              height: 285,
                                                              child: Text(
                                                                AppLocalizations.of(
                                                                            context)
                                                                        ?.photoNA ??
                                                                    'Photo N/A',
                                                                style: GoogleFonts
                                                                    .openSans(
                                                                  //   color: const Color(0xFF0D0D0E),
                                                                  fontSize: 18,
                                                                  // fontFamily: 'Open Sans',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  height: 0,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ] else ...[
                                                        _salonProfileProvider
                                                                    .allProducts[
                                                                        index]
                                                                    .productImageUrlList ==
                                                                null
                                                            ? SizedBox(
                                                                width: 285,
                                                                height: 285,
                                                                child: Text(
                                                                  AppLocalizations.of(
                                                                              context)
                                                                          ?.photoNA ??
                                                                      'Photo N/A',
                                                                  style: GoogleFonts
                                                                      .openSans(
                                                                    //   color: const Color(0xFF0D0D0E),
                                                                    fontSize:
                                                                        18,
                                                                    // fontFamily: 'Open Sans',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    height: 0,
                                                                  ),
                                                                ),
                                                              )
                                                            : Center(
                                                                child:
                                                                    CachedImage(
                                                                url:
                                                                    '${_salonProfileProvider.allProducts[index].productImageUrlList![0]}',
                                                                width: 285,
                                                                height: 285,
                                                                fit: BoxFit
                                                                    .cover,
                                                              )),
                                                      ],
                                                      const Gap(10),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 24.0,
                                                                right: 24.0),
                                                        child: SizedBox(
                                                          width: 285,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                _salonProfileProvider
                                                                        .allProducts[
                                                                            index]
                                                                        .productName ??
                                                                    ''.toCapitalized(),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: GoogleFonts
                                                                    .openSans(
                                                                  color: _salonProfileProvider
                                                                      .salonTheme
                                                                      .textTheme
                                                                      .displaySmall!
                                                                      .color,
                                                                  //   color: const Color(0xFF0D0D0E),
                                                                  fontSize: 18,
                                                                  // fontFamily: 'Open Sans',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  height: 0,
                                                                ),
                                                              ),
                                                              // Gap(170),
                                                              // const Spacer(),
                                                              Text(
                                                                '${getCurrency(chosenSalon.countryCode!)}${_salonProfileProvider.allProducts[index].clientPrice}' ??
                                                                    '',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: GoogleFonts
                                                                    .openSans(
                                                                  color: const Color(
                                                                      0xFF868686),
                                                                  fontSize: 18,
                                                                  //    fontFamily: 'Open Sans',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  height: 0,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }),
                                      ),
                                      SliderTheme(
                                        data: const SliderThemeData(
                                          thumbShape: RoundSliderThumbShape(
                                            enabledThumbRadius: 1,
                                          ),
                                          overlayColor: Color(0x29eb1555),
                                          activeTrackColor: Color(0xff868686),
                                          inactiveTrackColor: Color(0xffCACACA),
                                          thumbColor: Colors.white,
                                        ),
                                        child: Slider(
                                            value: _selectedProductIndex
                                                .toDouble(),
                                            thumbColor: Colors.transparent,
                                            //overlayColor: ,
                                            min: 0.0,
                                            max: _salonProfileProvider
                                                .allProducts.length
                                                .toDouble(),
                                            onChanged: (value1) {
                                              // setState(() {
                                              //   value = value1;
                                              // });
                                            }),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 38.0),
                                        child: SizedBox(
                                            width: 488,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    selectedProduct!
                                                            .productDescription ??
                                                        ''.toCapitalized(),
                                                    style: GoogleFonts.openSans(
                                                      fontSize: 15,
                                                      color: _salonProfileProvider
                                                          .salonTheme
                                                          .textTheme
                                                          .titleSmall!
                                                          .color, //height:1.5
                                                    )),
                                                const Gap(40),
                                                Row(
                                                  children: [
                                                    Text('BOOK NOW',
                                                        style: GoogleFonts.openSans(
                                                            color:
                                                                _salonProfileProvider
                                                                    .salonTheme
                                                                    .colorScheme
                                                                    .secondary,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700)),
                                                    const Gap(10),
                                                    Image.asset(
                                                      'assets/test_assets/book_arrow.png',
                                                      height: 24,
                                                      width: 24,
                                                      color:
                                                          _salonProfileProvider
                                                              .salonTheme
                                                              .colorScheme
                                                              .secondary,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        }
                        if (_currentProductIndex != 0) {
                          return Padding(
                            padding:
                                const EdgeInsets.only(left: 100.0, right: 8.0),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 488,
                                  child: Column(
                                    children: [
                                      if (selectedProduct!
                                                  .productImageUrlList ==
                                              null ||
                                          selectedProduct!
                                              .productImageUrlList!.isEmpty ||
                                          selectedProduct!
                                                  .productImageUrlList![0] ==
                                              null ||
                                          selectedProduct!
                                              .productImageUrlList![0]!
                                              .isEmpty) ...[
                                        Expanded(
                                          child: Text(
                                            AppLocalizations.of(context)
                                                    ?.photoNA ??
                                                'Photo N/A',
                                            style: GoogleFonts.openSans(
                                              //   color: const Color(0xFF0D0D0E),
                                              fontSize: 18,
                                              // fontFamily: 'Open Sans',
                                              fontWeight: FontWeight.w600,
                                              height: 0,
                                            ),
                                          ),
                                        )
                                      ] else ...[
                                        Center(
                                            child: CachedImage(
                                          url:
                                              '${selectedProduct!.productImageUrlList![0]}',
                                          width: 488,
                                          height: 530,
                                        )),
                                      ],
                                      const Gap(10),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5.0, right: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              selectedProduct!.productName ??
                                                  '',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.openSans(
                                                //   color: const Color(0xFF0D0D0E),
                                                fontSize: 18,
                                                // fontFamily: 'Open Sans',
                                                fontWeight: FontWeight.w600,
                                                height: 0,
                                              ),
                                            ),
                                            // const Spacer(),
                                            Text(
                                              '${getCurrency(chosenSalon.countryCode!)}${selectedProduct!.clientPrice ?? ''}',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.openSans(
                                                //      color: const Color(0xFF868686),
                                                fontSize: 18,
                                                //    fontFamily: 'Open Sans',
                                                fontWeight: FontWeight.w600,
                                                height: 0,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 350,
                                        child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: _salonProfileProvider
                                                .tabs[currentSelectedEntry]
                                                ?.length,
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              return GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    selectedProduct =
                                                        _salonProfileProvider
                                                                    .tabs[
                                                                currentSelectedEntry]![
                                                            index];
                                                    _selectedProductIndex =
                                                        index;
                                                  });
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    children: [
                                                      if (_salonProfileProvider
                                                                  .tabs[
                                                                      currentSelectedEntry]
                                                                      ?[index]
                                                                  .productImageUrlList ==
                                                              null ||
                                                          _salonProfileProvider
                                                              .tabs[
                                                                  currentSelectedEntry]![
                                                                  index]
                                                              .productImageUrlList!
                                                              .isEmpty ||
                                                          _salonProfileProvider
                                                                      .tabs[
                                                                          currentSelectedEntry]
                                                                          ?[index]
                                                                      .productImageUrlList![
                                                                  0] ==
                                                              null ||
                                                          _salonProfileProvider
                                                              .tabs[
                                                                  currentSelectedEntry]![
                                                                  index]
                                                              .productImageUrlList![
                                                                  0]!
                                                              .isEmpty) ...[
                                                        SizedBox(
                                                          width: 285,
                                                          height: 285,
                                                          child: Text(
                                                            AppLocalizations.of(
                                                                        context)
                                                                    ?.photoNA ??
                                                                'Photo N/A',
                                                            style: GoogleFonts
                                                                .openSans(
                                                              //   color: const Color(0xFF0D0D0E),
                                                              fontSize: 18,
                                                              // fontFamily: 'Open Sans',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              height: 0,
                                                            ),
                                                          ),
                                                        )
                                                      ] else ...[
                                                        Center(
                                                            child: CachedImage(
                                                          url:
                                                              '${_salonProfileProvider.tabs[currentSelectedEntry]?[index].productImageUrlList![0]}',
                                                          width: 285,
                                                          height: 285,
                                                          fit: BoxFit.cover,
                                                        )),
                                                      ],
                                                      const Gap(10),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 24.0,
                                                                right: 24.0),
                                                        child: SizedBox(
                                                          width: 285,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                _salonProfileProvider
                                                                        .tabs[
                                                                            currentSelectedEntry]
                                                                            ?[
                                                                            index]
                                                                        .productName ??
                                                                    ''.toCapitalized(),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: GoogleFonts
                                                                    .openSans(
                                                                  //   color: const Color(0xFF0D0D0E),
                                                                  fontSize: 18,
                                                                  // fontFamily: 'Open Sans',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  height: 0,
                                                                ),
                                                              ),
                                                              // Gap(170),
                                                              // const Spacer(),
                                                              Text(
                                                                '${getCurrency(chosenSalon.countryCode!)}${_salonProfileProvider.tabs[currentSelectedEntry]?[index].clientPrice}' ??
                                                                    '',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: GoogleFonts
                                                                    .openSans(
                                                                  //      color: const Color(0xFF868686),
                                                                  fontSize: 18,
                                                                  //    fontFamily: 'Open Sans',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  height: 0,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }),
                                      ),
                                      SliderTheme(
                                        data: const SliderThemeData(
                                          thumbShape: RoundSliderThumbShape(
                                            enabledThumbRadius: 1,
                                          ),
                                          overlayColor: Color(0x29eb1555),
                                          activeTrackColor: Color(0xff868686),
                                          inactiveTrackColor: Color(0xffCACACA),
                                          thumbColor: Colors.white,
                                        ),
                                        child: Slider(
                                            value: _selectedProductIndex
                                                .toDouble(),
                                            thumbColor: Colors.transparent,
                                            //overlayColor: ,
                                            min: 0.0,
                                            max: _salonProfileProvider
                                                .allProducts.length
                                                .toDouble(),
                                            onChanged: (value1) {
                                              // setState(() {
                                              //   value = value1;
                                              // });
                                            }),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 38.0),
                                        child: SizedBox(
                                            width: 488,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    selectedProduct!
                                                            .productDescription ??
                                                        ''.toCapitalized(),
                                                    style: GoogleFonts.openSans(
                                                      fontSize: 15,
                                                      color: _salonProfileProvider
                                                          .salonTheme
                                                          .textTheme
                                                          .titleSmall!
                                                          .color, //height:1.5
                                                    )),
                                                SvgPicture.asset(
                                                    'assets/arrow.svg'),
                                              ],
                                            )),
                                      ),
                                      const Gap(40),
                                      Row(
                                        children: [
                                          Text('BOOK NOW',
                                              style: GoogleFonts.openSans(
                                                  color: _salonProfileProvider
                                                      .salonTheme
                                                      .colorScheme
                                                      .secondary,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700)),
                                          const Gap(10),
                                          Image.asset(
                                            'assets/test_assets/book_arrow.png',
                                            height: 24,
                                            width: 24,
                                            color: _salonProfileProvider
                                                .salonTheme
                                                .colorScheme
                                                .secondary,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        }
                        return const SizedBox();
                      }),
                    ),
                  ],

                  //TEAM

                  if (displaySettings.showTeam &&
                      _createAppointmentProvider.salonMasters.isNotEmpty) ...[
                    SizedBox.fromSize(size: Size.zero, key: controller.team),
                    Padding(
                      padding: const EdgeInsets.only(left: 100.0, right: 8.0),
                      child: Text(
                        (AppLocalizations.of(context)?.team ?? 'TEAM')
                            .toUpperCase(),
                        style: GoogleFonts.openSans(
                          color: _salonProfileProvider
                              .salonTheme.textTheme.displaySmall!.color,
                          fontSize: 60,
                          //  fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                    ),
                    const Gap(50),
                    Padding(
                      padding: const EdgeInsets.only(left: 100.0, right: 20.0),
                      child: SizedBox(
                        height: 501,
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return TeamWidget(
                                masterModel: _createAppointmentProvider
                                    .salonMasters[index],
                                index: index);
                          },
                          itemCount:
                              _createAppointmentProvider.salonMasters.length,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          // children: [
                          //   GestureDetector(
                          //       onTap: () {
                          //         setState(() {
                          //           getWidget('masters');
                          //           isShowMenu = true;
                          //         });
                          //       },
                          //       child: const TeamWidget()),
                          //   const TeamWidget(),
                          //   const TeamWidget(),
                          // ],
                        ),
                      ),
                    ),
                    const Gap(100),
                  ],

                  if (_salonProfileProvider.salonReviews.isNotEmpty &&
                      displaySettings.reviews.showReviews) ...[
                    SizedBox.fromSize(size: Size.zero, key: controller.reviews),
                    const CityMuseDesktopReviews(),
                  ],

                  const Gap(70),
                  if (displaySettings.showRequestForm) ...[
                    SizedBox.fromSize(
                        size: Size.zero, key: controller.writeToUs),
                    Padding(
                      padding: const EdgeInsets.only(left: 100.0, right: 18.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'WRITE TO US',
                                style: GoogleFonts.openSans(
                                  color: _salonProfileProvider
                                      .salonTheme.textTheme.displaySmall!.color,
                                  fontSize: 60,
                                  fontWeight: FontWeight.w600,
                                  height: 0,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 18.0),
                                child: Text(
                                  'Write to us and we will get back to you as soon as possible',
                                  style: GoogleFonts.openSans(
                                    color: _salonProfileProvider.salonTheme
                                        .textTheme.displaySmall!.color,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    height: 1.5,
                                    letterSpacing: 0.16,
                                  ),
                                ),
                              ),
                              const Gap(40),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10.0, right: 18.0),
                                        child: Text(
                                          'First Name',
                                          style: GoogleFonts.openSans(
                                            color: _salonProfileProvider
                                                .salonTheme
                                                .textTheme
                                                .displaySmall!
                                                .color,
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
                                        padding: const EdgeInsets.only(
                                            left: 10.0, right: 18.0),
                                        child: SizedBox(
                                          height: 44,
                                          width: 250,
                                          child: TextField(
                                            controller: _salonProfileProvider
                                                .firstNameController,
                                            decoration: InputDecoration(
                                                hintText: 'First Name',
                                                filled: _salonProfileProvider
                                                    .salonTheme
                                                    .inputDecorationTheme
                                                    .filled,
                                                fillColor: _salonProfileProvider
                                                    .salonTheme
                                                    .inputDecorationTheme
                                                    .fillColor,
                                                border: _salonProfileProvider
                                                    .salonTheme
                                                    .inputDecorationTheme
                                                    .border,
                                                enabledBorder:
                                                    _salonProfileProvider
                                                        .salonTheme
                                                        .inputDecorationTheme
                                                        .enabledBorder,
                                                focusedBorder:
                                                    _salonProfileProvider
                                                        .salonTheme
                                                        .inputDecorationTheme
                                                        .focusedBorder),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 18.0, right: 18.0),
                                        child: Text(
                                          'Last Name',
                                          style: GoogleFonts.openSans(
                                            color: _salonProfileProvider
                                                .salonTheme
                                                .textTheme
                                                .displaySmall!
                                                .color,
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
                                        padding: const EdgeInsets.only(
                                            left: 18.0, right: 18.0),
                                        child: SizedBox(
                                          height: 44,
                                          width: 250,
                                          child: TextField(
                                            controller: _salonProfileProvider
                                                .lastNameController,
                                            decoration: InputDecoration(
                                                hintText: 'Last Name',
                                                filled: _salonProfileProvider
                                                    .salonTheme
                                                    .inputDecorationTheme
                                                    .filled,
                                                fillColor: _salonProfileProvider
                                                    .salonTheme
                                                    .inputDecorationTheme
                                                    .fillColor,
                                                border: _salonProfileProvider
                                                    .salonTheme
                                                    .inputDecorationTheme
                                                    .border,
                                                enabledBorder:
                                                    _salonProfileProvider
                                                        .salonTheme
                                                        .inputDecorationTheme
                                                        .enabledBorder,
                                                focusedBorder:
                                                    _salonProfileProvider
                                                        .salonTheme
                                                        .inputDecorationTheme
                                                        .focusedBorder),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Gap(40),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10.0, right: 18.0),
                                        child: Text(
                                          'Email',
                                          style: GoogleFonts.openSans(
                                            color: _salonProfileProvider
                                                .salonTheme
                                                .textTheme
                                                .displaySmall!
                                                .color,
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
                                        padding: const EdgeInsets.only(
                                            left: 10.0, right: 18.0),
                                        child: SizedBox(
                                          height: 44,
                                          width: 250,
                                          child: TextField(
                                            controller: _salonProfileProvider
                                                .emailController,
                                            decoration: InputDecoration(
                                                hintText: "glamiris@gmail.com",
                                                filled: _salonProfileProvider
                                                    .salonTheme
                                                    .inputDecorationTheme
                                                    .filled,
                                                fillColor: _salonProfileProvider
                                                    .salonTheme
                                                    .inputDecorationTheme
                                                    .fillColor,
                                                border: _salonProfileProvider
                                                    .salonTheme
                                                    .inputDecorationTheme
                                                    .border,
                                                enabledBorder:
                                                    _salonProfileProvider
                                                        .salonTheme
                                                        .inputDecorationTheme
                                                        .enabledBorder,
                                                focusedBorder:
                                                    _salonProfileProvider
                                                        .salonTheme
                                                        .inputDecorationTheme
                                                        .focusedBorder),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 18.0, right: 18.0),
                                        child: Text(
                                          'Phone',
                                          style: GoogleFonts.openSans(
                                            color: _salonProfileProvider
                                                .salonTheme
                                                .textTheme
                                                .displaySmall!
                                                .color,
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
                                        padding: const EdgeInsets.only(
                                            left: 18.0, right: 18.0),
                                        child: SizedBox(
                                          height: 44,
                                          width: 250,
                                          child: TextField(
                                            controller: _salonProfileProvider
                                                .phoneController,
                                            decoration: InputDecoration(
                                                hintText: 'Phone',
                                                filled: _salonProfileProvider
                                                    .salonTheme
                                                    .inputDecorationTheme
                                                    .filled,
                                                fillColor: _salonProfileProvider
                                                    .salonTheme
                                                    .inputDecorationTheme
                                                    .fillColor,
                                                border: _salonProfileProvider
                                                    .salonTheme
                                                    .inputDecorationTheme
                                                    .border,
                                                enabledBorder:
                                                    _salonProfileProvider
                                                        .salonTheme
                                                        .inputDecorationTheme
                                                        .enabledBorder,
                                                focusedBorder:
                                                    _salonProfileProvider
                                                        .salonTheme
                                                        .inputDecorationTheme
                                                        .focusedBorder),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Gap(40),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 18.0),
                                child: Text(
                                  'Message',
                                  style: GoogleFonts.openSans(
                                    color: _salonProfileProvider.salonTheme
                                        .textTheme.displaySmall!.color,
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
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 18.0),
                                child: SizedBox(
                                  height: 200,
                                  width: 550,
                                  child: TextField(
                                    // maxLength: 8,
                                    minLines: 7,
                                    maxLines: 8,
                                    controller:
                                        _salonProfileProvider.requestController,
                                    decoration: InputDecoration(
                                        hintText: 'Write to us',
                                        filled: _salonProfileProvider.salonTheme
                                            .inputDecorationTheme.filled,
                                        fillColor: _salonProfileProvider
                                            .salonTheme
                                            .inputDecorationTheme
                                            .fillColor,
                                        border: _salonProfileProvider.salonTheme
                                            .inputDecorationTheme.border,
                                        enabledBorder: _salonProfileProvider
                                            .salonTheme
                                            .inputDecorationTheme
                                            .enabledBorder,
                                        focusedBorder: _salonProfileProvider
                                            .salonTheme
                                            .inputDecorationTheme
                                            .focusedBorder),
                                  ),
                                ),
                              ),
                              const Gap(40),
                              GestureDetector(
                                onTap: () {
                                  _salonProfileProvider
                                      .sendEnquiryToSalonCityMuse(context,
                                          salonId: chosenSalon.salonId);
                                },
                                child: _salonProfileProvider.enquiryStatus ==
                                        Status.loading
                                    ? Center(
                                        child: SizedBox(
                                          height: 30,
                                          width: 30,
                                          child: CircularProgressIndicator(
                                              color: _salonProfileProvider
                                                  .salonTheme
                                                  .colorScheme
                                                  .secondary
                                              // Color(0xFFE980B2),
                                              ),
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10.0, right: 18.0),
                                        child: Center(
                                          child: Container(
                                            width: 544,
                                            height: 50,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 40, vertical: 13),
                                            decoration: ShapeDecoration(
                                              color: _salonProfileProvider
                                                  .salonTheme
                                                  .colorScheme
                                                  .secondary,
                                              // color: const Color(0xFFE980B2),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(2)),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Text(
                                                        'SEND MESSAGE',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                          fontFamily:
                                                              'Open Sans',
                                                          fontWeight:
                                                              FontWeight.w700,
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
                            ],
                          ),
                          //  Spacer(),
                          // const Gap(100),
                          (_salonProfileProvider
                                          .themeSettings?.backgroundImage !=
                                      null &&
                                  _salonProfileProvider
                                          .themeSettings?.backgroundImage !=
                                      '')
                              ? Expanded(
                                  child: CachedImage(
                                    url: _salonProfileProvider
                                        .themeSettings!.backgroundImage!,
                                    fit: BoxFit.cover,
                                    width: screenSize.width * 0.3,
                                    height: screenSize.width * 0.4,
                                  ),
                                )
                              : Expanded(
                                  child: Image.asset(AppIcons.photoSlider,
                                      width: screenSize.width * 0.3,
                                      height: screenSize.width * 0.4,
                                      fit: BoxFit.cover)),
                          // Expanded(
                          //   child: Image.asset(
                          //     'assets/test_assets/write.png',
                          // width: screenSize.width * 0.3,
                          // height: screenSize.width * 0.4,
                          //     fit: BoxFit.fitHeight,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    const Gap(80),
                  ],
                  if (displaySettings.showContact) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox.fromSize(
                                  size: Size.zero, key: controller.contacts),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 100.0, right: 18.0),
                                child: Text(
                                  (AppLocalizations.of(context)?.contacts ??
                                          'Contacts')
                                      .toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.openSans(
                                    color: _salonProfileProvider.salonTheme
                                        .textTheme.displaySmall!.color,
                                    fontSize: 40,
                                    //  fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                ),
                              ),
                              const Gap(24),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 100.0, right: 18.0),
                                child: SizedBox(
                                  width: 508,
                                  child: Text(
                                    "Connect with us easily. Whether it's questions, collaborations, or just saying hello, we're here for you. Reach out via email, find us on social media, give us a call, or visit our address below.",
                                    style: GoogleFonts.openSans(
                                      //  fontFamily: "Open Sans",
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: _salonProfileProvider.salonTheme
                                          .textTheme.displaySmall!.color,
                                      height: 1.5,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                              const Gap(40),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 80.0, right: 18.0),
                                child: Row(
                                  children: [
                                    ContactCard(
                                      contactTitle: 'Write To Us',
                                      contactAction: () async {
                                        final Uri emailLaunchUri = Uri(
                                          scheme: 'mailto',
                                          path: chosenSalon.email,
                                          queryParameters: {
                                            'subject': 'Contact'
                                          },
                                        );
                                        launchUrl(emailLaunchUri);
                                      },
                                      width: screenSize.width * 0.17,
                                      titleFontSize: screenSize.width * 0.009,
                                      descriptionFontSize:
                                          screenSize.width * 0.008,
                                      infoFontSize: screenSize.width * 0.008,
                                      contactAsset: 'message.svg',
                                      contactDescription:
                                          'Start a conversations via email',
                                      contactInfo: chosenSalon.email,
                                    ),
                                    if (chosenSalon.phoneNumber.isNotEmpty)
                                      ContactCard(
                                        contactTitle: 'Call Us',
                                        width: screenSize.width * 0.17,
                                        contactAction: () {
                                          Utils().launchCaller(chosenSalon
                                              .phoneNumber
                                              .replaceAll("-", ""));
                                        },
                                        titleFontSize: screenSize.width * 0.009,
                                        descriptionFontSize:
                                            screenSize.width * 0.008,
                                        infoFontSize: screenSize.width * 0.008,
                                        contactAsset: 'phone.svg',
                                        contactDescription:
                                            'Today from 10 am to 7 pm',
                                        contactInfo: chosenSalon.phoneNumber,
                                      ),
                                  ],
                                ),
                              ),
                              const Gap(20),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 80.0, right: 18.0),
                                child: Row(
                                  children: [
                                    ContactCard(
                                      contactTitle: 'Visit Us',
                                      width: screenSize.width * 0.17,
                                      titleFontSize: screenSize.width * 0.009,
                                      descriptionFontSize:
                                          screenSize.width * 0.008,
                                      infoFontSize: screenSize.width * 0.008,
                                      contactAsset: 'location.svg',
                                      contactAction: () async {
                                        Uri uri = Uri.parse(
                                            'https://www.google.com/maps/search/?api=1&query=${Uri.encodeFull(chosenSalon.address)}');

                                        if (await canLaunchUrl(uri)) {
                                          await launchUrl(uri);
                                        } else {
                                          showToast(AppLocalizations.of(context)
                                                  ?.couldNotLaunch ??
                                              "Could not launch");
                                        }
                                      },
                                      contactDescription: chosenSalon.address,
                                      contactInfo: 'View on The Map',
                                    ),
                                    ContactCard(
                                      width: screenSize.width * 0.17,
                                      titleFontSize: screenSize.width * 0.009,
                                      descriptionFontSize:
                                          screenSize.width * 0.008,
                                      infoFontSize: screenSize.width * 0.008,
                                      contactTitle: 'Social Media',
                                      contactAsset: 'social_media.svg',
                                      contactDescription: 'Salon address',
                                      contactInfo: '',
                                      contactAssetList: const [
                                        'instagram.svg',
                                        'tiktok.svg',
                                        'facebook.svg'
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),

                        /// Spacer(),
                        //    const Gap(70),
                        Expanded(
                          flex: 1,
                          child: SizedBox(
                            height: screenSize.width * 0.4,
                            width: screenSize.width * 0.3,
                            child: GoogleMaps(
                              salonModel: chosenSalon,
                            ),
                          ),
                        ),
                        // Expanded(
                        //     child: Image.asset(
                        //   'assets/test_assets/map1.png',
                        //   width: screenSize.width * 0.3,
                        //   height: screenSize.width * 0.4,
                        //   fit: BoxFit.fitHeight,
                        // )),
                        const Gap(50),
                      ],
                    ),
                  ],
                  const Gap(100),
                  Padding(
                    padding: const EdgeInsets.only(left: 100.0, right: 60.0),
                    child: Container(
                        height: 1,
                        width: double.infinity,
                        color: const Color(0xFFB8B2A6)),
                  ),
                  const Gap(40),
                  Padding(
                    padding: const EdgeInsets.only(left: 100.0, right: 60.0),
                    child: Row(
                      children: [
                        Text(
                          "Terms & Conditions",
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff868686),
                            height: 24 / 14,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const Gap(70),
                        Text(
                          "Privacy Policy",
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff868686),
                            height: 24 / 14,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const Spacer(),
                        Text(
                          "© 2023 Glamiris.",
                          style: GoogleFonts.openSans(
                            fontSize: 14,
                            color: const Color(0xff868686),
                            //fontWeight: FontWeight.wSymbol(figma.mixed),
                            height: 24 / 14,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const Gap(5),
                        Text(
                          "Powered by GlamIris",
                          style: GoogleFonts.openSans(
                            fontSize: 14,
                            color: _salonProfileProvider
                                .salonTheme.colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                            // color: const Color(0xFFE980B2),
                            //fontWeight: FontWeight.wSymbol(figma.mixed),
                            height: 24 / 14,
                          ),
                          textAlign: TextAlign.left,
                        )
                      ],
                    ),
                  ),
                  const Gap(30)
                ],
              ),
            ),
    );
  }
}

class CityMuseServiceTab extends StatelessWidget {
  const CityMuseServiceTab({
    super.key,
    required this.serviceList,
    required SalonProfileProvider salonProfileProvider,
    required this.chosenSalon,
  }) : _salonProfileProvider = salonProfileProvider;

  final ServiceModel serviceList;
  final SalonProfileProvider _salonProfileProvider;
  final SalonModel chosenSalon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 100.0, right: 100.0),
      child: Container(
        height: 59,
        width: 1199,
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0xffD9D9D9)))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              serviceList.translations?[
                      AppLocalizations.of(context)?.localeName ?? 'en'] ??
                  serviceList.translations?['en'] ??
                  '',
              style: GoogleFonts.openSans(
                color: _salonProfileProvider
                    .salonTheme.textTheme.displaySmall!.color,
                fontSize: 18,
                // fontFamily: 'Open Sans',
                fontWeight: FontWeight.w500,
                height: 0,
              ),
            ),
            Text(
              (serviceList.isPriceRange)
                  ? "${getCurrency(chosenSalon.countryCode!)}${serviceList.priceAndDuration!.price ?? '0'}-${getCurrency(chosenSalon.countryCode!)}${serviceList.priceAndDurationMax!.price ?? '0'}"
                  : (serviceList.isPriceStartAt)
                      ? "${getCurrency(chosenSalon.countryCode!)}${serviceList.priceAndDuration!.price ?? '0'}+"
                      : "${getCurrency(chosenSalon.countryCode!)}${serviceList.priceAndDuration!.price ?? '0'}",
              style: GoogleFonts.openSans(
                color: _salonProfileProvider
                    .salonTheme.textTheme.displaySmall!.color,
                fontSize: 18,
                // fontFamily: 'Open Sans',
                fontWeight: FontWeight.w500,
                height: 0,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TeamWidget extends ConsumerWidget {
  final MasterModel? masterModel;
  final int index;
  const TeamWidget({super.key, this.masterModel, required this.index});

  @override
  Widget build(BuildContext contex, ref) {
    final salonProfile = ref.watch(salonProfileProvider);
    return GestureDetector(
      onTap: () {
        salonProfile.changeShowMenu(true);
        salonProfile.getWidgetForDesktop("masters");
        salonProfile.changeCurrentIndex(index);
        salonProfile.changeSelectedMasterView(masterModel);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Center(
              child: (masterModel!.profilePicUrl != null &&
                      masterModel!.profilePicUrl != '')
                  ? CachedImage(
                      url: '${masterModel!.profilePicUrl}',
                      width: 381,
                      height: 400,
                      fit: BoxFit.fitWidth,
                    )
                  : Image.asset(
                      ThemeImages.noTeamMember,
                      width: 381,
                      height: 400,
                      fit: BoxFit.fitWidth,
                    ),
            ),
          ),
          const Gap(10),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 8.0),
            child: Text(
              '${masterModel?.personalInfo?.firstName} ${masterModel?.personalInfo?.lastName}'
                  .toUpperCase(),
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                color: salonProfile.salonTheme.colorScheme.secondary,
                // color:
                // const Color(0xFFE980B2),
                fontSize: 20,
                // fontFamily: 'Open Sans',
                fontWeight: FontWeight.w600,
                height: 0,
              ),
            ),
          ),
          if (masterModel?.title != null)
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 8.0),
              child: Text(
                '${masterModel?.title}',
                textAlign: TextAlign.center,
                style: GoogleFonts.openSans(
                  color: const Color(0xff868686),
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
  }
}

double getTotalRatings(List<ReviewModel> reviews) {
  ///values for the different ratings
  int oneStar = 33;
  int twoStar = 29;
  int threeStar = 40;
  int fourStar = 29;
  int fiveStar = 252;

//get total tyoes of ratings for salon
  int totalOneRating = 0;
  int totalTwoRating = 0;
  int totalThreeRating = 0;
  int totalFourRating = 0;
  int totalFiveRating = 0;

  for (var rev in reviews) {
    if (rev.rating == 1) {
      totalOneRating++;
    }
    if (rev.rating == 2) {
      totalTwoRating++;
    }
    if (rev.rating == 3) {
      totalThreeRating++;
    }
    if (rev.rating == 4) {
      totalFourRating++;
    }
    if (rev.rating == 5) {
      totalFiveRating++;
    }
  }

  //That's a weighted average, where you weigh each rating with the number of votes it got:

  double totalRatings = ((totalFiveRating * fiveStar +
          totalFourRating * fourStar +
          totalThreeRating * threeStar +
          totalTwoRating * twoStar +
          totalOneRating * oneStar) /
      (fiveStar + fourStar + threeStar + twoStar + oneStar));
  return totalRatings.toDouble();
}

class CityMuseDesktopReviews extends ConsumerWidget {
  const CityMuseDesktopReviews({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final _salonProfileProvider = ref.watch(salonProfileProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 100.0, right: 8.0),
          child: Text(
            (AppLocalizations.of(context)?.reviews ?? 'Reviews').toUpperCase(),
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
          padding: const EdgeInsets.only(left: 100.0, right: 8.0),
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
                  //   fontFamily: 'Onest',
                  fontWeight: FontWeight.w500,
                  height: 0,
                ),
              ),
              RatingBar.builder(
                initialRating: getTotalRatings(
                    _salonProfileProvider.salonReviews), // reviewStars ?? 5,
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
                        // color:
                        //Color(0xFFE980B2),
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
        Padding(
          padding: const EdgeInsets.only(left: 100.0, right: 18.0),
          child: SizedBox(
            height: 300,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: _salonProfileProvider.salonReviews.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 18.0),
                    child: Container(
                      width: 500,
                      height: 163,
                      padding: const EdgeInsets.all(20),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              width: 1,
                              color: _salonProfileProvider
                                  .salonTheme.colorScheme.secondary
                              //color: Color(0xFFE980B2)

                              ),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                _salonProfileProvider
                                    .salonReviews[index].customerName,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.openSans(
                                  color: _salonProfileProvider
                                      .salonTheme.colorScheme.secondary,
                                  // color: const Color(0xFFE980B2),
                                  fontSize: 20,
                                  //  fontFamily: 'Open Sans',
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
                                      decoration: ShapeDecoration(
                                        // color: Color(0xFFE980B2),
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
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              _salonProfileProvider.salonReviews[index].review,
                              style: GoogleFonts.openSans(
                                color: _salonProfileProvider
                                    .salonTheme.colorScheme.secondary,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ),
      ],
    );
  }
}

class AppBarMenu extends ConsumerWidget {
  final String? title;
  final Function()? action;
  const AppBarMenu({super.key, this.action, this.title});

  @override
  Widget build(BuildContext context, ref) {
    final theme = ref.watch(salonProfileProvider).salonTheme;
    return GestureDetector(
      onTap: action,
      child: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: Text(
          "$title",
          style: GoogleFonts.openSans(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: theme.appBarTheme.titleTextStyle!.color,
            height: 20 / 15,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class DesktopMastersView extends ConsumerStatefulWidget {
  const DesktopMastersView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DesktopMastersViewState();
}

class _DesktopMastersViewState extends ConsumerState<DesktopMastersView> {
  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(salonProfileProvider).salonTheme;
    final salonProvider = ref.watch(salonProfileProvider);
    return Padding(
      padding: const EdgeInsets.only(
        left: 18.0,
      ),
      child: SizedBox(
        // height: 1000,

        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(30),
              Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 80,
                            //MediaQuery.of(context).size.width / 6,
                            right: 80),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  salonProvider.changeShowMenu(false);
                                  // getWidget("menu");
                                });
                                setState(() {
                                  salonProvider.changeShowMenu(false);
                                });
                              },
                              child: SizedBox(
                                width: 500,
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                        'assets/test_assets/arrow_back.svg'),
                                    Text(
                                      ' Back to the main page',
                                      style: GoogleFonts.openSans(
                                        color: const Color(0xffb4b4b4),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const Gap(40),
                            Text(
                              '${salonProvider.selectedViewMasterModel?.personalInfo?.firstName} ${salonProvider.selectedViewMasterModel?.personalInfo?.lastName}',
                              style: GoogleFonts.openSans(
                                  color: theme.textTheme.displaySmall!.color,
                                  fontSize: 40),
                            ),
                            if (salonProvider.selectedViewMasterModel?.title !=
                                null)
                              Text(
                                '${salonProvider.selectedViewMasterModel?.title}',
                                style: GoogleFonts.openSans(
                                    color: const Color(0xff868686),
                                    fontSize: 20),
                              ),
                            const Gap(30),
                            const Gap(30),
                            SizedBox(
                              //width: 500,
                              child: Text(
                                '${salonProvider.selectedViewMasterModel?.personalInfo?.description}',
                                maxLines: 500,
                                textAlign: TextAlign.start,
                                style: GoogleFonts.openSans(
                                  letterSpacing: 1,
                                  height: 2,
                                  color: theme.textTheme.titleSmall!.color,
                                ),
                              ),
                            ),
                            const Gap(30),
                            SizedBox(
                              height: 50,
                              //width: 100,
                              child: SizedBox(
                                width: 500,
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                        'assets/test_assets/arrow_back.svg'),
                                    const Text(
                                      ' Previous specialist',
                                      style:
                                          TextStyle(color: Color(0xffb4b4b4)),
                                    ),
                                    const Spacer(),
                                    const Text(
                                      ' Next specialist',
                                      style:
                                          TextStyle(color: Color(0xffb4b4b4)),
                                    ),
                                    SvgPicture.asset(
                                        'assets/test_assets/arrow_forward.svg'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom:
                                        BorderSide(color: Color(0xff868686)),
                                    right: BorderSide(color: Color(0xff868686)),
                                    left:
                                        BorderSide(color: Color(0xff868686)))),
                            height: MediaQuery.of(context).size.height / 1.5,
                            child: Column(
                              children: [
                                Expanded(
                                    child: CachedImage(
                                  url:
                                      '${salonProvider.selectedViewMasterModel!.profilePicUrl}',
                                  width: MediaQuery.of(context).size.width / 2,
                                  fit: BoxFit.fitWidth,
                                )),
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
                      ],
                    ),
                  )
                ],
              ),
              const Gap(100),
              SizedBox(
                height: 100,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 80,
                      //MediaQuery.of(context).size.width / 6,
                      right: 80),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                            height: 1,
                            width: double.infinity,
                            color: const Color(0xFFB8B2A6)),
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(50),
              Padding(
                padding: const EdgeInsets.only(
                    left: 80,
                    //MediaQuery.of(context).size.width / 6,
                    right: 80),
                child: Row(
                  children: [
                    Text(
                      "Terms & Conditions",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff868686),
                        height: 24 / 14,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const Gap(70),
                    Text(
                      "Privacy Policy",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff868686),
                        height: 24 / 14,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const Spacer(),
                    Text(
                      "© 2023 Glamiris.",
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                        //fontWeight: FontWeight.wSymbol(figma.mixed),
                        height: 24 / 14,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const Gap(5),
                    Text(
                      "Powered by GlamIris",
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                        color: salonProvider.salonTheme.colorScheme.secondary,
                        // color: const Color(0xFFE980B2),

                        fontWeight: FontWeight.bold,
                        //fontWeight: FontWeight.wSymbol(figma.mixed),
                        height: 24 / 14,
                      ),
                      textAlign: TextAlign.left,
                    )
                  ],
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
