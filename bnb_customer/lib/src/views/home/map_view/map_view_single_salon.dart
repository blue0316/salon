import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../models/salon_master/salon.dart';
import '../../../theme/app_main_theme.dart';
import '../../widgets/widgets.dart';
import 'map.dart';

class MapViewSingleSalon extends ConsumerWidget {
  final SalonModel salon;

  const MapViewSingleSalon({Key? key, required this.salon}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final _salonSearchProvider = ref.watch(salonSearchProvider);
    return Scaffold(
        body: Stack(
      alignment: Alignment.bottomCenter,
      children: [
        MapWidget(
          salons: [salon],
          radius: _salonSearchProvider.searchRadius,
          center: _salonSearchProvider.tempCenter,
          selectedSalonId: '',
        ),
        Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.only(top: 42.h, left: 16.w),
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.lightBlack.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
              ),
              width: 50,
              height: 50,
              child: const Icon(
                CupertinoIcons.back,
                color: AppTheme.white,
                size: 24,
              ),
            ),
          ),
        ),
        ShowSingleSalon(salon: salon)
      ],
    ));
  }
}

class ShowSingleSalon extends StatelessWidget {
  final SalonModel salon;

  const ShowSingleSalon({Key? key, required this.salon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String _salonName = salon.salonName;
    final String _salonAddress = salon.address;
    final String _distance = "${salon.distanceFromCenter ?? "N/A"} Km";

    return Container(
      constraints: const BoxConstraints(maxWidth: 550, minHeight: 94, maxHeight: 94),
      alignment: Alignment.bottomCenter,
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.margin, vertical: AppTheme.margin),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppTheme.margin),
            child: CircleAvatar(
              backgroundColor: AppTheme.milkeyGrey,
              radius: 27,
              child: SizedBox(
                height: 20,
                width: 20,
                child: SvgPicture.asset('assets/icons/locationMarker.svg'),
              ),
            ),
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _salonName,
                  style: Theme.of(context).textTheme.headline4!.copyWith(color: AppTheme.textBlack),
                  overflow: TextOverflow.ellipsis,
                ),
                const Space(
                  factor: 1 / 4,
                ),
                Text(_salonAddress, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.headline4),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppTheme.margin),
            child: Text(_distance, style: Theme.of(context).textTheme.displaySmall!.copyWith(color: AppTheme.lightGrey)),
          ),
        ],
      ),
    );
  }
}
