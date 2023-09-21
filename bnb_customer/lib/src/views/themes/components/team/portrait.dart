import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'gentle_touch_team.dart';

class TeamPortraitView extends ConsumerStatefulWidget {
  final List<String> items;

  const TeamPortraitView({Key? key, required this.items}) : super(key: key);

  @override
  ConsumerState<TeamPortraitView> createState() => _TeamPortraitViewState();
}

class _TeamPortraitViewState extends ConsumerState<TeamPortraitView> {
  final CarouselController _controller = CarouselController();
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    final _createAppointmentProvider = ref.watch(createAppointmentProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: SizedBox(
            height: 500.h,
            width: double.infinity,
            child: SizedBox(
              width: double.infinity,
              child: CarouselSlider(
                carouselController: _controller,
                options: CarouselOptions(
                  height: 500.h,
                  autoPlay: true,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  },
                ),
                items: _createAppointmentProvider.salonMasters
                    .map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(right: 0),
                        child: GentleTouchTeamMember(
                          name: Utils().getNameMaster(item.personalInfo),
                          masterTitle: item.title ?? '',
                          image: item.profilePicUrl,
                          master: item,
                          showDesc: true,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
        SizedBox(height: 20.sp),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _createAppointmentProvider.salonMasters.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: _current == entry.key ? 7 : 4,
                height: _current == entry.key ? 7 : 4,
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == entry.key
                      ? Colors.black
                      : const Color(0XFF8A8A8A).withOpacity(
                          _current == entry.key ? 0.9 : 0.4,
                        ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
