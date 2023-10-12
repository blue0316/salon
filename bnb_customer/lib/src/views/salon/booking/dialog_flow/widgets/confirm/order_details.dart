import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/authentication/auth_provider.dart';
import 'package:bbblient/src/controller/create_apntmnt_provider/create_appointment_provider.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/firebase/customer.dart';
import 'package:bbblient/src/firebase/transaction.dart';
import 'package:bbblient/src/models/customer/credit_card.dart';
import 'package:bbblient/src/models/customer/customer.dart';
import 'package:bbblient/src/models/enums/status.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/models/transaction.dart';
import 'package:bbblient/src/utils/currency/currency.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/utils/time.dart';
import 'package:bbblient/src/views/salon/booking/dialog_flow/widgets/colors.dart';
import 'package:bbblient/src/views/salon/booking/dialog_flow/widgets/day_and_time/day_and_time.dart';
import 'package:bbblient/src/views/salon/booking/confirmation_success.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:bbblient/src/views/widgets/buttons.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'dart:js' as js;
// import 'dart:html' as html;
import 'pay_dialog.dart';

// ORDER LIST
class OrderDetails extends ConsumerStatefulWidget {
  final TabController tabController;

  const OrderDetails({Key? key, required this.tabController}) : super(key: key);

  @override
  ConsumerState<OrderDetails> createState() => _OrderListState();
}

class _OrderListState extends ConsumerState<OrderDetails> {
  bool acceptTerms = false;

  bool spinner = false;

  @override
  Widget build(BuildContext context) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final CreateAppointmentProvider _createAppointmentProvider = ref.watch(createAppointmentProvider);
    final AuthProvider _auth = ref.watch(authProvider);
    SalonModel salonModel = _salonProfileProvider.chosenSalon;

    final ThemeData theme = _salonProfileProvider.salonTheme;
    ThemeType themeType = _salonProfileProvider.themeType;

    // final PriceAndDurationModel _priceAndDuration = _createAppointmentProvider.priceAndDuration[_createAppointmentProvider.chosenMaster?.masterId] ?? PriceAndDurationModel();

    // TimeOfDay _startTime = Time().stringToTime(_createAppointmentProvider.selectedAppointmentSlot!);
    // TimeOfDay _endTime = _startTime.addMinutes(int.parse(_priceAndDuration.duration!));
    // '${_createAppointmentProvider.getStartTime()} - ${_createAppointmentProvider.getEndTime()}',

    // String totalAmount = _createAppointmentProvider.priceAndDuration[_createAppointmentProvider.chosenMaster?.masterId]?.price ?? '0'; // _priceAndDuration.price!;
    String totalAmount = _createAppointmentProvider.totalAmount;

