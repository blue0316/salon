import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/enums/service_specialist.dart';
import '../../../../theme/app_main_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ServiceSpecialistFilter extends ConsumerWidget {
  const ServiceSpecialistFilter({
    Key? key,
  }) : super(key: key);

// selectedValue: salonSearchController.serviceSpecialistTemp,
  // onChange: salonSearchController.onSpecialistChange,
  @override
  Widget build(BuildContext context, ref) {
    final _salonSearchProvider = ref.watch(salonSearchProvider);
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
                AppLocalizations.of(context)?.serviceSpecialist ?? "Service specialist",
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          ),
          const Divider(
            color: AppTheme.coolGrey,
          ),
          RadioListTile(
            value: ServiceSpecialist.all,
            groupValue: _salonSearchProvider.serviceSpecialistTemp,
            onChanged: (val) => _salonSearchProvider.onSpecialistChange(val.toString()),
            title: Text(AppLocalizations.of(context)?.all ?? "All"),
          ),
          RadioListTile(
            value: ServiceSpecialist.salon,
            groupValue: _salonSearchProvider.serviceSpecialistTemp,
            onChanged: (val) => _salonSearchProvider.onSpecialistChange(val.toString()),
            title: Text(AppLocalizations.of(context)?.onlySaloons ?? "Only Saloons"),
          ),
          RadioListTile(
            value: ServiceSpecialist.singleMaster,
            groupValue: _salonSearchProvider.serviceSpecialistTemp,
            onChanged: (val) => _salonSearchProvider.onSpecialistChange(val.toString()),
            title: Text(AppLocalizations.of(context)?.onlyMasters ?? "Only masters"),
          )
        ],
      ),
    );
  }
}
