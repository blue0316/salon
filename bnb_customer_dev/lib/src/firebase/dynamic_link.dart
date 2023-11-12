// import 'package:bbblient/src/firebase/bonus_referral_api.dart';
// import 'package:bbblient/src/firebase/customer.dart';
// import 'package:bbblient/src/models/bonus_setttings_model.dart';
// import 'package:bbblient/src/models/customer/customer.dart';
// import 'package:bbblient/src/views/widgets/dialogues/referral_dilouges.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:flutter/material.dart';

// class DynamicLinksApi {
//   DynamicLinksApi._privateConstructor();
//   static final DynamicLinksApi _instance = DynamicLinksApi._privateConstructor();
//   factory DynamicLinksApi() {
//     return _instance;
//   }
//   final dynamicLink = FirebaseDynamicLinks.instance;
//   final bonusReferralApi = BonusReferralApi();
//   final customerApi = CustomerApi();

//   handleDynamicLink({required BuildContext context, required BonusSettings bonusSettings}) async {
//     // if (kIsWeb) return;
//     // await dynamicLink.getInitialLink();
//     // dynamicLink.onLink(
//     //   onSuccess: (PendingDynamicLinkData? data) async {
//     //     // showToast('handling data');
//     //     printIt('is this where the linking happens ');
//     //     handleSuccessLinking(data, bonusSettings, context);
//     //   },
//     //   onError: (OnLinkErrorException error) async {
//     //     // showToast('invalid link');
//     //     printIt(error.message.toString());
//     //   },
//     // );
//   }

//   void handleSuccessLinking(PendingDynamicLinkData? data, BonusSettings bonusSettings, BuildContext context) async {
//     if (data != null) {
//       final Uri deepLink = data.link;
//       var isRefer = deepLink.pathSegments.contains('referral');
//       if (isRefer) {
//         var code = deepLink.queryParameters['code'];
//         if (code != null) {
//           if (bonusSettings.referralsActive) {
//             CustomerModel? referredTo = await customerApi.getCustomer();
//             CustomerModel? referredBy = await customerApi.getCustomerById(customerId: code);
//             if (referredTo != null && referredBy != null) {
//               // EasyDebounce.debounce('giveReferralBonuses', const Duration(seconds: 4), () async {
//               //   await BonusReferralApi().giveReferralBonuses(context: context, referredTo: referredTo, referredBy: referredBy);
//               // });
//             }
//           }
//         } else {
//           showErrorDialog(context: context, message: 'Error parsing referral link');
//         }
//       }
//     }
//   }

//   Future<String> createReferralLink({
//     required BuildContext context,
//     required String referralCode,
//     required BonusSettings bonusSettings,
//   }) async {
//     // final DynamicLinkParameters dynamicLinkParameters = DynamicLinkParameters(
//     //   uriPrefix: 'https://bowandbeautiful.page.link',
//     //   link: Uri.parse('https://bowandbeautiful.page.link/referral?code=$referralCode'),
//     //   androidParameters: AndroidParameters(
//     //     packageName: 'com.bnb.client',
//     //     fallbackUrl: Uri.parse('https://bowandbeautiful.com'),
//     //   ),
//     //   iosParameters: IosParameters(
//     //     bundleId: 'com.bnb.client',
//     //     appStoreId: '1577087975',
//     //     fallbackUrl: Uri.parse('https://apps.apple.com/in/app/bnb-self-care-services/id1577087975'),
//     //   ),
//     //   socialMetaTagParameters: SocialMetaTagParameters(
//     //     //!! show total bonuses
//     //     title: "${AppLocalizations.of(context)?.joinbnbAndGetBonus ?? 'Join bnb to take care of yourself with a '} ${Keys.dollars}${bonusSettings.referralBonusesAmounts.first} ${AppLocalizations.of(context)?.bonus ?? 'bonus'} ",
//     //     description: "${AppLocalizations.of(context)?.inviteWithinADayFirst ?? 'Download the bnb app now. invite your friends to join within your first '} ${bonusSettings.doubleHours} ${AppLocalizations.of(context)?.inviteWithinADaySecond ?? 'hours with us to get more bonuses'}",
//     //     imageUrl: Uri.parse('https://firebasestorage.googleapis.com/v0/b/bowandbeautiful-3372d.appspot.com/o/banners%2F2-1.png?alt=media&token=b7494c22-c676-447d-aa79-22cf8d0510bd'),
//     //   ),
//     // );
//     // final ShortDynamicLink shortLink = await dynamicLinkParameters.buildShortLink();
//     // final Uri dynamicUrl = shortLink.shortUrl;
//     // printIt(dynamicUrl);
//     // return dynamicUrl.toString();
//   }
// }
