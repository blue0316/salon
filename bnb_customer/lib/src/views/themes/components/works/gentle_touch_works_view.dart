import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/themes/glam_one/core/utils/prev_and_next.dart';
import 'package:bbblient/src/views/themes/glam_one/master_profile/unique_master_profile.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:carousel_slider/carousel_slider.dart';
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
  List<PhotosOfWorks> jumpPhotosList = [];

  int startJump = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      jumpPhotosList = widget.salonModel.photosOfWorks!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.portrait);

    // Check if Salon is a single masters
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
          isPortrait
              ? Center(
                  child: Text(
                    (AppLocalizations.of(context)?.portfolio ?? 'portfolio').toUpperCase(),
                    style: theme.textTheme.displayMedium?.copyWith(
                      fontSize: DeviceConstraints.getResponsiveSize(context, 50.sp, 50.sp, 60.sp),
                    ),
                    textAlign: isPortrait ? TextAlign.center : null,
                  ),
                )
              : Text(
                  (AppLocalizations.of(context)?.portfolio ?? 'portfolio').toUpperCase(),
                  style: theme.textTheme.displayMedium?.copyWith(
                    fontSize: DeviceConstraints.getResponsiveSize(context, 40.sp, 50.sp, 60.sp),
                  ),
                ),
          SizedBox(height: DeviceConstraints.getResponsiveSize(context, 30, 30, 60)),
          (jumpPhotosList.isNotEmpty)
              ? isPortrait
                  ? PortraitView(
                      salon: widget.salonModel,
                    )
                  : Column(
                      children: [
                        StaggeredGrid.count(
                          crossAxisCount: 5,
                          mainAxisSpacing: 6,
                          crossAxisSpacing: 4,
                          children: [
                            if (jumpPhotosList.isNotEmpty)
                              StaggeredGridTile.count(
                                crossAxisCellCount: 1,
                                mainAxisCellCount: 1,
                                child: Tile(
                                  index: 1,
                                  image: jumpPhotosList[0].image!,
                                  description: widget.salonModel.photosOfWorks![0].description ?? '',
                                ),
                              ),
                            if (jumpPhotosList.length >= 2)
                              StaggeredGridTile.count(
                                crossAxisCellCount: 1,
                                mainAxisCellCount: 1,
                                child: Tile(
                                  index: 2,
                                  image: jumpPhotosList[1].image!,
                                  description: widget.salonModel.photosOfWorks![1].description ?? '',
                                ),
                              ),
                            if (jumpPhotosList.length >= 3)
                              StaggeredGridTile.count(
                                crossAxisCellCount: 2,
                                mainAxisCellCount: 1.25,
                                child: Tile(
                                  index: 4,
                                  image: jumpPhotosList[2].image!,
                                  description: widget.salonModel.photosOfWorks![2].description ?? '',
                                ),
                              ),
                            if (jumpPhotosList.length >= 4)
                              StaggeredGridTile.count(
                                crossAxisCellCount: 2,
                                mainAxisCellCount: 1.5,
                                child: Tile(
                                  index: 3,
                                  image: jumpPhotosList[3].image!,
                                  description: widget.salonModel.photosOfWorks![3].description ?? '',
                                ),
                              ),
                            if (jumpPhotosList.length >= 5)
                              StaggeredGridTile.count(
                                crossAxisCellCount: 1,
                                mainAxisCellCount: 2.5,
                                child: Tile(
                                  index: 6,
                                  image: jumpPhotosList[4].image!,
                                  description: widget.salonModel.photosOfWorks![4].description ?? '',
                                ),
                              ),
                            if (jumpPhotosList.length > 5)
                              StaggeredGridTile.count(
                                crossAxisCellCount: 2,
                                mainAxisCellCount: 1.25,
                                child: Tile(
                                  index: 5,
                                  image: jumpPhotosList[5].image!,
                                  description: widget.salonModel.photosOfWorks![5].description ?? '',
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 20.sp),
                        Align(
                          alignment: Alignment.centerRight,
                          child: PrevAndNextButtons(
                            backOnTap: () {
                              if (!(startJump < 0)) {
                                setState(() {
                                  startJump -= 6;
                                  jumpPhotosList = widget.salonModel.photosOfWorks!.sublist(startJump);
                                });
                              }
                            },
                            forwardOnTap: () {
                              setState(() {
                                startJump += 6;
                                jumpPhotosList = jumpPhotosList.sublist(startJump);
                              });
                            },
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

class PortraitView extends ConsumerStatefulWidget {
  final SalonModel salon;

  const PortraitView({Key? key, required this.salon}) : super(key: key);

  @override
  ConsumerState<PortraitView> createState() => _PortraitViewState();
}

class _PortraitViewState extends ConsumerState<PortraitView> {
  final CarouselController _controller = CarouselController();
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    // final ThemeData theme = _salonProfileProvider.salonTheme;
    final ThemeType themeType = _salonProfileProvider.themeType;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 500.h,
          width: double.infinity,
          child: SizedBox(
            width: double.infinity,
            child: CarouselSlider(
              carouselController: _controller,
              options: CarouselOptions(
                height: 500.h,
                autoPlay: true,
                viewportFraction: 1,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                },
              ),
              items: widget.salon.photosOfWorks!
                  .map(
                    (item) => PortraitItemCard(
                      image: item.image!,
                      description: item.description ?? '',
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        SizedBox(height: 10.sp),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.salon.photosOfWorks!.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: _current == entry.key ? 7 : 4,
                height: _current == entry.key ? 7 : 4,
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == entry.key
                      ? themeType == ThemeType.GentleTouch
                          ? Colors.black
                          : Colors.white
                      : const Color(0XFF8A8A8A).withOpacity(
                          _current == entry.key ? 0.9 : 0.4,
                        ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class Tile extends ConsumerStatefulWidget {
  const Tile({
    Key? key,
    required this.index,
    required this.image,
    this.extent,
    this.backgroundColor,
    this.bottomSpace,
    required this.description,
    this.width,
  }) : super(key: key);

  final int index;
  final String image;
  final double? extent;
  final double? bottomSpace;
  final Color? backgroundColor;
  final String description;
  final double? width;

  @override
  ConsumerState<Tile> createState() => _TileState();
}

class _TileState extends ConsumerState<Tile> {
  bool isHovered = false;

  void onEntered(bool isHovered) => setState(() {
        this.isHovered = isHovered;
      });

  @override
  Widget build(BuildContext context) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    ThemeType themeType = _salonProfileProvider.themeType;

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

    final child = MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (event) => onEntered(true),
      onExit: (event) => onEntered(false),
      child: SizedBox(
        height: widget.extent,
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: CachedImage(
                url: widget.image,
                fit: BoxFit.cover,
                width: widget.width ?? MediaQuery.of(context).size.width / 3,
              ),
            ),
            if (isHovered && widget.description.isNotEmpty)
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: themeType == ThemeType.GentleTouch ? Colors.black : Colors.white,
                    width: 0.3,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.sp),
                  child: Center(
                    child: Text(
                      widget.description,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.primaryColorDark,
                        fontSize: DeviceConstraints.getResponsiveSize(context, 14.sp, 14.sp, 14.sp),
                        fontWeight: FontWeight.normal,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
          ],
        ),
        // Image.asset(
        //   image,
        //   fit: BoxFit.cover,
        //   width: double.infinity,
        // ),
      ),
    );

    if (widget.bottomSpace == null) {
      return child;
    }

    return Column(
      children: [
        Expanded(child: child),
        Container(
          height: widget.bottomSpace,
          color: Colors.green,
        )
      ],
    );
  }
}

class PortraitItemCard extends ConsumerWidget {
  final String image, description;

  const PortraitItemCard({Key? key, required this.image, required this.description}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    final ThemeType themeType = _salonProfileProvider.themeType;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: (themeType == ThemeType.GentleTouch) ? Colors.black : Colors.white,
            ),
          ),
          // color: backgroundColor ?? Colors.blue,
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    border: description.isNotEmpty
                        ? Border.all(
                            color: (themeType == ThemeType.GentleTouch) ? Colors.black : Colors.white,
                          )
                        : null,
                  ),
                  child: CachedImage(
                    url: image,
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width - 40.w,
                  ),
                ),
              ),
              if (description.isNotEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 15.sp),
                  child: Text(
                    description,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.primaryColorDark,
                      fontSize: DeviceConstraints.getResponsiveSize(context, 14.sp, 14.sp, 14.sp),
                      fontWeight: FontWeight.normal,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
          // Image.asset(
          //   image,
          //   fit: BoxFit.cover,
          //   width: double.infinity,
          // ),
        ),
      ),
    );
  }
}
