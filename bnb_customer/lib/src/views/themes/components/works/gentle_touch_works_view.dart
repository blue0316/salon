import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/themes/glam_one/core/utils/prev_and_next.dart';
import 'package:bbblient/src/views/themes/glam_one/master_profile/unique_master_profile.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class GentleTouchWorksView extends ConsumerStatefulWidget {
  final SalonModel salonModel;
  const GentleTouchWorksView({Key? key, required this.salonModel}) : super(key: key);

  @override
  ConsumerState<GentleTouchWorksView> createState() => _GentleTouchWorksViewState();
}

class _GentleTouchWorksViewState extends ConsumerState<GentleTouchWorksView> {
  // final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    // Check if Salon is a single master
    // final bool isSingleMaster = _salonProfileProvider.isSingleMaster;

    return Padding(
      padding: EdgeInsets.only(
        left: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w),
        right: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w),
        top: DeviceConstraints.getResponsiveSize(context, 80.h, 90.h, 100.h),
        bottom: DeviceConstraints.getResponsiveSize(context, 80.h, 90.h, 100.h),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            (AppLocalizations.of(context)?.portfolio ?? 'portfolio').toUpperCase(),
            style: theme.textTheme.displayMedium?.copyWith(
              fontSize: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 60.sp),
            ),
          ),
          SizedBox(height: DeviceConstraints.getResponsiveSize(context, 30, 30, 60)),
          (widget.salonModel.photosOfWorks!.isNotEmpty)
              ? Column(
                  children: [
                    StaggeredGrid.count(
                      crossAxisCount: 5,
                      mainAxisSpacing: 6,
                      crossAxisSpacing: 4,
                      children: [
                        if (widget.salonModel.photosOfWorks!.isNotEmpty)
                          StaggeredGridTile.count(
                            crossAxisCellCount: 1,
                            mainAxisCellCount: 1,
                            child: Tile(
                              index: 1,
                              image: widget.salonModel.photosOfWorks![0].image!,
                            ),
                          ),
                        if (widget.salonModel.photosOfWorks!.length >= 2)
                          StaggeredGridTile.count(
                            crossAxisCellCount: 1,
                            mainAxisCellCount: 1,
                            child: Tile(
                              index: 2,
                              image: widget.salonModel.photosOfWorks![1].image!,
                            ),
                          ),
                        if (widget.salonModel.photosOfWorks!.length >= 4)
                          StaggeredGridTile.count(
                            crossAxisCellCount: 2,
                            mainAxisCellCount: 1.25,
                            child: Tile(
                              index: 4,
                              image: widget.salonModel.photosOfWorks![3].image!,
                            ),
                          ),
                        if (widget.salonModel.photosOfWorks!.length >= 3)
                          StaggeredGridTile.count(
                            crossAxisCellCount: 2,
                            mainAxisCellCount: 1.5,
                            child: Tile(
                              index: 3,
                              image: widget.salonModel.photosOfWorks![2].image!,
                            ),
                          ),
                        if (widget.salonModel.photosOfWorks!.length >= 5)
                          StaggeredGridTile.count(
                            crossAxisCellCount: 1,
                            mainAxisCellCount: 2.5,
                            child: Tile(
                              index: 6,
                              image: widget.salonModel.photosOfWorks![4].image!,
                            ),
                          ),
                        if (widget.salonModel.photosOfWorks!.length > 5)
                          StaggeredGridTile.count(
                            crossAxisCellCount: 2,
                            mainAxisCellCount: 1.25,
                            child: Tile(
                              index: 5,
                              image: widget.salonModel.photosOfWorks![5].image!,
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 20.sp),
                    Align(
                      alignment: Alignment.centerRight,
                      child: PrevAndNextButtons(
                        backOnTap: () {},
                        forwardOnTap: () {},
                        leftFontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 15.sp, 18.sp),
                        rightFontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 15.sp, 18.sp),
                      ),
                    ),
                  ],
                )
              : NoSectionYet(
                  text: AppLocalizations.of(context)?.noWorks ?? 'No photos of works',
                  color: theme.colorScheme.secondary,
                ),
        ],
      ),
    );
  }
}

class Tile extends StatelessWidget {
  const Tile({
    Key? key,
    required this.index,
    required this.image,
    this.extent,
    this.backgroundColor,
    this.bottomSpace,
  }) : super(key: key);

  final int index;
  final String image;
  final double? extent;
  final double? bottomSpace;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    // final child = Container(
    //   color: backgroundColor ?? Colors.blue,
    //   height: extent,
    //   child: Center(
    //     child: CircleAvatar(
    //       minRadius: 20,
    //       maxRadius: 20,
    //       backgroundColor: Colors.white,
    //       foregroundColor: Colors.black,
    //       child: Text('$index', style: const TextStyle(fontSize: 20)),
    //     ),
    //   ),
    // );

    final child = GestureDetector(
      onTap: () {
        debugPrint(index.toString());
      },
      child: SizedBox(
        // color: backgroundColor ?? Colors.blue,
        height: extent,
        child: CachedImage(
          url: image,
          // width: double.infinity,
          fit: BoxFit.cover,
        ),
        // Image.asset(
        //   image,
        //   fit: BoxFit.cover,
        //   width: double.infinity,
        // ),
      ),
    );

    if (bottomSpace == null) {
      return child;
    }

    return Column(
      children: [
        Expanded(child: child),
        Container(
          height: bottomSpace,
          color: Colors.green,
        )
      ],
    );
  }
}
