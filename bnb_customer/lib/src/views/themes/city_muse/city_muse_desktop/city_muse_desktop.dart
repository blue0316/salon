import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/views/themes/city_muse/city_muse_desktop/reviews.dart';
import 'package:bbblient/src/views/themes/city_muse/city_muse_desktop/service_tab.dart';
import 'package:bbblient/src/views/themes/city_muse/city_muse_desktop/teams_tile.dart';
import 'package:bbblient/src/views/themes/city_muse/city_muse_mobile/app_bar_menu.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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
import '../../../../models/salon_master/salon.dart';
import '../../../../utils/currency/currency.dart';
import '../../../../utils/icons.dart';
import '../../../../utils/utils.dart';
import '../../../salon/booking/dialog_flow/booking_dialog_2.dart';
import '../../../salon/widgets/additional featured.dart';
import '../../../widgets/image.dart';
import '../../../widgets/widgets.dart';
import '../../components/contacts/widgets/contact_maps.dart';
import '../../components/works/gentle_touch_works_view.dart';
import '../city_muse_mobile/contact_card.dart';
import '../city_muse_mobile/specialization_box.dart';
import '../utils.dart';
import 'features_check.dart';
import 'product_slider_indicator.dart';
import 'smaller_product_section.dart';

class GlamMinimalSalonWorks extends ConsumerStatefulWidget {
  final PhotosOfWorks photosOfWork;
  const GlamMinimalSalonWorks({super.key, required this.photosOfWork});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GlamMinimalSalonWorksState();
}

class _GlamMinimalSalonWorksState extends ConsumerState<GlamMinimalSalonWorks> {
  bool isHovered = false;

