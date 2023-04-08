import 'package:bbblient/src/models/enums/profile_datails_tabs.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/views/chat/image_preview.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SaloonAllWorks extends StatefulWidget {
  final SalonModel salonModel;

  const SaloonAllWorks({Key? key, required this.salonModel}) : super(key: key);
  @override
  _SaloonAllWorksState createState() => _SaloonAllWorksState();
}

class _SaloonAllWorksState extends State<SaloonAllWorks> {
  int gridViewChildCount = 12;

  final ScrollController _gridViewScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedContainer(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: (AppTheme.margin * 2).h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Text(
              (AppLocalizations.of(context)?.localeName == 'uk') ? saloonDetailsTitlesUK[3] : saloonDetailsTitles[3].toCapitalized(),
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 30.sp,
                    letterSpacing: -1,
                  ),
            ),
            const Space(factor: 2),
            (widget.salonModel.photosOfWorks!.isNotEmpty)
                ? GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: DeviceConstraints.getResponsiveSize(context, 2, 3, 3).toInt(),
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      mainAxisExtent: DeviceConstraints.getResponsiveSize(context, 250.h, 250.h, 300.h),

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
                            SizedBox(
                              height: DeviceConstraints.getResponsiveSize(context, 150, 200, 200),
                              width: DeviceConstraints.getResponsiveSize(context, 200, 300, 400),
                              // decoration: const BoxDecoration(color: Colors.green),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: CachedImage(
                                  url: '${widget.salonModel.photosOfWorks![index].image}',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),
                            Text(
                              '${widget.salonModel.photosOfWorks![index].description}',
                              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 15.sp, 16.sp),
                                  ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            // const SizedBox(height: 15),
                          ],
                        ),
                      );
                    })
                : SizedBox(height: 0.5.sh),
            const Space(factor: 6),
          ],
        ),
      ),
    );
  }
}
