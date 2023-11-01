import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/home/map_view_provider.dart';
import 'package:bbblient/src/controller/home/salon_search_provider.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/views/home/map_view/pick_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../theme/app_main_theme.dart';
import '../../widgets/widgets.dart';
import '../search/filter/filter.dart';
import 'bottom_sheets/salon_description.dart';
import 'bottom_sheets/salon_search_result.dart';
import 'map.dart';

class MapView extends ConsumerStatefulWidget {
  final bool showAllNearby;
  const MapView({required this.showAllNearby, Key? key}) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends ConsumerState<MapView> {
  late MapViewProvider _mapViewProvider;

  @override
  void initState() {
    super.initState();
    initMap();
  }

  initMap() {
    _mapViewProvider = ref.read(mapViewProvider);
    _mapViewProvider.init();
  }

  @override
  Widget build(BuildContext context) {
    final _salonSearchProvider = ref.watch(salonSearchProvider);
    final _mapViewProvider = ref.watch(mapViewProvider);
    return Scaffold(
        appBar: _AppBar(),
        body: Stack(
          children: [
            MapWidget(
              salons: widget.showAllNearby ? _salonSearchProvider.nearbySalons : _salonSearchProvider.filteredSalons,
              selectedSalonId: _mapViewProvider.selectedSalonId,
              radius: _salonSearchProvider.searchRadius,
              center: _salonSearchProvider.tempCenter,
            ),
            _mapViewProvider.showSelectedSalon
                ? const SalonDescriptionDraggable()
                : SalonsDraggableList(
                    showAllNearby: widget.showAllNearby,
                  ),
            // _mapViewProvider.isSearching ? _SearchField() : Container()
          ],
        ));
  }
}

class SalonsDraggableList extends ConsumerWidget {
  final bool showAllNearby;
  const SalonsDraggableList({required this.showAllNearby, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return DraggableScrollableSheet(
        initialChildSize: 0.30,
        minChildSize: 0.3,
        maxChildSize: 0.75,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            decoration: const BoxDecoration(color: AppTheme.coolerGrey, borderRadius: BorderRadius.only(topLeft: Radius.circular(AppTheme.margin), topRight: Radius.circular(AppTheme.margin))),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(11.0),
                  child: Container(
                    width: 80,
                    height: 4,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: const Color(0xffD7D6D6)),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: SalonSearchResult(
                      showAllNearby: showAllNearby,
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}

class _AppBar extends ConsumerWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  Future pickLocation({required SalonSearchProvider salonSearchProvider, required BuildContext context}) async {
    bool? locationChanged = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PickLocation(),
      ),
    );
    if (locationChanged == true) {
      await salonSearchProvider.loadSalons();
      await salonSearchProvider.onApplyFilter();
      await salonSearchProvider.addPosition();
    }
  }

  @override
  Widget build(BuildContext context, ref) {
    final _salonSearchProvider = ref.watch(salonSearchProvider);
    final _mapViewProvider = ref.watch(mapViewProvider);
    return AppBar(
        backgroundColor: AppTheme.white,
        titleSpacing: AppTheme.margin / 2,
        leading: Padding(
          padding: const EdgeInsets.only(left: AppTheme.margin),
          child: InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: AppTheme.textBlack,
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
                child: SizedBox(
              height: 36,
              child: TextFormField(
                initialValue: _salonSearchProvider.tempAddress,
                readOnly: true,
                style: Theme.of(context).inputDecorationTheme.hintStyle!.copyWith(color: AppTheme.textBlack),
                decoration: InputDecoration(
                  //fillColor: backgroundLight,
                  contentPadding: const EdgeInsets.symmetric(horizontal: AppTheme.margin),
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  hintText: _salonSearchProvider.tempAddress,
                ),
              ),
            )),
            const SpaceHorizontal(),
            Material(
              child: InkWell(
                onTap: () {
                  pickLocation(salonSearchProvider: _salonSearchProvider, context: context);
                },
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Ink(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: _mapViewProvider.isSearching ? AppTheme.lightGrey : AppTheme.lightBlack),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                      AppIcons.locationCurrentSVG,
                      color: AppTheme.white,
                    ),
                  ),
                ),
              ),
            ),
            const SpaceHorizontal(),
            Material(
              child: InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FilterSearch())),
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Ink(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppTheme.lightBlack),
                  child: Padding(
                    padding: const EdgeInsets.all(9.0),
                    child: SvgPicture.asset('assets/images/Filter.svg'),
                  ),
                ),
              ),
            ),
            const SpaceHorizontal(
              factor: 0.5,
            ),
          ],
        ));
  }
}


// class _SearchField extends ConsumerStatefulWidget {
//   @override
//   __SearchFieldState createState() => __SearchFieldState();
// }

// class __SearchFieldState extends ConsumerState<_SearchField> {
//   @override
//   void dispose() {
//     //clears up the search element on dispose

//     super.dispose();
//     // Future.delayed(const Duration(milliseconds: 500), () => salonSearchController.onSearchChange(text: ""));
//   }

//   @override
//   Widget build(BuildContext context) {
//     final _salonSearchProvider = ref.watch(salonSearchProvider);

//     return Container(
//       height: 55,
//       margin: const EdgeInsets.symmetric(horizontal: AppTheme.margin, vertical: AppTheme.margin),
//       decoration: const BoxDecoration(boxShadow: [
//         BoxShadow(color: Colors.black26, blurRadius: 6.0, offset: Offset(0, 6)),
//       ]),
//       child: TextFormField(
//         onChanged: (val) {
//           _salonSearchProvider.onSearchChange(text: val);
//         },
//         style: Theme.of(context).inputDecorationTheme.hintStyle!.copyWith(color: AppTheme.textBlack),
//         decoration: InputDecoration(
//             fillColor: Colors.white,
//             filled: true,
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
//             prefixIcon: Padding(
//               padding: const EdgeInsets.all(14.0),
//               child: SvgPicture.asset(
//                 AppIcons.lensSVG,
//                 color: AppTheme.lightGrey,
//               ),
//             ),
//             hintText: AppLocalizations.of(context)?.search ?? "Search",
//             hintStyle: const TextStyle(
//                 fontFamily: "Montserrat",
//                 fontSize: 14,
//                 fontWeight: FontWeight.w300,
//                 color: AppTheme.lightGrey,
//                 fontStyle: FontStyle.italic)),
//       ),
//     );
//   }
// }