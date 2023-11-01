import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../theme/app_main_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguagePreferences extends ConsumerWidget {
  const LanguagePreferences({Key? key}) : super(key: key);

  final List<Locale> languages = const [
    Locale('en'),
    Locale('uk'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _bnbProvider = ref.watch(bnbProvider);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          AppLocalizations.of(context)?.language ?? "Language",
          style: Theme.of(context).textTheme.bodyText1,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          InkWell(
            onTap: () {
              _bnbProvider.changeLocale(locale: const Locale('uk'));
            },
            child: Ink(
              height: 57,
              decoration: BoxDecoration(
                border: const Border(
                  bottom: BorderSide(color: Colors.white, width: 2),
                ),
                color: _bnbProvider.getLocale.toString() == 'uk' ? Colors.white : AppTheme.milkeyGrey,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('українська'),
                    SizedBox(
                      height: 16,
                      width: 16,
                      child: _bnbProvider.getLocale.toString() == 'uk'
                          ? SvgPicture.asset('assets/icons/check_brown.svg')
                          : const SizedBox(),
                    )
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              _bnbProvider.changeLocale(locale: const Locale('en'));
              printIt(_bnbProvider.getLocale.toString());
            },
            child: Ink(
              height: 57,
              decoration: BoxDecoration(
                border: const Border(
                  bottom: BorderSide(color: Colors.white, width: 2),
                ),
                color: _bnbProvider.getLocale.toString() == 'en' ? Colors.white : AppTheme.milkeyGrey,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("english"),
                    SizedBox(
                      height: 16,
                      width: 16,
                      child: _bnbProvider.getLocale.toString() == 'en'
                          ? SvgPicture.asset('assets/icons/check_brown.svg')
                          : const SizedBox(),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
