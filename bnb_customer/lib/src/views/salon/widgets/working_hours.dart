import 'package:bbblient/src/models/backend_codings/working_hours.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WorkingHoursTable extends StatelessWidget {
  final WorkingHoursModel workingHoursModel;
  const WorkingHoursTable({required this.workingHoursModel, Key? key})
      : super(key: key);

  String trimWeekday(String text) => text.substring(0, 3);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)?.openingHours ?? "Opening hours",
          style: Theme.of(context).textTheme.subtitle1,
        ),
        SizedBox(
          height: 20.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                "${trimWeekday(AppLocalizations.of(context)!.mon)}, ${trimWeekday(AppLocalizations.of(context)!.tue)}, ${trimWeekday(AppLocalizations.of(context)!.wed)}, ${trimWeekday(AppLocalizations.of(context)!.thu)}, ${trimWeekday(AppLocalizations.of(context)!.fri)}"),
            Text(
              "${workingHoursModel.mon.startTime} - ${workingHoursModel.mon.endTime}",
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
        SizedBox(
          height: 8.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                "${trimWeekday(AppLocalizations.of(context)!.sat)}, ${trimWeekday(AppLocalizations.of(context)!.sun)}"),
            Text(
              "${workingHoursModel.sun.startTime} - ${workingHoursModel.sun.endTime}",
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
        SizedBox(
          height: 40.h,
        ),
      ],
    );
  }
}
