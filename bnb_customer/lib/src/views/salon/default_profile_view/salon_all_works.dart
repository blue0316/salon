import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/views/salon/default_profile_view/salon_profile.dart';
import 'package:bbblient/src/views/themes/components/widgets/image_preview.dart';
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

  @override
  Widget build(BuildContext context) {
    // final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.portrait);
    final _salonProfileProvider = ref.watch(salonProfileProvider);
    bool isSingleMaster = _salonProfileProvider.isSingleMaster;

    final ThemeData theme = _salonProfileProvider.salonTheme;
    bool isLightTheme = (theme == AppTheme.customLightTheme);

    return SingleChildScrollView(
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
            height: 1000.h,
            width: double.infinity,
            color: theme.canvasColor.withOpacity(0.7),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 80.h),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    (widget.salonModel.photosOfWorks != null && widget.salonModel.photosOfWorks!.isNotEmpty)
                        ? Wrap(
                            spacing: 20,
                            runSpacing: 40,
                            direction: Axis.horizontal,
                            children: widget.salonModel.photosOfWorks!.map((work) {
                              List<String> images = [];

                              for (PhotosOfWorks item in widget.salonModel.photosOfWorks!) {
                                images.add(item.image!);
                              }

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ImagePreview(
                                        imageUrls: images,
                                        index: widget.salonModel.photosOfWorks!.indexOf(work),
                                      ),
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 180.h,
                                      width: 290.h,
                                      child: CachedImage(url: '${work.image}', fit: BoxFit.cover),
                                    ),
                                    const SizedBox(height: 10),
                                    SizedBox(
                                      height: 50.h,
                                      width: 290.h,
                                      child: Text(
                                        (work.description != null && work.description != '') ? '${work.description}' : '',
                                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                              fontWeight: FontWeight.normal,
                                              fontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 15.sp, 15.sp),
                                              color: isLightTheme ? Colors.black : Colors.white,
                                            ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          )
                        // (widget.salonModel.photosOfWorks != null && widget.salonModel.photosOfWorks!.isNotEmpty)
                        //     ? GridView.builder(
                        //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        //           crossAxisCount: DeviceConstraints.getResponsiveSize(context, 1, 2, 3).toInt(),
                        //           crossAxisSpacing: 10,
                        //           mainAxisSpacing: DeviceConstraints.getResponsiveSize(context, 10, 10, 10),
                        //           mainAxisExtent: DeviceConstraints.getResponsiveSize(context, 250.h, 200.h, 200.h), // childAspectRatio: 1,
                        //           // mainAxisExtent: DeviceConstraints.getResponsiveSize(context, 0, 0, 256),
                        //         ),
                        //         shrinkWrap: true,
                        //         primary: false,
                        //         itemCount: widget.salonModel.photosOfWorks!.length,
                        //         controller: _gridViewScrollController,
                        //         // padding: EdgeInsets.all(20.w),
                        //         itemBuilder: (context, index) {
                        //           List<String?>? images = [];
                        //           images.add(widget.salonModel.photosOfWorks![index].image);

                        //           return GestureDetector(
                        //             onTap: () {
                        //               Navigator.push(
                        //                 context,
                        //                 MaterialPageRoute(
                        //                   builder: (context) => ImagePreview(
                        //                     imageUrls: images,
                        //                     index: index,
                        //                   ),
                        //                 ),
                        //               );
                        //             },
                        //             child: Container(
                        //               color: Colors.red,
                        //               child: Column(
                        //                 crossAxisAlignment: CrossAxisAlignment.start,
                        //                 mainAxisAlignment: MainAxisAlignment.start,
                        //                 children: [
                        //                   Expanded(
                        //                     flex: 1,
                        //                     child: Container(
                        //                       color: Colors.yellow,
                        //                       height: DeviceConstraints.getResponsiveSize(context, 250, 200, 100),
                        //                       width: isPortrait ? double.infinity : DeviceConstraints.getResponsiveSize(context, 200, 300, 400),
                        //                       // decoration: const BoxDecoration(color: Colors.green),
                        //                       child: CachedImage(
                        //                         url: '${widget.salonModel.photosOfWorks![index].image}',
                        //                         fit: BoxFit.cover,
                        //                       ),
                        //                     ),
                        //                   ),

                        //                   const SizedBox(height: 10),
                        //                   Text(
                        //                     (widget.salonModel.photosOfWorks![index].description != null && widget.salonModel.photosOfWorks![index].description != '') ? '${widget.salonModel.photosOfWorks![index].description}' : '...',
                        //                     style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        //                           fontWeight: FontWeight.normal,
                        //                           fontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 15.sp, 15.sp),
                        //                           color: isLightTheme ? Colors.black : Colors.white,
                        //                         ),
                        //                     maxLines: 2,
                        //                     overflow: TextOverflow.ellipsis,
                        //                   ),
                        //                   // const SizedBox(height: 15),
                        //                 ],
                        //               ),
                        //             ),
                        //           );
                        //         })

                        : Center(
                            child: Text(
                              'NO PHOTOS OF WORKS AVAILABLE AT THE MOMENT',
                              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                                    fontSize: DeviceConstraints.getResponsiveSize(context, 20.sp, 20.sp, 20.sp),
                                    color: isLightTheme ? Colors.black : Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                              textAlign: TextAlign.center,
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
