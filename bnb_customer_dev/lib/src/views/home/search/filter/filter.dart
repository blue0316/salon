import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/home/salon_search_provider.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../theme/app_main_theme.dart';
import '../../../widgets/widgets.dart';
import 'distance.dart';
import 'gender.dart';
import 'service_specialist.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FilterSearch extends ConsumerStatefulWidget {
  const FilterSearch({Key? key}) : super(key: key);

  @override
  _FilterSearchState createState() => _FilterSearchState();
}

class _FilterSearchState extends ConsumerState<FilterSearch> {
  late SalonSearchProvider salonSearchController;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    salonSearchController = ref.watch(salonSearchProvider);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        leading: const SizedBox(),
        title: Text(
          AppLocalizations.of(context)?.distanceArea ?? "Filters",
          style: Theme.of(context).textTheme.displaySmall,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: SizedBox(
              height: 15,
              width: 15,
              child: SvgPicture.asset(AppIcons.cancelSVG),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: const [
                  Space(
                    factor: 2,
                  ),
                  ServiceSpecialistFilter(),
                  Space(
                    factor: 2,
                  ),
                  //PriceFilter(),
                  // SizedBox(height: 32),
                  MapFilter(),
                  Space(
                    factor: 2,
                  ),
                  GenderFilter(),
                  // Space(
                  //   factor: 2,
                  // ),
                  // RatingFilter(),
                  SizedBox(height: 120),
                ],
              ),
            ),
          ),
          const BottomButton(),
        ],
      ),
    );
  }
}

class BottomButton extends ConsumerWidget {
  const BottomButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final salonSearchController = ref.watch(salonSearchProvider);
    return Positioned(
        bottom: 0,
        child: Container(
          padding: EdgeInsets.only(top: 12.h, bottom: AppTheme.margin * 2),
          width: 1.sw,
          decoration: const BoxDecoration(color: Colors.white),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                  onPressed: () {
                    salonSearchController.resetToDefault();
                    Navigator.pop(context);
                  },
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)?.reset ?? "Reset",
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  )),
              MaterialButton(
                onPressed: () {
                  salonSearchController.onApplyFilter();
                  Navigator.pop(context);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: AppTheme.creamBrown,
                height: 50.h,
                minWidth: 140.w,
                child: Text(
                  AppLocalizations.of(context)?.apply ?? "Apply",
                  style: Theme.of(context).textTheme.headline2,
                ),
              )
            ],
          ),
        ));
  }
}
