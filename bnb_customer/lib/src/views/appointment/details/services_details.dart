import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/appointment/appointment.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/currency/currency.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/appointment/widgets/row.dart';
import 'package:bbblient/src/views/appointment/widgets/theme_colors.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ServiceDetailsSection extends ConsumerWidget {
  final AppointmentModel? appointment;
  final ScrollController listViewController;
  final SalonModel? salon;

  const ServiceDetailsSection({Key? key, required this.appointment, required this.listViewController, required this.salon}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _appointmentProvider = ref.watch(appointmentProvider);
    ThemeData theme = _appointmentProvider.salonTheme ?? AppTheme.customLightTheme;

    ThemeType themeType = _appointmentProvider.themeType!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Services Details',
              style: theme.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 18.sp, 24.sp),
                color: confirmationTextColor(themeType, theme),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            // height: 1000.h,
            width: double.infinity,
            // color: Colors.white.withOpacity(0.7),
            child: ListView.builder(
              itemCount: appointment?.services.length,
              shrinkWrap: true,
              primary: false,
              controller: listViewController,
              padding: const EdgeInsets.all(0),
              itemBuilder: (context, index) {
                final Service service = appointment!.services[index];

                return Column(
                  children: [
                    ServiceDetails(
                      service: service,
                      salon: salon!,
                      appointment: appointment!,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceDetails extends ConsumerStatefulWidget {
  final Service service;
  final SalonModel salon;
  final AppointmentModel appointment;

  const ServiceDetails({
    Key? key,
    required this.service,
    required this.salon,
    required this.appointment,
  }) : super(key: key);

  @override
  ConsumerState<ServiceDetails> createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends ConsumerState<ServiceDetails> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final _appointmentProvider = ref.watch(appointmentProvider);
    ThemeData theme = _appointmentProvider.salonTheme ?? AppTheme.customLightTheme;

    ThemeType themeType = _appointmentProvider.themeType!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        decoration: BoxDecoration(
          color: boxColor(themeType, theme),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: isExpanded ? 30 : 10,
            horizontal: 30,
          ),
          child: Theme(
            data: ThemeData().copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              iconColor: borderColor(themeType, theme),
              collapsedIconColor: borderColor(themeType, theme),
              tilePadding: EdgeInsets.zero,
              childrenPadding: EdgeInsets.zero,
              onExpansionChanged: (bool expanded) {
                setState(() {
                  isExpanded = expanded;
                });
              },
              title: Text(
                widget.service.translations![AppLocalizations.of(context)?.localeName ?? 'en'],
                style: theme.textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: DeviceConstraints.getResponsiveSize(context, 14.sp, 15.sp, 20.sp),
                  color: confirmationTextColor(themeType, theme),
                ),
              ),
              children: [
                const Divider(color: Color(0XFFCDCDCD)),
                const SizedBox(height: 2),
                RowInfo(
                  title: '${AppLocalizations.of(context)?.price ?? 'Price'}:',
                  value: '${getCurrency(widget.salon.countryCode!)}${widget.service.priceAndDuration!.price}',
                ),
                const SizedBox(height: 2),
                RowInfo(
                  title: '${AppLocalizations.of(context)?.duration ?? 'Duration'}:',
                  value: '${widget.service.priceAndDuration!.duration} ${AppLocalizations.of(context)?.minutes ?? 'minutes'}',
                ),
                const SizedBox(height: 2),
                RowInfo(
                  title: '${AppLocalizations.of(context)?.master ?? 'Master'}:',
                  value: widget.appointment.master?.name ?? '',
                ),
                const SizedBox(height: 2),
                RowInfo(
                  title: '${AppLocalizations.of(context)?.phoneNumber ?? 'Phone number'}:',
                  value: widget.salon.phoneNumber,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
