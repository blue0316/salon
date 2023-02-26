import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Map<String, Color> tagColor = {
//   '1': const Color(0XFFF48B72),
//   '2': Colors.white,
//   '3': Colors.white,
//   '4': Colors.white,
//   '5': Colors.white,
//   'null': Colors.white,
// };

class SalonTags extends ConsumerWidget {
  final List<String> additionalFeatures;
  const SalonTags({Key? key, required this.additionalFeatures}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    // final int? themeNo = _salonProfileProvider.chosenSalon.selectedTheme;

    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 50),
      child: Column(
        children: [
          Divider(color: theme.dividerColor, thickness: 2),
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: additionalFeatures.length,
              itemBuilder: ((context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          convertLowerCamelCase(additionalFeatures[index]),
                          style: theme.textTheme.bodyText1?.copyWith(
                            color: theme.dividerColor,
                            fontSize: 18.sp,
                          ),
                        ),
                      ),
                      Container(
                        height: 8.h,
                        width: 8.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.dividerColor,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          Divider(color: theme.dividerColor, thickness: 2),
        ],
      ),
    );
  }
}

String convertLowerCamelCase(String input) {
  var output = '';
  for (var i = 0; i < input.length; i++) {
    if (i == 0) {
      output += input[i].toLowerCase();
    } else if (input[i].toUpperCase() == input[i]) {
      output += ' ' + input[i].toLowerCase();
    } else {
      output += input[i];
    }
  }
  return output.toLowerCase();
}

// List<String> tags = [
//   'Coffee/Tea',
//   'Pet friendly',
//   'Parking',
//   'covid-19 vaccinated',
//   'Medical degree',
//   'instruments sterilization',
//   'Disposable materials only',
//   'Pet friendly',
//   'Parking',
//   'covid-19 vaccinated',
//   'Medical degree',
//   'Medical degree',
//   'instruments sterilization',
//   'Disposable materials only',
// ];
