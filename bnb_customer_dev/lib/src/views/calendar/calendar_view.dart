import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/appointment/apointment_provider.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/app_main_theme.dart';
import 'calender.dart';
import 'event_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CalendarView extends ConsumerStatefulWidget {
  const CalendarView({Key? key}) : super(key: key);

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends ConsumerState<CalendarView> {
  late AppointmentProvider _appointmentProvider;
  @override
  void initState() {
    super.initState();
    if (mounted) {}
  }

  @override
  Widget build(BuildContext context) {
    _appointmentProvider = ref.watch(appointmentProvider);
    return Scaffold(
      body: ConstrainedContainer(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            children: [
              const Calender(),
              SizedBox(height: 30.0.h),
              (_appointmentProvider.selectedDayAppointments.isEmpty)
                  ? Padding(
                      padding: const EdgeInsets.only(top: AppTheme.margin),
                      child: Text(AppLocalizations.of(context)?.noAppointmentsFound ?? ''),
                    )
                  : ConstrainedContainer(
                    child: ListView.builder(
                        itemCount: _appointmentProvider.selectedDayAppointments.length,
                        primary: false,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return EventCard(
                            appointment: _appointmentProvider.selectedDayAppointments[index],
                          );
                        },
                      ),
                  )
            ],
          ),
        )),
      ),
    );
  }
}
