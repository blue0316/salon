import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/views/widgets/salon_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/salon_master/salon.dart';
import '../../../../theme/app_main_theme.dart';
import '../../../widgets/widgets.dart';

class SalonSearchResult extends ConsumerWidget {
  final bool showAllNearby;
  const SalonSearchResult({required this.showAllNearby, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final _salonSearchProvider = ref.watch(salonSearchProvider);
    final _mapViewProvider = ref.watch(mapViewProvider);
    return Container(
      color: AppTheme.coolerGrey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (SalonModel salon in showAllNearby ? _salonSearchProvider.nearbySalons : _salonSearchProvider.filteredSalons)
            SalonCard(
                onTap: () => _mapViewProvider.onSelectedSalonChange(salon: salon),
                isSelected: salon.salonId == _mapViewProvider.selectedSalonId,
                salon: salon),
          const Space(
            height: 8,
          ),
        ],
      ),
    );
  }
}
