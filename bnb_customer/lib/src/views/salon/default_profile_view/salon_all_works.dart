import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/enums/profile_datails_tabs.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'widgets/section_spacer.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/chat/image_preview.dart';
import 'package:bbblient/src/views/widgets/image.dart';

class SalonAllWorks extends StatefulWidget {
  final SalonModel salonModel;

  const SalonAllWorks({Key? key, required this.salonModel}) : super(key: key);

  @override
  State<SalonAllWorks> createState() => _SalonAllWorksState();
}

class _SalonAllWorksState extends State<SalonAllWorks> {
  final ScrollController _gridViewScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.portrait);

    return SingleChildScrollView(
      child: Column(
        children: [
          SectionSpacer(
            title: (AppLocalizations.of(context)?.localeName == 'uk') ? saloonDetailsTitlesUK[3] : saloonDetailsTitles[3],
          ),
          Container(
            // height: 1000.h,
            width: double.infinity,
            color: Colors.white.withOpacity(0.7),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    (widget.salonModel.photosOfWorks!.isNotEmpty)
                        ? GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: DeviceConstraints.getResponsiveSize(context, 1, 2, 3).toInt(),
                              crossAxisSpacing: 10,
                              mainAxisSpacing: DeviceConstraints.getResponsiveSize(context, 10, 10, 10),
                              mainAxisExtent: DeviceConstraints.getResponsiveSize(context, 250.h, 200.h, 200.h), // childAspectRatio: 1,
                              // mainAxisExtent: DeviceConstraints.getResponsiveSize(context, 0, 0, 256),
                            ),
                            shrinkWrap: true,
                            primary: false,
                            itemCount: widget.salonModel.photosOfWorks!.length,
                            controller: _gridViewScrollController,
                            // padding: EdgeInsets.all(20.w),
                            itemBuilder: (context, index) {
                              List<String?>? images = [];
                              images.add(widget.salonModel.photosOfWorks![index].image);

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ImagePreview(
                                        imageUrls: images,
                                        index: index,
                                      ),
                                    ),
                                  );
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: SizedBox(
                                        height: DeviceConstraints.getResponsiveSize(context, 250, 200, 100),
                                        width: isPortrait ? double.infinity : DeviceConstraints.getResponsiveSize(context, 200, 300, 400),
                                        // decoration: const BoxDecoration(color: Colors.green),
                                        child: CachedImage(
                                          url: '${widget.salonModel.photosOfWorks![index].image}',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 10),
                                    Text(
                                      (widget.salonModel.photosOfWorks![index].description != null || widget.salonModel.photosOfWorks![index].description != '') ? '${widget.salonModel.photosOfWorks![index].description}' : '...',
                                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                            fontWeight: FontWeight.normal,
                                            fontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 15.sp, 15.sp),
                                          ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    // const SizedBox(height: 15),
                                  ],
                                ),
                              );
                            })
                        : Center(
                            child: Text(
                              'NO PHOTOS OF WORKS AVAILABLE AT THE MOMENT',
                              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                                    fontSize: DeviceConstraints.getResponsiveSize(context, 20.sp, 20.sp, 20.sp),
                                    color: Colors.black,
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
