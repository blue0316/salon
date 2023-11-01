import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/salon/widgets/additional%20featured.dart';
import 'package:bbblient/src/views/themes/components/salon_tags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VintageTags extends ConsumerStatefulWidget {
  final SalonModel salonModel;
  final List<String> additionalFeatures;

  const VintageTags({Key? key, required this.additionalFeatures, required this.salonModel}) : super(key: key);

  @override
  ConsumerState<VintageTags> createState() => _VintageTagsState();
}

class _VintageTagsState extends ConsumerState<VintageTags> {
  getFeature(String s) {
    final repository = ref.watch(bnbProvider);

    List<Map<String, String>> searchList = getFeaturesList(repository.locale.toString());

    for (Map registeredFeatures in searchList) {
      if (registeredFeatures.containsKey(s)) {
        return registeredFeatures[s];
      }
    }

    return s;
  }

  @override
  Widget build(BuildContext context) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Container(
        color: theme.colorScheme.secondary.withOpacity(0.4),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: DeviceConstraints.getResponsiveSize(context, 10.w, 10.w, 30.w),
            vertical: 40.sp,
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.spaceBetween,
              runAlignment: WrapAlignment.spaceBetween,
              runSpacing: 15.sp,
              children: widget.additionalFeatures
                  .map(
                    (item) => InkWell(
                      onTap: () {
                        final repository = ref.watch(bnbProvider);

                        print(repository.locale.toString());
                      },
                      child: GentleTouchTagItem(
                        title: getFeature(item),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }

  List<Map<String, String>> getFeaturesList(String locale) {
    switch (locale) {
      case 'uk':
        return ukSalonFeatures;
      case 'es':
        return esSalonFeatures;
      case 'fr':
        return frSalonFeatures;
      case 'pt':
        return ptSalonFeatures;
      case 'ro':
        return roSalonFeatures;
      case 'ar':
        return arSalonFeatures;

      default:
        return salonFeatures;
    }
  }
}
