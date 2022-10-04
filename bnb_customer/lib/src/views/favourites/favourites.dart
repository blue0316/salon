import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/bnb/bnb_provider.dart';
import 'package:bbblient/src/controller/home/salon_search_provider.dart';
import 'package:bbblient/src/firebase/salons.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/salon/salon_home/salon_profile.dart';
import 'package:bbblient/src/views/widgets/salon_widgets.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../theme/app_main_theme.dart';
import '../../utils/icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Favourites extends ConsumerStatefulWidget {
  const Favourites({Key? key}) : super(key: key);

  @override
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends ConsumerState<Favourites> {
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    BnbProvider _bnbProvider = ref.watch(bnbProvider);
    SalonSearchProvider _salonProvider = ref.watch(salonSearchProvider);

    return Scaffold(
      body: ConstrainedContainer(
        margin:const EdgeInsets.symmetric(horizontal: 16),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 37.0.h, bottom: 24.h),
                  child: Text(
                    AppLocalizations.of(context)?.favourites ?? "Favourites",
                    style: Theme.of(context)
                        .textTheme
                        .headline4!
                        .copyWith(color: AppTheme.textBlack),
                  ),
                ),
                SizedBox(
                  height: 40,
                  width: 40,
                  child: SvgPicture.asset(AppIcons.favouritesHeartSVG),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: SizedBox(
                    height: 52,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none),
                                hintText:
                                    AppLocalizations.of(context)?.search ??
                                        "Search"),
                          ),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        // SizedBox(
                        //   height: 52,
                        //   width: 52,
                        //   child: GestureDetector(
                        //     onTap: () {
                        //       Navigator.push(context, MaterialPageRoute(builder: (context) => FilterSearch()));
                        //     },
                        //     child: Container(
                        //       decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(12),
                        //         color: AppTheme.creamBrown,
                        //       ),
                        //       child: Padding(
                        //         padding: const EdgeInsets.all(14.0),
                        //         child: SvgPicture.asset(AppIcons.filterSVG),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 32.h,
                ),
                _bnbProvider
                        .isFavPresent(_salonProvider.nearbySalons)
                    ? DeviceConstraints.getDeviceType(mediaQuery) ==
                            DeviceScreenType.tab
                        ? GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _salonProvider.nearbySalons.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 14,
                              crossAxisSpacing: 14,
                            ),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final SalonModel _salon =
                                  _salonProvider.nearbySalons[index];
                              if (_bnbProvider
                                  .checkForFav(_salon.salonId)) {
                                return SalonContainerForWeb(
                                  salon: _salon,
                                  showDialogForFavToggle: true,
                                  isFav: _bnbProvider
                                      .checkForFav(_salon.salonId),
                                  onFavouriteCallback: () => _bnbProvider
                                      .toggleFav(_salon.salonId),
                                  onBookTapped: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        settings: const RouteSettings(
                                            name: SalonPage.route),
                                        builder: (context) => SalonPage(
                                          salonId: _salon.salonId,
                                          switchSalon: true,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                              return Container();
                            },
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: _salonProvider.nearbySalons.length,
                            itemBuilder: (BuildContext context, int index) {
                              final SalonModel _salon =
                                  _salonProvider.nearbySalons[index];
                              if (_bnbProvider
                                  .checkForFav(_salon.salonId)) {
                                return SalonContainer(
                                  isFav: _bnbProvider
                                      .checkForFav(_salon.salonId),
                                  salon: _salon,
                                  showDialogForFavToggle: true,
                                  onFavouriteCallback: () => _bnbProvider
                                      .toggleFav(_salon.salonId),
                                  onBookTapped: () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        settings: const RouteSettings(
                                            name: SalonPage.route),
                                        builder: (context) => SalonPage(

                                          salonId: _salon.salonId,
                                          switchSalon: true,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                              return Container();
                            })
                    : Column(
                        children: [
                          const SizedBox(
                            height: 16,
                          ),
                          // this is when there are not favourites
                          Stack(
                            children: [
                              SizedBox(
                                height: 108,
                                child: Image.asset(AppIcons.noFavsPNG),
                              ),
                              Positioned(
                                right: 24,
                                top: 52,
                                child: Text(
                                  AppLocalizations.of(context)
                                          ?.noFavouritesYet ??
                                      "No favourites yet",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4!
                                      .copyWith(
                                          color: AppTheme.textBlack,
                                          fontSize: 16),
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24.0, vertical: 50),
                            child: Text(
                              AppLocalizations.of(context)
                                      ?.saveFavourites ??
                                  "Save salons and masters you like by tapping on heart",
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
