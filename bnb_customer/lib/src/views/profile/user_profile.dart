import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/views/profile/personal_info.dart';
import 'package:bbblient/src/views/profile/support/support_options.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../theme/app_main_theme.dart';
import '../../utils/functions.dart';
import '../../utils/icons.dart';
import 'invite/invite_friends.dart';
import 'my_bonuses.dart';
import 'payments/my_payments.dart';
import 'settings/settings.dart';
import 'widgets/profile_list_tile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserProfile extends ConsumerStatefulWidget {
  final Function onLogOut;

  const UserProfile({required this.onLogOut, Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends ConsumerState<UserProfile> {
  @override
  Widget build(BuildContext context) {
    final _auth = ref.watch(authProvider);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            AppLocalizations.of(context)?.profile ?? "Profile",
            style: Theme.of(context).textTheme.bodyText1,
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        body: SafeArea(
          child: ConstrainedContainer(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 110,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(color: AppTheme.coolGrey, width: 2),
                        bottom: BorderSide(color: AppTheme.coolGrey, width: 2),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Padding(
                                padding: EdgeInsets.only(left: 20.w),
                                child: CircleAvatar(
                                  radius: 35,
                                  backgroundColor: AppTheme.coolGrey,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(1000),
                                    child: _auth.currentCustomer
                                                ?.profilePicUploaded ??
                                            false
                                        ? SizedBox(
                                            height: 64,
                                            width: 64,
                                            child: CachedImage(
                                                url: _auth.currentCustomer!
                                                    .profilePic))
                                        : SvgPicture.asset(
                                            AppIcons.profilePicPlaceHolder,
                                            fit: BoxFit.cover,
                                            height: 64,
                                            width: 64,
                                          ),
                                  ),
                                )),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    NamingConventions.getName(
                                        _auth.currentCustomer?.personalInfo)!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(fontWeight: FontWeight.w400),
                                  ),
                                  const Space(
                                    factor: 0.5,
                                  ),
                                  Text(
                                    _auth.currentCustomer?.personalInfo.phone ??
                                        '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                            fontWeight: FontWeight.w400,
                                            color: AppTheme.lightGrey,
                                            fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          key: const Key("logout"),
                          onTap: () async {
                            widget.onLogOut();
                            await _auth.signOut();
                            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginIntro()));
                          },
                          // onTap: homeController.askLogOut,
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: 20.0.w,
                            ),
                            child: SizedBox(
                                height: 24,
                                width: 24,
                                child: SvgPicture.asset(AppIcons.logoutSVG)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ProfileListTile(
                    key: Key("profile"),
                    title: AppLocalizations.of(context)?.personalInformation ??
                        "Personal Information",
                    iconUrl: AppIcons.personGreySVG,
                    onTapped: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PersonalInformation()),
                      );
                    },
                  ),
                  // ProfileListTile(
                  //   title: "My history of visits",
                  //   iconUrl: AppIcons.recentSVG,
                  //   onTapped: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (context) => const HistoryOfVisits()),
                  //     );
                  //   },
                  // ),
                  ProfileListTile(
                    key: Key("settings"),
                    title: AppLocalizations.of(context)?.settings ?? "Settings",
                    iconUrl: AppIcons.settingsSVG,
                    onTapped: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Settings()),
                      );
                    },
                  ),
                  ProfileListTile(
                    key: Key("payments"),
                    title: AppLocalizations.of(context)?.myPayments ??
                        "My Payments",
                    iconUrl: AppIcons.dollarSVG,
                    onTapped: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyPayments()),
                      );
                    },
                  ),
                  ProfileListTile(
                    key: Key("bonuses"),
                    title:
                        AppLocalizations.of(context)?.myBonuses ?? "My Bonuses",
                    iconUrl: AppIcons.bonusesSVG,
                    onTapped: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          settings: const RouteSettings(name: MyBonuses.route),
                          builder: (context) => const MyBonuses(),
                        ),
                      );
                    },
                  ),
                  ProfileListTile(
                    key: Key("invite-friends"),
                    title: AppLocalizations.of(context)?.inviteFriends ??
                        "Invite Friends",
                    iconUrl: AppIcons.inviteFriendsSVG,
                    onTapped: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const InviteFriends(),
                        ),
                      );
                    },
                  ),
                  ProfileListTile(
                    key: Key("support-chats"),
                    title: AppLocalizations.of(context)?.supportChat ??
                        "Support Chat",
                    iconUrl: AppIcons.chatBubbleSVG,
                    onTapped: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SupportOptions(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MakeUseful extends StatefulWidget {
  const MakeUseful({Key? key}) : super(key: key);

  @override
  _MakeUsefulState createState() => _MakeUsefulState();
}

class _MakeUsefulState extends State<MakeUseful> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
