import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/bnb/bnb_provider.dart';
import 'package:bbblient/src/controller/home/salon_search_provider.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/views/salon/salon_home/salon_profile.dart';
import 'package:bbblient/src/views/widgets/salon_widgets.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import '../../../theme/app_main_theme.dart';
import '../map_view/map_view.dart';
import 'filter/filter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:bbblient/src/views/salon/salon_home/salon_profile_copy.dart';

class SearchCategoryWise extends ConsumerStatefulWidget {
  const SearchCategoryWise({Key? key}) : super(key: key);

  @override
  _SearchCategoryWiseState createState() => _SearchCategoryWiseState();
}

class _SearchCategoryWiseState extends ConsumerState<SearchCategoryWise> {
  CrossFadeState servicesMenuState = CrossFadeState.showFirst;

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    final SalonSearchProvider _salonSearchProvider = ref.watch(salonSearchProvider);
    final BnbProvider _bnbProvider = ref.watch(bnbProvider);
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppTheme.milkeyGrey,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _salonSearchProvider.getCategoryNameFromId(_salonSearchProvider.selectedCategoryId ?? ''),
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ],
          ),
        ),
        body: ConstrainedContainer(
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: SvgPicture.asset(AppIcons.locationMarkerSVG),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Flexible(
                            child: Text(
                              _salonSearchProvider.tempAddress,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.headline4!.copyWith(fontWeight: FontWeight.w400),
                            ),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MapView(
                                    showAllNearby: false,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              AppLocalizations.of(context)?.viewOnMap ?? "View on map",
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Space(),
                    Padding(
                      padding: const EdgeInsets.only(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 52,
                              child: TextFormField(
                                onChanged: (val) {
                                  _salonSearchProvider.onSearchChange(text: val);
                                },
                                decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    prefixIcon: const Icon(
                                      Icons.search,
                                      color: Colors.grey,
                                    ),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                                    hintText: AppLocalizations.of(context)?.search ?? "Search"),
                              ),
                            ),
                          ),
                          const SpaceHorizontal(),
                          SizedBox(
                            height: 52,
                            width: 52,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const FilterSearch()));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: AppTheme.creamBrown,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: SvgPicture.asset(
                                    AppIcons.filterSVG,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Space(),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppLocalizations.of(context)?.results ?? "Results",
                          style: Theme.of(context).textTheme.headline4,
                        )),
                    const Space(),
                    if (_salonSearchProvider.filteredSalons.isEmpty) ...[
                      const SizedBox(
                        height: 16,
                      ),
                      Column(
                        children: [
                          SizedBox(
                            width: 0.5.sw,
                            height: 0.5.sw,
                            child: Image.asset(AppIcons.noLocationPNG),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            AppLocalizations.of(context)?.noSalonsNearbyTryDifferentLocation ?? "No salons found in filters",
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        ],
                      )
                    ],
                    DeviceConstraints.getDeviceType(mediaQuery) == DeviceScreenType.tab
                        ? GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _salonSearchProvider.nearbySalons.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                            ),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final SalonModel _salon = _salonSearchProvider.nearbySalons[index];
                              return SalonContainerForWeb(
                                  salon: _salon,
                                  showDialogForFavToggle: false,
                                  isFav: _bnbProvider.checkForFav(_salon.salonId),
                                  onFavouriteCallback: () => _bnbProvider.toggleFav(_salon.salonId),
                                  onBookTapped: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        settings: const RouteSettings(name: SalonPage.route),
                                        builder: (context) => SalonPage(
                                          salonId: _salon.salonId,
                                          switchSalon: true,
                                        ),
                                      ),
                                    );
                                  });
                            },
                          )
                        : ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _salonSearchProvider.filteredSalons.length,
                            itemBuilder: (BuildContext context, int index) {
                              final _salon = _salonSearchProvider.filteredSalons[index];
                              return SalonContainer(
                                salon: _salon,
                                showDialogForFavToggle: false,
                                isFav: _bnbProvider.checkForFav(_salon.salonId),
                                onFavouriteCallback: () => _bnbProvider.toggleFav(_salon.salonId),
                                onBookTapped: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SalonPage(salonId: _salonSearchProvider.filteredSalons[index].salonId, switchSalon: true),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
