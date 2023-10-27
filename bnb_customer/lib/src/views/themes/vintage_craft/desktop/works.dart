import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/views/themes/glam_one/core/utils/prev_and_next.dart';
import 'package:bbblient/src/views/themes/glam_one/core/utils/header_height.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VintageWorks extends ConsumerStatefulWidget {
  final SalonModel salonModel;
  const VintageWorks({Key? key, required this.salonModel}) : super(key: key);

  @override
  ConsumerState<VintageWorks> createState() => _VintageWorksState();
}

class _VintageWorksState extends ConsumerState<VintageWorks> {
  List<PhotosOfWorks> jumpPhotosList = [];

  int startJump = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      jumpPhotosList = widget.salonModel.photosOfWorks!;
    });
  }

  bool isHovered = false;

  void onEntered(bool isHovered) => setState(() {
        this.isHovered = isHovered;
      });

  @override
  Widget build(BuildContext context) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

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
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                (AppLocalizations.of(context)?.portfolio ?? 'portfolio').toTitleCase(),
                style: theme.textTheme.displayMedium?.copyWith(
                  fontSize: DeviceConstraints.getResponsiveSize(context, 40.sp, 50.sp, 60.sp),
                ),
              ),
              PrevAndNextButtons(
                backOnTap: () {
                  if (!(startJump < 0)) {
                    setState(() {
                      startJump -= 5;
                      jumpPhotosList = widget.salonModel.photosOfWorks!.sublist(startJump);
                    });
                  }
                },
                forwardOnTap: () {
                  setState(() {
                    startJump += 5;
                    jumpPhotosList = jumpPhotosList.sublist(startJump);
                  });
                },
                leftFontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 15.sp, 18.sp),
                rightFontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 15.sp, 18.sp),
              ),
            ],
          ),
          SizedBox(height: DeviceConstraints.getResponsiveSize(context, 30, 30, 30)),
          (jumpPhotosList.isNotEmpty)
              ? SizedBox(
                  height: 830.h,
                  width: double.infinity,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 0,
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          onEnter: (event) => onEntered(true),
                          onExit: (event) => onEntered(false),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 430.h,
                                width: double.infinity,
                                child: ClipRect(
                                  child: ColorFiltered(
                                    colorFilter: const ColorFilter.mode(Colors.transparent, BlendMode.multiply),
                                    child: CachedImage(
                                      url: jumpPhotosList[0].image!,
                                      fit: BoxFit.cover,
                                      color: !isHovered ? Colors.grey[850] : null,
                                      colorBlendMode: BlendMode.saturation,
                                    ),
                                  ),
                                ),
                              ),
                              if (isHovered && jumpPhotosList[0].description!.isNotEmpty)
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.secondary,
                                    border: Border.all(color: theme.colorScheme.secondary, width: 0.3),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10.sp),
                                    child: Center(
                                      child: Text(
                                        '${jumpPhotosList[0].description}',
                                        style: theme.textTheme.bodyLarge?.copyWith(
                                          color: Colors.white,
                                          fontSize: DeviceConstraints.getResponsiveSize(context, 14.sp, 14.sp, 14.sp),
                                          fontWeight: FontWeight.normal,
                                        ),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 15.sp),
                      Expanded(
                        flex: 0,
                        child: SizedBox(
                          height: 360.h,
                          child: ListView.builder(
                            itemCount: 4,
                            shrinkWrap: true,
                            primary: false,
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              if (jumpPhotosList.length > index + 1) {
                                return BottomPortfolioItem(
                                  image: jumpPhotosList[index + 1].image!,
                                  description: jumpPhotosList[index + 1].description!,
                                );
                              } else {
                                return const SizedBox.shrink();
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
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

class BottomPortfolioItem extends ConsumerStatefulWidget {
  final String image, description;
  final bool? isLast;

  const BottomPortfolioItem({
    super.key,
    required this.image,
    required this.description,
    this.isLast = false,
  });

  @override
  ConsumerState<BottomPortfolioItem> createState() => _BottomPortfolioItemState();
}

class _BottomPortfolioItemState extends ConsumerState<BottomPortfolioItem> {
  bool isHovered = false;

  void onEntered(bool isHovered) => setState(() {
        this.isHovered = isHovered;
      });

  @override
  Widget build(BuildContext context) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    return Padding(
      padding: EdgeInsets.only(right: widget.isLast != true ? 10.sp : 0),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (event) {
          onEntered(true);
        },
        onExit: (event) {
          onEntered(false);
        },
        child: Column(
          children: [
            SizedBox(
              height: 280.h,
              width: MediaQuery.of(context).size.width / 5.4,
              child: ClipRect(
                child: ColorFiltered(
                  colorFilter: const ColorFilter.mode(Colors.transparent, BlendMode.multiply),
                  child: CachedImage(
                    url: widget.image,
                    fit: BoxFit.cover,
                    color: !isHovered ? Colors.grey[850] : null,
                    colorBlendMode: BlendMode.saturation,
                  ),
                ),
              ),
            ),
            if (isHovered && widget.description.isNotEmpty)
              Container(
                height: 80.h,
                width: MediaQuery.of(context).size.width / 5.4,
                color: theme.colorScheme.secondary,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
                  child: Center(
                    child: Text(
                      widget.description,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                        fontSize: DeviceConstraints.getResponsiveSize(context, 14.sp, 14.sp, 14.sp),
                        fontWeight: FontWeight.normal,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
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
