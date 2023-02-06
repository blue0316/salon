import 'package:bbblient/src/views/home/map_view/map_view.dart';
import 'package:bbblient/src/views/search/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../theme/app_main_theme.dart';
import '../../../utils/icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchField extends ConsumerWidget {
  const SearchField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Search(locale: Localizations.localeOf(context).languageCode)));
            },
            child: SizedBox(
              height: 54,
              child: TextField(
                enabled: false,
                autofocus: false,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  hintText: AppLocalizations.of(context)?.search ?? "Search",
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 8.h,
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MapView(
                          showAllNearby: true,
                        )));
          },
          child: Container(
            height: 54,
            width: 54,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.sp),
              color: AppTheme.creamBrown,
            ),
            child: Center(
              child: SizedBox(
                height: 24,
                width: 24,
                child: SvgPicture.asset(AppIcons.mapPinWhiteSVG),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
