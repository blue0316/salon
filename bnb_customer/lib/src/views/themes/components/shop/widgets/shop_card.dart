import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/products.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShopCard extends ConsumerWidget {
  final ProductModel product;

  const ShopCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size.width;
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    // final int? themeNo = _salonProfileProvider.chosenSalon.selectedTheme;

    return Padding(
      padding: EdgeInsets.only(right: 20.sp),
      child: SizedBox(
        // color: Colors.orange,
        width: DeviceConstraints.getResponsiveSize(
          context,
          size / 1.5.sp,
          size / 2.3.sp,
          70.w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: theme.primaryColorDark, // Colors.transparent,
                  // border: Border.all(color: theme.primaryColorDark, width: 0.3),
                ),
                // height: 300.h,
                width: DeviceConstraints.getResponsiveSize(
                  context,
                  size / 1.5.sp,
                  size / 2.3.sp,
                  70.w,
                ),

                child: (product.productImageUrlList!.isNotEmpty)
                    ? CachedImage(
                        url: '${product.productImageUrlList![0]}',
                        fit: BoxFit.cover,
                      )
                    : Center(
                        child: Text(
                          'Photo N/A',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.white,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
              ),
            ),
            SizedBox(height: 10.sp),
            Expanded(
              flex: 0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 45.sp,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${product.productName}',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.primaryColorDark,
                            fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 16.sp, 16.sp),
                            fontWeight: FontWeight.normal,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                  // Spacer(),
                  SizedBox(height: 10.sp),
                  Text(
                    '\$${product.clientPrice}',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.primaryColorLight,
                      fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 16.sp, 16.sp),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
