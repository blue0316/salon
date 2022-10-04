import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/create_apntmnt_provider/create_appointment_provider.dart';
import 'package:bbblient/src/models/backend_codings/bonus_type.dart';
import 'package:bbblient/src/models/bonus_model.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/utils/keys.dart';
import 'package:bbblient/src/utils/time.dart';
import 'package:bbblient/src/views/widgets/buttons.dart';

import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class MyBonuses extends ConsumerStatefulWidget {
  static const route = "/chooseBonuses";
  final bool chooseMode;
  const MyBonuses({this.chooseMode = false, Key? key}) : super(key: key);

  @override
  _MyBonusesState createState() => _MyBonusesState();
}

class _MyBonusesState extends ConsumerState<MyBonuses> {
  @override
  void initState() {
    super.initState();
    refreshBonuses();
  }

  refreshBonuses() {
    final _bnbProvider = ref.read(bnbProvider);
    _bnbProvider.refresh();
  }

  @override
  Widget build(BuildContext context) {
    final _bnbProvider = ref.watch(bnbProvider);
    final CreateAppointmentProvider _createAppointment =
        ref.watch(createAppointmentProvider);
    print(_bnbProvider.bonuses);
    final double padding = MediaQuery.of(context).size.height / 6;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          AppLocalizations.of(context)?.myBonuses ?? "Bonuses",
          style: Theme.of(context).textTheme.bodyText1,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: _bnbProvider.bonuses.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [Space(height: padding,),
                  SvgPicture.asset(
                    AppIcons.bonusesSVG,height: 100,color: AppTheme.grey2,

                  ),const Space(factor: 3,),
                  Text(
                      AppLocalizations.of(context)?.noBonusAvailable ?? "",
                      style: const TextStyle(fontSize: 22)),
                ],
              ))
          : Align(
        alignment: Alignment.topCenter,
            child: ConstrainedContainer(disableCenter: true,
              child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 40, bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppLocalizations.of(context)?.yourBonusAmount ??
                                  "Your Total Coupons Amount:",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(fontWeight: FontWeight.w400),
                            ),
                            Text(
                              " ${_bnbProvider.bonuses.length}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              " (${_bnbProvider.totalBonus} ${Keys.uah})",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                      if (_bnbProvider.bonuses.isNotEmpty) ...[
                        SizedBox(
                          height: 210.h,
                          child: ListView.builder(
                            itemCount: _bnbProvider.bonuses.length,
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.all(0),
                            itemBuilder: (context, index) {
                              final BonusModel bonus = _bnbProvider.bonuses[index];
                              print(bonus.expiresAt);
                              print(bonus.expired);
                              if (bonus.validated == true && bonus.used == false) {
                                return Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          if (widget.chooseMode) {
                                            _createAppointment.chooseBonus(
                                                bonusModel: bonus);
                                            Navigator.pop(context);
                                          }
                                        },
                                        child: BonusCard(bonus: bonus)),
                                    if (widget.chooseMode) ...[
                                      Positioned(
                                        top: 10,
                                        left: 10,
                                        child: BnbCheckCircle(
                                          value: _createAppointment
                                                  .chosenBonus?.bonusId ==
                                              bonus.bonusId,
                                        ),
                                      ),
                                    ],
                                  ],
                                );
                              } else {
                                return const SizedBox();
                              }
                            },
                          ),
                        ),
                      ],
                      if (_bnbProvider.bonuses.isEmpty) ...[
                        SizedBox(
                            height: 208.h,
                            width: 300.w,
                            child: Stack(children: [
                              SizedBox(
                                height: 208.h,
                                width: 300.w,
                                child: Image.asset(
                                  AppIcons.couponEmptyPNG,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                  top: 35.h,
                                  left: 50.w,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                            text: "0 ",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1!
                                                .copyWith(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 30.sp),
                                            children: [
                                              TextSpan(
                                                text: Keys.uah,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1!
                                                    .copyWith(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 12.sp),
                                              )
                                            ]),
                                      ),
                                    ],
                                  )),
                            ])),
                      ],
                      const SizedBox(
                        height: 40,
                      ),
                      ExpansionTile(
                        title: Padding(
                          padding: const EdgeInsets.only(left: 40.0),
                          child: Text(
                            AppLocalizations.of(context)?.couponsUsageRules ??
                                "Coupons usage rules",
                            style: TextStyle(
                              fontFamily: "Montserrat",
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.grey,
                            ),
                            // style: Theme.of(context).textTheme.headline4,
                          ),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    AppLocalizations.of(context)?.bonusRuleFirst ??
                                        "",
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(fontWeight: FontWeight.w400),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "${AppLocalizations.of(context)?.bonusRuleSecond ?? ""} 300 ${Keys.uah}",
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(fontWeight: FontWeight.w400),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    AppLocalizations.of(context)?.bonusRuleThird ??
                                        "",
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(
                      //     top: 40.0,
                      //     right: 40.0,
                      //     left: 40.0,
                      //     bottom: 35.0,
                      //   ),
                      //   child: Text(
                      //     AppLocalizations.of(context)?.inviteFriendsAndGet ?? "Invite Your Friends to get more Bonuses!",
                      //     style: const TextStyle(
                      //       fontFamily: "Epilogue",
                      //       fontSize: 18,
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 48,
                      //   width: 48,
                      //   child: SvgPicture.asset('assets/icons/person_add.svg'),
                      // ),
                      // Text(
                      //   AppLocalizations.of(context)?.invite ?? "Invite ",
                      //   style: const TextStyle(fontFamily: "Epilogue", fontSize: 18, color: AppTheme.black),
                      // ),
                    ],
                  ),
                ),
            ),
          ),
    );
  }
}

class BonusCard extends StatelessWidget {
  final BonusModel bonus;
  const BonusCard({required this.bonus, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Stack(
        children: [
          SizedBox(
            height: 208,
            width: 300,
            child: Image.asset(
              AppIcons.couponEmptyPNG,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 35,
            left: 50,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                      text: "${bonus.amount}",
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 30.sp),
                      children: [
                        TextSpan(
                          text: Keys.uah,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.sp),
                        )
                      ]),
                ),
              ],
            ),
          ),
          Positioned(
              bottom: 30,
              left: 50,
              child: SizedBox(
                height: 75,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (bonus.bonusType == BonusTypes.referralBonus) ...[
                      Text(
                        AppLocalizations.of(context)?.bonus ??
                            "Referral bonus",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 16.sp),
                      ),
                    ],
                    if (bonus.bonusType == BonusTypes.installBonus) ...[
                      Text(
                        AppLocalizations.of(context)?.welcomeBonus ??
                            "Welcome bonus",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 16.sp),
                      ),
                    ],
                    SizedBox(
                      height: 6.h,
                    ),
                    Text(
                      "${AppLocalizations.of(context)?.validUntil}: ${Time().getDateInStandardFormat(bonus.expiresAt)}",
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 13.sp),
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
