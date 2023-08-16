import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/salon_master/master.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
            height: widget.masterModel.profilePicUrl!.isNotEmpty ? null : 250.h,
            decoration: BoxDecoration(
              color: widget.masterModel.profilePicUrl!.isNotEmpty ? null : theme.primaryColor,
            ),
            child: Container(
              height: 300.sp,
              width: double.infinity,
              decoration: BoxDecoration(
                // border: !isLightTheme ? Border.all(color: Colors.white, width: 1) : null,
                color: widget.masterModel.profilePicUrl!.isNotEmpty ? null : theme.primaryColor,
              ),
              child: SizedBox(
                height: 300.sp,
                width: double.infinity,
                child: (widget.masterModel.profilePicUrl!.isNotEmpty)
                    ? CachedImage(
                        url: widget.masterModel.profilePicUrl!,
                      )
                    : Image.asset(
                        AppIcons.masterDefaultAvtar,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
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
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // const Space(factor: 0.7),
                  SizedBox(height: 12.sp),
                  Text(
                    'Hairdresser',
                    style: theme.textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w300,
                      fontSize: 15.sp,
                      color: isLightTheme ? Colors.black : Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.sp),

              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis molestie, dictum est a, mattis tellus. Sed dignissim, metus nec fringilla accumsan, risus sem sollicitudin lacus, ut interdum tellus tellustellus eit. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis molestie, dictum est a, mattis tellus. Sed dignissim, metus nec fringilla ',
                style: theme.textTheme.displayMedium!.copyWith(
                  fontWeight: FontWeight.normal,
                  fontSize: 15.sp,
                  color: isLightTheme ? Colors.black : const Color(0XFFB1B1B1),
                ),
                // maxLines: 8,
                // overflow: TextOverflow.ellipsis,
              ),
              // FollowUs(
              //   masterModel: widget.masterModel,
              // ),
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
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 12.sp),
            Text(
              'Hairdresser',
              style: theme.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w300,
                fontSize: 15.sp,
                color: isLightTheme ? Colors.black : Colors.white,
              ),
            ),
          ],
        ),
        SizedBox(height: 20.sp),
        Container(
          height: 300.h,
          width: double.infinity,
          decoration: BoxDecoration(
            // border: !isLightTheme ? Border.all(color: Colors.white, width: 1) : null,
            color: widget.masterModel.profilePicUrl!.isNotEmpty ? null : theme.primaryColor,
          ),
          child: SizedBox(
            height: 300.h,
            width: double.infinity,
            child: (widget.masterModel.profilePicUrl!.isNotEmpty)
                ? CachedImage(
                    url: widget.masterModel.profilePicUrl!,
                  )
                : Image.asset(
                    AppIcons.masterDefaultAvtar,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        SizedBox(height: 7.sp),
        Text(
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit.ur adipiscing elit. Etiam eu turpis molestie, dictum est a, mattis tel ur adipiscing elit. Etiam eu turpis molestie, dictum est a, mattis tel ur adipiscing elit. Etiam eu turpis molestie, dictum est a, mattis tel ur adipiscing elit. Etiam eu turpis molestie, dictum est a, mattis telur adipiscing elit. Etiam eu turpis molestie, dictum est a, mattis tel ur adipiscing elit. Etiam eu turpis molestie, dictum est a, mattis tel ur adipiscing elit. Etiam eu turpis molestie, dictum est a, mattis tel Etiam eu turpis molestie, dictum est a, mattis tellus. Sed dignissim, metus nec fringilla accumsan, risus sem sollicitudin lacus, ut interdum tellus tellustellus eit. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis molestie, dictum est a, mattis tellus. Sed dignissim, metus nec fringilla ',
          style: theme.textTheme.displayMedium!.copyWith(
            fontWeight: FontWeight.normal,
            fontSize: 15.sp,
            color: isLightTheme ? Colors.black : const Color(0XFFB1B1B1),
          ),
          maxLines: 8,
          overflow: TextOverflow.ellipsis,
        ),
        // FollowUs(
        //   masterModel: widget.masterModel,
        // ),
      ],
    );
  }
}

// class FollowUs extends ConsumerWidget {
//   final MasterModel masterModel;

//   const FollowUs({Key? key, required this.masterModel}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final _salonProfileProvider = ref.watch(salonProfileProvider);
//     final ThemeData theme = _salonProfileProvider.salonTheme;
//     bool isLightTheme = (theme == AppTheme.customLightTheme);

//     return Expanded(
//       flex: 0,
//       child: Padding(
//         padding: EdgeInsets.symmetric(vertical: 30.sp),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 (AppLocalizations.of(context)?.followUs ?? "Follow Us").toCapitalized(),
//                 style: theme.textTheme.bodyLarge!.copyWith(
//                   fontWeight: FontWeight.w600,
//                   fontSize: 20.sp,
//                   color: isLightTheme ? Colors.black : Colors.white,
//                 ),
//               ),
//             ),
//             Wrap(
//               alignment: WrapAlignment.start,
//               // crossAxisAlignment: CrossAxisAlignment.center,
//               // mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 if (masterModel.links?.website != '' && masterModel.links?.website != null)
//                   SocialLink2(
//                     icon: isLightTheme ? AppIcons.linkGlobe : AppIcons.linkGlobeDark,
//                     type: 'website',
//                     socialUrl: masterModel.links?.website,
//                   ),
//                 if (masterModel.links?.instagram != '' && masterModel.links?.instagram != null)
//                   SocialLink2(
//                     icon: isLightTheme ? AppIcons.linkInsta : AppIcons.linkInstaDark2,
//                     type: 'insta',
//                     socialUrl: masterModel.links?.instagram,
//                   ),
//                 if (masterModel.links?.tiktok != '' && masterModel.links?.tiktok != null)
//                   SocialLink2(
//                     icon: isLightTheme ? AppIcons.linkTikTok : AppIcons.linkTikTokDark,
//                     type: 'tiktok',
//                     socialUrl: masterModel.links?.tiktok,
//                   ),
//                 if (masterModel.links?.facebook != '' && masterModel.links?.facebook != null)
//                   SocialLink2(
//                     icon: isLightTheme ? AppIcons.linkFacebook : AppIcons.linkFacebookDark,
//                     type: 'facebook',
//                     socialUrl: masterModel.links?.facebook,
//                   ),
//                 if (masterModel.links?.twitter != '' && masterModel.links?.twitter != null)
//                   SocialIcon2(
//                     icon: FontAwesomeIcons.twitter,
//                     type: 'twitter',
//                     socialUrl: masterModel.links?.twitter,
//                   ),
//                 if (masterModel.links?.pinterest != '' && masterModel.links?.pinterest != null)
//                   SocialIcon2(
//                     icon: FontAwesomeIcons.pinterest,
//                     type: 'pinterest',
//                     socialUrl: masterModel.links?.pinterest,
//                   ),
//                 if (masterModel.links?.yelp != '' && masterModel.links?.yelp != null)
//                   SocialIcon2(
//                     icon: FontAwesomeIcons.yelp,
//                     type: 'yelp',
//                     socialUrl: masterModel.links?.yelp,
//                   ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
