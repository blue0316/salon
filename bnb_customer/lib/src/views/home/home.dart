import 'dart:math';

import 'package:bbblient/main.dart';
import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/authentication/auth_provider.dart';
import 'package:bbblient/src/controller/bnb/bnb_provider.dart';
import 'package:bbblient/src/controller/home/salon_search_provider.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/enums/status.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/chat/chat_list.dart';
import 'package:bbblient/src/views/home/widgets/banner_scroll.dart';
import 'package:bbblient/src/views/registration/authenticate/login.dart';

import 'package:bbblient/src/views/widgets/salon_widgets.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_main_theme.dart';
import '../../utils/icons.dart';
import '../salon/salon_home/salon_profile.dart';
import 'choose_category.dart';
import 'map_view/pick_location.dart';
import 'search/search_field.dart';
import 'package:paginable/paginable.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:html' as html;

class Home extends ConsumerStatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    final _salonSearchProvider = ref.watch(salonSearchProvider);
    final BnbProvider _bnbProvider = ref.watch(bnbProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const ConstrainedContainer(
                  margin: EdgeInsets.only(
                      top: 20.0, left: AppTheme.margin, right: AppTheme.margin),
                  child: HomePageAppBar()),
              const ConstrainedContainer(
                  margin: EdgeInsets.only(
                      top: 30, left: AppTheme.margin, right: AppTheme.margin),
                  child: SearchField()),
              const ConstrainedContainer(
                  margin: EdgeInsets.only(
                      left: AppTheme.margin, right: AppTheme.margin),
                  child: BannerScroll()),
              Space(
                factor: 1.h,
              ),
              const ConstrainedContainer(child: ChooseCategory()),
              ConstrainedContainer(
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(
                        AppLocalizations.of(context)?.nearby ?? "Nearby",
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    )),
              ),
              if (_salonSearchProvider.nearbySalons.isEmpty &&
                  _salonSearchProvider.status == Status.failed) ...[
                ConstrainedContainer(
                  child: Column(
                    children: [
                      SizedBox(
                        width: min(0.5.sw, 200),
                        height: min(0.5.sw, 200),
                        child: Image.asset(AppIcons.noLocationPNG),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        AppLocalizations.of(context)
                                ?.noSalonsNearbyTryDifferentLocation ??
                            '',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ],
                  ),
                )
              ],
              ConstrainedContainer(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppTheme.margin.h),
                  child: Loader(
                    iconPadding: const EdgeInsets.only(top: 42),
                    status: _salonSearchProvider.status,
                    errorWidget: Container(),
                    child: NotificationListener<ScrollEndNotification>(
                      onNotification: (val) {
                        // todo solve this- use recommendation logic or some other way to paginate
                        if (val is ScrollEndNotification) {
                          _salonSearchProvider.incrementRadius();
                          return true;
                        } else {
                          return false;
                        }
                      },
                      child: DeviceConstraints.getDeviceType(mediaQuery) ==
                              DeviceScreenType.tab
                          ? GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount:
                                  _salonSearchProvider.nearbySalons.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                              ),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final SalonModel _salon =
                                    _salonSearchProvider.nearbySalons[index];
                                return SalonContainerForWeb(
                                    salon: _salon,
                                    showDialogForFavToggle: false,
                                    isFav: _bnbProvider
                                        .checkForFav(_salon.salonId),
                                    onFavouriteCallback: () =>
                                        _bnbProvider.toggleFav(_salon.salonId),
                                    onBookTapped: () {
                                      context.go(
                                          '${NavigatorPage.route}/salon?id=${_salon.salonId}');
                                    });
                              },
                            )
                          : PaginableListViewBuilder(
                              shrinkWrap: true,
                              primary: false,
                              loadMore: () async {
                                _salonSearchProvider.incrementRadius();
                              },
                              errorIndicatorWidget: (exception, tryAgain) =>
                                  Container(
                                color: Colors.redAccent,
                                height: 130,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)
                                              ?.noSalonsNearby ??
                                          '',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                              progressIndicatorWidget: const SizedBox(
                                height: 100,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              itemBuilder: (context, index) {
                                final SalonModel _salon =
                                    _salonSearchProvider.nearbySalons[index];
                                return SalonContainer(
                                    salon: _salon,
                                    showDialogForFavToggle: false,
                                    isFav: _bnbProvider
                                        .checkForFav(_salon.salonId),
                                    onFavouriteCallback: () =>
                                        _bnbProvider.toggleFav(_salon.salonId),
                                    onBookTapped: () {
                                      context.go(
                                          '${NavigatorPage.route}/salon?id=${_salon.salonId}');
                                    });
                              },
                              itemCount:
                                  _salonSearchProvider.nearbySalons.length,
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomePageAppBar extends ConsumerStatefulWidget {
  const HomePageAppBar({
    Key? key,
  }) : super(key: key);
  @override
  _AppBarState createState() => _AppBarState();
}

class _AppBarState extends ConsumerState<HomePageAppBar> {
  bool showCurrentAddress = false;
  @override
  void initState() {
    super.initState();
    if (mounted) {
      changeToWelcome();
    }
  }

  void changeToWelcome() {
    setState(() {
      showCurrentAddress = true;
    });
    Future.delayed(const Duration(seconds: 10), () {
      if (showCurrentAddress) {
        if (mounted) {
          setState(() {
            showCurrentAddress = false;
          });
        }
      }
    });
  }

  Future pickLocation(
      {required SalonSearchProvider salonSearchProvider}) async {
    bool? locationChanged = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PickLocation(),
      ),
    );
    if (locationChanged == true) {
      salonSearchProvider.loadSalons();
      salonSearchProvider.addPosition();
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthProvider _authProvider = ref.watch(authProvider);
    final SalonSearchProvider _salonSearchProvider =
        ref.watch(salonSearchProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: AnimatedCrossFade(
            crossFadeState: showCurrentAddress
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
            firstChild: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "${AppLocalizations.of(context)!.welcomeback}${(_authProvider.currentCustomer?.personalInfo.firstName != null && _authProvider.currentCustomer?.personalInfo.firstName != '') ? "," : ""}",
                    style: Theme.of(context).textTheme.headline5),
                SizedBox(height: 4.h),
                if ((_authProvider.currentCustomer?.personalInfo.firstName !=
                        null &&
                    _authProvider.currentCustomer?.personalInfo.firstName !=
                        ''))
                  Text(
                      _authProvider.currentCustomer?.personalInfo.firstName ??
                          "",
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textBlack)),
              ],
            ),
            secondChild: Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 4, right: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      _salonSearchProvider.tempAddress,
                      style: Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(fontSize: 15.sp),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  right:
                      DeviceConstraints.getResponsiveSize(context, 24, 30, 42)),
              child: GestureDetector(
                onTap: () {
                  html.window
                      .open("https://bowandbeautiful.com/privacy", "_blank");
                },
                child: const Text(
                  "PRIVACY",
                  style: TextStyle(),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                if (!showCurrentAddress) {
                  changeToWelcome();
                } else {
                  await pickLocation(salonSearchProvider: _salonSearchProvider);
                }
              },
              onDoubleTap: () async {
                await pickLocation(salonSearchProvider: _salonSearchProvider);
              },
              onLongPress: () async {
                await pickLocation(salonSearchProvider: _salonSearchProvider);
              },
              child: Padding(
                padding: EdgeInsets.only(
                    right: DeviceConstraints.getResponsiveSize(
                        context, 24, 30, 42)),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SvgPicture.asset(AppIcons.locationMarkerSVG,
                        height: DeviceConstraints.getResponsiveSize(
                            context, 26, 27, 28)),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () => checkUser(
                  context,
                  ref,
                  () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ChatList()))),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  SvgPicture.asset(AppIcons.speechBubbleSVG,
                      height: DeviceConstraints.getResponsiveSize(
                          context, 26, 27, 28)),

                  // const Positioned(
                  //     top: 0,
                  //     right: -3,
                  //     child: CircleAvatar(
                  //       radius: 6,
                  //       backgroundColor: AppTheme.green,
                  //     ))
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
