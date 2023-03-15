import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'widgets/review_builder.dart';
import 'widgets/section_title.dart';

class DefaultReviewsView extends ConsumerStatefulWidget {
  final SalonModel salonModel;
  final CarouselController controller;

  const DefaultReviewsView({Key? key, required this.salonModel, required this.controller}) : super(key: key);

  @override
  ConsumerState<DefaultReviewsView> createState() => _DefaultReviewsViewState();
}

class _DefaultReviewsViewState extends ConsumerState<DefaultReviewsView> {
  @override
  Widget build(BuildContext context) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    return Padding(
      padding: EdgeInsets.only(
        left: DeviceConstraints.getResponsiveSize(context, 20.w, 50.w, 50.w),
        right: DeviceConstraints.getResponsiveSize(context, 20.w, 50.w, 50.w),
        top: 60,
        bottom: 100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ReviewSectionTitle(
            salonModel: widget.salonModel,
            controller: widget.controller,
          ),
          const SizedBox(height: 40),
          (_salonProfileProvider.salonReviews.isNotEmpty)
              ? ReviewBuilder(controller: widget.controller)
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      (AppLocalizations.of(context)?.noReviews ?? 'No reviews yet').toUpperCase(),
                      style: theme.textTheme.bodyText1?.copyWith(
                        fontSize: DeviceConstraints.getResponsiveSize(context, 20.sp, 20.sp, 20.sp),
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
