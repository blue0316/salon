import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/views/home/search/search_category_wise.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../models/cat_sub_service/category_service.dart';
import '../../utils/icons.dart';
import '../../utils/translation.dart';
import '../widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChooseCategory extends ConsumerStatefulWidget {
  const ChooseCategory({Key? key}) : super(key: key);
  @override
  _ChooseCategoryState createState() => _ChooseCategoryState();
}

class _ChooseCategoryState extends ConsumerState<ChooseCategory> {
  CrossFadeState servicesMenuState = CrossFadeState.showFirst;
  @override
  Widget build(BuildContext context) {
    final _salonSearchProvider = ref.watch(salonSearchProvider);

    return Column(
      children: [
        AnimatedCrossFade(
          firstChild: SizedBox(
            height: 60.h,
            child: ListView(
              primary: false,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.margin),
              children: [
                for (CategoryModel cat in _salonSearchProvider.categories)
                  Padding(
                    padding: EdgeInsets.only(
                      right: 12.0.w,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        _salonSearchProvider.chooseCategory(cat.categoryId);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const SearchCategoryWise()));
                      },
                      child: CategoryButton(
                          id: cat.categoryId,
                          selectedCategoryId:
                              _salonSearchProvider.selectedCategoryId ?? '',
                          title: Translation.getCatName(
                              cat: cat,
                              langCode:
                                  AppLocalizations.of(context)?.localeName ??
                                      'en')),
                    ),
                  )
              ],
            ),
          ),
          secondChild: Wrap(
            runSpacing: 12.sp,
            spacing: 12.sp,
            children: [
              for (CategoryModel cat in _salonSearchProvider.categories)
                GestureDetector(
                  onTap: () {
                  
                    _salonSearchProvider.chooseCategory(cat.categoryId);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SearchCategoryWise()));
                  },
                  child: CategoryButton(
                      id: cat.categoryId,
                      selectedCategoryId:
                          _salonSearchProvider.selectedCategoryId ?? '',
                      title: Translation.getCatName(
                          cat: cat,
                          langCode: AppLocalizations.of(context)?.localeName ??
                              'en')),
                )
            ],
          ),
          crossFadeState: servicesMenuState,
          firstCurve: Curves.easeIn,
          sizeCurve: Curves.easeIn,
          secondCurve: Curves.easeIn,
          duration: const Duration(milliseconds: 300),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: AppTheme.margin, right: AppTheme.margin),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (servicesMenuState == CrossFadeState.showFirst) {
                      servicesMenuState = CrossFadeState.showSecond;
                    } else {
                      servicesMenuState = CrossFadeState.showFirst;
                    }
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  height: 32,
                  width: 32,
                  child: Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: SvgPicture.asset(
                      servicesMenuState == CrossFadeState.showFirst
                          ? AppIcons.arrowDownSVG
                          : AppIcons.arrowUpSVG,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
