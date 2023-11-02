import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/views/themes/city_muse/city_muse_desktop/city_muse_desktop.dart';
import 'package:bbblient/src/views/themes/city_muse/city_muse_mobile/products.dart';
import 'package:bbblient/src/views/themes/city_muse/city_muse_mobile/service_widget.dart';
import 'package:bbblient/src/views/themes/city_muse/city_muse_mobile/specialization_box.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
import '../../../../models/salon_master/salon.dart';
import '../../../../utils/country_code/country.dart';
import '../../../../utils/country_code/json/country_codes.dart';
import '../../../../utils/icons.dart';
import '../../../../utils/utils.dart';
import '../../../salon/booking/dialog_flow/booking_dialog_2.dart';
import '../../../salon/widgets/additional featured.dart';
import '../../../widgets/image.dart';
import '../../../widgets/widgets.dart';
import '../../components/contacts/widgets/contact_maps.dart';
import '../../images.dart';
import '../../utils/theme_type.dart';
import '../utils.dart';
import 'contact_card.dart';
import 'features_check.dart';

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

  bool showPicker = false;
  FocusNode focusNode = FocusNode();
  List<Country> countries =
      countryCodes.map((country) => Country.from(json: country)).toList();
  int selectedIndex = 0;

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
            : SizedBox(
                width: 40,
                child: CircleAvatar(
                  radius: 15,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: CachedImage(
                      width: 100,
                      url: chosenSalon.salonLogo,
                      fit: BoxFit.contain,
                    ),
                  ),
                )),
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
      floatingActionButton: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            Scrollable.ensureVisible(
              controller.landing.currentContext!,
              duration: const Duration(seconds: 2),
              curve: Curves.ease,
            );
          },
          child: Container(
            height: 60.h,
            width: 60.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0XFFC1C1C1), width: 1.2),
            ),
            child: Icon(
              Icons.keyboard_arrow_up_rounded,
              size: 30.h,
              color: const Color(0XFFC1C1C1),
            ),
          ),
        ),
      ),
      body: _salonProfileProvider.isShowMenuMobile
          ? Container(
              width: double.infinity,
              color: _salonProfileProvider.salonTheme.scaffoldBackgroundColor,
              child: _salonProfileProvider.currentWidget)
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(50),
                  SizedBox.fromSize(size: Size.zero, key: controller.landing),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 2),
                    child: SizedBox(
                      //   width: 409,
                      height:
                          _salonProfileProvider.themeSettings!.showSignature! &&
                                  _salonProfileProvider
                                          .themeSettings!.themeSignature !=
                                      null
                              ? 200
                              : 70,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              chosenSalon.salonName.toTitleCase(),
                              textAlign: TextAlign.start,
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
                          if (_salonProfileProvider
                                  .themeSettings!.showSignature! &&
                              _salonProfileProvider
                                      .themeSettings!.themeSignature !=
                                  null)
                            Expanded(
                              child: Text(
                                'by ${_salonProfileProvider.themeSettings!.themeSignature}',
                                textAlign: TextAlign.right,
                                style: GoogleFonts.ooohBaby(
                                  color: _salonProfileProvider
                                      .salonTheme.textTheme.displaySmall!.color,
                                  fontSize: 30,
                                  //  fontFamily: 'Oooh Baby',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
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
                  BookNowButton(salonProfileProvider: _salonProfileProvider),
                  const Gap(18),
                  (_salonProfileProvider.themeSettings?.backgroundImage !=
                              null &&
                          _salonProfileProvider
                                  .themeSettings?.backgroundImage !=
                              '')
                      ? CachedImage(
                          url: _salonProfileProvider
                              .themeSettings!.backgroundImage!,
                          width: size.width,
                          fit: BoxFit.fitWidth,
                        )
                      : Image.asset(
                          AppIcons.cityMuseBackground,
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
                          chosenSalon.locale,
                        ),
                        index: index,
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
                        _createAppointmentProvider.salonMasters.length > 1
                            ? 'WHO ARE WE?'
                            : 'WHO AM I?',
                        textAlign: TextAlign.start,
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
                          textAlign: TextAlign.left,
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
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20),
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

                  const Gap(20),
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
                        textAlign: TextAlign.start,
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
                              border:
                                  Border.all(color: const Color(0xFF282828))),
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
                            itemBuilder: (BuildContext context, int index,
                                int realIndex) {
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
                                                color: _salonProfileProvider
                                                    .salonTheme
                                                    .textTheme
                                                    .displaySmall!
                                                    .color,
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
                        textAlign: TextAlign.start,
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
                                                .salonTheme
                                                .colorScheme
                                                .secondary,
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
                                      color: _currentServiceIndex == index
                                          ? _salonProfileProvider
                                              .salonTheme.colorScheme.secondary
                                          : _salonProfileProvider.salonTheme
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
                                in _createAppointmentProvider
                                    .servicesAvailable) {
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
                              }
                            }
                          }
                          return const SizedBox();
                        }),
                      ),
                    ),
                    const Gap(40),
                    //const Gap(48),
                    BookNowButton(salonProfileProvider: _salonProfileProvider),
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
                        textAlign: TextAlign.start,
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
                                                .salonTheme
                                                .colorScheme
                                                .secondary,
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
                                      color: _currentProductIndex == index
                                          ? _salonProfileProvider
                                              .salonTheme.colorScheme.secondary
                                          : _salonProfileProvider.salonTheme
                                              .textTheme.bodyMedium!.color,
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
                              itemCount:
                                  _salonProfileProvider.allProducts.length,
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
                                    itemCount: _salonProfileProvider
                                        .allProducts.length),
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
                        textAlign: TextAlign.start,
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
                              _salonProfileProvider
                                  .getWidgetForMobile('masters');

                              _salonProfileProvider.changeSelectedMasterView(
                                  _createAppointmentProvider
                                      .salonMasters[index]);
                              _salonProfileProvider.changeCurrentIndex(index);
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
                                              ThemeType.CityMuseLight
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
                                    "assets/test_assets/arrow_side.svg",
                                    color: _salonProfileProvider
                                        .salonTheme.colorScheme.secondary,
                                  ),
                                ],
                              ),
                              if (_createAppointmentProvider
                                      .salonMasters[index].title !=
                                  null) ...[
                                const Gap(10),
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
                              ]
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
                        textAlign: TextAlign.start,
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
                          padding:
                              const EdgeInsets.only(left: 18.0, right: 18.0),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                              decoration: ShapeDecoration(
                                                color: _salonProfileProvider
                                                    .salonTheme
                                                    .colorScheme
                                                    .secondary,
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
                            itemCount:
                                _salonProfileProvider.salonReviews.length),
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
                        textAlign: TextAlign.start,
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
                        style: GoogleFonts.openSans(
                          color: _salonProfileProvider
                              .salonTheme.textTheme.displaySmall!.color,
                        ),
                        controller: _salonProfileProvider.nameController,
                        decoration:
                            textFieldStyle("Full Name", _salonProfileProvider),
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
                      child: SizedBox(
                          height: 50,
                          // width: 250,
                          child: Focus(
                            onFocusChange: ((value) {
                              if (value) {
                                if (showPicker) {
                                  setState(() {
                                    showPicker = false;
                                  });
                                }
                              }
                              print("focus value");
                              print(value);
                            }),
                            child: TextField(
                              controller: _salonProfileProvider.phoneController,
                              decoration: InputDecoration(
                                  prefixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (!showPicker) {
                                          FocusScope.of(context).unfocus();
                                        }
                                        showPicker = !showPicker;
                                      });

                                      print(showPicker);
                                    },
                                    child: SizedBox(
                                      // height: 170,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10.0, left: 5.0),
                                        child: Text(
                                          "+" +
                                              _salonProfileProvider
                                                  .selectedCountry.phoneCode,
                                          style: _salonProfileProvider
                                              .salonTheme
                                              .textTheme
                                              .displayLarge,
                                        ),
                                      ),
                                    ),
                                  ),
                                  hintText: 'Phone',
                                  filled: _salonProfileProvider
                                      .salonTheme.inputDecorationTheme.filled,
                                  fillColor: _salonProfileProvider.salonTheme
                                      .inputDecorationTheme.fillColor,
                                  border: _salonProfileProvider
                                      .salonTheme.inputDecorationTheme.border,
                                  enabledBorder: _salonProfileProvider
                                      .salonTheme
                                      .inputDecorationTheme
                                      .enabledBorder,
                                  focusedBorder: _salonProfileProvider
                                      .salonTheme
                                      .inputDecorationTheme
                                      .focusedBorder),
                            ),
                          )),

                      // TextField(
                      //   style: GoogleFonts.openSans(
                      //     color: _salonProfileProvider
                      //         .salonTheme.textTheme.displaySmall!.color,
                      //   ),
                      //   controller: _salonProfileProvider.phoneController,
                      //   decoration:
                      //       textFieldStyle("Phone", _salonProfileProvider),
                      // ),
                    ),
                  ),
                  if (showPicker)
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                      child: SizedBox(
                        height: 350.h,
                        width: 250,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: countries.length,
                          itemBuilder: (context, index) {
                            Country country = countries[index];
                            return CountryCodeCard(
                              country: country,
                              selected: selectedIndex == index ? true : false,
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                  _salonProfileProvider.selectedCountry =
                                      country;
                                  showPicker = !showPicker;
                                });
                              },
                            );
                          },
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
                        style: GoogleFonts.openSans(
                          color: _salonProfileProvider
                              .salonTheme.textTheme.displaySmall!.color,
                        ),
                        controller: _salonProfileProvider.emailController,
                        decoration:
                            textFieldStyle("Email", _salonProfileProvider),
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
                        style: GoogleFonts.openSans(
                          color: _salonProfileProvider
                              .salonTheme.textTheme.displaySmall!.color,
                        ),
                        controller: _salonProfileProvider.requestController,
                        // maxLength: 0,
                        // minLines: 0,
                        maxLines: 10,
                        decoration: textFieldStyle(
                            "Write to Us", _salonProfileProvider),
                      ),
                    ),
                  ),
                  const Gap(40),
                  GestureDetector(
                    onTap: () {
                      _salonProfileProvider.sendEnquiryToSalonCityMuse(context,
                          salonId: chosenSalon.salonId);
                    },
                    child: _salonProfileProvider.enquiryStatus == Status.loading
                        ? Center(
                            child: SizedBox(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(
                                  color: _salonProfileProvider
                                      .salonTheme.colorScheme.secondary),
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
                                    horizontal: 30, vertical: 4),
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
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'SEND MESSAGE',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.openSans(
                                              color: Colors.white,
                                              fontSize: 16,
                                              //  fontFamily: 'Open Sans',
                                              fontWeight: FontWeight.w700,
                                              height: 0,
                                            ),
                                          ),
                                          const Gap(20),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 5.0),
                                            child: SvgPicture.asset(
                                              'assets/test_assets/arrow_side.svg',
                                              color: Colors.white,
                                            ),
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
                    SizedBox.fromSize(
                        size: Size.zero, key: controller.contacts),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                      child: Text(
                        (AppLocalizations.of(context)?.contacts ?? 'Contacts')
                            .toUpperCase(),
                        textAlign: TextAlign.start,
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
                    CityMuseContactCard(
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
                      CityMuseContactCard(
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
                    CityMuseContactCard(
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
                    const CityMuseContactCard(
                      contactTitle: 'Social Media',
                      contactAsset: 'social_media.svg',
                      contactDescription: 'Discover more on social',
                      contactInfo: '',
                      contactAssetList: true,
                      // contactAssetList: [
                      //   'instagram.svg',
                      //   'tiktok.svg',
                      //   'facebook.svg'
                      // ],
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
                  GestureDetector(
                    onTap: () async {
                      Uri uri = Uri.parse('https://glmrs.space/home');

                      // debugPrint("launching Url: $uri");

                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri);
                      } else {
                        showToast("Unable to launch Glamiris website");
                      }
                    },
                    child: Center(
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
                  ),
                  const Gap(30),
                ],
              ),
            ),
    );
  }
}

class BookNowButton extends StatelessWidget {
  const BookNowButton({
    super.key,
    required SalonProfileProvider salonProfileProvider,
  }) : _salonProfileProvider = salonProfileProvider;

  final SalonProfileProvider _salonProfileProvider;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        const BookingDialogWidget222().show(context);
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 12),
        child: Row(
          children: [
            Text('BOOK NOW',
                style: GoogleFonts.openSans(
                    color:
                        _salonProfileProvider.salonTheme.colorScheme.secondary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700)),
            const Gap(10),
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                  _salonProfileProvider.salonTheme.colorScheme.secondary,
                  BlendMode.src),
              child: Image.asset(
                'assets/test_assets/book_arrow.png',
                height: 24,
                width: 24,
                // color: _salonProfileProvider
                //     .salonTheme.colorScheme.secondary,
              ),
            ),
          ],
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
