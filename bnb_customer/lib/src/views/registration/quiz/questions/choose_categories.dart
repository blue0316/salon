import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/cat_sub_service/category_service.dart';
import 'package:bbblient/src/models/enums/gender.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChooseCategories extends ConsumerWidget {
  const ChooseCategories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final _quizProvider = ref.watch(quizProvider);
    final _salonSearchProvider = ref.read(salonSearchProvider);
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 30.0, bottom: 8, left: 24.sp, right: 24.sp),
          child: Text(
            AppLocalizations.of(context)?.chooseThreeWords ?? "Choose at least three words describing\nyour preferences",
            style: Theme.of(context).textTheme.headline4,
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(18.0.sp),
          child: Wrap(
            runSpacing: 18.sp,
            spacing: 18.sp,
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.center,
            children: [
              for (CategoryModel cat in _salonSearchProvider.categories)
                GestureDetector(
                  onTap: () {
                    _quizProvider.onTapCategory(catId: cat.categoryId);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                        color:
                            _quizProvider.selectedCategories.contains(cat.categoryId) ? AppTheme.creamBrownLight : Colors.white,
                        border: Border.all(
                          color: _quizProvider.selectedCategories.contains(cat.categoryId)
                              ? AppTheme.creamBrownLight
                              : AppTheme.grey2,
                        ),
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 6.sp),
                        child: Text(
                          cat.translations[AppLocalizations.of(context)?.localeName ?? 'en'],
                          style: _quizProvider.selectedCategories.contains(cat.categoryId)
                              ? AppTheme.subTitle1.copyWith(color: Colors.white)
                              : AppTheme.subTitle1.copyWith(color: AppTheme.lightGrey),
                        )),
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 32.0, bottom: 0),
          child: Text(
            AppLocalizations.of(context)?.preferServicesFor ?? "do you prefer services for",
            style: Theme.of(context).textTheme.headline4,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Wrap(
            alignment: WrapAlignment.center,
            runSpacing: 8.sp,
            spacing: 8.sp,
            children: [
              Tile(
                svg: 'assets/images/women.png',
                label: AppLocalizations.of(context)?.women ?? "Women",
                onTap: () => _quizProvider.setGender(PreferredGender.women),
                isSelected: _quizProvider.preferredGender == PreferredGender.women,
              ),
              Tile(
                svg: 'assets/images/men.png',
                label: AppLocalizations.of(context)?.men ?? "Men",
                onTap: () => _quizProvider.setGender(PreferredGender.men),
                isSelected: _quizProvider.preferredGender == PreferredGender.men,
              ),
              Tile(
                svg: 'assets/images/allsex.png',
                label: AppLocalizations.of(context)?.all ?? "All",
                onTap: () => _quizProvider.setGender(PreferredGender.all),
                isSelected: _quizProvider.preferredGender == PreferredGender.all,
              )
            ],
          ),
        )
      ],
    );
  }
}

class Tile extends StatelessWidget {
  final String svg;
  final String label;
  final Function onTap;
  final bool isSelected;
  const Tile({
    Key? key,
    required this.svg,
    required this.label,
    required this.onTap,
    required this.isSelected,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap as void Function()?,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
              color: isSelected ? AppTheme.creamBrownLight : Colors.white,
              border: Border.all(
                color: isSelected ? AppTheme.creamBrownLight : AppTheme.grey2,
              ),
              borderRadius: BorderRadius.circular(50)),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 6.sp),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 35, height: 35, child: Image.asset(svg)),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  label,
                  style: isSelected
                      ? AppTheme.subTitle1.copyWith(color: Colors.white)
                      : AppTheme.subTitle1.copyWith(color: AppTheme.lightGrey),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


 // GestureDetector(
              //   onTap: () {
              //     _quizProvider.setLocale("uk");
              //     _bnbProvider.changeLocale(locale: const Locale('uk'));
              //   },
              //   child: AnimatedContainer(
              //     duration: const Duration(milliseconds: 300),
              //     decoration: BoxDecoration(
              //         color: _quizProvider.locale == "uk" ? AppTheme.creamBrownLight : Colors.white,
              //         border: Border.all(
              //           color: _quizProvider.locale == "uk" ? AppTheme.creamBrownLight : AppTheme.grey2,
              //         ),
              //         borderRadius: BorderRadius.circular(20)),
              //     child: Padding(
              //         padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 6.sp),
              //         child: Text(
              //           'українська',
              //           style: _quizProvider.locale == "uk"
              //               ? AppTheme.subTitle1.copyWith(color: Colors.white)
              //               : AppTheme.subTitle1.copyWith(color: AppTheme.lightGrey),
              //         )),
              //   ),
              // ),
              // SizedBox(width: 18.sp),
              // GestureDetector(
              //   onTap: () {
              //     _quizProvider.setLocale("en");
              //     _bnbProvider.changeLocale(locale: const Locale('en'));
              //   },
              //   child: AnimatedContainer(
              //     duration: const Duration(milliseconds: 300),
              //     decoration: BoxDecoration(
              //         color: _quizProvider.locale == "en" ? AppTheme.creamBrownLight : Colors.white,
              //         border: Border.all(
              //           color: _quizProvider.locale == "en" ? AppTheme.creamBrownLight : AppTheme.grey2,
              //         ),
              //         borderRadius: BorderRadius.circular(20)),
              //     child: Padding(
              //         padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 6.sp),
              //         child: Text(
              //           'english',
              //           style: _quizProvider.locale == "en"
              //               ? AppTheme.subTitle1.copyWith(color: Colors.white)
              //               : AppTheme.subTitle1.copyWith(color: AppTheme.lightGrey),
              //         )),
              //   ),
              // ),