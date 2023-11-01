import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/salon_master/master.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/salon/default_profile_view/salon_about.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MasterAboutHeaderLandscape extends ConsumerStatefulWidget {
  final MasterModel masterModel;
  const MasterAboutHeaderLandscape({Key? key, required this.masterModel}) : super(key: key);

  @override
  ConsumerState<MasterAboutHeaderLandscape> createState() => _MasterAboutHeaderLandscapeState();
}

class _MasterAboutHeaderLandscapeState extends ConsumerState<MasterAboutHeaderLandscape> {
  @override
  Widget build(BuildContext context) {
    final _salonProfileProvider = ref.watch(salonProfileProvider);
    final _createAppointmentProvider = ref.watch(createAppointmentProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;
    bool isLightTheme = (theme == AppTheme.customLightTheme);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: Container(
            height: 300.h, // widget.masterModel.profilePicUrl!.isNotEmpty ? 300.h : null,
            decoration: (widget.masterModel.profilePicUrl != null && widget.masterModel.profilePicUrl != '')
                ? BoxDecoration(
                    image: DecorationImage(
                    image: NetworkImage(widget.masterModel.profilePicUrl!),
                    fit: BoxFit.cover,
                  ))
                : BoxDecoration(
                    color: isLightTheme
                        ? const Color(0XFF1A1A1A).withOpacity(0.6)
                        : const Color(
                            0XFF3D3D3D,
                          ),
                  ),
            child: !(widget.masterModel.profilePicUrl != null && widget.masterModel.profilePicUrl != '')
                ? Center(
                    child: Text(
                      (Utils().getNameMaster(_createAppointmentProvider.chosenMaster?.personalInfo)).initials,
                      style: theme.textTheme.titleMedium!.copyWith(
                        fontSize: 25.sp,
                        fontWeight: FontWeight.w500,
                        color: isLightTheme ? Colors.black : Colors.white,
                        fontFamily: 'Inter-Medium',
                      ),
                    ),
                  )
                : null,
          ),
        ),
        const SizedBox(width: 35),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    Utils().getNameMaster(_createAppointmentProvider.chosenMaster?.personalInfo),
                    style: theme.textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp,
                      color: isLightTheme ? Colors.black : Colors.white,
                      fontFamily: 'Inter-Medium',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // const Space(factor: 0.7),
                  SizedBox(height: 12.sp),
                  Text(
                    _createAppointmentProvider.chosenMaster?.title ?? '-', //   'Hairdresser',
                    style: theme.textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w300,
                      fontSize: 15.sp,
                      color: isLightTheme ? Colors.black : Colors.white,
                      fontFamily: 'Inter-Medium',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.sp),
              Text(
                '${_createAppointmentProvider.chosenMaster?.personalInfo?.description}',
                style: theme.textTheme.displayMedium!.copyWith(
                  fontWeight: FontWeight.normal,
                  fontSize: 15.sp,
                  color: isLightTheme ? Colors.black : const Color(0XFFB1B1B1),
                  fontFamily: 'Inter-Medium',
                  letterSpacing: 0.5,
                ),
                maxLines: 10,
                overflow: TextOverflow.ellipsis,
              ),
              if (widget.masterModel.links != null)
                MasterFollowUs(
                  masterModel: widget.masterModel,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class MasterAboutHeaderPortrait extends ConsumerStatefulWidget {
  final MasterModel masterModel;

  const MasterAboutHeaderPortrait({Key? key, required this.masterModel}) : super(key: key);

  @override
  ConsumerState<MasterAboutHeaderPortrait> createState() => _MasterAboutHeaderPortraitState();
}

class _MasterAboutHeaderPortraitState extends ConsumerState<MasterAboutHeaderPortrait> {
  @override
  Widget build(BuildContext context) {
    final _salonProfileProvider = ref.watch(salonProfileProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;
    bool isLightTheme = (theme == AppTheme.customLightTheme);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 20.sp),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              Utils().getNameMaster(widget.masterModel.personalInfo),
              style: theme.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20.sp,
                color: isLightTheme ? Colors.black : Colors.white,
                fontFamily: 'Inter-Medium',
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 12.sp),
            Text(
              widget.masterModel.title ?? '-', //   'Hairdresser',
              style: theme.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w300,
                fontSize: 15.sp,
                color: isLightTheme ? Colors.black : Colors.white,
                fontFamily: 'Inter-Medium',
              ),
            ),
          ],
        ),
        SizedBox(height: 20.sp),
        Container(
          height: 300.h,
          width: double.infinity,
          decoration: (widget.masterModel.profilePicUrl != null && widget.masterModel.profilePicUrl != '')
              ? BoxDecoration(
                  image: DecorationImage(
                  image: NetworkImage(widget.masterModel.profilePicUrl!),
                  fit: BoxFit.cover,
                ))
              : BoxDecoration(
                  color: isLightTheme
                      ? const Color(0XFF1A1A1A).withOpacity(0.6)
                      : const Color(
                          0XFF3D3D3D,
                        ),
                ),
          child: !(widget.masterModel.profilePicUrl != null && widget.masterModel.profilePicUrl != '')
              ? Center(
                  child: Text(
                    (Utils().getNameMaster(widget.masterModel.personalInfo)).initials,
                    style: theme.textTheme.titleMedium!.copyWith(
                      fontSize: 25.sp,
                      fontWeight: FontWeight.w500,
                      color: isLightTheme ? Colors.black : Colors.white,
                      fontFamily: 'Inter-Medium',
                    ),
                  ),
                )
              : null,
        ),
        SizedBox(height: 7.sp),
        Text(
          '${widget.masterModel.personalInfo?.description}',
          style: theme.textTheme.displayMedium!.copyWith(
            fontWeight: FontWeight.normal,
            fontSize: 15.sp,
            color: isLightTheme ? Colors.black : const Color(0XFFB1B1B1),
            fontFamily: 'Inter-Medium',
            letterSpacing: 0.5,
          ),
          maxLines: 8,
          overflow: TextOverflow.ellipsis,
        ),
        if (widget.masterModel.links != null) MasterFollowUs(masterModel: widget.masterModel),
      ],
    );
  }
}