    double deposit = _createAppointmentProvider.totalDeposit;
    // double payAtAppointment = double.parse(totalAmount) - deposit;

    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
            // shrinkWrap: true,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: _createAppointmentProvider.chosenServices
                    .map(
                      (service) => ServiceNameAndPrice(
                        serviceName: service.translations?[AppLocalizations.of(context)?.localeName ?? 'en'] ?? service.translations?['en'] ?? '',
                        // servicePrice: '${getCurrency(salonModel.countryCode!)}${_createAppointmentProvider.chosenMaster?.servicesPriceAndDuration?[service.serviceId]?.price}',
                        servicePrice:
                            // NOT SINGLE MASTER
                            (!_salonProfileProvider.isSingleMaster)
                                ? (service.isPriceRange)
                                    ? "${getCurrency(salonModel.countryCode!)}${service.priceAndDuration?.price ?? '0'}-${getCurrency(salonModel.countryCode!)}${service.priceAndDurationMax?.price ?? '0'}"
                                    : (service.isPriceStartAt)
                                        ? "${getCurrency(salonModel.countryCode!)}${_createAppointmentProvider.chosenMaster!.originalServicesPriceAndDuration![service.serviceId]?.price ?? '0'}+"
                                        : "${getCurrency(salonModel.countryCode!)}${_createAppointmentProvider.chosenMaster!.originalServicesPriceAndDuration![service.serviceId]?.price ?? '0'}"

                                // SINGLE MASTER
                                : (service.isPriceRange)
                                    ? "${getCurrency(salonModel.countryCode!)}${service.priceAndDuration!.price ?? '0'}-${getCurrency(salonModel.countryCode!)}${service.priceAndDurationMax!.price ?? '0'}"
                                    : (service.isPriceStartAt)
                                        ? "${getCurrency(salonModel.countryCode!)}${service.priceAndDuration!.price ?? '0'}+"
                                        : "${getCurrency(salonModel.countryCode!)}${service.priceAndDuration!.price ?? '0'}",
                      ),
                    )
                    .toList(),
              ),
              SizedBox(height: 10.sp),

              const GradientDivider(),

              // SERVICE PROVIDER DETAILS
              ServiceNameAndPrice(
                notService: true,
                serviceName: AppLocalizations.of(context)?.serviceProvider ?? "Service provider:",
                servicePrice: '${_createAppointmentProvider.chosenMaster?.personalInfo?.lastName} ${_createAppointmentProvider.chosenMaster?.personalInfo?.firstName}',
              ),

              ServiceNameAndPrice(
                notService: true,
                serviceName: '${AppLocalizations.of(context)?.date ?? "Date"}:',
                servicePrice: Time().getDateInStandardFormat(_createAppointmentProvider.chosenDay),
              ),

              ServiceNameAndPrice(
                notService: true,
                serviceName: '${AppLocalizations.of(context)?.time ?? "Time"}:',
                // servicePrice: '${Time().timeToString(_startTime)} - ${Time().timeToString(_endTime)}',
                servicePrice: (!_salonProfileProvider.isSingleMaster) ? '${_createAppointmentProvider.getStartTime()} - ${_createAppointmentProvider.getEndTime()}' : "${_createAppointmentProvider.selectedAppointmentSlot} - ${_createAppointmentProvider.selectedSlotEndTime}",
              ),

              const GradientDivider(),

              ServiceNameAndPrice(
                notService: true,
                serviceName: '${AppLocalizations.of(context)?.total ?? 'Total'}:',
                // servicePrice: '${getCurrency(salonModel.countryCode!)}$totalAmount',
                servicePrice:
                    // NOT SINGLE MASTER
                    (!_salonProfileProvider.isSingleMaster)
                        ? (_createAppointmentProvider.isPriceFrom!)
                            ? "${getCurrency(salonModel.countryCode!)}${_createAppointmentProvider.priceAndDuration[_createAppointmentProvider.chosenMaster?.masterId]?.price ?? '-'} ${_createAppointmentProvider.isPriceFrom! ? "+" : ""}"
                            : (_createAppointmentProvider.priceAndDuration[_createAppointmentProvider.chosenMaster?.masterId]?.priceMax != null && _createAppointmentProvider.priceAndDuration[_createAppointmentProvider.chosenMaster?.masterId]?.priceMax != '0')
                                ? "${getCurrency(salonModel.countryCode!)}${_createAppointmentProvider.priceAndDuration[_createAppointmentProvider.chosenMaster?.masterId]?.price ?? '-'}-${getCurrency(salonModel.countryCode!)}${_createAppointmentProvider.priceAndDuration[_createAppointmentProvider.chosenMaster?.masterId]?.priceMax ?? '-'}"
                                : "${getCurrency(salonModel.countryCode!)}${_createAppointmentProvider.priceAndDuration[_createAppointmentProvider.chosenMaster?.masterId]?.price ?? '-'} ${_createAppointmentProvider.isPriceFrom! ? "+" : ""}"

                        // SINGLE MASTER
                        : _createAppointmentProvider.isPriceFrom!
                            ? "${getCurrency(salonModel.countryCode!)}${_createAppointmentProvider.servicePrice ?? '-'} ${_createAppointmentProvider.isPriceFrom! ? "+" : ""}"
                            : _createAppointmentProvider.serviceMaxPrice != '0'
                                ? "${getCurrency(salonModel.countryCode!)}${_createAppointmentProvider.servicePrice ?? '-'}-${getCurrency(salonModel.countryCode!)}${_createAppointmentProvider.serviceMaxPrice ?? '-'}"
                                : "${getCurrency(salonModel.countryCode!)}${_createAppointmentProvider.servicePrice ?? '-'} ${_createAppointmentProvider.isPriceFrom! ? "+" : ""}",
              ),

              ServiceNameAndPrice(
                notService: true,
                serviceName: AppLocalizations.of(context)?.payAtAppointment ?? "Pay at Appointment:",
                servicePrice: '${getCurrency(salonModel.countryCode!)}${double.parse(totalAmount) - deposit}',
              ),

              ServiceNameAndPrice(
                notService: true,
                serviceName: AppLocalizations.of(context)?.depositToBook ?? "Deposit to book:",
                servicePrice: '${getCurrency(salonModel.countryCode!)}$deposit',
              ),

              Padding(
                padding: EdgeInsets.only(bottom: 12.sp),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        AppLocalizations.of(context)?.payNow ?? "Pay Now:",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: DeviceConstraints.getResponsiveSize(context, 18.sp, 18.sp, 20.sp),
                          color: theme.colorScheme.tertiary,
                          fontFamily: 'Inter-Medium',
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 0,
                      child: Text(
                        '${getCurrency(salonModel.countryCode!)}$deposit', // totalAmount',
                        // '\$${_createAppointmentProvider.priceAndDuration[_createAppointmentProvider.chosenMaster?.masterId]?.price ?? '0'}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: DeviceConstraints.getResponsiveSize(context, 18.sp, 18.sp, 20.sp),
                          color: theme.colorScheme.tertiary,
                          fontFamily: 'Inter-Medium',
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              if (salonModel.cancellationAndNoShowPolicy.setCancellationAndNoShowPolicy == true)
                Padding(
                  padding: EdgeInsets.only(top: 10.sp),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Theme(
                        data: Theme.of(context).copyWith(
                          unselectedWidgetColor: theme.colorScheme.tertiary, // ,
                        ),
                        child: Checkbox(
                          checkColor: Colors.white,
                          fillColor: MaterialStateProperty.all(themeType == ThemeType.GentleTouchDark ? Colors.black : theme.primaryColor),
                          value: acceptTerms,
                          side: MaterialStateBorderSide.resolveWith(
                            (states) => BorderSide(
                              width: 1.0,
                              color: themeType == ThemeType.GentleTouchDark ? Colors.white : theme.primaryColor,
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              acceptTerms = !acceptTerms;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)?.understandAndAccept ?? "I understand and accept the ",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.normal,
                                fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 17.sp, 18.sp),
                                color: theme.colorScheme.tertiary,
                                fontFamily: 'Inter-Medium',
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                const CancellationPolicyScreen().show(context);
                              },
                              child: Text(
                                AppLocalizations.of(context)?.cancellationPolicy ?? "Cancelation Policy",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w500,
                                  fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 17.sp, 18.sp),
                                  color: theme.primaryColor,
                                  fontFamily: 'Inter-Medium',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              SizedBox(height: 20.sp),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_rounded,
                        size: 30.sp,
                        color: theme.colorScheme.tertiary.withOpacity(0.6),
                      ),
                      SizedBox(width: 10.sp),
                      GestureDetector(
                        onTap: () {
                          // const ThankYou().show(context);
                        },
                        child: Text(
                          AppLocalizations.of(context)?.importantInformation ?? "Important Information",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 17.sp, 18.sp),
                            color: theme.colorScheme.tertiary,
                            fontFamily: 'Inter-Medium',
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.sp),
                  Text(
                    (salonModel.cancellationAndNoShowPolicy.setCancellationAndNoShowPolicy == true)
                        ? '${AppLocalizations.of(context)?.toCancel1 ?? 'You can cancel up to'} ${salonModel.cancellationAndNoShowPolicy.chargeWhenNoShow} ${AppLocalizations.of(context)?.toCancel2 ?? 'before the appointment without any charge. Your deposit will be returned to your card within 2 business days'}'
                        : '${AppLocalizations.of(context)?.toCancel3 ?? 'To cancel or reschedule please contact'} ${salonModel.salonName}. ${AppLocalizations.of(context)?.toCancel4 ?? 'You can cancel up to 24 hours before the appointment without any charge. You deposit will be returned to your card within 2 business days'}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 17.sp, 18.sp),
                      color: theme.colorScheme.tertiary.withOpacity(0.6),
                      fontFamily: 'Inter-Medium',
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10.sp),

              const Spacer(),

              Column(
                children: [
                  (deposit != 0 || salonModel.cancellationAndNoShowPolicy.chargeWhenNoShowBool == true || salonModel.cancellationAndNoShowPolicy.chargeWhenCancelledBool == true)
                      ? DefaultButton(
                          borderRadius: 60,
                          onTap: () async {
                            if (salonModel.cancellationAndNoShowPolicy.setCancellationAndNoShowPolicy == true) {
                              if (!acceptTerms) {
                                // Terms Checkbox is unchecked

                                showToast(
                                  AppLocalizations.of(context)?.pleaseAcceptCancellationPolicy ?? "Please accept the cancellation policy",
                                );

                                return;
                              }
                            }

                            CustomerModel? currentCustomer = _auth.currentCustomer;

                            CustomerModel customer = CustomerModel(
                              customerId: currentCustomer!.customerId,
                              personalInfo: currentCustomer.personalInfo,
                              registeredSalons: [],
                              createdAt: DateTime.now(),
                              avgRating: 3.0,
                              noOfRatings: 6,
                              profilePicUploaded: false,
                              profilePic: "",
                              profileCompleted: false,
                              quizCompleted: false,
                              preferredGender: "male",
                              preferredCategories: [],
                              locations: [],
                              fcmToken: "",
                              locale: "en",
                              favSalons: [],
                              referralLink: "",
                            );

                            // const ConfirmedDialog().show(context);

                            // ---------------------------- +++++++++++++++ ----------------------------
                            setState(() => spinner = true);

                            final TransactionModel newTransaction = TransactionModel(
                              amount: '$deposit',
                              timeInitiated: DateTime.now(),
                              salonId: salonModel.salonId,
                            );

                            String? transactionId = await TransactionApi().createTransaction(newTransaction);

                            if (transactionId == null) {
                              // Transaction must not be null (a doc must me created in transactions collection)
                              showToast(AppLocalizations.of(context)?.somethingWentWrongPleaseTryAgain ?? 'Something went wrong, please try again');
                              return;
                            } else {
                              TransactionApi().streamTransaction(transactionId).listen((event) async {
                                for (TransactionModel transaction in event) {
                                  if (transaction.responseCode != null) {
                                    if (transaction.responseCode == 'A' || transaction.responseCode == 'E') {
                                      // ADD CARD TO CARDS SUB-COLLECTION IN CUSTOMER DOCUMENT
                                      // IF REFERENCE EXISTS

                                      if (transaction.cardReference != null) {
                                        await CustomerApi().createCard(
                                          customerId: customer.customerId,
                                          card: CreditCard(
                                            cardNumber: transaction.cardNumber ?? '',
                                            cardExpiry: transaction.cardExpiry ?? '',
                                            cardReference: transaction.cardReference ?? '',
                                            cardType: transaction.cardType ?? '',
                                            merchantRef: transaction.merchantRef ?? '',
                                            storedCredentialUse: transaction.storedCredentialUse ?? '',
                                          ),
                                        );
                                      }

                                      Navigator.pop(context); // closes payroc dialog

                                      // html.window.open('https://yogasm.firebaseapp.com/confirmation?RESPONSECODE=${transaction.responseCode}?transactionId=$transactionId', "_self");
                                      // Build Appointment
                                      if (_createAppointmentProvider.chosenServices.length > 1) {
                                        if (!_salonProfileProvider.isSingleMaster) {
                                          await _createAppointmentProvider.saveNewAppointmentForMultipleServices(
                                            isSingleMaster: _salonProfileProvider.isSingleMaster,
                                            customer: customer,
                                            transactionId: transactionId,
                                          );
                                        } else {
                                          await _createAppointmentProvider.saveAppointmentForMultipleServices(
                                            isSingleMaster: _salonProfileProvider.isSingleMaster,
                                            customer: customer,
                                            transactionId: transactionId,
                                          );
                                        }
                                      } else {
                                        //call multiple appointment service save option

                                        if (!_salonProfileProvider.isSingleMaster) {
                                          await _createAppointmentProvider.saveAppointment(
                                            isSingleMaster: _salonProfileProvider.isSingleMaster,
                                            customer: customer,
                                            transactionId: transactionId,
                                          );
                                        } else {
                                          await _createAppointmentProvider.saveAppointmentSingleMaster(
                                            isSingleMaster: _salonProfileProvider.isSingleMaster,
                                            customer: customer,
                                            transactionId: transactionId,
                                          );
                                        }
                                      }

                                      setState(() => spinner = false);

                                      if (_createAppointmentProvider.bookAppointmentStatus == Status.success) {
                                        // Show Success Dialog
                                        ConfirmationSuccess(
                                          responseCode: '${transaction.responseCode}',
                                          transactionID: transactionId,
                                        ).show(context);
                                      } else {
                                        showToast(AppLocalizations.of(context)?.somethingWentWrongPleaseTryAgain ?? 'Something went wrong, please try again');
                                      }
                                    }
                                    if (transaction.responseCode == 'D') {
                                      setState(() => spinner = false);

                                      ConfirmationError(
                                        responseCode: '${transaction.responseCode}',
                                      ).show(context);

                                      // html.window.open('https://yogasm.firebaseapp.com/confirmationError?RESPONSECODE=${transaction.responseCode}', "_self");
                                    }
                                  }
                                }
                              });

                              PayDialog(
                                amount: totalAmount,
                                transactionId: transactionId,
                                currency: getCurrency(salonModel.countryCode!),
                              ).show(context);
                            }
                          },
                          color: dialogButtonColor(themeType, theme),
                          textColor: loaderColor(themeType),
                          height: 60.h,
                          label: (AppLocalizations.of(context)?.registerCard ?? 'Register Card').toCapitalized(), //  'Pay ${(deposit != 0) ? deposit : totalAmount}${getCurrency(salonModel.countryCode!)} deposit',
                          // isLoading: _createAppointmentProvider.bookAppointmentStatus == Status.loading,
                          isLoading: spinner,
                          loaderColor: loaderColor(themeType),
                          fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 17.sp, 18.sp),
                          suffixIcon: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: loaderColor(themeType),
                            size: 18.sp,
                          ),
                        )
                      : DefaultButton(
                          borderRadius: 60,
                          onTap: () async {
                            if (salonModel.cancellationAndNoShowPolicy.setCancellationAndNoShowPolicy == true) {
                              if (!acceptTerms) {
                                // Terms Checkbox is unchecked

                                showToast(
                                  AppLocalizations.of(context)?.pleaseAcceptCancellationPolicy ?? "Please accept the cancellation policy",
                                );

                                return;
                              }
                            }

                            CustomerModel? currentCustomer = _auth.currentCustomer;

                            CustomerModel customer = CustomerModel(
                              customerId: currentCustomer!.customerId,
                              personalInfo: currentCustomer.personalInfo,
                              registeredSalons: [],
                              createdAt: DateTime.now(),
                              avgRating: 3.0,
                              noOfRatings: 6,
                              profilePicUploaded: false,
                              profilePic: "",
                              profileCompleted: false,
                              quizCompleted: false,
                              preferredGender: "male",
                              preferredCategories: [],
                              locations: [],
                              fcmToken: "",
                              locale: "en",
                              favSalons: [],
                              referralLink: "",
                            );

                            // Build Appointment
                            if (_createAppointmentProvider.chosenServices.length > 1) {
                              //call multiple appointment service save option

                              if (!_salonProfileProvider.isSingleMaster) {
                                await _createAppointmentProvider.saveNewAppointmentForMultipleServices(
                                  isSingleMaster: _salonProfileProvider.isSingleMaster,
                                  customer: customer,
                                  transactionId: null,
                                );
                              } else {
                                await _createAppointmentProvider.saveAppointmentForMultipleServices(
                                  isSingleMaster: _salonProfileProvider.isSingleMaster,
                                  customer: customer,
                                  transactionId: null,
                                );
                              }
                            } else {
                              //call this single appointment service save function

                              if (!_salonProfileProvider.isSingleMaster) {
                                await _createAppointmentProvider.saveAppointment(
                                  isSingleMaster: _salonProfileProvider.isSingleMaster,
                                  customer: customer,
                                  transactionId: null,
                                );
                              } else {
                                await _createAppointmentProvider.saveAppointmentSingleMaster(
                                  isSingleMaster: _salonProfileProvider.isSingleMaster,
                                  customer: customer,
                                  transactionId: null,
                                );
                              }
                            }

                            if (_createAppointmentProvider.bookAppointmentStatus == Status.success) {
                              const ConfirmationSuccess(
                                responseCode: 'A',
                                transactionID: '',
                                isLocal: true,
                              ).show(context);
                            } else {
                              showToast(AppLocalizations.of(context)?.somethingWentWrongPleaseTryAgain ?? 'Something went wrong, please try again');
                            }
                          },
                          color: dialogButtonColor(themeType, theme),
                          textColor: loaderColor(themeType),
                          height: 60.h,
                          label: (AppLocalizations.of(context)?.book ?? 'Book').toCapitalized(),
                          isLoading: _createAppointmentProvider.bookAppointmentStatus == Status.loading,
                          loaderColor: loaderColor(themeType),
                          fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
                          suffixIcon: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: loaderColor(themeType),
                            size: 18.sp,
                          ),
                        ),
                ],
              ),
              // SizedBox(height: 20.h),
            ],
          ),
        ),
      ],
    );
  }
}

