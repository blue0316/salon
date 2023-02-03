// ignore_for_file: unused_field

import 'package:bbblient/src/controller/create_apntmnt_provider/create_appointment_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../controller/all_providers/all_providers.dart';

class BookingDateTime extends ConsumerStatefulWidget {
  const BookingDateTime({Key? key}) : super(key: key);

  @override
  _BookingDateTimeState createState() => _BookingDateTimeState();
}

class _BookingDateTimeState extends ConsumerState<BookingDateTime> {
  final DateTime _today = DateTime.now();
  final DateTime _lastDay = DateTime.now().add(const Duration(days: 31 * 3));
  final ScrollController _mastresListController = ScrollController();
  late CreateAppointmentProvider createAppointment;
  final BoxDecoration _calBoxDecoration = BoxDecoration(
    color: Colors.transparent,
    shape: BoxShape.rectangle,
    borderRadius: BorderRadius.circular(12),
  );

  @override
  void initState() {
    super.initState();
    // setUpMasterPrice();
  }

  // setUpMasterPrice() {
  //   createAppointment = ref.read(createAppointmentProvider);
  //   if (createAppointment.chosenMaster != null) {
  //     Future.delayed(const Duration(milliseconds: 300), () {
  //       createAppointment.chooseMaster(
  //           masterModel: createAppointment.chosenMaster!, context: context);
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    createAppointment = ref.watch(createAppointmentProvider);
    final _auth = ref.watch(authProvider);
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            SizedBox(
              height: 1.sh,
            ),
          ],
        ),
      ),
    );
  }
}