class MasterFollowUs extends ConsumerWidget {
  final MasterModel masterModel;

  const MasterFollowUs({Key? key, required this.masterModel}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    bool isLightTheme = (theme == AppTheme.customLightTheme);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.sp),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              (AppLocalizations.of(context)?.followUs ?? "Follow Us").toCapitalized(),
              style: theme.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 20.sp,
                color: isLightTheme ? Colors.black : Colors.white,
                fontFamily: "Inter",
              ),
            ),
          ),
          Wrap(
            alignment: WrapAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (masterModel.links?.instagram != '' && masterModel.links?.instagram != null)
                (!isLightTheme)
                    ? SocialLink2(
                        icon: AppIcons.linkInstaDark2,
                        type: 'insta',
                        socialUrl: masterModel.links?.instagram,
                      )
                    : SocialIcon2(
                        icon: FontAwesomeIcons.instagram,
                        type: 'insta',
                        socialUrl: masterModel.links?.instagram,
                      ),
              if (masterModel.links?.tiktok != '' && masterModel.links?.tiktok != null)
                SocialLink2(
                  icon: isLightTheme ? AppIcons.linkTikTok : AppIcons.linkTikTokDark,
                  type: 'tiktok',
                  socialUrl: masterModel.links?.tiktok,
                ),
              if (masterModel.links?.facebook != '' && masterModel.links?.facebook != null)
                SocialLink2(
                  icon: isLightTheme ? AppIcons.linkFacebook : AppIcons.linkFacebookDark,
                  type: 'facebook',
                  socialUrl: masterModel.links?.facebook,
                ),
              if (masterModel.links?.twitter != '' && masterModel.links?.twitter != null)
                SocialIcon2(
                  icon: FontAwesomeIcons.twitter,
                  type: 'twitter',
                  socialUrl: masterModel.links?.twitter,
                ),
              if (masterModel.links?.pinterest != '' && masterModel.links?.pinterest != null)
                SocialIcon2(
                  icon: FontAwesomeIcons.pinterest,
                  type: 'pinterest',
                  socialUrl: masterModel.links?.pinterest,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
