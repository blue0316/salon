import 'package:bbblient/src/controller/create_apntmnt_provider/create_appointment_provider.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/extracted/expansion_tile.dart';
import 'package:bbblient/src/models/cat_sub_service/services_model.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/views/salon/default_profile_view/salon_reviews.dart';
import 'package:bbblient/src/views/salon/default_profile_view/widgets/service_tile.dart';
import 'package:bbblient/src/views/themes/components/widgets/image_preview.dart';
import 'package:bbblient/src/views/themes/images.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'widgets/about.dart';

class SalonMasterView extends ConsumerStatefulWidget {
  const SalonMasterView({Key? key}) : super(key: key);

  @override
  ConsumerState<SalonMasterView> createState() => _SalonMasterViewState();
}

class _SalonMasterViewState extends ConsumerState<SalonMasterView> {
  final ScrollController _listViewController = ScrollController();
  late SalonProfileProvider _salonProfileProvider;
  late CreateAppointmentProvider _createAppointmentProvider;
  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    super.initState();
    getReviews();
  }

  void getReviews() {
    _salonProfileProvider = ref.read(salonProfileProvider);
    _createAppointmentProvider = ref.read(createAppointmentProvider);
    _salonProfileProvider.getMasterReviews(masterId: _createAppointmentProvider.chosenMaster!.masterId);
    // masterId: widget.masterModel!.masterId);
  }

  @override
  Widget build(BuildContext context) {
    final _createAppointmentProvider = ref.watch(createAppointmentProvider);
    final _salonProfileProvider = ref.watch(salonProfileProvider);
    final _salonSearchProvider = ref.watch(salonSearchProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;
    bool isLightTheme = (theme == AppTheme.customLightTheme);
    final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.portrait);
    final size = MediaQuery.of(context).size;

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: Padding(
        padding: EdgeInsets.only(top: 30.h, bottom: 100.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 100.h,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      Utils().getNameMaster(_createAppointmentProvider.chosenMaster?.personalInfo),
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                            fontSize: DeviceConstraints.getResponsiveSize(context, 25.sp, 30.sp, 35.sp),
                            color: Colors.white,
                            fontFamily: "Inter-Bold",
                            letterSpacing: 0.5,
                          ),
                    ),
                  ),
                  if (!isPortrait)
                    Positioned(
                      left: 0,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () => _salonProfileProvider.switchMasterView(),
                          child: Container(
                            height: 45.h,
                            // width: 70.w,
                            color: theme.canvasColor.withOpacity(!isLightTheme ? 0.5 : 1),
                            margin: EdgeInsets.symmetric(horizontal: 0, vertical: 20.h),

                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.w),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.chevron_left_rounded,
                                    color: isLightTheme ? AppTheme.textBlack : Colors.white,
                                    size: 20.sp,
                                  ),
                                  SizedBox(width: 5.sp),
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
                    ),
                ],
              ),
            ),
            const Space(factor: 2.5),
            Container(
              width: double.infinity,
              color: theme.canvasColor.withOpacity(0.7),
              height: 2500.h,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 10.h),
                      SizedBox(
                        height: !isPortrait ? null : 600.h,
                        child: !isPortrait
                            ? MasterAboutHeaderLandscape(
                                masterModel: _createAppointmentProvider.chosenMaster!,
                              )
                            : MasterAboutHeaderPortrait(
                                masterModel: _createAppointmentProvider.chosenMaster!,
                              ),
                      ),
                      SizedBox(height: 30.h),
                      CustomExpansionTile(
                        iconColor: Colors.black,
                        collapsedIconColor: Colors.black,
                        tilePadding: EdgeInsets.zero,
                        childrenPadding: EdgeInsets.zero,
                        trailing: const SizedBox.shrink(),
                        backgroundColor: Colors.transparent, // const Color(0XFF0A0A0A).withOpacity(0.6),
                        // onExpansionChanged: (bool val) {
                        //   setState(() => isExpanded = !isExpanded);
                        // },
                        title: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)?.services ?? 'Services',
                              style: theme.textTheme.displayLarge!.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 18.sp, 18.sp),
                                color: isLightTheme ? Colors.black : Colors.white,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 7),
                              child: RotatedBox(
                                quarterTurns: -1,
                                child: Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: const Color(0XFF919191),
                                  size: 20.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                        children: [
                          ListView.builder(
                              itemCount: _salonSearchProvider.categories.length,
                              shrinkWrap: true,
                              primary: false,
                              controller: _listViewController,
                              padding: const EdgeInsets.all(0),
                              itemBuilder: (context, index) {
                                List<ServiceModel> services = _createAppointmentProvider.mastersServicesMapAll[_createAppointmentProvider.chosenMaster?.masterId]
                                        ?.where(
                                          (element) => element.categoryId == (_salonSearchProvider.categories[index].categoryId).toString(),
                                        )
                                        .toList() ??
                                    [];

                                if (services.isNotEmpty) {
                                  return NewServiceTile(
                                    services: services,
                                    categoryModel: _salonSearchProvider.categories
                                        .where(
                                          (element) => element.categoryId == (_salonSearchProvider.categories[index].categoryId).toString(),
                                        )
                                        .first,
                                    listViewController: _listViewController,
                                    initiallyExpanded: false,
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              }),
                        ],
                      ),
                      SizedBox(height: 25.sp),
                      CustomExpansionTile(
                        iconColor: Colors.black,
                        collapsedIconColor: Colors.black,
                        tilePadding: EdgeInsets.zero,
                        childrenPadding: EdgeInsets.zero,
                        trailing: const SizedBox.shrink(),
                        backgroundColor: Colors.transparent, // const Color(0XFF0A0A0A).withOpacity(0.6),
                        title: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)?.portfolio ?? 'Portfolio',
                              style: theme.textTheme.displayLarge!.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 18.sp, 18.sp),
                                color: isLightTheme ? Colors.black : Colors.white,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 7),
                              child: RotatedBox(
                                quarterTurns: -1,
                                child: Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: const Color(0XFF919191),
                                  size: 20.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                        children: [
                          Container(
                            height: !(_createAppointmentProvider.chosenMaster!.photosOfWork != null && _createAppointmentProvider.chosenMaster!.photosOfWork!.isNotEmpty)
                                ? 300.h
                                : isPortrait
                                    ? 1500.h
                                    : null, // 1000.h,
                            width: double.infinity,
                            color: theme.canvasColor.withOpacity(!isLightTheme ? 0.5 : 1),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
                              child: SingleChildScrollView(
                                physics: const NeverScrollableScrollPhysics(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    (_createAppointmentProvider.chosenMaster!.photosOfWork != null && _createAppointmentProvider.chosenMaster!.photosOfWork!.isNotEmpty)
                                        ? !isPortrait
                                            ? Column(
                                                children: [
                                                  CarouselSlider(
                                                    carouselController: _controller,
                                                    options: CarouselOptions(
                                                      scrollPhysics: const AlwaysScrollableScrollPhysics(),
                                                      autoPlay: false,
                                                      pauseAutoPlayOnTouch: true,
                                                      viewportFraction: DeviceConstraints.getResponsiveSize(context, 1, 0.4, 0.34),
                                                      height: DeviceConstraints.getResponsiveSize(context, 280.h, 300.h, 320.h),
                                                    ),
                                                    items: _createAppointmentProvider.chosenMaster!.photosOfWork!.map((item) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) => ImagePreview(
                                                                imageUrls: [item],
                                                                index: _createAppointmentProvider.chosenMaster!.photosOfWork!.indexOf(item),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child: Padding(
                                                          padding: EdgeInsets.only(right: 20.sp),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              Expanded(
                                                                child: CachedImage(
                                                                  width: DeviceConstraints.getResponsiveSize(
                                                                    context,
                                                                    size.width - 20.w,
                                                                    ((size.width / 2)), // size.width - 20.w,
                                                                    (size.width / 3) - 20, // 200.w,
                                                                  ),
                                                                  url: item,
                                                                  fit: BoxFit.cover,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ),
                                                  SizedBox(height: 30.sp),
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () => _controller.previousPage(),
                                                        child: Container(
                                                          height: 41.h,
                                                          width: 41.h,
                                                          decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            color: !isLightTheme ? const Color(0XFFFFFFFF).withOpacity(0.1) : const Color(0XFF000000).withOpacity(0.4),
                                                          ),
                                                          child: const Icon(Icons.chevron_left_outlined, color: Colors.white),
                                                        ),
                                                      ),
                                                      SizedBox(width: 10.w),
                                                      GestureDetector(
                                                        onTap: () => _controller.nextPage(),
                                                        child: Container(
                                                          height: 41.h,
                                                          width: 41.h,
                                                          decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            color: !isLightTheme ? const Color(0XFFFFFFFF).withOpacity(0.1) : const Color(0XFF000000).withOpacity(0.4),
                                                          ),
                                                          child: const Icon(Icons.chevron_right_outlined, color: Colors.white),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )
                                            : Column(
                                                children: [
                                                  SizedBox(
                                                    height: 850.h,
                                                    child: CarouselSlider(
                                                      carouselController: _controller,
                                                      options: CarouselOptions(
                                                        scrollPhysics: const NeverScrollableScrollPhysics(),
                                                        viewportFraction: DeviceConstraints.getResponsiveSize(context, 0.365, 0.4, 0.34),
                                                        // height: DeviceConstraints.getResponsiveSize(context, 241.h, 250.h, 280.h),
                                                        aspectRatio: 1,
                                                        enlargeCenterPage: false,
                                                        scrollDirection: Axis.vertical,
                                                        enableInfiniteScroll: false, // this
                                                        padEnds: false, // this
                                                        autoPlay: false,
                                                      ),
                                                      items: _createAppointmentProvider.chosenMaster!.photosOfWork!.map((item) {
                                                        // String image = item.image ?? '';

                                                        return GestureDetector(
                                                          onTap: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) => ImagePreview(
                                                                  imageUrls: [item],
                                                                  index: _createAppointmentProvider.chosenMaster!.photosOfWork!.indexOf(item),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          child: Padding(
                                                            padding: EdgeInsets.only(bottom: 40.h),
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              children: [
                                                                Expanded(
                                                                  child: CachedImage(
                                                                    // height: 300.h,
                                                                    width: MediaQuery.of(context).size.width,

                                                                    // height: DeviceConstraints.getResponsiveSize(
                                                                    //   context,
                                                                    //   size.width - 20.w,
                                                                    //   ((size.width / 2)), // size.width - 20.w,
                                                                    //   (size.width / 3) - 20, // 200.w,
                                                                    // ),
                                                                    url: item,
                                                                    fit: BoxFit.cover,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                  SizedBox(height: 30.sp),
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () => _controller.previousPage(),
                                                        child: Container(
                                                          height: 41.h,
                                                          width: 41.h,
                                                          decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            color: !isLightTheme ? const Color(0XFFFFFFFF).withOpacity(0.1) : const Color(0XFF000000).withOpacity(0.4),
                                                          ),
                                                          child: const Icon(Icons.chevron_left_outlined, color: Colors.white),
                                                        ),
                                                      ),
                                                      SizedBox(width: 30.w),
                                                      GestureDetector(
                                                        onTap: () => _controller.nextPage(),
                                                        child: Container(
                                                          height: 41.h,
                                                          width: 41.h,
                                                          decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            color: !isLightTheme ? const Color(0XFFFFFFFF).withOpacity(0.1) : const Color(0XFF000000).withOpacity(0.4),
                                                          ),
                                                          child: const Icon(Icons.chevron_right_outlined, color: Colors.white),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )
                                        : Padding(
                                            padding: EdgeInsets.only(top: 30.h),
                                            child: Center(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    height: 150.h,
                                                    width: 250.h,
                                                    child: Image.asset(ThemeImages.noPhotos, fit: BoxFit.cover),
                                                  ),
                                                  SizedBox(height: 20.sp),
                                                  Text(
                                                    AppLocalizations.of(context)?.noPhotosAvailable ?? 'No photos added yet',
                                                    style: theme.textTheme.displayLarge!.copyWith(
                                                      fontSize: 16.sp,
                                                      color: const Color(0XFFBDBDBD), // isLightTheme ? Colors.black : Colors.white,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 25.sp),
                      CustomExpansionTile(
                        iconColor: Colors.black,
                        collapsedIconColor: Colors.black,
                        tilePadding: EdgeInsets.zero,
                        childrenPadding: EdgeInsets.zero,
                        trailing: const SizedBox.shrink(),
                        backgroundColor: Colors.transparent, // const Color(0XFF0A0A0A).withOpacity(0.6),
                        title: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)?.reviews ?? 'Reviews',
                              style: theme.textTheme.displayLarge!.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 18.sp, 18.sp),
                                color: isLightTheme ? Colors.black : Colors.white,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 7),
                              child: RotatedBox(
                                quarterTurns: -1,
                                child: Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: const Color(0XFF919191),
                                  size: 20.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                        children: [
                          Consumer(
                            builder: (context, ref, child) => ReviewSection(
                              reviews: ref.watch(salonProfileProvider).masterReviews,
                              avgRating: _createAppointmentProvider.chosenMaster!.avgRating ?? 0,
                              isFromMasterView: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
