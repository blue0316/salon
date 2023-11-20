// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:convert';
import 'dart:html';
import 'package:bbblient/main.dart';
import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/firebase/appointments.dart';
import 'package:bbblient/src/firebase/transaction.dart';
import 'package:bbblient/src/models/appointment/appointment.dart';
import 'package:bbblient/src/models/backend_codings/appointment.dart';
import 'package:bbblient/src/models/cancellation_noShow_policy.dart';
import 'package:bbblient/src/models/enums/status.dart';
import 'package:bbblient/src/models/transaction.dart';
import 'package:bbblient/src/mongodb/db_service.dart';
import 'package:bbblient/src/routes.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/currency/currency.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:screenshot/screenshot.dart';
import 'details/services_details.dart';
import 'details/your_details.dart';
import 'widgets/appointment_header.dart';
import 'widgets/button.dart';
import 'widgets/calendar_buttons.dart';
import 'widgets/date_time_price.dart';
import 'widgets/theme_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:html' as html;

class AppointmentViewDetails extends ConsumerStatefulWidget {
  static const route = "/appointments";
  final String appointmentDocId;

  const AppointmentViewDetails({Key? key, required this.appointmentDocId}) : super(key: key);

  @override
  ConsumerState<AppointmentViewDetails> createState() => _AppointmentViewDetailsState();
}

class _AppointmentViewDetailsState extends ConsumerState<AppointmentViewDetails> {
  AppointmentModel? appointment;
  bool appointmentCompleted = false;

  @override
  void initState() {
    super.initState();

    fetchDetails();
  }

  void fetchDetails() async {
    // Get Appointment
    appointment = await ref.read(appointmentProvider.notifier).fetchAppointmentMongo(
          appointmentID: widget.appointmentDocId,
        );

    // Get Salon Theme
    // ref.read(appointmentProvider.notifier).getSalonTheme(salon?.salonId);
    if (appointment != null) {
      ref.read(appointmentProvider.notifier).getTotalDeposit(appointment!);
    }

    setState(() {
      appointmentCompleted = appointment!.updates.contains('completed');
    });

    // Change Language based on salon
    String salonLocale = ref.read(appointmentProvider.notifier).salon!.locale;
    final repository = ref.watch(bnbProvider);
    repository.changeLocale(locale: Locale(salonLocale));

    // // ---------- GET BROWSER LANGUAGE ----------
    // String browserLanguage = html.window.navigator.language;

    // if (browserLanguage.isNotEmpty && browserLanguage.length >= 2) {
    //   String browserLocale = browserLanguage.substring(0, 2);

    //   if (availableLocales.contains(browserLocale)) {
    //     repository.changeLocale(locale: Locale(browserLocale));
    //   } else {
    //     repository.changeLocale(locale: const Locale('en'));
    //   }
    // } else {
    //   repository.changeLocale(locale: const Locale('en'));
    // }
  }

  bool shouldShowConfirmButton(DateTime appointmentTime) {
    final currentTime = DateTime.now();
    final timeDifference = appointmentTime.difference(currentTime);
    return timeDifference.inHours < 25;
  }

  final ScrollController serviceController = ScrollController();
  bool _spinner = false;

  // SCREENSHOT IMPLEMENTATION
  ScreenshotController screenshotController = ScreenshotController();
  // bool screenshotTapped = false;

  Future<void> downloadScreenshotFn() async {
    screenshotController.capture().then((Uint8List? value) {
      final _base64 = base64Encode(value!);
      final anchor = AnchorElement(href: 'data:application/octet-stream;base64,$_base64')
        ..download = "receipt.png"
        ..target = 'blank';

      document.body!.append(anchor);
      anchor.click();
      anchor.remove();
    });

    // setState(() => screenshotTapped = false);
  }

