import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/backend_codings/payment_methods.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/views/profile/payments/my_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChoosePaymentMode extends ConsumerStatefulWidget {
  final bool chooseMode;
  const ChoosePaymentMode({this.chooseMode = false, Key? key}) : super(key: key);

  @override
  _ChoosePaymentModeState createState() => _ChoosePaymentModeState();
}

class _ChoosePaymentModeState extends ConsumerState<ChoosePaymentMode> {
  String? _paymentMethod;

  @override
  Widget build(BuildContext context) {
    final _createAppointment = ref.watch(createAppointmentProvider);
    // final _auth = ref.watch(authProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)?.myPayments ?? "Payment",
          style: AppTheme.bodyText1,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(children: [
        Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(top: 40.0.h, left: 40.w, bottom: 20.h),
                child: Text(
                  AppLocalizations.of(context)?.bnbOnlineComingSoon ?? "bnb (online)",
                  style: AppTheme.headLine3,
                ),
              ),
            ),
            Opacity(
              opacity: 0.4,
              child: Column(
                children: [
                  RadioListTile(
                    value: PaymentMethods.card,
                    groupValue: _paymentMethod,
                    onChanged: (dynamic val) {},
                    activeColor: AppTheme.black,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 156.w,
                          height: 60,
                          child: Image.asset(
                            AppIcons.creditCardBlackPNG,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)?.myCards ?? "My Cards",
                              style: AppTheme.headLine4.copyWith(fontWeight: FontWeight.w400),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const MyCards()));
                              },
                              icon: const Icon(Icons.arrow_forward_ios),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  RadioListTile(
                    value: PaymentMethods.googlePay,
                    groupValue: _paymentMethod,
                    onChanged: (dynamic val) {
                      // setState(() {
                      //   _paymentMethod = PaymentMethods.googlePay;
                      // });
                    },
                    activeColor: AppTheme.black,
                    title: Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)?.googlePay ?? "Google Pay",
                          style: AppTheme.headLine4.copyWith(
                            color: AppTheme.black,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    ),
                  ),
                  RadioListTile(
                    value: PaymentMethods.applePay,
                    groupValue: _paymentMethod,
                    onChanged: (dynamic val) {
                      // setState(() {
                      //   _paymentMethod = PaymentMethods.applePay;
                      // });
                    },
                    activeColor: AppTheme.black,
                    title: Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)?.applePay ?? 'Apple Pay',
                          style: AppTheme.headLine4.copyWith(
                            color: AppTheme.black,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(top: 40.0.h, left: 40.w, bottom: 20.h),
                child: Text(
                  AppLocalizations.of(context)?.payInSalon ?? "Pay in salon",
                  style: AppTheme.headLine3,
                ),
              ),
            ),
            RadioListTile(
              value: PaymentMethods.cardSalon,
              groupValue: _paymentMethod,
              onChanged: (dynamic val) {
                setState(() {
                  _paymentMethod = PaymentMethods.cardSalon;
                  _createAppointment.selectPaymentMethod(PaymentMethods.cardSalon);
                });
                Navigator.pop(context);
              },
              activeColor: AppTheme.black,
              title: Row(
                children: [
                  Text(
                    AppLocalizations.of(context)?.card ?? 'Card',
                    style: AppTheme.headLine4.copyWith(
                      color: AppTheme.black,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
            ),
            RadioListTile(
              value: PaymentMethods.cashSalon,
              groupValue: _paymentMethod,
              onChanged: (dynamic val) {
                setState(() {
                  _paymentMethod = PaymentMethods.cashSalon;
                  _createAppointment.selectPaymentMethod(PaymentMethods.cashSalon);
                });
                Navigator.pop(context);
              },
              activeColor: AppTheme.black,
              title: Row(
                children: [
                  Text(
                    AppLocalizations.of(context)?.cash ?? 'Cash',
                    style: AppTheme.headLine4.copyWith(
                      color: AppTheme.black,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: () async {},
            child: Container(
              height: 60.h,
              width: 0.5.sw,
              decoration: const BoxDecoration(color: AppTheme.creamBrown, borderRadius: BorderRadius.only(topLeft: Radius.circular(28))),
              child: Center(
                child: Text(
                  AppLocalizations.of(context)?.bookNow ?? "Book Now",
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
