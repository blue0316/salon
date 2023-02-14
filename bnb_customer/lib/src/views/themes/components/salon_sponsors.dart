import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SalonSponsors extends ConsumerWidget {
  const SalonSponsors({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    // final int? themeNo = _salonProfileProvider.chosenSalon.selectedTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: Column(
        children: [
          Divider(color: theme.dividerColor, thickness: 2),
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: tags.length,
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
                          tags[index],
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

List<String> tags = [
  'CONRAD',
  'ebay',
  'Zalando',
  'bol.com',
  'amazon',
  'ebay',
  'Zalando',
  'Zalando',
  'bol.com',
  'amazon',
  'ebay',
  'Zalando',
  'bol.com',
  'Zalando',
  'bol.com',
  'amazon',
  'ebay',
  'Zalando',
  'CONRAD',
  'ebay',
  'Zalando',
];
