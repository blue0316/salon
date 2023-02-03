import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'booking_choose_master.dart';
import 'booking_choose_service.dart';
import 'widgets/booking_header.dart';
import 'widgets/repeat_booking_details.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BookingStart extends StatefulWidget {
  const BookingStart({Key? key}) : super(key: key);

  @override
  _BookingStartState createState() => _BookingStartState();
}

class _BookingStartState extends State<BookingStart> {
  int _tabIndex = 0;
  int _servicePrefIndex = 0;
  bool smallHeader = false;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              height: 1.sh,
              width: 1.sw,
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  BookingHeader(
                    small: smallHeader,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _tabIndex = 0;
                            smallHeader = false;
                            _pageController.animateToPage(0, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: _tabIndex == 0 ? Colors.white : Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                            child: Text(
                              AppLocalizations.of(context)?.newAppointment ?? "New Appointment",
                              style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 14, color: _tabIndex == 0 ? AppTheme.textBlack : AppTheme.lightGrey),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _tabIndex = 1;
                            smallHeader = true;
                            _pageController.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: _tabIndex == 1 ? Colors.white : Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                            child: Text(
                              AppLocalizations.of(context)?.repeated ?? "Repeated",
                              style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 14, color: _tabIndex == 1 ? AppTheme.textBlack : AppTheme.lightGrey),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 500.h,
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: 80.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _servicePrefIndex = 0;
                                        });
                                      },
                                      child: Stack(
                                        children: [
                                          SizedBox(
                                            height: 160.sp,
                                            width: 160.sp,
                                            // color: Colors.red,
                                            child: SvgPicture.asset(AppIcons.masterBigSVG),
                                          ),
                                          Positioned(
                                            top: 8.sp,
                                            left: 15.sp,
                                            child: Container(
                                              height: 130.sp,
                                              width: 130.sp,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: _servicePrefIndex == 0 ? AppTheme.creamBrownLight : Colors.transparent,
                                                  width: 2,
                                                ),
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 25.w,
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _servicePrefIndex = 1;
                                        });
                                      },
                                      child: Stack(
                                        children: [
                                          SizedBox(
                                            height: 160.sp,
                                            width: 160.sp,
                                            // color: Colors.red,
                                            child: SvgPicture.asset(AppIcons.serviceBigSVG),
                                          ),
                                          Positioned(
                                            top: 8.sp,
                                            left: 15.sp,
                                            child: Container(
                                              height: 130.sp,
                                              width: 130.sp,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: _servicePrefIndex == 1 ? AppTheme.creamBrownLight : Colors.transparent,
                                                  width: 2,
                                                ),
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                        SingleChildScrollView(
                          child: Column(
                            children: const [
                              SizedBox(
                                height: 50,
                              ),
                              RepeatBookingDetails(),
                              RepeatBookingDetails(),
                              RepeatBookingDetails(),
                              SizedBox(
                                height: 50,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: SizedBox(
                height: 60.h,
                width: 1.sw,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.arrow_back,
                                color: AppTheme.textBlack,
                              ),
                              SizedBox(
                                width: 16.w,
                              ),
                              Text(
                                AppLocalizations.of(context)?.back ?? "Back",
                                style: Theme.of(context).textTheme.subtitle1,
                              )
                            ],
                          ),
                        )),
                    Flexible(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            if (_tabIndex == 0) {
                              if (_servicePrefIndex == 0) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const BookingChooseMaster(),
                                  ),
                                );
                              } else if (_servicePrefIndex == 1) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const BookingChooseService(),
                                  ),
                                );
                              }
                            }
                          },
                          child: Container(
                            decoration: const BoxDecoration(color: AppTheme.creamBrown, borderRadius: BorderRadius.only(topLeft: Radius.circular(28))),
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context)?.continue_word ?? "Continue",
                                style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
