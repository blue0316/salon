import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/create_apntmnt_provider/create_appointment_provider.dart';
import 'package:bbblient/src/models/backend_codings/owner_type.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/utils/keys.dart';
import 'package:bbblient/src/views/widgets/buttons.dart';
import 'package:bbblient/src/views/widgets/dialogues/dialogue_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../booking_date_time.dart';

class BookingBottomSheet extends ConsumerStatefulWidget {
  final bool showBookButton;
  const BookingBottomSheet({
    Key? key,
    this.showBookButton = true,
  }) : super(key: key);

  @override
  _BookingBottomSheetState createState() => _BookingBottomSheetState();
}

class _BookingBottomSheetState extends ConsumerState<BookingBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final CreateAppointmentProvider _createAppointmentProvider = ref.watch(createAppointmentProvider);
    return SizedBox(
      width: 1.sw,
      child: Padding(
        padding: EdgeInsets.only(top: 8.0.h, right: 24.w, left: 24.w, bottom: 36.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.grey4,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            SizedBox(
              height: 28.h,
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${_createAppointmentProvider.chosenServices.length} ${AppLocalizations.of(context)?.selectedServices ?? "selected services"}",
                      style: AppTheme.bodyText2.copyWith(
                        color: AppTheme.black,
                      ),
                    ),
                    // Text(
                    //   "pre book is active for 14:59 min",
                    //   style: AppTheme.bodyText2.copyWith(
                    //     fontStyle: FontStyle.italic,
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 16.h,
            ),
            Expanded(
              child: Scrollbar(
                isAlwaysShown: true,
                child: ListView.builder(
                    itemCount: _createAppointmentProvider.chosenServices.length,
                    shrinkWrap: true,
                    primary: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 0, bottom: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                _createAppointmentProvider.chosenServices[index].translations[AppLocalizations.of(context)?.localeName ?? 'en'],
                                style: AppTheme.bodyText1,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              "${_createAppointmentProvider.chosenServices[index].priceAndDuration.price} ${Keys.uah}",
                              style: AppTheme.bodyText1,
                            ),
                            IconButton(
                              onPressed: () {
                                _createAppointmentProvider.toggleService(serviceModel: _createAppointmentProvider.chosenServices[index], clearChosenMaster: true, context: context);

                                if (_createAppointmentProvider.chosenServices.isEmpty) {
                                  Navigator.pop(context);
                                }
                              },
                              icon: SvgPicture.asset(
                                AppIcons.cancelSVG,
                                color: AppTheme.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    AppLocalizations.of(context)?.totalAmount ?? "Total amount:   ",
                    style: AppTheme.headLine4,
                  ),
                  Text(
                    "${_createAppointmentProvider.totalPrice} ${Keys.uah}",
                    style: AppTheme.headLine3,
                  ),
                ],
              ),
            ),
            widget.showBookButton
                ? BnbMaterialButton(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const BookingDateTime(),
                        ),
                      );
                    },
                    title: AppLocalizations.of(context)?.bookNow ?? "Book Now",
                    minWidth: 1.sw - 48,
                  )
                : const SizedBox(
                    height: 40,
                  )
          ],
        ),
      ),
    );
  }
}

class BookingBottomSheetFinal extends ConsumerStatefulWidget {
  final bool showBookButton;
  const BookingBottomSheetFinal({
    Key? key,
    this.showBookButton = true,
  }) : super(key: key);

  @override
  _BookingBottomSheetFinalState createState() => _BookingBottomSheetFinalState();
}

