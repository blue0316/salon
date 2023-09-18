import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GlamLightShop extends ConsumerStatefulWidget {
  const GlamLightShop({Key? key}) : super(key: key);

  @override
  ConsumerState<GlamLightShop> createState() => _GlamLightShopState();
}

class _GlamLightShopState extends ConsumerState<GlamLightShop> {
  @override
  Widget build(BuildContext context) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    // final List<ProductModel> allProducts = _salonProfileProvider.allProducts;

    return Padding(
      padding: EdgeInsets.only(
        left: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w),
        right: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w),
        // top: DeviceConstraints.getResponsiveSize(context, 30.h, 50.h, 50.h),
        top: DeviceConstraints.getResponsiveSize(context, 90.h, 100.h, 120.h),

        bottom: 50,
      ),
      child: Column(
        children: [
          Center(
            child: Text(
              'Products'.toUpperCase(),
              // (AppLocalizations.of(context)?.produc ?? 'Shop').toUpperCase(),
              style: theme.textTheme.displayMedium?.copyWith(
                fontSize: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 60.sp),
              ),
            ),
          ),
          _salonProfileProvider.allProducts.isNotEmpty ? SizedBox(height: 70.sp) : const SizedBox(height: 50),
          (_salonProfileProvider.allProducts.isNotEmpty)
              ? Expanded(
                  flex: 0,
                  child: Container(
                    height: 500.h,
                    width: double.infinity,
                    color: Colors.amber,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Text(
                      (AppLocalizations.of(context)?.noItemsAvailable ?? 'No items available for sale').toUpperCase(),
                      style: theme.textTheme.bodyLarge?.copyWith(
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
