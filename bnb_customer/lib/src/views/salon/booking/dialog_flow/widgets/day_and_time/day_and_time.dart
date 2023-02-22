import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DayAndTime extends ConsumerStatefulWidget {
  const DayAndTime({Key? key}) : super(key: key);

  @override
  ConsumerState<DayAndTime> createState() => _DayAndTimeState();
}

class _DayAndTimeState extends ConsumerState<DayAndTime> {
  @override
  Widget build(BuildContext context) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final _createAppointmentProvider = ref.watch(createAppointmentProvider);
    final _salonSearchProvider = ref.watch(salonSearchProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;
    bool defaultTheme = (theme == AppTheme.lightTheme);

    return Container(
      height: 100,
      color: Colors.green,
    );
  }
}
