import 'package:bbblient/src/utils/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'views/salon/widgets/floating_button_booking.dart';

class AppointmentViewDetails22 extends ConsumerStatefulWidget {
  const AppointmentViewDetails22({Key? key}) : super(key: key);

  @override
  ConsumerState<AppointmentViewDetails22> createState() => _AppointmentViewDetails22State();
}

class _AppointmentViewDetails22State extends ConsumerState<AppointmentViewDetails22> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 100,
              width: double.infinity,
              color: Colors.blue,
            ),
            Container(
              height: 300,
              width: double.infinity,
              color: Colors.brown,
            ),
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.purple,
            ),
            Container(
              height: 300,
              width: double.infinity,
              color: Colors.brown,
            ),
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.blue,
            ),
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.blue,
            ),
            Container(
              height: 300,
              width: double.infinity,
              color: Colors.brown,
            ),
          ],
        ),
      ),
    );
  }
}

class AppointmentViewDetails222 extends ConsumerStatefulWidget {
  const AppointmentViewDetails222({Key? key}) : super(key: key);

  @override
  ConsumerState<AppointmentViewDetails222> createState() => _AppointmentViewDetails222State();
}

class _AppointmentViewDetails222State extends ConsumerState<AppointmentViewDetails222> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
              child: Image.asset(AppIcons.photoSlider, fit: BoxFit.cover),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 200),
                      Container(
                        height: 100,
                        width: double.infinity,
                        color: Colors.blue,
                      ),
                      Container(
                        height: 300,
                        width: double.infinity,
                        color: Colors.brown,
                      ),
                      Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.purple,
                      ),
                      Container(
                        height: 300,
                        width: double.infinity,
                        color: Colors.brown,
                      ),
                      const SizedBox(height: 200),
                      Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.blue,
                      ),
                      Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 200),
                      Container(
                        height: 300,
                        width: double.infinity,
                        color: Colors.brown,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: FloatingBar(),
          ),
        ],
      ),
    );
  }
}
