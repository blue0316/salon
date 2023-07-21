import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../models/enums/status.dart';
import '../../theme/app_main_theme.dart';
import '../../utils/icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LogoDark extends StatelessWidget {
  const LogoDark({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80.sp,
      width: 80.sp,
      child: Center(
        child: Image.asset(AppIcons.logoBnbPNG),
      ),
    );
  }
}

void showToast(message, {duration = const Duration(seconds: 1)}) => BotToast.showText(
      text: message,
      duration: duration,
    );

void showToast2(context, {duration = const Duration(seconds: 1)}) => BotToast.showText(
      text: AppLocalizations.of(context)?.new_code_sent ?? 'New Code Sent',
      duration: duration,
      contentColor: const Color(
        0xff4BBB53,
      ),
    );

class Loader extends StatelessWidget {
  final Widget? child;
  final Status? status;
  final EdgeInsetsGeometry iconPadding;
  final Widget? errorWidget;

  const Loader({
    Key? key,
    this.status,
    this.child,
    this.iconPadding = EdgeInsets.zero,
    this.errorWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (status == Status.loading) {
      return Container(
        alignment: Alignment.center,
        padding: iconPadding,
        child: const CircularProgressIndicator(),
      );
    }
    if (status == Status.success) {
      return child ?? Container();
    } else {
      return errorWidget ??
          Container(
            alignment: Alignment.center,
            padding: iconPadding,
            child: const Icon(Icons.error_outline_outlined),
          );
    }
  }
}

class Space extends StatelessWidget {
  final double? height;
  final double factor;

  const Space({Key? key, this.height, this.factor = 1}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? (AppTheme.margin * factor),
    );
  }
}

class SpaceHorizontal extends StatelessWidget {
  final double? width;
  final double factor;

  const SpaceHorizontal({Key? key, this.width, this.factor = 1}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? (AppTheme.margin * factor),
    );
  }
}

class Back extends StatelessWidget {
  final bool showBackButton;

  const Back({Key? key, this.showBackButton = true}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return showBackButton
        ? GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Icon(
                Icons.arrow_back,
                size: 24,
                color: AppTheme.textBlack,
              ),
            ),
          )
        : const SizedBox(
            height: 24,
          );
  }
}

class BnbRatings extends ConsumerWidget {
  final double rating;
  final bool editable;
  final double starSize;
  final Function? onRatingUpdate;
  final Color? color, unratedColor;
  final double? padding;

  const BnbRatings({
    Key? key,
    required this.rating,
    required this.editable,
    required this.starSize,
    this.onRatingUpdate,
    this.color,
    this.unratedColor,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RatingBar.builder(
      unratedColor: unratedColor ?? Colors.white, // Changed to reflect properly on Booking Dialog
      initialRating: rating,
      minRating: 0,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemPadding: EdgeInsets.symmetric(horizontal: padding ?? 0.0),
      itemBuilder: (context, _) {
        return SvgPicture.asset(
          'assets/icons/flutterRating.svg',
          color: color ?? AppTheme.bookingYellow,
        );
      },
      onRatingUpdate: (rating) {
        onRatingUpdate!();
      },
      itemSize: DeviceConstraints.getResponsiveSize(context, starSize, starSize * 1.2, starSize * 1.3),
      glow: false,
      updateOnDrag: true,
      ignoreGestures: !editable,
    );
  }
}

class CategoryButton extends ConsumerWidget {
  final String title;
  final String id;
  final String selectedCategoryId;

  const CategoryButton({
    Key? key,
    required this.title,
    required this.id,
    required this.selectedCategoryId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return Material(
      child: Ink(
        height: 60,
        width: DeviceConstraints.getResponsiveSize(context, 170, 190, 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.sp),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.all(6.0.sp),
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.lightBlack,
                  borderRadius: BorderRadius.circular(12.sp),
                ),
                child: Padding(
                  padding: EdgeInsets.all(12.0.sp),
                  child:
                      // Image.asset(AppIcons.getIconFromCategoryId(id: id),color:Colors.white)
                      SvgPicture.asset(
                    AppIcons.getIconFromCategoryId(id: id),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 6.w,
            ),
            Flexible(
              child: Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                maxLines: 2,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CustomDivider extends StatelessWidget {
  final double left;
  final double top;
  final double right;
  final double bottom;
  final Color? color;
  final double width;
  final double? height;

  const CustomDivider({
    this.left = 0,
    this.top = 0,
    this.right = 0,
    this.bottom = 0,
    this.color,
    this.height,
    this.width = 1.0,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return height == null
        ? Container(
            margin: EdgeInsets.fromLTRB(left, top, right, bottom),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: color ?? Theme.of(context).dividerColor, width: width)),
            ),
          )
        : Container(
            color: color ?? Theme.of(context).dividerColor,
            width: width,
            height: height,
          );
  }
}

///standard reusable container that provides standard margin, and max-width
class ConstrainedContainer extends StatelessWidget {
  final EdgeInsets margin;
  final Widget? child;
  final double? maxWidth;
  final bool isLargeSize;
  final bool disableCenter;
  final Alignment? alignment;

  const ConstrainedContainer({
    this.margin = const EdgeInsets.symmetric(horizontal: 0),
    this.child,
    this.maxWidth,
    this.isLargeSize = true,
    Key? key,
    this.disableCenter = false,
    this.alignment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment ?? Alignment.topCenter,
      child: Container(
        margin: margin,
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? (isLargeSize ? DeviceConstraints.breakPointTab : DeviceConstraints.breakPointPhone),
        ),
        child: child,
      ),
    );
  }
}