class GradientDivider extends StatelessWidget {
  const GradientDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.sp),
      child: Container(
        width: double.infinity,
        height: 1.5.sp,
        decoration: const BoxDecoration(
          color: Colors.white,
          gradient: LinearGradient(
            colors: [Color.fromARGB(43, 74, 74, 74), Color(0XFF4A4A4A), Color.fromARGB(43, 74, 74, 74)],
          ),
        ),
      ),
    );
  }
}

class CancellationPolicyScreen<T> extends ConsumerWidget {
  const CancellationPolicyScreen({Key? key}) : super(key: key);

  Future<void> show(BuildContext context) async {
    await showDialog<T>(
      context: context,
      builder: (context) => this,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var mediaQuery = MediaQuery.of(context).size;
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    SalonModel salonModel = _salonProfileProvider.chosenSalon;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Dialog(
        backgroundColor: theme.dialogBackgroundColor,
        insetPadding: EdgeInsets.symmetric(
          horizontal: DeviceConstraints.getResponsiveSize(
            context,
            0,
            20, // mediaQuery.width / 5,
            mediaQuery.width / 6,
          ),
          vertical: DeviceConstraints.getResponsiveSize(context, 0, 50.h, 50.h),
        ),
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10), // , horizontal: 5),

            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Padding(
                          padding: EdgeInsets.only(left: 20.sp),
                          child: Icon(
                            Icons.arrow_back_ios_rounded,
                            color: theme.colorScheme.tertiary.withOpacity(0.6),
                            size: DeviceConstraints.getResponsiveSize(context, 20.sp, 20.sp, 20.sp),
                          ),
                        ),
                      ),
                      const Spacer(flex: 2),
                      Text(
                        (AppLocalizations.of(context)?.cancellationPolicy ?? "cancelation Policy").toUpperCase(),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: DeviceConstraints.getResponsiveSize(context, 18.sp, 18.sp, 20.sp),
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Inter-Medium',
                          color: theme.colorScheme.onBackground,
                        ),
                      ),
                      const Spacer(flex: 2),
                    ],
                  ),
                  const Space(factor: 2),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: DeviceConstraints.getResponsiveSize(context, 10.sp, 20.sp, 30.sp),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)?.cancelingAppointment ?? "Canceling Appointment",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
                            color: theme.colorScheme.tertiary,
                            fontFamily: 'Inter-Medium',
                          ),
                        ),
                        SizedBox(height: 10.sp),
                        Text(
                          'To cancel or reschedule please contact ${salonModel.salonName}. You can cancel up to ${salonModel.cancellationAndNoShowPolicy.cancellationWindow} before the appointment without any charge. You deposit will be returned to your card within 2 business days',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.normal,
                            fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
                            color: theme.colorScheme.tertiary.withOpacity(0.6),
                            fontFamily: 'Inter-Medium',
                          ),
                        ),
                        SizedBox(height: 35.sp),
                        Text(
                          'Not showing to the Appointment',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
                            color: theme.colorScheme.tertiary,
                            fontFamily: 'Inter-Medium',
                          ),
                        ),
                        SizedBox(height: 10.sp),
                        Text(
                          'To cancel or reschedule please contact ${salonModel.salonName}. You can cancel up to ${salonModel.cancellationAndNoShowPolicy.chargeWhenNoShow} before the appointment without any charge. You deposit will be returned to your card within 2 business days',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.normal,
                            fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
                            color: theme.colorScheme.tertiary.withOpacity(0.6),
                            fontFamily: 'Inter-Medium',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
