import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/authentication/auth_provider.dart';
import 'package:bbblient/src/firebase/customer.dart';
import 'package:bbblient/src/firebase/dynamic_link.dart';
import 'package:bbblient/src/utils/keys.dart';
import 'package:bbblient/src/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share_plus/share_plus.dart';
import '../../../theme/app_main_theme.dart';
import '../../../utils/icons.dart';
import '../../widgets/buttons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InviteFriends extends ConsumerStatefulWidget {
  const InviteFriends({Key? key}) : super(key: key);

  @override
  _InviteFriendsState createState() => _InviteFriendsState();
}

class _InviteFriendsState extends ConsumerState<InviteFriends> {
  int _currentStep = 0;
  late AuthProvider _authProvider;
  String referralLink = '';
  int _amount = 0;

  @override
  void initState() {
    super.initState();
    getDynamicLink();
  }

  void getDynamicLink() async {
    Future.delayed(const Duration(milliseconds: 100), () async {
      final _authProvider = ref.read(authProvider);
      final _bnbProvider = ref.read(bnbProvider);
      _amount = _bnbProvider.bonusSettings.referralBonusesAmounts[0];
      setState(() {});
      // if (_authProvider.bnbUser?.referralLink != '') {
      //   referralLink = _authProvider.bnbUser!.referralLink;
      //   printIt('fatched from firebase $referralLink');
      //   setState(() {});
      // } else {
      //   referralLink = await DynamicLinksApi().createReferralLink(
      //     context: context,
      //     referralCode: _authProvider.bnbUser!.customerId,
      //     bonusSettings: _bnbProvider.bonusSettings,
      //   );
      //   setState(() {});
      //   printIt('saved to firebase $referralLink');
      //   CustomerApi().updateReferral(customerId: _authProvider.bnbUser!.customerId, referralLink: referralLink);
      //   _authProvider.getUserInfo();
      // }
      // if (forceUpdate) {
      //   referralLink = await DynamicLinksApi().createReferralLink(
      //     context: context,
      //     referralCode: _authProvider.bnbUser!.customerId,
      //     bonusSettings: _bnbProvider.bonusSettings,
      //   );
      //   setState(() {});
      //   printIt('saved to firebase $referralLink');
      //   CustomerApi().updateReferral(customerId: _authProvider.bnbUser!.customerId, referralLink: referralLink);
      //   _authProvider.getUserInfo();
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          AppLocalizations.of(context)?.friendsInvitation ??
              "Friends Invitation",
          style: Theme.of(context).textTheme.bodyText1,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Opacity(
              opacity: 0.4,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 90, vertical: 50),
                    child: Image.asset('assets/images/invite_friends.png'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Column(
                      children: [
                        Text(
                          AppLocalizations.of(context)?.goodFriendsTakeCare ??
                              "Good friends take care of each other 😊",
                          style: Theme.of(context)
                              .textTheme
                              .headline2!
                              .copyWith(color: AppTheme.textBlack),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: AppLocalizations.of(context)
                                        ?.inviteFriendsAndGet ??
                                    "Invite friends and get",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(fontSize: 14),
                              ),
                              TextSpan(
                                text: " $_amount ₴ ",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                              ),
                              TextSpan(
                                text: AppLocalizations.of(context)
                                        ?.forEachonYourBonusAccount ??
                                    "for each \non your bonus account!",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(fontSize: 14),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Row(
                  //     children: [
                  //       IconButton(
                  //         onPressed: () {
                  //           Clipboard.setData(ClipboardData(text: referralLink));
                  //           showToast("Copied to Clipboard");
                  //         },
                  //         icon: const Icon(Icons.copy),
                  //       ),
                  //       Expanded(
                  //         child: Text(
                  //           referralLink,
                  //           style: TextStyle(fontFamily: "Epilogue", fontSize: 18.sp, color: Colors.black),
                  //           textAlign: TextAlign.center,
                  //           maxLines: 3,
                  //           overflow: TextOverflow.ellipsis,
                  //         ),
                  //       ),
                  //       IconButton(
                  //         onPressed: () {
                  //           Share.share('sign up on bnb self care and get $_amount ${Keys.uah} $referralLink',
                  //               subject: 'referral link for bnb');
                  //         },
                  //         icon: const Icon(Icons.refresh),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 16),
                  //   child: BnbMaterialButton(
                  //     onTap: () {
                  //
                  //     },
                  //     title: "Share",
                  //     minWidth: double.infinity,
                  //   ),
                  // ),
                  const SizedBox(
                    height: 40,
                  ),
                  Stepper(
                    physics: const NeverScrollableScrollPhysics(),
                    onStepTapped: (value) {
                      setState(() {
                        _currentStep = value;
                      });
                    },
                    // controlsBuilder: (context, details) {
                    //   return const SizedBox();
                    // },
                    steps: [
                      Step(
                        title: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child:
                                    SvgPicture.asset(AppIcons.emailFilledSVG),
                              ),
                            ),
                            Text(AppLocalizations.of(context)?.inviteFriends ??
                                "Invite Friends"),
                            Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: _currentStep == 0
                                    ? const SizedBox()
                                    : const Icon(
                                        Icons.keyboard_arrow_down,
                                        color: AppTheme.lightGrey,
                                      )),
                          ],
                        ),
                        content: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(AppLocalizations.of(context)
                                    ?.personalLinkDescription ??
                                "You have a personal referral link for inviting friends to join bnb. Just enter friend’s phone number and we will send them an unique registration code"),
                          ),
                        ),
                        isActive: _currentStep == 0,
                      ),
                      Step(
                        title: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: SvgPicture.asset(
                                    AppIcons.bellActiveBrownSVG),
                              ),
                            ),
                            Text(AppLocalizations.of(context)
                                    ?.receiveNotifications ??
                                "Receive notifications"),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: _currentStep == 1
                                  ? const SizedBox()
                                  : const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: AppTheme.lightGrey,
                                    ),
                            ),
                          ],
                        ),
                        content: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: AppLocalizations.of(context)
                                              ?.notifWhenSignUp ??
                                          "We will notify you when your friend signs up and give you a ",
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                    ),
                                    TextSpan(
                                      text: " $_amount ₴ ",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2!
                                          .copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: AppTheme.textBlack,
                                          ),
                                    ),
                                    TextSpan(
                                      text: AppLocalizations.of(context)
                                              ?.bonusAfterThat ??
                                          " bonus after that",
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                    ),
                                  ],
                                ),
                              )),
                        ),
                        isActive: _currentStep == 1,
                      ),
                      Step(
                        title: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child:
                                    SvgPicture.asset(AppIcons.bonusesFilledSVG),
                              ),
                            ),
                            Text(AppLocalizations.of(context)?.getBonuses ??
                                "Get bonuses"),
                            Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: _currentStep == 2
                                    ? const SizedBox()
                                    : const Icon(
                                        Icons.keyboard_arrow_down,
                                        color: AppTheme.lightGrey,
                                      )),
                          ],
                        ),
                        content: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: AppLocalizations.of(context)
                                            ?.everyInviteWillGet ??
                                        "Every time you invite friends to experience self-care with us, they will get ",
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                  TextSpan(
                                    text: " $_amount ₴ ",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme.textBlack,
                                        ),
                                  ),
                                  TextSpan(
                                    text: AppLocalizations.of(context)
                                            ?.afterSignupYouWillGet ??
                                        " after signing up. You will also get ",
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                  TextSpan(
                                    text: " $_amount ₴ ",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme.textBlack,
                                        ),
                                  ),
                                  TextSpan(
                                    text: AppLocalizations.of(context)
                                            ?.bczSharingIsCaring ??
                                        " for each invited friend, because sharing is caring",
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        isActive: _currentStep == 2,
                      ),
                      Step(
                        title: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child:
                                    SvgPicture.asset(AppIcons.dollarFilledSVG),
                              ),
                            ),
                            Text(AppLocalizations.of(context)?.spendBonuses ??
                                "Spend bonuses"),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: _currentStep == 3
                                  ? const SizedBox()
                                  : const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: AppTheme.lightGrey,
                                    ),
                            ),
                          ],
                        ),
                        content: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(AppLocalizations.of(context)
                                    ?.useBonusAndEnjoy ??
                                "Use bonuses while paying for services online: pay part of the total sum with your bonus account and enjoy your time with bnb!"),
                          ),
                        ),
                        isActive: _currentStep == 3,
                      )
                    ],
                    currentStep: _currentStep,
                    onStepContinue: () {
                      if (_currentStep < 3) {
                        setState(() {
                          ++_currentStep;
                        });
                      }
                    },
                  ),
                  SizedBox(
                    height: 30.h,
                  )
                ],
              ),
            ),
          ),
          Center(
            child: SizedBox(
              child: Text(
                  AppLocalizations.of(context)?.comingSoon ?? "coming soon",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: 22, color: AppTheme.redishPink)),
            ),
          ),
        ],
      ),
    );
  }
}
