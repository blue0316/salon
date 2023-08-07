import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/create_apntmnt_provider/create_appointment_provider.dart';
import 'package:bbblient/src/models/customer_web_settings.dart';
import 'package:bbblient/src/models/salon_master/master.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/themes/components/salon_sponsors.dart';
import 'package:bbblient/src/views/themes/components/salon_tags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'about/master_about.dart';
import 'contacts/master_contact.dart';
import 'header/landing_header.dart';
import 'reviews/master_reviews.dart';
import 'services/master_services.dart';
import 'works/master_works.dart';

class UniqueMasterProfile extends ConsumerStatefulWidget {
  static const route = '/unique-master-profile';

  final MasterModel masterModel;
  const UniqueMasterProfile({Key? key, required this.masterModel}) : super(key: key);

  @override
  _UniqueMasterProfileState createState() => _UniqueMasterProfileState();
}

class _UniqueMasterProfileState extends ConsumerState<UniqueMasterProfile> {
  late CreateAppointmentProvider _createAppointmentProvider;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _createAppointmentProvider.chosenServices.clear();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(themeController);
    final _salonSearchProvider = ref.watch(salonSearchProvider);
    final _createAppointmentProvider = ref.watch(createAppointmentProvider);

    final _salonProfileProvider = ref.watch(salonProfileProvider);
    final SalonModel chosenSalon = _salonProfileProvider.chosenSalon;
    final ThemeData theme = _salonProfileProvider.salonTheme;
    final DisplaySettings? displaySettings = _salonProfileProvider.themeSettings?.displaySettings;

    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        //  drawerEnableOpenDragGesture: false, // Prevent user sliding open
        backgroundColor: theme.colorScheme.background,
        resizeToAvoidBottomInset: false,
        // drawer: const ThemeDrawer(),
        body: SizedBox(
          // width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: SizedBox(
                    // width: size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        MasterLandingHeader(
                          masterModel: widget.masterModel,
                        ),

                        // TAGS
                        if (displaySettings?.showBrands == true) SizedBox.fromSize(size: Size.zero, key: controller.tags),
                        if (displaySettings?.showBrands == true)
                          if (chosenSalon.additionalFeatures.isNotEmpty)
                            SalonTags(
                              salonModel: chosenSalon,
                              additionalFeatures: chosenSalon.additionalFeatures,
                            ),

                        // ABOUT
                        if (displaySettings?.showAbout == true) SizedBox.fromSize(size: Size.zero, key: controller.about),
                        if (displaySettings?.showAbout == true) MasterAboutUnique(masterModel: widget.masterModel),

                        // SPONSORS
                        if (displaySettings?.showBrands == true) SizedBox.fromSize(size: Size.zero, key: controller.sponsor),
                        if (displaySettings?.showBrands == true) const SalonSponsors(),

                        // WORKS
                        if (displaySettings?.showPhotosOfWork == true) SizedBox.fromSize(size: Size.zero, key: controller.works),
                        if (displaySettings?.showPhotosOfWork == true) MasterWorksUnique(masterModel: widget.masterModel),

                        // PRICE
                        if (displaySettings?.services.showServices == true) SizedBox.fromSize(size: Size.zero, key: controller.price),
                        if (displaySettings?.services.showServices == true)
                          MasterPriceUnique(
                            masterModel: widget.masterModel,
                            categories: _salonSearchProvider.categories,
                            categoryServicesMapNAWA: _createAppointmentProvider.categoryServicesMap,
                          ),

                        // REVIEWS
                        if (displaySettings?.reviews.showReviews == true) SizedBox.fromSize(size: Size.zero, key: controller.reviews),
                        if (displaySettings?.reviews.showReviews == true) MasterReviewsUnique(masterModel: widget.masterModel),

                        // CONTACT
                        if (displaySettings?.showContact == true) SizedBox.fromSize(size: Size.zero, key: controller.contacts),
                        if (displaySettings?.showContact == true) MasterContactUnique(masterModel: widget.masterModel),

                        // BOTTOM ITEM
                        Padding(
                          padding: const EdgeInsets.only(top: 19, bottom: 15),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Design By ",
                                  style: theme.textTheme.bodyLarge!.copyWith(
                                    fontSize: 20.sp,
                                    color: theme.primaryColorLight,
                                  ),
                                ),
                                TextSpan(
                                  text: "GlamIris",
                                  style: theme.textTheme.bodyLarge!.copyWith(
                                    fontSize: 20.sp,
                                    color: theme.primaryColorDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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

class NoSectionYet extends ConsumerWidget {
  final String text;
  final Color color;

  const NoSectionYet({Key? key, required this.text, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: Text(
          text.toUpperCase(),
          style: theme.textTheme.bodyLarge?.copyWith(
            fontSize: DeviceConstraints.getResponsiveSize(context, 25.sp, 25.sp, 25.sp),
            color: color,
          ),
        ),
      ),
    );
  }
}
