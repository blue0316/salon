import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/salon_master/master.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'widgets/review_builder.dart';
import 'widgets/section_title.dart';

class DefaultReviewsView extends ConsumerStatefulWidget {
  final MasterModel masterModel;
  final CarouselController controller;

  const DefaultReviewsView({Key? key, required this.masterModel, required this.controller}) : super(key: key);

  @override
  ConsumerState<DefaultReviewsView> createState() => _DefaultReviewsViewState();
}

class _DefaultReviewsViewState extends ConsumerState<DefaultReviewsView> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  @override
  Widget build(BuildContext context) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    return Padding(
      padding: EdgeInsets.only(
        left: DeviceConstraints.getResponsiveSize(context, 20.w, 50.w, 50.w),
        right: DeviceConstraints.getResponsiveSize(context, 20.w, 50.w, 50.w),
        top: DeviceConstraints.getResponsiveSize(context, 140.h, 180.h, 200.h),
        bottom: DeviceConstraints.getResponsiveSize(context, 140.h, 180.h, 200.h),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ReviewSectionTitle(
            masterModel: widget.masterModel,
            controller: widget.controller,
            itemPositionsListener: itemPositionsListener,
            itemScrollController: itemScrollController,
          ),
          const SizedBox(height: 40),
          (ref.watch(salonProfileProvider).masterReviews.isNotEmpty)
              ? ReviewBuilder(
                  controller: widget.controller,
                  itemPositionsListener: itemPositionsListener,
                  itemScrollController: itemScrollController,
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      (AppLocalizations.of(context)?.noReviews ?? 'No reviews yet').toUpperCase(),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: DeviceConstraints.getResponsiveSize(context, 25.sp, 25.sp, 25.sp),
                      ),
                    ),
                  ),
                ),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }
}
