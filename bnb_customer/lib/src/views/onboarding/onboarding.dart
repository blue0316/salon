import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/app_provider.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/views/home_page.dart';

import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:html' as html;
import '../../theme/app_main_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnBoarding extends ConsumerStatefulWidget {
  const OnBoarding({Key? key}) : super(key: key);
  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends ConsumerState<OnBoarding> {
  final PageController _pageController = PageController();

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final AppProvider _appProvider = ref.read(appProvider);
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (val) {
              setState(() {
                _currentIndex = val;
              });
            },
            children: [
              OnBoardingPage(
                imageUrl: AppIcons.onboardingFirstPNG,
                title: AppLocalizations.of(context)?.appointmentInAfewtaps ??
                    "Appointment in a few taps",
                subtitle: AppLocalizations.of(context)?.quicklyChooseFromWide ??
                    "quickly choose from wide range of services near you,and some more text, here suggest in group",
              ),
              OnBoardingPage(
                imageUrl: AppIcons.onboardingSecondPNG,
                title: AppLocalizations.of(context)
                        ?.chooseByServicesPriceDistanceRating ??
                    "Choose by services, price, distance, rating",
                subtitle: AppLocalizations.of(context)
                        ?.viewAllDetailsAboutService ??
                    "view all the details about a service, and some more text, here suggest in group",
              ),
              OnBoardingPage(
                imageUrl: AppIcons.onboardingThirdPNG,
                title:
                    AppLocalizations.of(context)?.seeSalonNMastersArpundYou ??
                        "See salons and masters around you",
                subtitle: AppLocalizations.of(context)?.viewAllTheTopSalons ??
                    "view all the top salons and masters around you",
              ),
              OnBoardingPage(
                imageUrl: AppIcons.onboardingFourthPNG,
                title: AppLocalizations.of(context)
                        ?.chooseMasterSalonBasedOnRealReview ??
                    "Choose master or salon based on real reviews",
                subtitle: AppLocalizations.of(context)?.weHaveHonestReviews ??
                    "we have honest reviews by real users",
              ),
              OnBoardingPage(
                imageUrl: AppIcons.onboardingFifthPNG,
                title: AppLocalizations.of(context)
                        ?.dontEverMissAppointmentsWithOurNotifications ??
                    "Don’t ever miss appointments with our notifications",
                subtitle: AppLocalizations.of(context)
                        ?.weWillMakeSureToRemind ??
                    "We will make sure to remind you, decide how many and when you want to get notified",
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 20),
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: 5,
                  effect: SwapEffect(
                    activeDotColor: AppTheme.creamBrown,
                    dotHeight: 12.sp,
                    dotWidth: 12.sp,
                    dotColor: AppTheme.coolGrey,
                    paintStyle: PaintingStyle.fill,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                child: SizedBox(
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        key: const ValueKey("first"),
                        onPressed: () => _appProvider.setSalonFirstTime(),
                        child: Text(
                          AppLocalizations.of(context)?.skip ?? "Skip",
                          style: const TextStyle(fontWeight: FontWeight.w400),
                        ),
                      ),
                      TextButton(
                        key: const ValueKey("policy"),
                        onPressed: () {
                          html.window.open(
                              "https://bowandbeautiful.com/privacy", "_blank");
                        },
                        child: Text(
                          AppLocalizations.of(context)?.policy ??
                              "Privacy Policy",
                          style: const TextStyle(fontWeight: FontWeight.w400),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          if (_currentIndex < 4) {
                            _pageController.animateToPage(_currentIndex + 1,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.ease);
                          } else {
                            _appProvider.setSalonFirstTime();
                          }
                        },
                        child: Row(
                          children: [
                            Text(_currentIndex == 4
                                ? AppLocalizations.of(context)?.getStarted ??
                                    "Get Started"
                                : AppLocalizations.of(context)?.next ?? "Next"),
                            const Icon(
                              Icons.arrow_forward,
                              size: 16,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OnBoardingPage extends StatelessWidget {
  final String? imageUrl;
  final String? title;
  final String? subtitle;

  const OnBoardingPage({Key? key, this.imageUrl, this.title, this.subtitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(left: 32, right: 32, top: 32),
            child: Image.asset(imageUrl!),
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding:
                EdgeInsets.only(bottom: 30.w, top: 16, left: 16, right: 16),
            child: Column(
              children: [
                Text(
                  title!,
                  style: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(fontSize: 22, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                const Space(),
                // todo write more stuff title
                Text(
                  subtitle!,
                  style: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 100,
        )
      ],
    );
  }
}