  void onEntered(bool isHovered) => setState(() {
        this.isHovered = isHovered;
      });
  @override
  Widget build(BuildContext context) {
    final _salonProfileProvider = ref.watch(salonProfileProvider);
    final size = MediaQuery.of(context).size;
    return MouseRegion(
      onEnter: (event) => setState(() {
        isHovered = true;
        _salonProfileProvider.changeHoveredPortfolio(true);
      }),
      onExit: (event) => setState(() {
        isHovered = false;
        _salonProfileProvider.changeHoveredPortfolio(false);
      }),
      // onEnter: (_) => _onEnter(
      //     chosenSalon.photosOfWorks!.indexOf(e)),
      // onExit: (_) {
      //   _onExit(chosenSalon.photosOfWorks!.indexOf(e));
      //   setState(() {
      //     isHovered = false;
      //   });
      // },
      child: Container(
        // width: 300,
        height: 358,

        //clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: CachedImage(
                url: widget.photosOfWork.image.toString(),
                width: 400,
                //size.width / 1.2,
                fit: BoxFit.fitWidth,
                // height: 296,
              ),
            ),
            if (isHovered && widget.photosOfWork.description!.isNotEmpty)
              const Gap(50),
            //Spacer(),
            if (isHovered && widget.photosOfWork.description!.isNotEmpty)
              Expanded(
                child: Visibility(
                  visible: isHovered,
                  child: Text(
                    widget.photosOfWork.description.toString(),
                    style: GoogleFonts.openSans(
                      color: _salonProfileProvider
                          .salonTheme.textTheme.displaySmall!.color,
                      fontSize: 14,
                      //  fontFamily: 'Onest',
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                      letterSpacing: 0.16,
                    ),
                  ),
                ),
              ),
          ],
        ),

        decoration: isHovered && widget.photosOfWork.description!.isNotEmpty
            ? const ShapeDecoration(
                //  color: Colors.white,
                //               _salonProfileProvider
                // .salonTheme.scaffoldBackgroundColor,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      width: 0.5, color: Color.fromARGB(255, 135, 66, 66)),
                ),
              )
            : null,
      ),
    );
  }
}

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

  bool isTabHovered = false;
  void onEntered(bool isHovered) => setState(() {
        this.isHovered = isHovered;
      });

  void onEnteredTab(bool isHovered) => setState(() {
        isTabHovered = isHovered;
      });

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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: null,
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
          // Padding(
          //   padding: const EdgeInsets.only(top:13.0),
          //   child: Text('about' ,style: TextStyle( color:Colors.black),),
          // ),
          // Text('about'),Text('about'),Text('about'),Text('about'),Text('about'),
          // Spacer(),
          // Container(
          //   child: Row(
          //     children: [

          if (chosenSalon.description.isNotEmpty &&
              displaySettings!.showAbout) ...[
            AppBarMenu(
              index: 0,
              title: AppLocalizations.of(context)?.aboutUs ?? 'About Us',
              action: () {
                Scrollable.ensureVisible(
                  controller.about.currentContext!,
                  duration: const Duration(seconds: 2),
                  curve: Curves.ease,
                );
              },
            ),
            const SizedBox(
              width: 40,
            ),
          ],
          if (chosenSalon.photosOfWorks != null &&
              chosenSalon.photosOfWorks!.isNotEmpty &&
              displaySettings!.showPhotosOfWork) ...[
            AppBarMenu(
              index: 1,
              title: AppLocalizations.of(context)?.portfolio ?? 'Portfolio',
              action: () {
                Scrollable.ensureVisible(
                  controller.works.currentContext!,
                  duration: const Duration(seconds: 2),
                  curve: Curves.ease,
                );
              },
            ),
            const SizedBox(
              width: 40,
            ),
          ],
          if (displaySettings!.services.showServices) ...[
            AppBarMenu(
              index: 2,
              title: AppLocalizations.of(context)?.services ?? 'Services',
              action: () {
                Scrollable.ensureVisible(
                  controller.price.currentContext!,
                  duration: const Duration(seconds: 2),
                  curve: Curves.ease,
                );
              },
            ),
            const SizedBox(
              width: 40,
            ),
          ],

          if (displaySettings.product.showProduct &&
              _salonProfileProvider.allProducts.isNotEmpty) ...[
            AppBarMenu(
              index: 3,
              title: AppLocalizations.of(context)?.products ?? 'Products',
              action: () {
                Scrollable.ensureVisible(
                  controller.shop.currentContext!,
                  duration: const Duration(seconds: 2),
                  curve: Curves.ease,
                );
              },
            ),
            const SizedBox(
              width: 40,
            ),
          ],
          if (displaySettings.showTeam &&
              _createAppointmentProvider.salonMasters.isNotEmpty) ...[
            AppBarMenu(
              index: 4,
              title: AppLocalizations.of(context)?.team ?? 'Team',
              action: () {
                Scrollable.ensureVisible(
                  controller.team.currentContext!,
                  duration: const Duration(seconds: 2),
                  curve: Curves.ease,
                );
              },
            ),
            const SizedBox(
              width: 40,
            ),
          ],

          if (_salonProfileProvider.salonReviews.isNotEmpty &&
              displaySettings.reviews.showReviews) ...[
            AppBarMenu(
              index: 5,
              title: AppLocalizations.of(context)?.reviews ?? 'Reviews',
              action: () {
                Scrollable.ensureVisible(
                  controller.reviews.currentContext!,
                  duration: const Duration(seconds: 2),
                  curve: Curves.ease,
                );
              },
            ),
            const SizedBox(
              width: 40,
            ),
          ],
          if (displaySettings.showContact) ...[
            AppBarMenu(
              index: 6,
              title: AppLocalizations.of(context)?.contacts ?? 'Contacts',
              action: () {
                Scrollable.ensureVisible(
                  controller.contacts.currentContext!,
                  duration: const Duration(seconds: 2),
                  curve: Curves.ease,
                );
              },
            ),
            const SizedBox(
              width: 40,
            ),
          ],
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
                  SizedBox.fromSize(size: Size.zero, key: controller.landing),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: height,
                          //color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Gap(150),
                              SizedBox(
                                // width: 537,
                                height: 150,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                    if (_salonProfileProvider
                                            .themeSettings!.showSignature! &&
                                        _salonProfileProvider.themeSettings!
                                                .themeSignature !=
                                            null)
                                      Expanded(
                                        child: Text(
                                          'by ${_salonProfileProvider.themeSettings!.themeSignature}',
                                          textAlign: TextAlign.right,
                                          style: GoogleFonts.ooohBaby(
                                            color: _salonProfileProvider
                                                .salonTheme
                                                .textTheme
                                                .displaySmall!
                                                .color,
                                            fontSize: screenSize.width * 0.02,
                                            //  fontFamily: 'Oooh Baby',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              const Gap(50),
                              if (chosenSalon.specializations != null &&
                                  chosenSalon.specializations!.isNotEmpty &&
                                  displaySettings.showSpecialization)
                                Padding(
                                  // padding: const EdgeInsets.only(
                                  //     left: 113.0, right: 30),
                                  padding: const EdgeInsets.only(
                                      left: 113.0, right: 20),
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
                                child: MouseRegion(
                                  onEnter: (event) => onEntered(true),
                                  onExit: (event) => onEntered(false),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 113.0, right: 12),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      // mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('BOOK NOW',
                                            style: GoogleFonts.openSans(
                                                color: isHovered
                                                    ? increaseBrightness(
                                                        _salonProfileProvider
                                                            .salonTheme
                                                            .colorScheme
                                                            .secondary,
                                                        10)
                                                    : _salonProfileProvider
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
                                          color: isHovered
                                              ? increaseBrightness(
                                                  _salonProfileProvider
                                                      .salonTheme
                                                      .colorScheme
                                                      .secondary,
                                                  10)
                                              : _salonProfileProvider.salonTheme
                                                  .colorScheme.secondary,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
                              child: Image.asset(AppIcons.cityMuseBackground,
                                  height: height, fit: BoxFit.cover)),
                    ],
                  ),
                  if (chosenSalon.additionalFeatures.isNotEmpty &&
                      displaySettings.showFeatures)
                    Container(
                        width: double.infinity,
                        height: chosenSalon.additionalFeatures.length * 30,
                        decoration: BoxDecoration(
                          color: blendColors(
                              _salonProfileProvider
                                  .salonTheme.colorScheme.secondary,
                              // const Color(0xffea80b2),
                              _salonProfileProvider
                                  .salonTheme.scaffoldBackgroundColor,
                              0.4),

                          // increaseBrightness(
                          // _salonProfileProvider
                          //     .salonTheme.colorScheme.secondary,
                          //     40)
                        ),
                        child: Column(
                          children: [
                            const Gap(40),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 100.0, right: 30),
                                child: GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisSpacing: 5,
                                    mainAxisExtent: 30,
                                    mainAxisSpacing: 30,
                                    crossAxisCount: 3, // Number of columns
                                  ),
                                  itemCount:
                                      //15,
                                      chosenSalon.additionalFeatures.length,
                                  itemBuilder: (context, index) {
                                    return
                                        //const Text('helloooooooooo');
                                        DesktopFeaturesCheck(
                                            title: getFeature(
                                                chosenSalon
                                                    .additionalFeatures[index],
                                                chosenSalon.locale));
                                  },
                                ),
                              ),
                            ),
                          ],
                        )),
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
                            fit: BoxFit.fitHeight,
                            height: 616,
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
                      text: ' .  ${chosenSalon.salonName.toTitleCase()} ',
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
                      padding: const EdgeInsets.only(left: 100.0, right: 100.0),
                      child: StaggeredGrid.count(
                        crossAxisCount: 5,
                        mainAxisSpacing: 6,
                        crossAxisSpacing: 4,
                        children: [
                          if (chosenSalon.photosOfWorks!.isNotEmpty)
                            StaggeredGridTile.count(
                              crossAxisCellCount: 1,
                              mainAxisCellCount: 1,
                              child: Tile(
                                index: 1,
                                image: chosenSalon.photosOfWorks![0].image!,
                                description:
                                    chosenSalon.photosOfWorks![0].description ??
                                        '',
                              ),
                            ),
                          if (chosenSalon.photosOfWorks!.length >= 2)
                            StaggeredGridTile.count(
                              crossAxisCellCount: 1,
                              mainAxisCellCount: 1,
                              child: Tile(
                                index: 2,
                                image: chosenSalon.photosOfWorks![1].image!,
                                description:
                                    chosenSalon.photosOfWorks![1].description ??
                                        '',
                              ),
                            ),
                          if (chosenSalon.photosOfWorks!.length >= 3)
                            StaggeredGridTile.count(
                              crossAxisCellCount: 2,
                              mainAxisCellCount: 1.25,
                              child: Tile(
                                index: 4,
                                image: chosenSalon.photosOfWorks![2].image!,
                                description:
                                    chosenSalon.photosOfWorks![2].description ??
                                        '',
                              ),
                            ),
                          if (chosenSalon.photosOfWorks!.length >= 4)
                            StaggeredGridTile.count(
                              crossAxisCellCount: 2,
                              mainAxisCellCount: 1.5,
                              child: Tile(
                                index: 3,
                                image: chosenSalon.photosOfWorks![3].image!,
                                description:
                                    chosenSalon.photosOfWorks![3].description ??
                                        '',
                              ),
                            ),
                          if (chosenSalon.photosOfWorks!.length >= 5)
                            StaggeredGridTile.count(
                              crossAxisCellCount: 1,
                              mainAxisCellCount: 2.5,
                              child: Tile(
                                index: 6,
                                image: chosenSalon.photosOfWorks![4].image!,
                                description:
                                    chosenSalon.photosOfWorks![4].description ??
                                        '',
                              ),
                            ),
                          if (chosenSalon.photosOfWorks!.length > 5)
                            StaggeredGridTile.count(
                              crossAxisCellCount: 2,
                              mainAxisCellCount: 1.25,
                              child: Tile(
                                index: 5,
                                image: chosenSalon.photosOfWorks![5].image!,
                                description:
                                    chosenSalon.photosOfWorks![5].description ??
                                        '',
                              ),
                            ),
                        ],
                      ),
                      // StaggeredGridView.countBuilder(
                      //   shrinkWrap: true,
                      //   crossAxisCount: 4,
                      //   itemCount: chosenSalon.photosOfWorks!.length,
                      //   itemBuilder: (BuildContext context, int index) =>
                      //       GlamMinimalSalonWorks(
                      //     photosOfWork: chosenSalon.photosOfWorks![index],
                      //   ),

                      //   // Card(
                      //   //   shape: RoundedRectangleBorder(
                      //   //       borderRadius: BorderRadius.circular(15)),
                      //   //   color: Colors.yellow,
                      //   //   child: Stack(
                      //   //     children: const <Widget>[],
                      //   //   ),
                      //   // ),
                      //   staggeredTileBuilder: (int index) => StaggeredTile.count(
                      //       1,
                      //       index.isEven
                      //           ? 1.7
                      //           :
                      //           //_salonProfileProvider.isPortfolioHovered?1.2:
                      //           1.4),
                      //   mainAxisSpacing: 2.0,
                      //   crossAxisSpacing: 4.0,
                      // ),

