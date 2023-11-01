import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/enums/gender.dart';
import '../../../../theme/app_main_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GenderFilter extends ConsumerStatefulWidget {
  const GenderFilter({Key? key}) : super(key: key);

  @override
  _GenderFilterState createState() => _GenderFilterState();
}

class _GenderFilterState extends ConsumerState<GenderFilter> {
  @override
  Widget build(BuildContext context) {
    final salonSearchController = ref.watch(salonSearchProvider);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                AppLocalizations.of(context)?.serviceFor ?? "Service for",
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          ),
          const Divider(
            color: AppTheme.coolGrey,
          ),
          RadioListTile(
            value: PreferredGender.all,
            groupValue: salonSearchController.selectedGenderTemp,
            onChanged: (dynamic val) => salonSearchController.onGenderChange(val),
            title: Text(AppLocalizations.of(context)?.all ?? "All"),
          ),
          RadioListTile(
            value: PreferredGender.men,
            groupValue: salonSearchController.selectedGenderTemp,
            onChanged: (dynamic val) => salonSearchController.onGenderChange(val),
            title: Text(AppLocalizations.of(context)?.men ?? "Men"),
          ),
          RadioListTile(
            value: PreferredGender.women,
            groupValue: salonSearchController.selectedGenderTemp,
            onChanged: (dynamic val) => salonSearchController.onGenderChange(val),
            title: Text(AppLocalizations.of(context)?.forWoman ?? "Women"),
          ),
        ],
      ),
    );
  }
}
