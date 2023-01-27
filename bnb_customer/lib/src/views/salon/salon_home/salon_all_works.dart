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
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 30.sp,
                    letterSpacing: -1,
                  ),
            ),
            const Space(factor: 2),
            (widget.salonModel.photosOfWork.isNotEmpty)
                ? GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: DeviceConstraints.getResponsiveSize(context, 2, 3, 3).toInt(),
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      // mainAxisExtent: DeviceConstraints.getResponsiveSize(context, 0, 0, 256),
                    ),
                    shrinkWrap: true,
                    primary: false,
                    itemCount: widget.salonModel.photosOfWork.length,
                    controller: _gridViewScrollController,
                    // padding: EdgeInsets.all(20.w),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ImagePreview(
                                imageUrls: widget.salonModel.photosOfWork,
                                index: index,
                              ),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: DeviceConstraints.getResponsiveSize(context, 100, 150, 200),
                              width: DeviceConstraints.getResponsiveSize(context, 150, 250, 400),
                              decoration: const BoxDecoration(color: Colors.green),
                              // child: CachedImage(
                              //   url: widget.salonModel.photosOfWork[index],
                              // ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              'Lorem ipsum dolor sit amet',
                              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                  // fontSize: 30.sp,
                                  ),
                            ),
                          ],
                        ),
                      );
                    })
                : SizedBox(height: 0.5.sh),
            const Space(factor: 3),
          ],
        ),
      ),
    );
  }
}
