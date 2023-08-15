import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/views/salon/default_profile_view/salon_profile.dart';
import 'package:bbblient/src/views/themes/components/widgets/image_preview.dart';
import 'package:bbblient/src/views/themes/images.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'widgets/section_spacer.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/widgets/image.dart';

class SalonAllWorks extends ConsumerStatefulWidget {
  final SalonModel salonModel;

  const SalonAllWorks({Key? key, required this.salonModel}) : super(key: key);

  @override
  ConsumerState<SalonAllWorks> createState() => _SalonAllWorksState();
}

class _SalonAllWorksState extends ConsumerState<SalonAllWorks> {
  // final ScrollController _gridViewScrollController = ScrollController();
  final CarouselController _controller = CarouselController();
  List<PhotosOfWorks> firstPhoto = [];
  List<PhotosOfWorks> remainingPhotos = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  init() {
    if (widget.salonModel.photosOfWorks != null && widget.salonModel.photosOfWorks!.isNotEmpty) {
      setState(() {
        firstPhoto.add(widget.salonModel.photosOfWorks![0]);
        widget.salonModel.photosOfWorks!.removeAt(0);
        remainingPhotos = widget.salonModel.photosOfWorks!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.portrait);
    final size = MediaQuery.of(context).size;
    final _salonProfileProvider = ref.watch(salonProfileProvider);
    bool isSingleMaster = _salonProfileProvider.isSingleMaster;

    final ThemeData theme = _salonProfileProvider.salonTheme;
    // bool isLightTheme = (theme == AppTheme.customLightTheme);

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          SectionSpacer(
            title: (!isSingleMaster)
                ? salonTitles(
                    AppLocalizations.of(context)?.localeName ?? 'en',
                  )[3]
                : masterTitles(
                    AppLocalizations.of(context)?.localeName ?? 'en',
                  )[2],
          ),
          Container(
            height: (widget.salonModel.photosOfWorks != null && widget.salonModel.photosOfWorks!.isNotEmpty)
                ? 400.h
                : isPortrait
                    ? 4400.h
                    : null, // 1000.h,
            width: double.infinity,
            color: theme.canvasColor.withOpacity(0.7),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    !(widget.salonModel.photosOfWorks != null && widget.salonModel.photosOfWorks!.isNotEmpty)
                        ? Column(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: DeviceConstraints.getResponsiveSize(context, 400.h, 410.h, 410.h),
                                    width: double.infinity,
                                    child: CachedImage(
                                      url: firstPhoto[0].image!, // widget.salonModel.photosOfWorks![0].image!,
                                      fit: BoxFit.cover,
                                      width: MediaQuery.of(context).size.width,
                                    ),
                                  ),
                                  SizedBox(height: 12.sp),
                                  Text(
                                    '${firstPhoto[0].description}',
                                    style: theme.textTheme.bodyLarge!.copyWith(
                                      fontWeight: FontWeight.normal,
                                      fontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 15.sp, 15.sp),
                                      color: const Color(0XFFBDBDBD), // isLightTheme ? Colors.black : Colors.white,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.h),

                              //
                              !isPortrait
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
                                          items: remainingPhotos.map((item) {
                                            String image = item.image ?? '';
                                            if (image.isNotEmpty) {
                                              return GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => ImagePreview(
                                                        imageUrls: [item.image], //  widget.salonModel.photosOfWorks,
                                                        index: remainingPhotos.indexOf(item),
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
                                                          url: item.image!,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      SizedBox(height: 10.sp),
                                                      Text(
                                                        (item.description != null && item.description != '') ? '${item.description}' : '',
                                                        style: theme.textTheme.bodyLarge!.copyWith(
                                                          fontWeight: FontWeight.normal,
                                                          fontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 15.sp, 15.sp),
                                                          color: const Color(0XFFBDBDBD), //  isLightTheme ? Colors.black : Colors.white,
                                                        ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return const SizedBox();
                                            }
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
                                                  color: const Color(0XFFFFFFFF).withOpacity(0.1),
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
                                                  color: const Color(0XFFFFFFFF).withOpacity(0.1),
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
                                            items: widget.salonModel.photosOfWorks!.map((item) {
                                              // String image = item.image ?? '';

                                              return GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => ImagePreview(
                                                        imageUrls: [item.image], //  widget.salonModel.photosOfWorks,
                                                        index: remainingPhotos.indexOf(item),
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
                                                          url: item.image!,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      SizedBox(height: 12.sp),
                                                      Text(
                                                        (item.description != null && item.description != '') ? '${item.description}' : '',
                                                        style: theme.textTheme.bodyLarge!.copyWith(
                                                          fontWeight: FontWeight.normal,
                                                          fontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 15.sp, 15.sp),
                                                          color: const Color(0XFFBDBDBD), //  isLightTheme ? Colors.black : Colors.white,
                                                        ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
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
                                                  color: const Color(0XFFFFFFFF).withOpacity(0.1),
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
                                                  color: const Color(0XFFFFFFFF).withOpacity(0.1),
                                                ),
                                                child: const Icon(Icons.chevron_right_outlined, color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),

                              // Wrap(
                              //   spacing: 20,
                              //   runSpacing: 40,
                              //   direction: Axis.horizontal,
                              //   children: widget.salonModel.photosOfWorks!.map((work) {
                              //     List<String> images = [];

                              //     for (PhotosOfWorks item in widget.salonModel.photosOfWorks!) {
                              //       images.add(item.image!);
                              //     }

                              //     return GestureDetector(
                              //       onTap: () {
                              //         Navigator.push(
                              //           context,
                              //           MaterialPageRoute(
                              //             builder: (context) => ImagePreview(
                              //               imageUrls: images,
                              //               index: widget.salonModel.photosOfWorks!.indexOf(work),
                              //             ),
                              //           ),
                              //         );
                              //       },
                              //       child: Column(
                              //         children: [
                              //           SizedBox(
                              //             height: 180.h,
                              //             width: 290.h,
                              //             child: CachedImage(url: '${work.image}', fit: BoxFit.cover),
                              //           ),
                              //           const SizedBox(height: 10),
                              //           SizedBox(
                              //             height: 50.h,
                              //             width: 290.h,
                              //             child: Text(
                              //               (work.description != null && work.description != '') ? '${work.description}' : '',
                              //               style: theme.textTheme.bodyLarge!.copyWith(
                              //                 fontWeight: FontWeight.normal,
                              //                 fontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 15.sp, 15.sp),
                              //                 color: const Color(0XFFBDBDBD), //  isLightTheme ? Colors.black : Colors.white,
                              //               ),
                              //               maxLines: 2,
                              //               overflow: TextOverflow.ellipsis,
                              //             ),
                              //           ),
                              //         ],
                              //       ),
                              //     );
                              //   }).toList(),
                              // ),
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
                                    child: Image.asset(
                                      ThemeImages.noPhotos,
                                      fit: BoxFit.cover,
                                    ),
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
    );
  }
}
