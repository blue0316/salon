import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/authentication/auth_provider.dart';
import 'package:bbblient/src/controller/create_apntmnt_provider/create_appointment_provider.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/firebase/transaction.dart';
import 'package:bbblient/src/models/cat_sub_service/price_and_duration.dart';
import 'package:bbblient/src/models/customer/customer.dart';
import 'package:bbblient/src/models/enums/status.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/models/transaction.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/time.dart';
import 'package:bbblient/src/views/payment/payment.dart';
import 'package:bbblient/src/views/salon/booking/dialog_flow/widgets/colors.dart';
import 'package:bbblient/src/views/salon/booking/dialog_flow/widgets/day_and_time/day_and_time.dart';
import 'package:bbblient/src/views/salon/booking/thank_you.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:bbblient/src/views/widgets/buttons.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:js' as js;

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

    final PriceAndDurationModel _priceAndDuration = _createAppointmentProvider.priceAndDuration[_createAppointmentProvider.chosenMaster?.masterId] ?? PriceAndDurationModel();

    TimeOfDay _startTime = Time().stringToTime(_createAppointmentProvider.selectedAppointmentSlot!);

    TimeOfDay _endTime = _startTime.addMinutes(
      int.parse(_priceAndDuration.duration),
    );

    String totalAmount = _priceAndDuration.price;

    return Column(
      children: [
        Expanded(
          flex: 1,
          child: ListView(
            shrinkWrap: true,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: _createAppointmentProvider.chosenServices
                    .map(
                      (service) => ServiceNameAndPrice(
                        serviceName: service.translations[AppLocalizations.of(context)?.localeName ?? 'en'].toString(),
                        servicePrice: service.isFixedPrice
                            ? "${salonModel.selectedCurrency}${service.priceAndDuration.price}"
                            : service.isPriceRange
                                ? "${salonModel.selectedCurrency}${service.priceAndDuration.price} - ${salonModel.selectedCurrency}${service.priceAndDurationMax!.price}"
                                : "${salonModel.selectedCurrency}${service.priceAndDuration.price} - ${salonModel.selectedCurrency}∞",
                      ),
                    )
                    .toList(),
              ),
              SizedBox(height: 10.sp),

              const GradientDivider(),

              // SERVICE PROVIDER DETAILS
              ServiceNameAndPrice(
                notService: true,
                serviceName: 'Service provider:',
                servicePrice: '${_createAppointmentProvider.chosenMaster?.personalInfo?.lastName} ${_createAppointmentProvider.chosenMaster?.personalInfo?.firstName}',
              ),

              ServiceNameAndPrice(
                notService: true,
                serviceName: 'Date:',
                servicePrice: Time().getDateInStandardFormat(_createAppointmentProvider.chosenDay),
              ),

              ServiceNameAndPrice(
                notService: true,
                serviceName: 'Time:',
                servicePrice: '$_startTime - $_endTime',
              ),

              const GradientDivider(),

              ServiceNameAndPrice(
                notService: true,
                serviceName: 'Total:',
                servicePrice: totalAmount,
              ),

              const ServiceNameAndPrice(
                notService: true,
                serviceName: 'Pay at Appointment:',
                servicePrice: '--',
              ),

              const ServiceNameAndPrice(
                notService: true,
                serviceName: 'Deposit to book:',
                servicePrice: '---',
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
                        'Pay Now:',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: DeviceConstraints.getResponsiveSize(context, 18.sp, 21.sp, 20.sp),
                          color: theme.colorScheme.tertiary,
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 0,
                      child: Text(
                        '\$${_createAppointmentProvider.priceAndDuration[_createAppointmentProvider.chosenMaster?.masterId]?.price ?? '0'}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: DeviceConstraints.getResponsiveSize(context, 18.sp, 21.sp, 20.sp),
                          color: theme.colorScheme.tertiary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10.sp),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Theme(
                    data: Theme.of(context).copyWith(
                      unselectedWidgetColor: theme.colorScheme.tertiary, // ,
                    ),
                    child: Checkbox(
                      checkColor: Colors.white,
                      fillColor: MaterialStateProperty.all(theme.primaryColor),
                      value: acceptTerms,
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
                          'I understand and accept the ',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.normal,
                            fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
                            color: theme.colorScheme.tertiary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            const CancellationPolicyScreen().show(context);
                          },
                          child: Text(
                            'Cancelation Policy',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w500,
                              fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
                              color: theme.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 5.sp),
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
                    'Important Information',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
                      color: theme.colorScheme.tertiary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.sp),
            Text(
              'To cancel or reschedule please contact LK Nails. You can cancel up to 24 hours before the appointment without any charge. You deposit will be returned to your card within 2 business days',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
                color: theme.colorScheme.tertiary.withOpacity(0.6),
              ),
            ),
          ],
        ),

        SizedBox(height: 40.sp),

        Expanded(
          flex: 0,
          child: Column(
            children: [
              DefaultButton(
                borderRadius: 60,
                onTap: () async {
                  if (!acceptTerms) {
                    // Terms Checkbox is unchecked

                    showToast('Please accept the cancellation policy');

                    return;
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

                  // if (_createAppointmentProvider.chosenServices.length > 1) {
                  //   //call this single appointment service save function
                  //   await _createAppointmentProvider.saveNewAppointmentForMultipleServices(customer: customer);
                  // } else {
                  //   //call multiple appointment service save option
                  //   await _createAppointmentProvider.saveAppointment(customer: customer);
                  // }

                  // const ConfirmedDialog().show(context);

                  // ---------------------------- +++++++++++++++ ----------------------------
                  setState(() => spinner = true);

                  final TransactionModel newTransaction = TransactionModel(
                    amount: totalAmount,
                    timeInitiated: DateTime.now(),
                  );

                  String? transactionId = await TransactionApi().createTransaction(newTransaction);

                  setState(() => spinner = false);

                  js.context.callMethod(
                    'open',
                    ['https://yogasm.firebaseapp.com/payment?amount=$totalAmount&currency=USD&transactionId=$transactionId&terminalId=5363001'],
                  );

                  // https://yogasm.firebaseapp.com/appointments?id=mvEdvmbMxRjgwFrzIjao

                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const Payment(),
                  //   ),
                  // );

                  // bool enabledOTP = _salonProfileProvider.themeSettings?.displaySettings?.enableOTP ?? true;

                  // if (!acceptTerms) {
                  //   // Terms Checkbox is unchecked

                  //   showToast(AppLocalizations.of(context)?.pleaseAgree ?? "Please agree to the terms and conditions");

                  //   return;
                  // }

                  // bool success = await _createAppointmentProvider.finishBooking(
                  //   context: context,
                  //   customerModel: enabledOTP ? _auth.currentCustomer! : _auth.currentCustomerWithoutOTP!,
                  // );

                  // if (success) {
                  //   // Pop current dialog
                  //   Navigator.of(context).pop();

                  //   const ConfirmedDialog().show(context);
                  // } else {
                  //   showToast(AppLocalizations.of(context)?.somethingWentWrong ?? "Something went wrong");
                  // }
                },
                color: dialogButtonColor(themeType, theme),
                textColor: loaderColor(themeType),
                height: 60,
                label: 'Pay $totalAmount\$ deposit',
                // isLoading: _createAppointmentProvider.bookAppointmentStatus == Status.loading,
                isLoading: spinner,
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
        ),
        // SizedBox(height: 20.h),
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
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.sp, horizontal: 30.sp),
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
                      padding: const EdgeInsets.only(left: 15),
                      child: Icon(
                        Icons.arrow_back_ios_rounded,
                        color: theme.colorScheme.tertiary.withOpacity(0.6),
                        size: DeviceConstraints.getResponsiveSize(context, 20.sp, 20.sp, 20.sp),
                      ),
                    ),
                  ),
                  const Spacer(flex: 2),
                  Text(
                    'cancelation Policy'.toUpperCase(),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: DeviceConstraints.getResponsiveSize(context, 18.sp, 18.sp, 20.sp),
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Inter',
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
                      'Canceling Appointment ',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
                        color: theme.colorScheme.tertiary,
                      ),
                    ),
                    SizedBox(height: 10.sp),
                    Text(
                      'To cancel or reschedule please contact LK Nails. You can cancel up to 24 hours before the appointment without any charge. You deposit will be returned to your card within 2 business days',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.normal,
                        fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
                        color: theme.colorScheme.tertiary.withOpacity(0.6),
                      ),
                    ),
                    SizedBox(height: 35.sp),
                    Text(
                      'Not showing to the Appointment',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
                        color: theme.colorScheme.tertiary,
                      ),
                    ),
                    SizedBox(height: 10.sp),
                    Text(
                      'To cancel or reschedule please contact LK Nails. You can cancel up to 24 hours before the appointment without any charge. You deposit will be returned to your card within 2 business days',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.normal,
                        fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
                        color: theme.colorScheme.tertiary.withOpacity(0.6),
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
    );
  }
}
