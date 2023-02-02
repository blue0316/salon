import 'package:bbblient/main.dart';
import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/app_provider.dart';
import 'package:bbblient/src/models/appointment/appointment.dart';
import 'package:bbblient/src/models/enums/appointment_status.dart';
import 'package:bbblient/src/models/enums/status.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/utils/keys.dart';
import 'package:bbblient/src/utils/time.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/profile/my_bonuses.dart';
import 'package:bbblient/src/views/widgets/buttons.dart';
import 'package:bbblient/src/views/widgets/dialogues/dialogue_function.dart';
import 'package:bbblient/src/views/widgets/dotted_line.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:html' as html;

class PaymentBonusConfirmation extends ConsumerStatefulWidget {
  const PaymentBonusConfirmation({Key? key}) : super(key: key);

  @override
  _PaymentBonusConfirmationState createState() => _PaymentBonusConfirmationState();
}

class _PaymentBonusConfirmationState extends ConsumerState<PaymentBonusConfirmation> {
  Status _status = Status.init;

  @override
  Widget build(BuildContext context) {
    final _createAppointment = ref.watch(createAppointmentProvider);
    final _authProvider = ref.watch(authProvider);
    final AppProvider _appProvider = ref.read(appProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.milkeyGrey,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Text(AppLocalizations.of(context)?.payment ?? "Payment", style: Theme.of(context).textTheme.headline4), Text(Time().getLocaleDate(_createAppointment.chosenDay, AppLocalizations.of(context)?.localeName ?? 'en').toString())],
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        fit: StackFit.loose,
        children: [
          SingleChildScrollView(
            child: ConstrainedContainer(
              child: Column(
                children: [
                  const Divider(
                    color: AppTheme.grey,
                  ),
                  if (double.parse(_createAppointment.appointmentModel?.priceAndDuration.price ?? "0").toInt() >= 300) ...[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 24.w),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              settings: const RouteSettings(name: MyBonuses.route),
                              builder: (context) => const MyBonuses(
                                chooseMode: true,
                              ),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_createAppointment.chosenBonus == null) ...[
                              Text(AppLocalizations.of(context)?.useYourBonus ?? "Use your Bonus", style: Theme.of(context).textTheme.subtitle1),
                            ],
                            if (_createAppointment.chosenBonus != null) ...[
                              SizedBox(
                                width: 20.w,
                                height: 20,
                                child: SvgPicture.asset(
                                  AppIcons.bonusGiftSVG,
                                  color: AppTheme.textBlack,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                "${AppLocalizations.of(context)?.youAreUsingOneCoupon} (${_createAppointment.chosenBonus?.amount} ₴)",
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              SizedBox(width: 10.w),
                              GestureDetector(
                                onTap: () {
                                  _createAppointment.removeBonus();
                                },
                                child: SizedBox(
                                  width: 16.w,
                                  height: 16,
                                  child: SvgPicture.asset(
                                    AppIcons.cancelSVG,
                                    color: AppTheme.grey,
                                  ),
                                ),
                              ),
                            ]
                          ],
                        ),
                      ),
                    ),
                  ],
                  if (_createAppointment.chosenBonus != null) ...[
                    if (double.parse(_createAppointment.appointmentModel?.priceAndDuration.price ?? "0").toInt() <= 299) ...[
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 24.w),
                        child: Text("${AppLocalizations.of(context)?.bonusValidAbove} 300 ${Keys.uah}", style: Theme.of(context).textTheme.subtitle1),
                      ),
                    ],
                  ],
                  if (_createAppointment.chosenBonus != null) ...[
                    const Divider(
                      color: AppTheme.grey,
                    ),
                  ],
                  SizedBox(
                    height: 32.h,
                  ),
                  Text(
                    AppLocalizations.of(context)?.total ?? "Total",
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: AppTheme.textBlack,
                          fontSize: 30.sp,
                        ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Container(
                    // height: 404.h,
                    width: 334.w,
                    decoration: BoxDecoration(color: AppTheme.oliveLight.withOpacity(0.7), borderRadius: BorderRadius.circular(16.sp)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(28.sp),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(AppLocalizations.of(context)?.youHaveToPay ?? "You have to pay:", style: Theme.of(context).textTheme.subtitle1!.copyWith(color: AppTheme.creamBrown, fontSize: 14.sp)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  if (_createAppointment.chosenBonus != null) ...[
                                    Text(
                                      "${_createAppointment.appointmentModel?.priceAndDuration.price} ${Keys.uah}",
                                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                            color: AppTheme.lightGrey,
                                            fontSize: 18.sp,
                                            decoration: TextDecoration.lineThrough,
                                          ),
                                    ),
                                  ],
                                  if (_createAppointment.chosenBonus != null) ...[
                                    Text(
                                      "${double.parse(_createAppointment.appointmentModel?.priceAndDuration.price ?? "0") - _createAppointment.chosenBonus!.amount} ${Keys.uah}",
                                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                            color: AppTheme.textBlack,
                                            fontSize: 32.sp,
                                          ),
                                    ),
                                  ],
                                  if (_createAppointment.chosenBonus == null) ...[
                                    Text(
                                      "${_createAppointment.appointmentModel?.priceAndDuration.price} ${Keys.uah}",
                                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                            color: AppTheme.textBlack,
                                            fontSize: 32.sp,
                                          ),
                                    ),
                                  ]
                                ],
                              ),
                            ],
                          ),
                        ),
                        const DottedLine(
                          color: Colors.white,
                          height: 2,
                        ),
                        Padding(
                          padding: EdgeInsets.all(28.sp),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Row(
                              //   children: [
                              //     Text(
                              //       "Payment Method:",
                              //       style: Theme.of(context).textTheme.subtitle1!.copyWith(fontWeight: FontWeight.normal),
                              //     ),
                              //     const Text("offline"),
                              //   ],
                              // ),
                              SizedBox(
                                height: 20.h,
                              ),
                              Text(
                                "${AppLocalizations.of(context)?.services ?? "services:"} :",
                                style: Theme.of(context).textTheme.subtitle1!.copyWith(fontWeight: FontWeight.normal),
                              ),
                              Column(
                                children: [
                                  if (_createAppointment.appointmentModel != null) ...[
                                    for (Service service in _createAppointment.appointmentModel!.services)
                                      Padding(
                                        padding: EdgeInsets.symmetric(vertical: 6.h),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    height: 20.h,
                                                    width: 20.w,
                                                    child: SvgPicture.asset(
                                                      AppIcons.getIconFromCategoryId(id: service.categoryId),
                                                      color: AppTheme.creamBrown,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 8.w,
                                                  ),
                                                  SizedBox(
                                                    width: 0.4.sw,
                                                    child: Text(
                                                      service.translations[AppLocalizations.of(context)?.localeName ?? 'en'].toString(),
                                                      style: AppTheme.bodyText1,
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              int.parse(service.priceAndDurationMax!.price) > 0 ? "${service.priceAndDurationMax!.price} ${Keys.uah}" : "${service.priceAndDuration.price} ${Keys.uah}",
                                              style: AppTheme.bodyText1,
                                            ),
                                          ],
                                        ),
                                      ),
                                    SizedBox(
                                      height: 16.h,
                                    ),
                                    Row(
                                      children: [
                                        if (_createAppointment.chosenBonus != null) ...[
                                          Text(
                                            "${AppLocalizations.of(context)?.bonusUsed ?? "Bonus used"} :  ",
                                            style: Theme.of(context).textTheme.subtitle1!.copyWith(fontWeight: FontWeight.normal),
                                          ),
                                        ] else ...[
                                          const SizedBox(),
                                        ],
                                        if (_createAppointment.chosenBonus == null) ...[const SizedBox()],
                                        if (_createAppointment.chosenBonus != null) ...[
                                          Text(
                                            "${_createAppointment.chosenBonus!.amount} ${Keys.uah}",
                                            style: AppTheme.bodyText1,
                                          ),
                                        ]
                                      ],
                                    ),
                                  ]
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                ],
              ),
            ),
          ),
          ConstrainedContainer(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(bottom: 34.h),
            disableCenter: true,
            child: MaterialButton(
              key: const Key("request-booking"),
              onPressed: _status == Status.init
                  ? () async {
                      setState(() {
                        _status = Status.loading;
                      });
                      try {
                        bool _success = await _createAppointment.finishBooking(context: context, customerModel: _authProvider.currentCustomer!);
                        if (_success) {
                          setState(() {
                            _status = Status.success;
                          });
                          showMyDialog(
                            context: context,
                            child: SizedBox(
                              height: 300.h,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(height: 150.h, width: 150.w, child: Image.asset(AppIcons.bookingConfirmedPNG)),
                                  Text(AppLocalizations.of(context)?.doneOnly ?? "done"),
                                  Text(
                                    (_createAppointment.appointmentModel?.status ?? "") == AppointmentStatus.requested ? AppLocalizations.of(context)?.requestConfirmed ?? "Request Confirmed" : AppLocalizations.of(context)?.bookingConfirmed ?? "Your booking has been confirmed",
                                    textAlign: TextAlign.center,
                                    style: AppTheme.bodyText1.copyWith(fontSize: 13, fontWeight: FontWeight.w300, color: AppTheme.green),
                                  ),
                                  BnbMaterialButton(
                                    key: const Key("great-key"),
                                    onTap: () {
                                      // print(object)
                                      if (_appProvider.firstRoute != null) {
                                        printIt("Going back to : ${_appProvider.firstRoute}");
                                        // context.pop();
                                        // context.push(
                                        //     '${NavigatorPage.redirect}${_appProvider.firstRoute!}');
                                        html.window.open("https://bowandbeautiful.com${_appProvider.firstRoute}", "_self");
                                      } else {
                                        Navigator.of(context).popUntil((Route<dynamic> route) => route.isFirst);
                                      }
                                    },
                                    title: AppLocalizations.of(context)?.great ?? 'Great',
                                    minWidth: 150.w,
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          setState(() {
                            _status = Status.failed;
                          });
                          showToast(AppLocalizations.of(context)?.errorOccurred ?? 'Error Occurred');
                          if (_appProvider.firstRoute != null) {
                            printIt("Going back to : ${_appProvider.firstRoute}");
                            // context.pop();
                            // context.push(
                            //     '${NavigatorPage.redirect}${_appProvider.firstRoute!}');
                            html.window.open("https://bowandbeautiful.com${_appProvider.firstRoute}", "_self");
                          } else {
                            Navigator.of(context).popUntil((Route<dynamic> route) => route.isFirst);
                          }
                        }
                      } catch (e) {
                        printIt(e);
                        setState(() {
                          _status = Status.failed;
                        });
                        showToast(AppLocalizations.of(context)?.errorOccurred ?? 'Error Occured');

                        Navigator.popUntil(context, ModalRoute.withName(NavigatorPage.route));
                      }
                    }
                  : null,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              color: AppTheme.creamBrown,
              disabledColor: AppTheme.grey,
              height: 50,
              minWidth: 1.sw - 48,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_status == Status.init) ...[
                    Text(
                      (_createAppointment.appointmentModel?.status ?? "") == AppointmentStatus.requested ? AppLocalizations.of(context)?.requestBooking ?? "Request Booking" : AppLocalizations.of(context)?.confirmBooking ?? "Confirm Booking",
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  ],
                  if (_status == Status.loading) ...[
                    SizedBox(
                      height: 20.h,
                      width: 20.h,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.white),
                      ),
                    ),
                  ],
                  if (_status == Status.failed) ...[
                    Text(
                      AppLocalizations.of(context)?.errorOccurred ?? "Error Occured",
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  ],
                  if (_status == Status.success) ...[
                    Text(
                      AppLocalizations.of(context)?.booked ?? "booked",
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  ]
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
