import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'barbershop_about_view.dart';
import 'default_about_view.dart';

class SalonAbout2 extends ConsumerStatefulWidget {
  final SalonModel salonModel;

  const SalonAbout2({Key? key, required this.salonModel}) : super(key: key);

  @override
  ConsumerState<SalonAbout2> createState() => _SalonAbout2State();
}

class _SalonAbout2State extends ConsumerState<SalonAbout2> {
  @override
  Widget build(BuildContext context) {
    final SalonProfileProvider _salonProfileProvider =
        ref.watch(salonProfileProvider);

    return _salonProfileProvider.theme == '4'
        ? BarbershopAboutUs(salonModel: widget.salonModel)
        : DefaultAboutView(salonModel: widget.salonModel);
  }
}
