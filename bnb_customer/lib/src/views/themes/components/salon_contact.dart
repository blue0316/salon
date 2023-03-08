import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'contacts/default_view.dart';

class SalonContact extends ConsumerStatefulWidget {
  final SalonModel salonModel;

  const SalonContact({Key? key, required this.salonModel}) : super(key: key);

  @override
  ConsumerState<SalonContact> createState() => _SalonContactState();
}

class _SalonContactState extends ConsumerState<SalonContact> with SingleTickerProviderStateMixin {
  TabController? tabController;

  @override
  void initState() {
    tabController = TabController(vsync: this, length: 2);
    super.initState();
  }

  @override
  void dispose() {
    tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final bool isPortrait =
    //     (DeviceConstraints.getDeviceType(MediaQuery.of(context)) ==
    //         DeviceScreenType.portrait);

    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);

    String? themeNo = _salonProfileProvider.theme;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w),
        vertical: 120,
      ),
      child: ContactDefaultView(salonModel: widget.salonModel),
    );
  }
}