  @override
  Widget build(BuildContext context) {
    final _appointmentProvider = ref.watch(appointmentProvider);
    ThemeData theme = _appointmentProvider.salonTheme ?? AppTheme.customLightTheme;
    ThemeType themeType = _appointmentProvider.themeType ?? ThemeType.DefaultLight;
    final DatabaseProvider _dbProvider = ref.watch(dbProvider);

    return Scaffold(
      backgroundColor: scaffoldBGColor(themeType, theme),
      body: _appointmentProvider.appointmentStatus == Status.loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _appointmentProvider.appointmentStatus == Status.failed
              ? ErrorScreen(
                  backgroundColor: boxColor(themeType, theme), // isLightTheme ? const Color(0XFFEFEFEF) : theme.colorScheme.background,
                  textColor: confirmationTextColor(themeType, theme), // isLightTheme ? Colors.black : Colors.white,
                )
              : (appointment != null)
                  ? Column(
                      children: [
                        Header(
                          salonName: _appointmentProvider.salon?.salonName ?? '',
                          salonLogo: _appointmentProvider.salon?.salonLogo,
                          salonAddress: _appointmentProvider.salon?.address,
                          salonPhone: _appointmentProvider.salon?.phoneNumber,
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: DeviceConstraints.getResponsiveSize(context, 25, 0, 0),
                            ),
                            child: SizedBox(
                              // height: 700,
                              width: double.infinity,
                              // color: Colors.orange,

                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 30),
                                    Text(
                                      !appointmentCompleted ? AppLocalizations.of(context)?.appointmentConfirmation ?? 'Appointment Confirmation' : AppLocalizations.of(context)?.completedAppointment ?? 'Completed Appointment',
                                      style: theme.textTheme.bodyLarge!.copyWith(
                                        fontWeight: FontWeight.w500,
                                        fontSize: DeviceConstraints.getResponsiveSize(context, 20.sp, 30.sp, 40.sp),
                                        color: confirmationTextColor(themeType, theme),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    if (appointmentCompleted)
                                      ViewOrReview(
                                        appointment: appointment!,
                                        appointmentId: widget.appointmentDocId,
                                        viewReceiptOnTap: () {
                                          // setState(() => screenshotTapped = true);
                                          downloadScreenshotFn();
                                        },
                                      ),
                                    if (!appointmentCompleted)
                                      AddToCalendars(
                                        appointment: appointment!,
                                        appointmentID: widget.appointmentDocId,
                                      ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 20.0,
                                        horizontal: DeviceConstraints.getResponsiveSize(context, 10.w, 20.w, 70.w),
                                      ),
                                      child: Screenshot(
                                        controller: screenshotController,
                                        child: Container(
                                          // height: 700,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: scaffoldBGColor(themeType, theme),
                                            border: Border.all(color: const Color(0XFF999999), width: 0.5),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            vertical: DeviceConstraints.getResponsiveSize(context, 25, 20, 60.0),
                                            horizontal: DeviceConstraints.getResponsiveSize(context, 15, 30, 50),
                                          ),
                                          child: Column(
                                            children: [
                                              // if (screenshotTapped)
                                              //   Padding(
                                              //     padding: EdgeInsets.only(bottom: 15.sp),
                                              //     child: Text(
                                              //       'RECEIPT',
                                              //       style: theme.textTheme.bodyLarge!.copyWith(
                                              //         fontWeight: FontWeight.w500,
                                              //         fontSize: DeviceConstraints.getResponsiveSize(context, 20.sp, 35.sp, 35.sp),
                                              //         color: confirmationTextColor(themeType, theme),
                                              //       ),
                                              //       textAlign: TextAlign.center,
                                              //     ),
                                              //   ),
                                              DateTimePrice(
                                                appointment: appointment!,
                                                salonModel: _appointmentProvider.salon!,
                                              ),
                                              YourDetails(
                                                appointment: appointment!,
                                              ),
                                              ServiceDetailsSection(
                                                salon: _appointmentProvider.salon!,
                                                appointment: appointment,
                                                listViewController: serviceController,
                                              ),
                                              if (_appointmentProvider.salon!.countryCode == 'US')
                                                if (_appointmentProvider.salon?.cancellationAndNoShowPolicy.allowOnlineCancellation == false)
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Icon(
                                                        Icons.info_outline_rounded,
                                                        size: 50.sp,
                                                        color: theme.colorScheme.tertiary.withOpacity(0.6),
                                                      ),
                                                      SizedBox(width: 10.sp),
                                                      Flexible(
                                                        child: Text(
                                                          '${AppLocalizations.of(context)?.cancelNote1 ?? 'Please note that to cancel you have to contact'}  ${_appointmentProvider.salon?.salonName.toUpperCase()}. ${AppLocalizations.of(context)?.cancelNote2 ?? 'Online cancelation is not available at the moment.'}',
                                                          // 'Please note that to cancel you have to contact ${_appointmentProvider.salon?.salonName}. Online cancelation is not available at the moment. ',
                                                          style: theme.textTheme.bodyMedium?.copyWith(
                                                            fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 16.sp, 18.sp),
                                                            fontWeight: FontWeight.w400,
                                                            fontFamily: 'Inter',
                                                            color: theme.colorScheme.onBackground,
                                                          ),
                                                          textAlign: TextAlign.start,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                              if (!appointmentCompleted)
                                                Wrap(
                                                  direction: Axis.horizontal,
                                                  crossAxisAlignment: WrapCrossAlignment.center,
                                                  runAlignment: WrapAlignment.center,
                                                  spacing: 10,
                                                  runSpacing: 10,
                                                  children: [
                                                    // US CHECK
                                                    if (_appointmentProvider.salon!.countryCode == 'US') ...[
                                                      if (_appointmentProvider.salon?.cancellationAndNoShowPolicy.allowOnlineCancellation == true)
                                                        if (appointment?.status != AppointmentStatus.cancelled)
                                                          Button(
                                                            text: AppLocalizations.of(context)?.cancelAppointment ?? 'Cancel Appointment',
                                                            // onTap: (_appointmentProvider.salon?.cancellationAndNoShowPolicy.allowOnlineCancellation == false)
                                                            //     ? () {}
                                                            //     : () => _appointmentProvider.cancelAppointment(
                                                            //           isSingleMaster: _appointmentProvider.isSingleMaster,
                                                            //           appointmentID: appointmentDocId,
                                                            //           appointment: appointment!,
                                                            //           salon: _appointmentProvider.salon!,
                                                            //           salonMasters: _appointmentProvider.allMastersInSalon,
                                                            //           callback: () {
                                                            //             fetchDetails();
                                                            //           },
                                                            //         ),
                                                            onTap: () async {
                                                              DateTime now = DateTime.now();
                                                              Duration diff = appointment!.appointmentStartTime!.difference(now);
                                                              int hourDiff = diff.inHours;
                                                              double charge = 0;
                                                              double payableAmount = 0.0;
                                                              bool isRefund = false;
                                                              CancellationNoShowPolicy? policy;
                                                              List<CancellationPolicy?>? validPolicy;

                                                              if (_appointmentProvider.salon!.cancellationAndNoShowPolicy != null && _appointmentProvider.salon!.cancellationAndNoShowPolicy.chargeWhenCancelledBool! && appointment!.transactionId != null && appointment!.transactionId!.isNotEmpty) {
                                                                if (_appointmentProvider.salon!.cancellationAndNoShowPolicy.cancellationPolicies != null && _appointmentProvider.salon!.cancellationAndNoShowPolicy.cancellationPolicies!.isNotEmpty) {
                                                                  validPolicy = _appointmentProvider.salon!.cancellationAndNoShowPolicy.cancellationPolicies!
                                                                      .where(
                                                                        (element) => int.parse(element!.from!) <= hourDiff && hourDiff <= int.parse(element.to!),
                                                                      )
                                                                      .toList();
                                                                  if (validPolicy.isNotEmpty) {
                                                                    charge = appointment!.priceAndDuration.priceMax != null
                                                                        ? int.parse(appointment!.priceAndDuration.priceMax!) *
                                                                            (int.parse(
                                                                                  validPolicy.first!.percentage!,
                                                                                ) /
                                                                                100)
                                                                        : int.parse(appointment!.priceAndDuration.price!) *
                                                                            (int.parse(
                                                                                  validPolicy.first!.percentage!,
                                                                                ) /
                                                                                100);
                                                                  }
                                                                }

                                                                setState(() => _spinner = true);
                                                                // 9  http: //localhost:50828/appointments?id=655a63b4cea56b73a9290366;

                                                                TransactionModel? transaction = await TransactionApi(
                                                                  mongodbProvider: _dbProvider,
                                                                ).getTransaction(appointment!.transactionId!.first);

                                                                setState(() => _spinner = false);

                                                                if (double.parse(_appointmentProvider.totalDeposit) > charge) {
                                                                  isRefund = true;
                                                                  payableAmount = double.parse(_appointmentProvider.totalDeposit) - charge;
                                                                } else {
                                                                  payableAmount = charge - double.parse(_appointmentProvider.totalDeposit);
                                                                }

                                                                policy = CancellationNoShowPolicy(
                                                                  appointmentId: widget.appointmentDocId,
                                                                  customerId: appointment!.customer!.id,
                                                                  salonId: appointment!.salon.id,
                                                                  paymentType: isRefund ? CancellationNoShowPaymentType.refund : CancellationNoShowPaymentType.charge,
                                                                  type: CancellationNoShowType.cancellation,
                                                                  status: "pending",
                                                                  paymentInfo: CancellationPaymentInfo(
                                                                    cancellationFee: charge.toStringAsFixed(2),
                                                                    deposit: _appointmentProvider.totalDeposit,
                                                                    payableAmount: payableAmount.toStringAsFixed(2),
                                                                  ),
                                                                  paymentMethod: CancellationPaymentMethod(
                                                                    cardNumber: transaction!.cardNumber,
                                                                    cardReference: transaction.cardReference,
                                                                  ),
                                                                );

                                                                showMyDialog(
                                                                  context,
                                                                  bgColor: scaffoldBGColor(themeType, theme),
                                                                  child: DeleteClientNewTheme(
                                                                    title: _appointmentProvider.salon!.cancellationAndNoShowPolicy != null && _appointmentProvider.salon!.cancellationAndNoShowPolicy.chargeWhenCancelledBool! && appointment!.transactionId != null && appointment!.transactionId!.isNotEmpty
                                                                        ? (AppLocalizations.of(context)?.cancelAppointmentDialogue ?? "Are you sure you want to cancel this appointment?")
                                                                        : AppLocalizations.of(context)?.cancelAppointmentDialogue ?? "Do you want to mark appointment like “No-show”?",
                                                                    desc: "${getCurrency(_appointmentProvider.salon!.countryCode!)}${payableAmount.toStringAsFixed(2)} ${AppLocalizations.of(context)?.willBe ?? "will be"} ${isRefund ? AppLocalizations.of(context)?.refunded ?? "refunded" : AppLocalizations.of(context)?.charged ?? "charged"} ${AppLocalizations.of(context)?.asCancellationFee ?? "as Cancellation & No-show protection fee"}",
                                                                    delete: 'tr(Keys.yes)',
                                                                    cancel: 'tr(Keys.no)',
                                                                    onDelete: () async {
                                                                      if (_appointmentProvider.salon!.cancellationAndNoShowPolicy != null && _appointmentProvider.salon!.cancellationAndNoShowPolicy.chargeWhenCancelledBool! && appointment!.transactionId != null && appointment!.transactionId!.isNotEmpty) {
                                                                        await _appointmentProvider.createNoShowPolicy(policy: policy);
                                                                        await AppointmentApi(mongodbProvider: _dbProvider).updateMultipleAppointment(
                                                                          isSingleMaster: _appointmentProvider.isSingleMaster,
                                                                          appointmentModel: appointment,
                                                                          appointmentSubStatus: ActiveAppointmentSubStatus.cancelledByCustomer,
                                                                          appointmentStatus: AppointmentStatus.cancelled,
                                                                          salon: _appointmentProvider.salon!,
                                                                          salonMasters: _appointmentProvider.allMastersInSalon,
                                                                        );
                                                                        showToast(AppLocalizations.of(context)?.appointmentCancelledSuccessfully ?? 'Appointment cancelled succesfully');
                                                                      } else {
                                                                        await AppointmentApi(mongodbProvider: _dbProvider).updateMultipleAppointment(
                                                                          isSingleMaster: _appointmentProvider.isSingleMaster,
                                                                          appointmentModel: appointment,
                                                                          appointmentSubStatus: ActiveAppointmentSubStatus.cancelledByCustomer,
                                                                          appointmentStatus: AppointmentStatus.cancelled,
                                                                          salon: _appointmentProvider.salon!,
                                                                          salonMasters: _appointmentProvider.allMastersInSalon,
                                                                        );
                                                                        showToast(AppLocalizations.of(context)?.appointmentCancelledSuccessfully ?? 'Appointment cancelled succesfully');
                                                                      }
                                                                    },
                                                                  ),
                                                                );
                                                              } else {
                                                                setState(() => _spinner = true);

                                                                await AppointmentApi(mongodbProvider: _dbProvider).updateMultipleAppointment(
                                                                  isSingleMaster: _appointmentProvider.isSingleMaster,
                                                                  appointmentModel: appointment,
                                                                  appointmentSubStatus: ActiveAppointmentSubStatus.cancelledByCustomer,
                                                                  appointmentStatus: AppointmentStatus.cancelled,
                                                                  salon: _appointmentProvider.salon!,
                                                                  salonMasters: _appointmentProvider.allMastersInSalon,
                                                                );

                                                                setState(() => _spinner = false);

                                                                showToast(AppLocalizations.of(context)?.appointmentCancelledSuccessfully ?? 'Appointment cancelled succesfully');
                                                              }
                                                            },
                                                            isLoading: _spinner == true || _appointmentProvider.cancelAppointmentStatus == Status.loading || _appointmentProvider.createNoShowPolicyStatus == Status.loading,
                                                            loaderColor: transparentLoaderColor(themeType, theme),
                                                            borderColor: theme.primaryColor.withOpacity(0.6),
                                                            textColor: borderColor(themeType, theme),
                                                          ),
                                                    ],
                                                    // NOT US CHECK
                                                    if (_appointmentProvider.salon!.countryCode != 'US') ...[
                                                      Button(
                                                        text: AppLocalizations.of(context)?.cancelAppointment ?? 'Cancel Appointment',
                                                        onTap: () async {
                                                          showMyDialog(
                                                            context,
                                                            bgColor: scaffoldBGColor(themeType, theme),
                                                            child: DeleteClientNewTheme(
                                                              title: (AppLocalizations.of(context)?.cancelAppointmentDialogue ?? "Are you sure you want to cancel this appointment?"),
                                                              desc: "",
                                                              delete: 'tr(Keys.yes)',
                                                              cancel: 'tr(Keys.no)',
                                                              onDelete: () async {
                                                                _appointmentProvider.cancelAppointment(
                                                                  isSingleMaster: _appointmentProvider.isSingleMaster,
                                                                  appointmentID: appointment!.appointmentId!,
                                                                  appointment: appointment!,
                                                                  salon: _appointmentProvider.salon!,
                                                                  salonMasters: _appointmentProvider.allMastersInSalon,
                                                                  callback: () {
                                                                    fetchDetails();
                                                                  },
                                                                );

                                                                showToast(AppLocalizations.of(context)?.appointmentCancelledSuccessfully ?? 'Appointment cancelled succesfully');
                                                              },
                                                            ),
                                                          );
                                                        },
                                                        isLoading: _spinner == true || _appointmentProvider.cancelAppointmentStatus == Status.loading || _appointmentProvider.createNoShowPolicyStatus == Status.loading,
                                                        loaderColor: transparentLoaderColor(themeType, theme),
                                                        borderColor: theme.primaryColor.withOpacity(0.6),
                                                        textColor: borderColor(themeType, theme),
                                                      ),
                                                    ],
                                                    const SizedBox(width: 20),
                                                    if (appointment?.subStatus != ActiveAppointmentSubStatus.confirmed && shouldShowConfirmButton(appointment!.appointmentStartTime!))
                                                      Button(
                                                        text: AppLocalizations.of(context)?.confirmApppointment ?? 'Confirm Appointment',
                                                        buttonColor: confirmButton(themeType, theme),
                                                        textColor: buttonTextColor(themeType),
                                                        onTap: () => _appointmentProvider.updateAppointmentSubStatus(
                                                          appointmentID: widget.appointmentDocId,
                                                          callback: () {
                                                            fetchDetails();
                                                          },
                                                        ),
                                                        isLoading: _appointmentProvider.updateSubStatus == Status.loading,
                                                        loaderColor: loaderColor(themeType, theme),
                                                      ),
                                                  ],
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  : Center(
                      child: Text(
                        AppLocalizations.of(context)?.appointmentDoesNotExist ?? 'Appointment does not exist',
                        style: TextStyle(
                          color: AppTheme.creamBrown,
                          fontSize: DeviceConstraints.getResponsiveSize(context, 18.sp, 20.sp, 25.sp),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
    );
  }
}

Future showMyDialog(
  context, {
  Widget? child,
  EdgeInsets? contentPadding,
  bool isDismissible = false,
  double? width,
  Color? bgColor,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: isDismissible, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: bgColor ?? AppTheme.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        contentPadding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        content: SizedBox(width: width ?? 250, child: child),
      );
    },
  );
}

class DeleteClientNewTheme extends ConsumerStatefulWidget {
  final Function? onDelete;
  final String? title, desc, cancel, delete;
  final Color? color;
  final TextStyle? descriptionStyle;
  final TextStyle? titleStyle;

  const DeleteClientNewTheme({
    Key? key,
    this.onDelete,
    required this.title,
    required this.desc,
    this.color,
    this.descriptionStyle,
    this.titleStyle,
    this.cancel,
    this.delete,
  }) : super(key: key);

  @override
  _DeleteClientNewThemeState createState() => _DeleteClientNewThemeState();
}

class _DeleteClientNewThemeState extends ConsumerState<DeleteClientNewTheme> {
  @override
  Widget build(BuildContext context) {
    final _appointmentProvider = ref.watch(appointmentProvider);
    ThemeData theme = _appointmentProvider.salonTheme ?? AppTheme.customLightTheme;
    ThemeType themeType = _appointmentProvider.themeType ?? ThemeType.DefaultLight;

    return Column(
      mainAxisSize: MainAxisSize.min,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        widget.title!.isNotEmpty
            ? Text(
                widget.title!,
                style: theme.textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 18.sp, 24.sp),
                  color: confirmationTextColor(themeType, theme),
                ),
                textAlign: TextAlign.center,
              )
            : const SizedBox.shrink(),
        widget.title!.isNotEmpty ? const SizedBox(height: 8) : const SizedBox.shrink(),
        widget.desc!.isNotEmpty
            ? Text(
                widget.desc!,
                style: theme.textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.normal,
                  fontSize: DeviceConstraints.getResponsiveSize(context, 14.sp, 15.sp, 20.sp),
                  color: titleColor(themeType, theme),
                ),
                textAlign: TextAlign.center,
              )
            : const SizedBox.shrink(),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Button(
                onTap: () => Navigator.of(context).pop(false),
                text: AppLocalizations.of(context)?.no ?? 'No',
                loaderColor: transparentLoaderColor(themeType, theme),
                borderColor: theme.primaryColor.withOpacity(0.6),
                textColor: borderColor(themeType, theme),
              ),
            ),
            SizedBox(width: 20.sp),
            Expanded(
              child: Button(
                onTap: () {
                  widget.onDelete!();

                  Navigator.of(context).pop(true);
                },
                text: AppLocalizations.of(context)?.yes ?? 'Yes',
                buttonColor: confirmButton(themeType, theme),
                textColor: buttonTextColor(themeType),
                // isLoading: _appointmentProvider.createNoShowPolicyStatus == Status.loading,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