class _BookingBottomSheetFinalState extends ConsumerState<BookingBottomSheetFinal> {
  @override
  Widget build(BuildContext context) {
    final CreateAppointmentProvider _createAppointmentProvider = ref.watch(createAppointmentProvider);
    return SizedBox(
      width: 1.sw,
      child: Padding(
        padding: EdgeInsets.only(top: 8.0.h, right: 24.w, left: 24.w, bottom: 36.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.grey4,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            SizedBox(
              height: 28.h,
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _createAppointmentProvider.chosenMaster == null ? "${_createAppointmentProvider.chosenServices.length} ${AppLocalizations.of(context)?.selectedServices ?? "selected services"}" : "${_createAppointmentProvider.mastersServicesMap[_createAppointmentProvider.chosenMaster?.masterId]?.length} ${AppLocalizations.of(context)?.availableServices ?? "available services"}",
                      style: AppTheme.bodyText2.copyWith(
                        color: AppTheme.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 16.h,
            ),
            Expanded(
              child: Scrollbar(
                isAlwaysShown: true,
                child: ListView.builder(
                    itemCount: _createAppointmentProvider.chosenServices.length,
                    shrinkWrap: true,
                    primary: true,
                    itemBuilder: (context, index) {
                      // todo optimise this booking flow entirely
                      bool valid = true;
                      if (_createAppointmentProvider.ownerType == OwnerType.salon) {
                        if (_createAppointmentProvider.mastersServicesMap[_createAppointmentProvider.chosenMaster?.masterId] != null) {
                          valid = _createAppointmentProvider.mastersServicesMap[_createAppointmentProvider.chosenMaster?.masterId]!.where((element) => element.serviceId == _createAppointmentProvider.chosenServices[index].serviceId).isNotEmpty;
                        } else {
                          valid = false;
                        }
                      }

                      return Padding(
                        padding: const EdgeInsets.only(top: 0, bottom: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                _createAppointmentProvider.chosenServices[index].translations[AppLocalizations.of(context)?.localeName ?? "en"],
                                style: AppTheme.bodyText1.copyWith(color: valid ? Colors.black : Colors.grey),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              "${_createAppointmentProvider.chosenServices[index].priceAndDuration.price} ${Keys.uah}",
                              style: AppTheme.bodyText1.copyWith(color: valid ? Colors.black : Colors.grey),
                            ),
                            IconButton(
                              onPressed: () {
                                if (_createAppointmentProvider.chosenServices.length <= 1) {
                                  showMyDialog(
                                      context: context,
                                      child: SizedBox(
                                        height: 150.h,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(AppLocalizations.of(context)?.removeServiceQue ?? "Remove service ?"),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(AppLocalizations.of(context)?.no ?? 'No'),
                                                ),
                                                BnbMaterialButton(
                                                  onTap: () {
                                                    _createAppointmentProvider.toggleService(serviceModel: _createAppointmentProvider.chosenServices[index], clearChosenMaster: widget.showBookButton, context: context);
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                  },
                                                  title: AppLocalizations.of(context)?.remove ?? 'Remove',
                                                  minWidth: 100.w,
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ));
                                } else {
                                  _createAppointmentProvider.toggleService(serviceModel: _createAppointmentProvider.chosenServices[index], clearChosenMaster: widget.showBookButton, context: context);
                                }
                              },
                              icon: SvgPicture.asset(
                                AppIcons.cancelSVG,
                                color: AppTheme.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    AppLocalizations.of(context)?.totalAmount ?? "Total amount:   ",
                    style: AppTheme.headLine4,
                  ),
                  Text(
                    _createAppointmentProvider.chosenMaster == null ? "${_createAppointmentProvider.totalPrice} ${Keys.uah}" : "${_createAppointmentProvider.mastersPriceDurationMap[_createAppointmentProvider.chosenMaster?.masterId]?.price} ${Keys.uah}",
                    // "${_createAppointmentProvider.totalPrice} ${Keys.uah}",
                    style: AppTheme.headLine3,
                  ),
                ],
              ),
            ),
            widget.showBookButton
                ? BnbMaterialButton(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const BookingDateTime()));
                    },
                    title: AppLocalizations.of(context)?.bookNow ?? "Book Now",
                    minWidth: 1.sw - 48,
                  )
                : const SizedBox(
                    height: 40,
                  )
          ],
        ),
      ),
    );
  }
}
