import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/banner_model.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:transparent_image/transparent_image.dart';

class BannerScroll extends ConsumerWidget {
  const BannerScroll({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final _bnbProvider = ref.watch(bnbProvider);

    if (_bnbProvider.generalBanners.isEmpty) {
      return SizedBox(
          height: 144.h, child: const Center(child:  BannerLoading()));
    }
    //generates and returns the list of banners
    List<Widget> showBannersList() {
      List<Widget> banners = [];
      for (int i = 0; i < _bnbProvider.generalBanners.length; i++) {
        final BannerModel banner = _bnbProvider.generalBanners[i];
        BannerModel? upComingBanner;
        if (i + 1 < _bnbProvider.generalBanners.length) {
          upComingBanner = _bnbProvider.generalBanners[i + 1];
        }

        banners.add(Stack(
          alignment: Alignment.center,
          children: [
            //using this unnecessary widget to load next upcoming network image in to memory
            if (upComingBanner != null)
              SizedBox(
                height: 0.0000001,
                width: 0.00000001,
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: upComingBanner
                      .urls[AppLocalizations.of(context)?.localeName ?? 'en'],
                ),
              ),
            const BannerLoading(),
            FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: banner
                  .urls[AppLocalizations.of(context)?.localeName ?? 'en'],
            ),
          ],
        ));
      }
      return banners;
    }

    return CarouselSlider(
        options: CarouselOptions(
          viewportFraction: DeviceConstraints.getResponsiveSize(context, 1,1, 0.5),
          autoPlay: true,
          enlargeCenterPage: true,
          height: 144,
          autoPlayAnimationDuration: const Duration(milliseconds: 600),
          autoPlayInterval: const Duration(seconds: 5),
        ),
        items: showBannersList());
  }
}

class BannerLoading extends StatelessWidget {
  const BannerLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 30,
      width: 30,
    );
  }
}
