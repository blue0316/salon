import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/cat_sub_service/category_service.dart';
import 'package:bbblient/src/models/salon_master/master.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/salon/master/master_profile.dart';
import 'package:bbblient/src/views/themes/glam_one/master_profile/unique_master_profile.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SalonTeam extends ConsumerWidget {
  final SalonModel salonModel;

  const SalonTeam({Key? key, required this.salonModel}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final _salonSearchProvider = ref.watch(salonSearchProvider);
    final _createAppointmentProvider = ref.watch(createAppointmentProvider);

    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    ThemeType themeType = _salonProfileProvider.themeType;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: (themeType == ThemeType.GlamGradient) ? null : theme.cardColor,
        gradient: themeGradient(themeType, theme),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 30.w),
          right: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 30.w),
          top: 100, // DeviceConstraints.getResponsiveSize(context, 140.h, 180.h, 200.h),
          bottom: 60, // DeviceConstraints.getResponsiveSize(context, 140.h, 180.h, 200.h),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                (AppLocalizations.of(context)?.ourTeam ?? 'Our Team').toUpperCase(),
                style: theme.textTheme.displayMedium?.copyWith(
                  color: theme.colorScheme.secondary,
                  fontSize: DeviceConstraints.getResponsiveSize(context, 40.sp, 40.sp, 50.sp),
                ),
              ),
            ),
            const Space(factor: 4),
            Center(
              child: Container(
                height: size.height * 0.30, // DeviceConstraints.getResponsiveSize(context, 230.h, 230.h, 210.h),
                alignment: Alignment.center,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  separatorBuilder: (context, index) {
                    return const SizedBox(width: 20);
                  },
                  itemCount: _createAppointmentProvider.salonMasters.length,
                  itemBuilder: (context, index) {
                    // Get All Salon Masters
                    List<MasterModel> _filteredMasters = _createAppointmentProvider.salonMasters;

                    // Find Master Service
                    // a master might have multiple services (but I just picked the first index to show on landing page)
                    List<CategoryModel> categories = _salonSearchProvider.categories; // All available Categories

                    // Previous implementation to show only one service
                    // String masterCategoryId = _filteredMasters[index].categoryIds![0]; // Master category id
                    // Find master category id in all categories and pick the first one to display
                    // String? masterService = categories
                    //     .firstWhere(
                    //       (item) => item.categoryId == masterCategoryId,
                    //     )
                    //     .translations[AppLocalizations.of(context)?.localeName];

                    List<String> masterCategoryIds = _filteredMasters[index].categoryIds!;
                    if (masterCategoryIds.length > 2) {
                      masterCategoryIds.removeRange(2, masterCategoryIds.length);
                    }

                    List<CategoryModel> masterCategories = [];
                    for (String id in masterCategoryIds) {
                      masterCategories.add(categories.firstWhere((element) => element.categoryId == id));
                    }

                    if (_filteredMasters.isNotEmpty) {
                      return TeamMember(
                        name: Utils().getNameMaster(_filteredMasters[index].personalInfo),
                        services: masterCategories, // masterService, // "Hairdresser",
                        image: _filteredMasters[index].profilePicUrl,
                        master: _filteredMasters[index],
                        salonModel: salonModel,
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ),
            ),

            // Section Divider

            if (themeType == ThemeType.GlamLight)
              Space(
                factor: DeviceConstraints.getResponsiveSize(context, 4, 5, 9),
              ),
            if (themeType == ThemeType.GlamLight)
              const Divider(
                color: Colors.black,
                thickness: 1,
              ),
          ],
        ),
      ),
    );
  }
}

class TeamMember extends ConsumerWidget {
  final String? name, image;
  final List<CategoryModel> services;
  final MasterModel master;
  final SalonModel salonModel;

  const TeamMember({
    Key? key,
    required this.name,
    required this.services,
    required this.image,
    required this.master,
    required this.salonModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final _salonSearchProvider = ref.watch(salonSearchProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;
    ThemeType themeType = _salonProfileProvider.themeType;
    final _createAppointmentProvider = ref.watch(createAppointmentProvider);

    return GestureDetector(
      onTap: () {
        _createAppointmentProvider.setMaster(
          masterModel: master,
          categories: _salonSearchProvider.categories,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UniqueMasterProfile(
              // salonModel: salonModel,
              masterModel: master,
              // categories: const [],
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 0,
            child: SizedBox(
              // height: 140.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  avatar(themeType, image),

                  const SizedBox(height: 15),
                  Text(
                    name ?? '',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.secondary,
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                  ),
                  // Text(
                  //   service ?? '',
                  //   style: theme.textTheme.titleSmall?.copyWith(
                  //     fontSize: 15.sp,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: services
                .map(
                  (item) => Text(
                    item.translations[AppLocalizations.of(context)?.localeName] ?? '',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.onSecondaryContainer,
                      fontSize: 15.sp,
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

Widget avatar(ThemeType themeType, String? image) {
  switch (themeType) {
    case ThemeType.Barbershop:
      return RectangleTeamAvatar(image: image);
    case ThemeType.GlamMinimalLight:
      return RectangleTeamAvatar(image: image);
    case ThemeType.GlamMinimalDark:
      return RectangleTeamAvatar(image: image);

    default:
      return CircularTeamAvatar(image: image);
  }
}

class CircularTeamAvatar extends ConsumerWidget {
  final String? image;

  const CircularTeamAvatar({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);

    ThemeType themeType = _salonProfileProvider.themeType;

    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppTheme.white, // coolGrey,
        border: (themeType == ThemeType.GlamLight) ? Border.all(color: Colors.black) : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: (image != null && image != '')
            ? CachedImage(url: image!, fit: BoxFit.cover)
            : Image.asset(
                AppIcons.masterDefaultAvtar,
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}

class RectangleTeamAvatar extends StatelessWidget {
  final String? image;

  const RectangleTeamAvatar({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      decoration: const BoxDecoration(
        color: AppTheme.white, // coolGrey,
      ),
      child: (image != null && image != '')
          ? CachedImage(url: image!, fit: BoxFit.cover)
          : Image.asset(
              AppIcons.masterDefaultAvtar,
              fit: BoxFit.cover,
            ),
    );
  }
}

Gradient? themeGradient(ThemeType type, ThemeData theme) {
  switch (type) {
    case ThemeType.GlamGradient:
      return LinearGradient(
        colors: [
          theme.colorScheme.onSurfaceVariant,
          theme.colorScheme.surfaceTint,
        ],
      );

    default:
      return null;
  }
}