//                       GridView.custom(
//                         shrinkWrap: true,
//                         gridDelegate: SliverQuiltedGridDelegate(
//     crossAxisCount: 4,
//     mainAxisSpacing: 1,
//     crossAxisSpacing: 1,
//     repeatPattern: QuiltedGridRepeatPattern.inverted,
//     pattern: [
//       QuiltedGridTile(2, 1),
//       QuiltedGridTile(1, 1),
//       QuiltedGridTile(1, 1),
//       QuiltedGridTile(1, 1),
//     ],
//   ),
// //  gridDelegate: SliverWovenGridDelegate.count(

// //     crossAxisCount: 4,
// //     mainAxisSpacing: 1,
// //     crossAxisSpacing: 1,
// //     pattern: [
// //      // WovenGridTile(1),
// //       WovenGridTile(
// //         5 / 7,
// //         crossAxisRatio: 0.9,
// //         alignment: AlignmentDirectional.centerEnd,
// //       ),
// //     ],
// //   ),
//   childrenDelegate: SliverChildBuilderDelegate(
//     childCount:  chosenSalon.photosOfWorks!.length,
//     (context, index) => GlamMinimalSalonWorks(
//                                 photosOfWork:  chosenSalon.photosOfWorks![index],
//                               ),
//   ),
// ),
                      //  StaggeredGrid.count(
                      //  // axisDirection: AxisDirection.right,
                      //     crossAxisCount: 4,
                      //     mainAxisSpacing: 4,
                      //     crossAxisSpacing: 1,
                      //     children: chosenSalon.photosOfWorks!.map((e) {
                      //       // bool isHovered =
                      //       //     chosenSalon.photosOfWorks!.indexOf(e) ==
                      //       //         hoveredIndex;

                      //       return StaggeredGridTile.count(
                      //         crossAxisCellCount: 1,
                      //         mainAxisCellCount: 1.1,
                      //         child: GlamMinimalSalonWorks(
                      //           photosOfWork: e,
                      //         ),
                      //       );
                      //       // return GlamMinimalSalonWorks(
                      //       //   photosOfWork: e,
                      //       // );
                      //     }).toList()),
                      // [
                      // StaggeredGridTile.count(
                      //   crossAxisCellCount: 2,
                      //   mainAxisCellCount: 2,
                      //   child: Tile(index: 0),
                      // ),
                      //   StaggeredGridTile.count(
                      //     crossAxisCellCount: 2,
                      //     mainAxisCellCount: 1,
                      //     child: Tile(index: 1),
                      //   ),
                      //   StaggeredGridTile.count(
                      //     crossAxisCellCount: 1,
                      //     mainAxisCellCount: 1,
                      //     child: Tile(index: 2),
                      //   ),
                      //   StaggeredGridTile.count(
                      //     crossAxisCellCount: 1,
                      //     mainAxisCellCount: 1,
                      //     child: Tile(index: 3),
                      //   ),
                      //   StaggeredGridTile.count(
                      //     crossAxisCellCount: 4,
                      //     mainAxisCellCount: 2,
                      //     child: Tile(index: 4),
                      //   ),
                      // ],
                    ),

                    // Wrap(
                    //     //verticalDirection: VerticalDirection.up,
                    //     alignment: WrapAlignment.start,
                    //     runSpacing: 7,
                    //     spacing: 10,
                    //     children: chosenSalon.photosOfWorks!.map((e) {
                    //       // bool isHovered =
                    //       //     chosenSalon.photosOfWorks!.indexOf(e) ==
                    //       //         hoveredIndex;
                    // return GlamMinimalSalonWorks(
                    //   photosOfWork: e,
                    // );
                    //     }).toList()),
                    // ),
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
                              bool isHovered2 = index == hoveredIndex;

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _currentIndex = index;
                                    selectedCatId = catList[index].categoryId;

                                    _pageController.animateToPage(
                                      index,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.ease,
                                    );
                                  });
                                },
                                child: MouseRegion(
                                  //  onEnter: (event) => setState(() {
                                  //   isTabHovered = true;
                                  // }),
                                  // onExit: (event) => setState(() {
                                  //   isTabHovered = false;
                                  // }),
                                  onEnter: (_) => _onEnter(index),
                                  onExit: (_) => _onExit(index),
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
                                            color: _currentIndex == index
                                                ? _salonProfileProvider
                                                    .salonTheme
                                                    .colorScheme
                                                    .secondary
                                                : isHovered2
                                                    ? _salonProfileProvider
                                                        .salonTheme
                                                        .colorScheme
                                                        .secondary
                                                    : _salonProfileProvider
                                                        .salonTheme
                                                        .textTheme
                                                        .bodyMedium!
                                                        .color,
                                            fontSize: 16,
                                            fontWeight: _currentIndex == index
                                                ? FontWeight.w600
                                                : null

                                            // _currentIndex == index
                                            //     ? Colors.white
                                            //     : Colors.black, // Change the text color
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
                    const Gap(50),
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
                                              index: index,
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
                                                  index: index,
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
                        child: MouseRegion(
                          onEnter: (event) => onEntered(true),
                          onExit: (event) => onEntered(false),
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
                                          color: isHovered
                                              ? increaseBrightness(
                                                  _salonProfileProvider
                                                      .salonTheme
                                                      .colorScheme
                                                      .secondary,
                                                  10)
                                              : _salonProfileProvider.salonTheme
                                                  .colorScheme.secondary,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700)),
                                  const Gap(10),
                                  Image.asset(
                                    'assets/test_assets/book_arrow.png',
                                    height: 24,
                                    width: 24,
                                    color: isHovered
                                        ? increaseBrightness(
                                            _salonProfileProvider.salonTheme
                                                .colorScheme.secondary,
                                            10)
                                        : _salonProfileProvider
                                            .salonTheme.colorScheme.secondary,
                                  ),
                                ],
                              ),
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
                    const Gap(50),
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
                            bool isHovered2 = index == hoveredIndex;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _currentProductIndex = index;
                                  selectedCatId = catList[index].categoryId;

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
                                child: MouseRegion(
                                  onEnter: (_) => _onEnter(index),
                                  onExit: (_) => _onExit(index),
                                  child: Center(
                                    child: Text(
                                      '${catList[index].translations![AppLocalizations.of(context)?.localeName ?? 'en'] ?? catList[index].translations!['en']}'
                                          .toTitleCase(),
                                      style: GoogleFonts.openSans(
                                          color: _currentProductIndex == index
                                              ? _salonProfileProvider.salonTheme
                                                  .colorScheme.secondary
                                              : isHovered2
                                                  ? _salonProfileProvider
                                                      .salonTheme
                                                      .colorScheme
                                                      .secondary
                                                  : _salonProfileProvider
                                                      .salonTheme
                                                      .textTheme
                                                      .bodyMedium!
                                                      .color,
                                          fontSize: 16,
                                          fontWeight:
                                              _currentProductIndex == index
                                                  ? FontWeight.w600
                                                  : null
                                          // _currentIndex == index
                                          //     ? Colors.white
                                          //     : Colors.black, // Change the text color
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
                                      const Gap(20),
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
                                                color: const Color(0xFF868686),
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
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 38.0),
                                        child: SizedBox(
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
                                                                  .allProducts[
                                                              index];
                                                      _selectedProductIndex =
                                                          index;
                                                    });
                                                    setState(() {});
                                                  },
                                                  child: CityMuseDesktopSmallerProductWidget(
                                                      salonProfileProvider:
                                                          _salonProfileProvider,
                                                      product:
                                                          _salonProfileProvider
                                                                  .allProducts[
                                                              index],
                                                      index: index,
                                                      chosenSalon: chosenSalon),
                                                );
                                              }),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20.0),
                                        child: ProductSliderIndicator(
                                          selectedProductIndex:
                                              _selectedProductIndex,
                                          salonProfileProvider:
                                              _salonProfileProvider,
                                          length: _salonProfileProvider
                                              .allProducts.length
                                              .toDouble(),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 38.0),
                                        child: SizedBox(
                                            width: double.infinity,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    selectedProduct!
                                                            .productDescription ??
                                                        ''.toCapitalized(),
                                                    softWrap: true,
                                                    style: GoogleFonts.openSans(
                                                      fontSize: 15,
                                                      color: _salonProfileProvider
                                                          .salonTheme
                                                          .textTheme
                                                          .titleSmall!
                                                          .color, //height:1.5
                                                    )),
                                                const Gap(40),
                                                GestureDetector(
                                                  onTap: () {
                                                    const BookingDialogWidget222()
                                                        .show(context);
                                                  },
                                                  child: MouseRegion(
                                                    onEnter: (event) =>
                                                        onEntered(true),
                                                    onExit: (event) =>
                                                        onEntered(false),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 38.0),
                                                      child: Row(
                                                        children: [
                                                          Text('BOOK NOW',
                                                              style: GoogleFonts.openSans(
                                                                  color: isHovered
                                                                      ? increaseBrightness(
                                                                          _salonProfileProvider
                                                                              .salonTheme
                                                                              .colorScheme
                                                                              .secondary,
                                                                          10)
                                                                      : _salonProfileProvider
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
                                                            color: isHovered
                                                                ? increaseBrightness(
                                                                    _salonProfileProvider
                                                                        .salonTheme
                                                                        .colorScheme
                                                                        .secondary,
                                                                    10)
                                                                : _salonProfileProvider
                                                                    .salonTheme
                                                                    .colorScheme
                                                                    .secondary,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
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
                                      const Gap(20),
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
                                                color: const Color(0xFF868686),
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
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 38.0),
                                        child: SizedBox(
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
                                                  child: CityMuseDesktopSmallerProductWidget(
                                                      salonProfileProvider:
                                                          _salonProfileProvider,
                                                      product: _salonProfileProvider
                                                                  .tabs[
                                                              currentSelectedEntry]![
                                                          index],
                                                      index: index,
                                                      chosenSalon: chosenSalon),
                                                );
                                              }),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20.0),
                                        child: ProductSliderIndicator(
                                          selectedProductIndex:
                                              _selectedProductIndex,
                                          salonProfileProvider:
                                              _salonProfileProvider,
                                          length: _salonProfileProvider
                                              .tabs[currentSelectedEntry]!
                                              .length
                                              .toDouble(),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 38.0),
                                        child: SizedBox(
                                            width: double.infinity,
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
                                      GestureDetector(
                                        onTap: () {
                                          const BookingDialogWidget222()
                                              .show(context);
                                        },
                                        child: MouseRegion(
                                          onEnter: (event) => onEntered(true),
                                          onExit: (event) => onEntered(false),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 38.0),
                                            child: Row(
                                              children: [
                                                Text('BOOK NOW',
                                                    style: GoogleFonts.openSans(
                                                        color: isHovered
                                                            ? increaseBrightness(
                                                                _salonProfileProvider
                                                                    .salonTheme
                                                                    .colorScheme
                                                                    .secondary,
                                                                10)
                                                            : _salonProfileProvider
                                                                .salonTheme
                                                                .colorScheme
                                                                .secondary,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w700)),
                                                const Gap(10),
                                                Image.asset(
                                                  'assets/test_assets/book_arrow.png',
                                                  height: 24,
                                                  width: 24,
                                                  color: isHovered
                                                      ? increaseBrightness(
                                                          _salonProfileProvider
                                                              .salonTheme
                                                              .colorScheme
                                                              .secondary,
                                                          10)
                                                      : _salonProfileProvider
                                                          .salonTheme
                                                          .colorScheme
                                                          .secondary,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
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
                    const Gap(60),
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
                            return MouseRegion(
                              onEnter: (event) => _salonProfileProvider
                                  .onEnterTeamMember(index),
                              onExit: (event) =>
                                  _salonProfileProvider.onExitTeamMember(index),
                              child: TeamWidget(
                                  masterModel: _createAppointmentProvider
                                      .salonMasters[index],
                                  index: index),
                            );
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
                  //REVIEWS

                  if (_salonProfileProvider.salonReviews.isNotEmpty &&
                      displaySettings.reviews.showReviews) ...[
                    SizedBox.fromSize(size: Size.zero, key: controller.reviews),
                    const CityMuseDesktopReviews(),
                  ],
                  //CONTACT US
                  const Gap(70),
                  if (displaySettings.showRequestForm) ...[
                    SizedBox.fromSize(
                        size: Size.zero, key: controller.writeToUs),
                    Padding(
                      padding: const EdgeInsets.only(left: 100.0, right: 18.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'WRITE TO US',
                                  style: GoogleFonts.openSans(
                                    color: _salonProfileProvider.salonTheme
                                        .textTheme.displaySmall!.color,
                                    fontSize: 60,
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                ),
                                const Gap(20),
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
                                              decoration: textFieldStyle(
                                                  "First Name",
                                                  _salonProfileProvider),
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
                                              decoration: textFieldStyle(
                                                  "Last Name",
                                                  _salonProfileProvider),
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
                                              decoration: textFieldStyle(
                                                  "glamiris@gmail.com",
                                                  _salonProfileProvider),
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
                                              decoration: textFieldStyle(
                                                  "Phone",
                                                  _salonProfileProvider),
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
                                      controller: _salonProfileProvider
                                          .requestController,
                                      decoration: textFieldStyle(
                                          "Write to Us", _salonProfileProvider),
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
                                      : MouseRegion(
                                          onEnter: (event) => onEntered(true),
                                          onExit: (event) => onEntered(false),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0, right: 18.0),
                                            child: Container(
                                              width: 550,
                                              height: 50,
                                              // padding:
                                              // const EdgeInsets.symmetric(
                                              //     horizontal: 40,
                                              //     vertical: 13),
                                              decoration: ShapeDecoration(
                                                color: isHovered
                                                    ? increaseBrightness(
                                                        _salonProfileProvider
                                                            .salonTheme
                                                            .colorScheme
                                                            .secondary,
                                                        10)
                                                    : _salonProfileProvider
                                                        .salonTheme
                                                        .colorScheme
                                                        .secondary,
                                                // color: const Color(0xFFE980B2),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2)),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
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
                                          ),
                                        ),
                                ),
                              ],
                            ),
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
                                  child: Padding(
                                  padding: const EdgeInsets.only(right: 100.0),
                                  child: Image.asset(
                                      AppIcons.cityMuseBackground,
                                      width: screenSize.width * 0.3,
                                      height: screenSize.width * 0.4,
                                      fit: BoxFit.cover),
                                )),
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
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 100.0,
                            ),
                            child: SizedBox(
                              height: screenSize.width * 0.35,
                              width: screenSize.width * 0.1,
                              child: GoogleMaps(
                                salonModel: chosenSalon,
                              ),
                            ),
                          ),
                        ),
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
                                    left: 80.0, right: 5.0),
                                child: Row(
                                  children: [
                                    CityMuseContactCard(
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
                                      CityMuseContactCard(
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
                              const Gap(10),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 80.0, right: 5.0),
                                child: Row(
                                  children: [
                                    CityMuseContactCard(
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
                                    CityMuseContactCard(
                                      width: screenSize.width * 0.17,
                                      titleFontSize: screenSize.width * 0.009,
                                      descriptionFontSize:
                                          screenSize.width * 0.008,
                                      infoFontSize: screenSize.width * 0.008,
                                      contactTitle: 'Social Media',
                                      contactAsset: 'social_media.svg',
                                      contactDescription:
                                          'Discover more on social',
                                      contactInfo: '',
                                      contactAssetList: true,
                                      // contactAssetList:  [
                                      //   if (chosenSalon.links?.instagram != '' &&chosenSalon.links?.instagram != null)
                                      //   'instagram.svg',
                                      //   'tiktok.svg',
                                      //   'facebook.svg'
                                      // ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),

                        /// Spacer(),
                        //    const Gap(70),

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
                        color: const Color(0xff41403c)),
                  ),
                  const Gap(20),
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
                          child: Text(
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
                          ),
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

Color increaseBrightness(Color color, double percent) {
  final hslColor = HSLColor.fromColor(color);
  final newLightness = (hslColor.lightness + (percent / 100)).clamp(0.0, 1.0);
  final newColor = hslColor.withLightness(newLightness);
  return newColor.toColor();
}

Color blendColors(Color color1, Color color2, double opacity) {
  int red = (color1.red + (color2.red - color1.red) * opacity).round();
  int green = (color1.green + (color2.green - color1.green) * opacity).round();
  int blue = (color1.blue + (color2.blue - color1.blue) * opacity).round();

  // Color? combinedColor = Color.lerp(color1, color2, 0.09);
  return
      //combinedColor!;
      Color.fromARGB(255, red, green, blue);
}
