import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/enums/status.dart';
import 'package:bbblient/src/models/salon_master/master.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/currency/currency.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/salon/booking/dialog_flow/widgets/colors.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:bbblient/src/views/widgets/buttons.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_horizontal_date_picker/flutter_horizontal_date_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class DayAndTime extends ConsumerStatefulWidget {
  final TabController tabController;

  const DayAndTime({Key? key, required this.tabController}) : super(key: key);

  @override
  ConsumerState<DayAndTime> createState() => _DayAndTimeState();
}

class _DayAndTimeState extends ConsumerState<DayAndTime> {
  DateTime date = DateTime.now();
  bool loading = false;
  bool? masterAndSalonPriceDifferent;
  DateTime? dateSingleMaster;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    setState(() {
      loading = true;
    });
    final _createAppointmentProvider = ref.read(createAppointmentProvider);
    final SalonProfileProvider _salonProfileProvider = ref.read(salonProfileProvider);

    await _createAppointmentProvider.initTimeOfDay();
    await _createAppointmentProvider.onDateChange(date, isSingleMaster: _salonProfileProvider.isSingleMaster);

    if (_salonProfileProvider.isSingleMaster) {
      setState(() {
        dateSingleMaster = _createAppointmentProvider.selectedDate1;
      });
      _createAppointmentProvider.selectedAppointmentSlot = null;
      if (_createAppointmentProvider.selectedAppointmentSlot == null) {
        _createAppointmentProvider.initTimeOfDay();
        _createAppointmentProvider.onDateChange(date, isSingleMaster: true);
        _createAppointmentProvider.initializeTimeSlots();
        _createAppointmentProvider.loadPriceAndDurationForMultipleServices();
      }
    }

    // final _random = Random();
    // if (_createAppointmentProvider.serviceableMasters.isNotEmpty) {
    //   MasterModel randomMaster = _createAppointmentProvider.serviceableMasters[_random.nextInt(_createAppointmentProvider.serviceableMasters.length)];

    //   setState(() {
    //     selectedMaster = randomMaster;
    //   });
    // }

    setState(() {
      selectedMaster = _createAppointmentProvider.mastersOfferingChosenServices.toList()[0];
    });

    masterAndSalonPriceDifferent = _createAppointmentProvider.checkIfSalonPriceAndMasterPriceIsDifferent();
    _createAppointmentProvider.controlModal(false);

    setState(() {
      loading = false;
    });
  }

  MasterModel? selectedMaster;
  // bool isAnyoneSelected = true;
  bool isSingleMaster = false;

  @override
  Widget build(BuildContext context) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final _createAppointmentProvider = ref.watch(createAppointmentProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;
    ThemeType themeType = _salonProfileProvider.themeType;
    SalonModel salonModel = _salonProfileProvider.chosenSalon;

    // bool defaultLightTheme = themeType == ThemeType.DefaultLight;
    bool isLightTheme = (theme == AppTheme.customLightTheme);

    if (_salonProfileProvider.isSingleMaster) {
      selectedMaster = _salonProfileProvider.allMastersInSalon[0];
    }

    isSingleMaster = _salonProfileProvider.isSingleMaster;

    return loading
        ? CircularProgressIndicator(color: theme.primaryColor)
        : (_createAppointmentProvider.salonMasters.isEmpty || _createAppointmentProvider.mastersOfferingChosenServices.isEmpty)
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: DeviceConstraints.getResponsiveSize(context, 17.w, 20.w, 20.w)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Space(factor: 2),
                    Text(
                      AppLocalizations.of(context)?.noMasterIsAvailableForSelectedServices ?? "No master is available for your selected services",
                      style: theme.textTheme.bodyLarge!.copyWith(
                        fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
                        color: theme.colorScheme.tertiary, // defaultTheme ? AppTheme.textBlack : Colors.white,
                        fontFamily: 'Inter-Medium',
                      ),
                    ),
                    // const SizedBox(height: 10),
                    const Spacer(),
                    DefaultButton(
                      borderRadius: 60,
                      onTap: () {
                        // Go to previous page
                        _createAppointmentProvider.changeBookingFlowIndex(enteringConfirmationView: true);
                        widget.tabController.animateTo(0);
                      },
                      color: dialogButtonColor(themeType, theme),
                      borderColor: theme.primaryColor,
                      textColor: loaderColor(themeType),
                      height: 60,
                      label: AppLocalizations.of(context)?.back ?? "Back",
                      fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
                    ),
                  ],
                ),
              )
            : Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: DeviceConstraints.getResponsiveSize(context, 17.w, 20.w, 20.w)),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        // InkWell(
                        //   onTap: () {
                        //     print('-----+++++-----');
                        //     _createAppointmentProvider.checkForMastersOfferingChosenServices();

                        //     for (MasterModel master in _createAppointmentProvider.mastersOfferingChosenServices) {
                        //       print(master.personalInfo?.firstName);
                        //     }
                        //     // print(_createAppointmentProvider.chosenServices[0].serviceId);
                        //     // print(selectedMaster?.masterId);

                        //     // // print(_createAppointmentProvider.priceAndDuration);
                        //     print('-----+++++-----');
                        //     // print('price');
                        //     // print(selectedMaster?.servicesPriceAndDuration?['nVqUIPr07PLneP8QW3wd']?.price);
                        //     // print(selectedMaster?.servicesPriceAndDuration?['nVqUIPr07PLneP8QW3wd']?.durationinHr);
                        //     // print(_createAppointmentProvider.priceAndDuration['IBe7FoipMcfj6J8epMOV']?.price);
                        //     // print(selectedMaster?.servicesPriceAndDuration?['nVqUIPr07PLneP8QW3wd']?.price);
                        //   },
                        //   child: Container(
                        //     height: 100,
                        //     width: 400,
                        //     color: Colors.blue,
                        //   ),
                        // ),
                        if (masterAndSalonPriceDifferent == true && !_salonProfileProvider.isSingleMaster)
                          Padding(
                            padding: EdgeInsets.only(bottom: 10.sp),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.info_rounded,
                                  size: 30.sp,
                                  color: theme.colorScheme.tertiary.withOpacity(0.6),
                                ),
                                SizedBox(width: 10.sp),
                                Text(
                                  AppLocalizations.of(context)?.serviceProvidersChargeDifferentPrices ?? "Service providers charge different prices",
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
                                    color: theme.colorScheme.tertiary,
                                    fontFamily: 'Inter-Medium',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        // Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   children: _createAppointmentProvider.chosenServices
                        //       .map(
                        //         (service) => ServiceNameAndPrice(
                        //           serviceName: service.translations?[AppLocalizations.of(context)?.localeName ?? 'en'] ?? service.translations?['en'].toString(),
                        //           servicePrice: '${getCurrency(salonModel.countryCode!)}${service.masterPriceAndDurationMap?[selectedMaster?.masterId]?.price}',

                        //           //  service.isFixedPrice
                        //           //     ? "${getCurrency(salonModel.countryCode!)}${service.priceAndDuration!.price}"
                        //           //     : service.isPriceRange
                        //           //         ? "${getCurrency(salonModel.countryCode!)}${service.priceAndDuration!.price} - ${getCurrency(salonModel.countryCode!)}${service.priceAndDurationMax!.price}"
                        //           //         : "${getCurrency(salonModel.countryCode!)}${service.priceAndDuration!.price} - ${getCurrency(salonModel.countryCode!)}∞",
                        //         ),
                        //       )
                        //       .toList(),
                        // ),
                        if (masterAndSalonPriceDifferent == true && !_salonProfileProvider.isSingleMaster) SizedBox(height: 20.sp),
                        if (masterAndSalonPriceDifferent == true && !_salonProfileProvider.isSingleMaster)
                          Container(
                            width: double.infinity,
                            height: 1.5.sp,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              gradient: LinearGradient(
                                colors: [Color.fromARGB(43, 74, 74, 74), Color(0XFF4A4A4A), Color.fromARGB(43, 74, 74, 74)],
                              ),
                            ),
                          ),

                        if (masterAndSalonPriceDifferent == true && !_salonProfileProvider.isSingleMaster) SizedBox(height: 20.sp),

                        // SELECT MASTER
                        if (!_salonProfileProvider.isSingleMaster)
                          SizedBox(
                            // color: Colors.blue,
                            height: 45.h,
                            child: ListView(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              children: [
                                // if (!(_createAppointmentProvider.serviceableMasters.length <= 1))
                                //   GestureDetector(
                                //     onTap: () {
                                //       setState(() => isAnyoneSelected = true);

                                //       // find random master
                                //       final _random = Random();
                                //       MasterModel randomMaster = _createAppointmentProvider.serviceableMasters[_random.nextInt(_createAppointmentProvider.serviceableMasters.length)];

                                //       setState(() => selectedMaster = randomMaster);
                                //     },
                                //     child: Container(
                                //       height: 45.h,
                                //       decoration: BoxDecoration(
                                //         color: isAnyoneSelected == true ? theme.primaryColor : Colors.transparent,
                                //         borderRadius: BorderRadius.circular(70),
                                //         border: Border.all(
                                //           color: isAnyoneSelected == true ? theme.primaryColor : const Color(0XFF4A4A4A),
                                //           width: 0.8,
                                //         ),
                                //       ),
                                //       child: Padding(
                                //         padding: const EdgeInsets.symmetric(horizontal: 25),
                                //         child: Center(
                                //           child: Text(
                                //             AppLocalizations.of(context)?.anyone ?? "Anyone",
                                //             style: theme.textTheme.bodyLarge!.copyWith(
                                //               fontSize: 14.sp,
                                //               fontWeight: FontWeight.normal,

                                //               // color: (selectedMaster == master && isAnyoneSelected == false) ? selectSlots(themeType, theme) : theme.colorScheme.tertiary,
                                //               color: (isAnyoneSelected) ? selectSlots(themeType, theme) : theme.colorScheme.tertiary,

                                //               // color: (_createAppointmentProvider.serviceAgainstMaster
                                //               //         .where(
                                //               //           (element) => element.service!.serviceId == service.serviceId && element.isRandom!,
                                //               //         )
                                //               //         .toList()
                                //               //         .isNotEmpty)
                                //               //     ? selectMasterColor(themeType)
                                //               //     : unSelectedMasterColor(themeType),
                                //             ),
                                //           ),
                                //         ),
                                //       ),
                                //     ),
                                //   ),
                                // const SizedBox(width: 10),
                                SizedBox(
                                  // color: Colors.lightBlueAccent,
                                  height: 45.h,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: _createAppointmentProvider.mastersOfferingChosenServices.length,
                                    physics: const NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      MasterModel master = _createAppointmentProvider.mastersOfferingChosenServices.toList()[index];

                                      // String? price = _createAppointmentProvider.priceAndDuration[master.masterId]?.price ?? '0';
                                      // String? duration = _createAppointmentProvider.priceAndDuration[master.masterId]?.duration ?? '0';

                                      // // if price and duration for a master is 0 return a white space
                                      // // we dont want to create appointments with 0 values as price and duration
                                      // if (price == '\$0' || duration == '0') return const SizedBox.shrink();

                                      return Padding(
                                        padding: const EdgeInsets.only(right: 10),
                                        child: MouseRegion(
                                          cursor: SystemMouseCursors.click,
                                          child: GestureDetector(
                                            onTap: () async {
                                              setState(() => selectedMaster = master);
                                              // setState(() => isAnyoneSelected = false);

                                              _createAppointmentProvider.selectMasterForBooking(master);
                                              _createAppointmentProvider.controlModal(false);
                                              // _createAppointmentProvider.addServiceMaster(service, master, context);

                                              // if (_createAppointmentProvider.slotsStatus == Status.failed) {
                                              //   showToast(
                                              //     '${master.personalInfo?.firstName} is not working',
                                              //     duration: const Duration(seconds: 5),
                                              //   );
                                              // }
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                // color: (selectedMaster == master && isAnyoneSelected == false) ? theme.primaryColor : Colors.transparent,
                                                color: (selectedMaster == master) ? theme.primaryColor : Colors.transparent,
                                                borderRadius: BorderRadius.circular(70),
                                                border: Border.all(
                                                  // color: (selectedMaster == master && isAnyoneSelected == false) ? theme.primaryColor : const Color(0XFF4A4A4A),
                                                  color: (selectedMaster == master) ? theme.primaryColor : const Color(0XFF4A4A4A),
                                                  width: 0.8,
                                                ),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.only(top: 3, bottom: 3, right: 10.sp),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      height: 50.h,
                                                      width: 50.h,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: isLightTheme ? const Color(0XFF1A1A1A).withOpacity(0.6) : const Color(0XFF3D3D3D),
                                                      ),
                                                      child: (master.profilePicUrl != null && master.profilePicUrl != '')
                                                          ? CachedImage(
                                                              url: master.profilePicUrl!,
                                                              imageBuilder: (context, imageProvider) => Container(
                                                                height: 50.h,
                                                                width: 50.h,
                                                                decoration: BoxDecoration(
                                                                  shape: BoxShape.circle,
                                                                  image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                                                ),
                                                              ),
                                                            )
                                                          : Center(
                                                              child: Text(
                                                                Utils().getNameMaster(master.personalInfo).initials,
                                                                style: theme.textTheme.titleMedium!.copyWith(
                                                                  fontSize: 16.sp,
                                                                  fontWeight: FontWeight.w500,
                                                                  color: isLightTheme ? Colors.black : Colors.white,
                                                                  fontFamily: 'Inter-Medium',
                                                                ),
                                                              ),
                                                            ),
                                                    ),
                                                    SizedBox(width: 2.sp),
                                                    Text(
                                                      Utils().getNameMaster(master.personalInfo).toTitleCase(),
                                                      style: theme.textTheme.bodyLarge!.copyWith(
                                                        fontSize: 16.sp,
                                                        fontWeight: FontWeight.normal,
                                                        // color: (selectedMaster == master && isAnyoneSelected == false) ? selectSlots(themeType, theme) : theme.colorScheme.tertiary,
                                                        color: (selectedMaster == master) ? selectSlots(themeType, theme) : theme.colorScheme.tertiary, fontFamily: 'Inter-Medium',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),

                        if (!_salonProfileProvider.isSingleMaster) SizedBox(height: 50.sp),

                        // SELECT MASTER TIME
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Spacer(),
                            InkWell(
                              onTap: () {
                                date = date.subtract(const Duration(days: 1));

                                _createAppointmentProvider.onDateChange(
                                  date,
                                  isSingleMaster: _salonProfileProvider.isSingleMaster,
                                );
                              },
                              child: Icon(
                                Icons.arrow_back_ios,
                                size: 18.sp,
                                color: theme.colorScheme.tertiary,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              DateFormat('MMMM yyyy').format(date),
                              textAlign: TextAlign.left,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.normal,
                                fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
                                color: theme.colorScheme.tertiary,
                                fontFamily: 'Inter-Medium',
                              ),
                            ),
                            SizedBox(width: 8.w),
                            InkWell(
                              onTap: () {
                                date = date.add(const Duration(days: 1));

                                _createAppointmentProvider.onDateChange(
                                  date,
                                  isSingleMaster: _salonProfileProvider.isSingleMaster,
                                );
                              },
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 18.sp,
                                color: theme.colorScheme.tertiary,
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),

                        SizedBox(height: 20.sp),

                        HorizontalDatePicker(
                          selectedColor: Colors.transparent,
                          unSelectedColor: Colors.transparent,
                          itemHeight: 80.sp,
                          begin: date.subtract(const Duration(days: 365)),
                          end: date.add(const Duration(days: 365)),
                          selected: _createAppointmentProvider.chosenDay,
                          onSelected: (item) {
                            date = item;
                            // print('-----+++------ HORIZONTAL DATE PICKER DAY -----+++------');
                            // print(item);
                            // print('-----+++------ HORIZONTAL DATE PICKER DAY -----+++------');

                            _createAppointmentProvider.onDateChange(
                              date,
                              isSingleMaster: _salonProfileProvider.isSingleMaster,
                            );

                            // singleMasterTimeLineController.refreshGraph();
                          },
                          itemBuilder: (DateTime itemValue, DateTime? selected) {
                            var isSelected = selected?.difference(itemValue).inMilliseconds == 0;

                            return Column(
                              children: [
                                Text(
                                  DateFormat("EE").format(itemValue).toUpperCase(),
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: theme.colorScheme.tertiary,
                                    fontFamily: 'Inter-Medium',
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 10.h),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      date = itemValue;
                                    });
                                    // print(itemValue);
                                    // print('------+++++-------');
                                    // print(_createAppointmentProvider.serviceableMasters);
                                    // print(_createAppointmentProvider.checkIfMasterIsWorking(itemValue));
                                    // print('------+++++-------');

                                    _createAppointmentProvider.onDateChange(
                                      date,
                                      isSingleMaster: _salonProfileProvider.isSingleMaster,
                                    );
                                  },
                                  child: DateTime(date.year, date.month, date.day) == DateTime(itemValue.year, itemValue.month, itemValue.day)
                                      ? Container(
                                          height: 40.sp,
                                          width: 36.sp,
                                          decoration: BoxDecoration(
                                            color: theme.primaryColor,
                                            borderRadius: const BorderRadius.all(Radius.circular(5)),
                                          ),
                                          // margin: EdgeInsets.all(margin),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              '${itemValue.day}',
                                              style: TextStyle(
                                                fontSize: 14,
                                                // color: defaultLightTheme ? Colors.white : theme.colorScheme.tertiary,
                                                color: currentDateTextColor(themeType, theme),
                                                fontFamily: 'Inter-Medium',
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(
                                          height: 40.sp,
                                          width: 36.sp,
                                          decoration: BoxDecoration(
                                            color: _createAppointmentProvider.checkIfMasterIsWorking(itemValue, isSingleMaster)
                                                ? null
                                                : isLightTheme
                                                    ? const Color.fromARGB(255, 135, 134, 134)
                                                    : const Color.fromARGB(255, 53, 53, 54),
                                            borderRadius: BorderRadius.circular(6),
                                            border: Border.all(
                                              color: _createAppointmentProvider.checkIfMasterIsWorking(itemValue, isSingleMaster) ? theme.primaryColor : Colors.transparent, //  Colors.black,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${itemValue.day}',
                                              style: TextStyle(
                                                fontSize: 14,
                                                // color: defaultLightTheme
                                                //     ? (_createAppointmentProvider.checkIfMasterIsWorking(itemValue, isSingleMaster) ? const Color.fromARGB(255, 53, 53, 54) : Colors.white)
                                                //     : selectSlots(
                                                //         themeType,
                                                //         theme,
                                                //       ), // AppT
                                                color: notCurrentDateTextColor(themeType, theme),
                                                fontFamily: 'Inter-Medium',
                                              ),
                                            ),
                                          ),
                                        ),
                                )
                              ],
                            );
                          },
                          itemCount: 730,
                          itemSpacing: 12,
                        ),
                        // SizedBox(height: 20.sp),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: theme.primaryColor),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    _createAppointmentProvider.timeOfDayIndexForSlots = 0;
                                    _createAppointmentProvider.onDateChange(
                                      date,
                                      isSingleMaster: _salonProfileProvider.isSingleMaster,
                                    );
                                  },
                                  child: Container(
                                    height: 37.sp,
                                    // width: 40.sp,
                                    decoration: BoxDecoration(
                                      color: _createAppointmentProvider.timeOfDayIndexForSlots == 0 ? theme.primaryColor : Colors.transparent,
                                      // border: Border.all(color: _createAppointmentProvider.timeOfDayIndexForSlots == 0 ? Colors.black : Colors.transparent),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 20.sp),
                                      child: Center(
                                        child: Text(
                                          (AppLocalizations.of(context)?.morning ?? "morning").toCapitalized(),
                                          maxLines: 2,
                                          style: theme.textTheme.bodyMedium?.copyWith(
                                            fontWeight: FontWeight.normal,
                                            fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 18.sp, 18.sp),
                                            color: _createAppointmentProvider.timeOfDayIndexForSlots == 0 ? Colors.white : theme.colorScheme.tertiary,
                                            fontFamily: 'Inter-Medium',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    _createAppointmentProvider.timeOfDayIndexForSlots = 1;
                                    _createAppointmentProvider.onDateChange(
                                      date,
                                      isSingleMaster: _salonProfileProvider.isSingleMaster,
                                    );
                                  },
                                  child: Container(
                                    height: 37.sp,
                                    decoration: BoxDecoration(
                                      color: _createAppointmentProvider.timeOfDayIndexForSlots == 1 ? theme.primaryColor : Colors.transparent,
                                      // border: Border.all(color: _createAppointmentProvider.timeOfDayIndexForSlots == 1 ? Colors.black : Colors.transparent),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 20.sp),
                                      child: Center(
                                        child: Text(
                                          (AppLocalizations.of(context)?.afternoon ?? "afternoon").toCapitalized(),
                                          maxLines: 2,
                                          style: theme.textTheme.bodyMedium?.copyWith(
                                            fontWeight: FontWeight.normal,
                                            fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 18.sp, 18.sp),
                                            color: _createAppointmentProvider.timeOfDayIndexForSlots == 1 ? Colors.white : theme.colorScheme.tertiary,
                                            fontFamily: 'Inter-Medium',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    _createAppointmentProvider.timeOfDayIndexForSlots = 2;
                                    _createAppointmentProvider.onDateChange(
                                      date,
                                      isSingleMaster: _salonProfileProvider.isSingleMaster,
                                    );
                                  },
                                  child: Container(
                                    height: 37.sp,
                                    // width: 130.sp,
                                    decoration: BoxDecoration(
                                      color: _createAppointmentProvider.timeOfDayIndexForSlots == 2 ? theme.primaryColor : Colors.transparent,
                                      // border: Border.all(color: _createAppointmentProvider.timeOfDayIndexForSlots == 2 ? Colors.black : Colors.transparent),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 20.sp),
                                      child: Center(
                                        child: Text(
                                          (AppLocalizations.of(context)?.evening ?? "evening").toCapitalized(),
                                          maxLines: 2,
                                          style: theme.textTheme.bodyMedium?.copyWith(
                                            fontWeight: FontWeight.normal,
                                            fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 18.sp, 18.sp),
                                            color: _createAppointmentProvider.timeOfDayIndexForSlots == 2 ? Colors.white : theme.colorScheme.tertiary,
                                            fontFamily: 'Inter-Medium',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20.sp),

                        if (selectedMaster != null)
                          (_createAppointmentProvider.masterViewStatus == Status.loading)
                              ? const Center(child: CircularProgressIndicator())
                              : (!_salonProfileProvider.isSingleMaster)
                                  ? (_createAppointmentProvider.allAppointments[selectedMaster?.masterId] == null || _createAppointmentProvider.allAppointments[selectedMaster?.masterId]!.isEmpty)
                                      ? Center(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(vertical: 30.sp),
                                            child: Center(
                                              child: Text(
                                                (AppLocalizations.of(context)?.unavailable ?? "Unavailable").toCapitalized(),
                                                style: theme.textTheme.bodyMedium?.copyWith(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
                                                  color: theme.primaryColor,
                                                  fontFamily: 'Inter-Medium',
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Center(
                                          child: GridView.builder(
                                            shrinkWrap: true,
                                            itemCount: _createAppointmentProvider.allAppointments[selectedMaster?.masterId]?.length ?? 0,
                                            physics: const NeverScrollableScrollPhysics(),
                                            padding: EdgeInsets.only(left: 20, right: 20, bottom: 20.sp, top: 0),
                                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: DeviceConstraints.getCrossAxisCount(context, small: 5, medium: 8, large: 10),
                                              childAspectRatio: 2,
                                              mainAxisSpacing: 12,
                                              crossAxisSpacing: 12,
                                            ),
                                            itemBuilder: (context, index) {
                                              List<String> appointmentString = _createAppointmentProvider.allAppointments[selectedMaster?.masterId] ?? [];
                                              final String _appointment = appointmentString[index];

                                              final bool _isSelected = _createAppointmentProvider.isMasterSelected(
                                                selectedMaster?.masterId,
                                                _createAppointmentProvider.chosenDay,
                                                _appointment,
                                              );

                                              final bool _isAvailable = _createAppointmentProvider.availableAppointments[selectedMaster?.masterId]!.contains(
                                                _appointment,
                                              );

                                              //  in-case there is no appointments available then don't show salon in the first case as well
                                              if (_createAppointmentProvider.allAppointments[selectedMaster?.masterId] == null || _createAppointmentProvider.allAppointments[selectedMaster?.masterId]!.isEmpty) {
                                                return Center(
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(vertical: 30.sp),
                                                    child: Center(
                                                      child: Text(
                                                        (AppLocalizations.of(context)?.unavailable ?? "Unavailable").toCapitalized(),
                                                        style: theme.textTheme.bodyMedium?.copyWith(
                                                          fontWeight: FontWeight.normal,
                                                          fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
                                                          color: selectSlots(themeType, theme),
                                                          fontFamily: 'Inter-Medium',
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }

                                              return InkWell(
                                                onTap: () {
                                                  // if (!_salonProfileProvider.isSingleMaster) {
                                                  //   _createAppointmentProvider.onAppointmentChange(context, selectedMaster!, _appointment);
                                                  // } else {
                                                  //   // _createAppointmentProvider.onSlotChange(
                                                  //   //   context,
                                                  //   //   selectedMaster!,
                                                  //   //   _appointment,
                                                  //   // );
                                                  // }
                                                  _createAppointmentProvider.onAppointmentChange(context, selectedMaster!, _appointment);
                                                },
                                                child: _isSelected && _isAvailable
                                                    ? Ink(
                                                        decoration: BoxDecoration(
                                                          color: theme.primaryColor,
                                                          borderRadius: const BorderRadius.all(Radius.circular(2)),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            _createAppointmentProvider.allAppointments[selectedMaster?.masterId]![index],
                                                            style: theme.textTheme.bodyLarge?.copyWith(
                                                              color: selectSlots(themeType, theme),
                                                              fontFamily: 'Inter-Medium',
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : !_isAvailable
                                                        ? Ink(
                                                            decoration: const BoxDecoration(
                                                              color: Color(0xff232529),
                                                              borderRadius: BorderRadius.all(Radius.circular(2)),
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                _createAppointmentProvider.allAppointments[selectedMaster?.masterId]![index],
                                                                style: theme.textTheme.bodyLarge?.copyWith(
                                                                  color: theme.colorScheme.tertiary,
                                                                  fontFamily: 'Inter-Medium',
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : Ink(
                                                            decoration: BoxDecoration(
                                                              color: theme.dialogBackgroundColor,
                                                              borderRadius: const BorderRadius.all(Radius.circular(2)),
                                                              border: Border.all(
                                                                color: Colors.grey,
                                                              ),
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                _createAppointmentProvider.allAppointments[selectedMaster?.masterId]![index],
                                                                style: theme.textTheme.bodyLarge?.copyWith(
                                                                  color: theme.colorScheme.tertiary,
                                                                  fontFamily: 'Inter-Medium',
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                              );
                                            },
                                          ),
                                        )
                                  : (_createAppointmentProvider.allSlotsSingleMaster.isEmpty)
                                      ? Center(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(vertical: 30.sp),
                                            child: Center(
                                              child: Text(
                                                (AppLocalizations.of(context)?.unavailable ?? "Unavailable").toCapitalized(),
                                                style: theme.textTheme.bodyMedium?.copyWith(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
                                                  color: theme.primaryColor,
                                                  fontFamily: 'Inter-Medium',
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : ListView.builder(
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          padding: const EdgeInsets.only(bottom: 10),
                                          itemCount: 1,
                                          itemBuilder: (context, i) {
                                            var slotsList;
                                            if (_createAppointmentProvider.timeOfDayIndexForSlots == 0) {
                                              slotsList = _createAppointmentProvider.morningAllTimeslots;
                                            } else if (_createAppointmentProvider.timeOfDayIndexForSlots == 1) {
                                              // slotsDay1 = afternoonTimeslots;
                                              slotsList = _createAppointmentProvider.afternoonAllTimeslots;
                                            } else {
                                              // slotsDay1 = eveningTimeslots;
                                              slotsList = _createAppointmentProvider.eveningAllTimeslots;
                                            }

                                            // doing this because i don't wat to conflict
                                            if (i == 0) {
                                              return ShowSlots(
                                                selectedSlot: _createAppointmentProvider.selectedAppointmentSlot,
                                                selectedDate: _createAppointmentProvider.selectedAppointmentDate,
                                                date: _createAppointmentProvider.getSelectedDate(i),
                                                timeSlots: slotsList.map<String>((e) => e.toString()).toList(),
                                                masterSlotIndex: i,
                                              );
                                            }
                                            return const SizedBox();
                                          },
                                        ),

                        SizedBox(height: 20.sp),

                        SizedBox(height: 250.h),
                      ],
                    ),
                  ),
                  if (selectedMaster != null)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Visibility(
                        visible: _createAppointmentProvider.showModal && !_createAppointmentProvider.isNotEnoughSlots,
                        child: InkWell(
                          onTap: () {
                            if (_createAppointmentProvider.selectedAppointmentSlot != null) {
                              Navigator.pop(context);
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            // height: 230.h,
                            decoration: BoxDecoration(
                              color: const Color(0xff1F2125),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 15.sp),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 47.h,
                                        width: 45.h,
                                        decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: (selectedMaster?.profilePicUrl != null && selectedMaster?.profilePicUrl != '')
                                              ? CachedImage(url: '${selectedMaster?.profilePicUrl}', fit: BoxFit.cover)
                                              : Image.asset(
                                                  AppIcons.masterDefaultAvtar,
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                      ),
                                      SizedBox(width: 15.sp),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            Utils().getNameMaster(selectedMaster?.personalInfo).toTitleCase(),
                                            style: theme.textTheme.bodyLarge!.copyWith(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.normal,
                                              color: selectSlots(themeType, theme),
                                              fontFamily: 'Inter-Medium',
                                            ),
                                          ),
                                          SizedBox(height: 2.sp),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                // NOT SINGLE MASTER
                                                (!_salonProfileProvider.isSingleMaster)
                                                    ? (_createAppointmentProvider.isPriceFrom!)
                                                        ? "${getCurrency(salonModel.countryCode!)}${_createAppointmentProvider.priceAndDuration[selectedMaster?.masterId]?.price ?? '-'} ${_createAppointmentProvider.isPriceFrom! ? "+" : ""}"
                                                        : (_createAppointmentProvider.priceAndDuration[selectedMaster?.masterId]?.priceMax != null && _createAppointmentProvider.priceAndDuration[selectedMaster?.masterId]?.priceMax != '0')
                                                            ? "${getCurrency(salonModel.countryCode!)}${_createAppointmentProvider.priceAndDuration[selectedMaster?.masterId]?.price ?? '-'}-${getCurrency(salonModel.countryCode!)}${_createAppointmentProvider.priceAndDuration[selectedMaster?.masterId]?.priceMax ?? '-'}"
                                                            : "${getCurrency(salonModel.countryCode!)}${_createAppointmentProvider.priceAndDuration[selectedMaster?.masterId]?.price ?? '-'} ${_createAppointmentProvider.isPriceFrom! ? "+" : ""}"

                                                    // SINGLE MASTER
                                                    : _createAppointmentProvider.isPriceFrom!
                                                        ? "${getCurrency(salonModel.countryCode!)}${_createAppointmentProvider.servicePrice ?? '-'} ${_createAppointmentProvider.isPriceFrom! ? "+" : ""}"
                                                        : _createAppointmentProvider.serviceMaxPrice != '0'
                                                            ? "${getCurrency(salonModel.countryCode!)}${_createAppointmentProvider.servicePrice ?? '-'}-${getCurrency(salonModel.countryCode!)}${_createAppointmentProvider.serviceMaxPrice ?? '-'}"
                                                            : "${getCurrency(salonModel.countryCode!)}${_createAppointmentProvider.servicePrice ?? '-'} ${_createAppointmentProvider.isPriceFrom! ? "+" : ""}",

                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                style: theme.textTheme.bodyLarge!.copyWith(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.normal,
                                                  color: selectSlots(themeType, theme)?.withOpacity(0.8),
                                                  fontFamily: 'Inter-Medium',
                                                ),
                                              ),
                                              SizedBox(width: 7.sp),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 3.0),
                                                child: CircleAvatar(
                                                  radius: 3.sp,
                                                  // backgroundColor: theme.primaryColor, //  Color.fromARGB(43, 74, 74, 74),
                                                  backgroundColor: selectSlots(themeType, theme),
                                                ),
                                              ),
                                              SizedBox(width: 7.sp),
                                              Text(
                                                // NOT SINGLE MASTER
                                                (!_salonProfileProvider.isSingleMaster)
                                                    ? '${_createAppointmentProvider.priceAndDuration[selectedMaster?.masterId]?.duration ?? '-'} ${AppLocalizations.of(context)?.minutes ?? "minutes"}'

                                                    // SINGLE MASTER
                                                    : '${_createAppointmentProvider.serviceDuration} ${AppLocalizations.of(context)?.minutes ?? "minutes"}',
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                style: theme.textTheme.bodyLarge!.copyWith(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.normal,
                                                  color: selectSlots(themeType, theme)?.withOpacity(0.8),
                                                  fontFamily: 'Inter-Medium',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            (!_salonProfileProvider.isSingleMaster) ? '${_createAppointmentProvider.getStartTime()} - ${_createAppointmentProvider.getEndTime()}' : "${_createAppointmentProvider.selectedAppointmentSlot} - ${_createAppointmentProvider.selectedSlotEndTime}",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: theme.textTheme.bodyLarge!.copyWith(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.normal,
                                              color: selectSlots(themeType, theme),
                                              letterSpacing: 0.5,
                                              fontFamily: 'Inter-Medium',
                                            ),
                                          ),
                                          SizedBox(height: 2.sp),
                                          Text(
                                            DateFormat('EEEE, d MMM').format(_createAppointmentProvider.chosenDay),
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: theme.textTheme.bodyLarge!.copyWith(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.normal,
                                              color: selectSlots(themeType, theme)?.withOpacity(0.7),
                                              fontFamily: 'Inter-Medium',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20.sp),

                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: _createAppointmentProvider.chosenServices
                                        .map(
                                          (service) => ServiceNameAndPrice(
                                            serviceName: (service.translations?[AppLocalizations.of(context)?.localeName ?? 'en'] ?? service.translations?['en']).toString().toTitleCase(),
                                            servicePrice:
                                                // NOT SINGLE MASTER
                                                (!_salonProfileProvider.isSingleMaster)
                                                    ? (service.isPriceRange)
                                                        ? "${getCurrency(salonModel.countryCode!)}${service.priceAndDuration?.price ?? '0'}-${getCurrency(salonModel.countryCode!)}${service.priceAndDurationMax?.price ?? '0'}"
                                                        : (service.isPriceStartAt)
                                                            ? "${getCurrency(salonModel.countryCode!)}${selectedMaster!.originalServicesPriceAndDuration![service.serviceId]?.price ?? '0'}+"
                                                            : "${getCurrency(salonModel.countryCode!)}${selectedMaster!.originalServicesPriceAndDuration![service.serviceId]?.price ?? '0'}"

                                                    // SINGLE MASTER
                                                    : (service.isPriceRange)
                                                        ? "${getCurrency(salonModel.countryCode!)}${service.priceAndDuration!.price ?? '0'}-${getCurrency(salonModel.countryCode!)}${service.priceAndDurationMax!.price ?? '0'}"
                                                        : (service.isPriceStartAt)
                                                            ? "${getCurrency(salonModel.countryCode!)}${service.priceAndDuration!.price ?? '0'}+"
                                                            : "${getCurrency(salonModel.countryCode!)}${service.priceAndDuration!.price ?? '0'}",

                                            // (!_salonProfileProvider.isSingleMaster)
                                            //     ? (service.isPriceRange)
                                            //         ? "${getCurrency(salonModel.countryCode!)}${selectedMaster!.originalServicesPriceAndDuration![service.serviceId]?.price ?? '0'}-${getCurrency(salonModel.countryCode!)}${selectedMaster!.originalServicesPriceAndDurationMax![service.serviceId]?.price ?? '0'}"
                                            //         : (service.isPriceStartAt)
                                            //             ? "${getCurrency(salonModel.countryCode!)}${selectedMaster!.originalServicesPriceAndDuration![service.serviceId]?.price ?? '0'}+"
                                            //             : "${getCurrency(salonModel.countryCode!)}${selectedMaster!.originalServicesPriceAndDuration![service.serviceId]?.price ?? '0'}"

                                            //     // SINGLE MASTER
                                            //     : (service.isPriceRange)
                                            //         ? "${getCurrency(salonModel.countryCode!)}${service.priceAndDuration!.price ?? '0'}-${getCurrency(salonModel.countryCode!)}${service.priceAndDurationMax!.price ?? '0'}"
                                            //         : (service.isPriceStartAt)
                                            //             ? "${getCurrency(salonModel.countryCode!)}${service.priceAndDuration!.price ?? '0'}+"
                                            //             : "${getCurrency(salonModel.countryCode!)}${service.priceAndDuration!.price ?? '0'}",

                                            // -------
                                            // servicePrice:
                                            //     // NOT SINGLE MASTER
                                            //     (!_salonProfileProvider.isSingleMaster)
                                            //         ? _createAppointmentProvider.isPriceFrom!
                                            //             ? "${getCurrency(salonModel.countryCode!)}${_createAppointmentProvider.priceAndDuration[selectedMaster!.masterId]?.price ?? '-'} ${_createAppointmentProvider.isPriceFrom! ? "+" : ""}"
                                            //             : _createAppointmentProvider.priceAndDuration[selectedMaster!.masterId]?.priceMax != '0'
                                            //                 ? "${getCurrency(salonModel.countryCode!)}${_createAppointmentProvider.priceAndDuration[selectedMaster!.masterId]?.price ?? '-'}-${getCurrency(salonModel.countryCode!)}${_createAppointmentProvider.priceAndDuration[selectedMaster!.masterId]?.priceMax ?? '-'}"
                                            //                 : "${getCurrency(salonModel.countryCode!)}${_createAppointmentProvider.priceAndDuration[selectedMaster!.masterId]?.price ?? '-'} ${_createAppointmentProvider.isPriceFrom! ? "+" : ""}"

                                            //         // SINGLE MASTER
                                            //         : (service.isPriceRange)
                                            //             ? "${getCurrency(salonModel.countryCode!)}${service.priceAndDuration!.price ?? '0'}-${getCurrency(salonModel.countryCode!)}${service.priceAndDurationMax!.price ?? '0'}"
                                            //             : (service.isPriceStartAt)
                                            //                 ? "${getCurrency(salonModel.countryCode!)}${service.priceAndDuration!.price ?? '0'}+"
                                            //                 : "${getCurrency(salonModel.countryCode!)}${service.priceAndDuration!.price ?? '0'}",
                                            color: selectSlots(themeType, theme),
                                            fontSize: DeviceConstraints.getResponsiveSize(context, 14.sp, 18.sp, 16.sp),
                                            priceFontSize: DeviceConstraints.getResponsiveSize(context, 14.sp, 18.sp, 16.sp),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                  SizedBox(height: 20.sp),
                                  // const Spacer(),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Padding(
                                      padding: EdgeInsets.only(bottom: 5.h, left: 2, right: 2),
                                      child: Column(
                                        children: [
                                          DefaultButton(
                                            borderRadius: 60,
                                            onTap: () {
                                              if (selectedMaster == null) {
                                                showToast(AppLocalizations.of(context)?.selectAMasterBeforeProceeding ?? "Please select a master before proceeding");

                                                return;
                                              }

                                              if (_createAppointmentProvider.selectedAppointmentSlot == null) {
                                                showToast(AppLocalizations.of(context)?.chooseSlots ?? "choose slots");
                                                return;
                                              }

                                              if (_salonProfileProvider.isSingleMaster) {
                                                _createAppointmentProvider.setSelectedMaster(selectedMaster!);
                                              }

                                              _createAppointmentProvider.getTotalDeposit();
                                              _createAppointmentProvider.calculateTotals(isSingleMaster: _salonProfileProvider.isSingleMaster);

                                              // Next Page
                                              _createAppointmentProvider.changeBookingFlowIndex(enteringConfirmationView: true);
                                              widget.tabController.animateTo(2);
                                            },
                                            color: dialogButtonColor(themeType, theme),
                                            borderColor: theme.primaryColor,
                                            textColor: loaderColor(themeType),
                                            height: 60,
                                            label: (AppLocalizations.of(context)?.selectAndConfirm ?? "Select & Confirm"),
                                            suffixIcon: Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              color: loaderColor(themeType),
                                              size: 18.sp,
                                            ),
                                            fontSize: DeviceConstraints.getResponsiveSize(context, 14.sp, 18.sp, 16.sp),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
  }
}

class ServiceNameAndPrice extends ConsumerWidget {
  final String serviceName, servicePrice;
  final bool notService;
  final double? fontSize, priceFontSize;
  final FontWeight? weight;
  final Color? color;

  const ServiceNameAndPrice({
    Key? key,
    required this.serviceName,
    required this.servicePrice,
    this.notService = false,
    this.fontSize,
    this.priceFontSize,
    this.weight,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    return Padding(
      padding: EdgeInsets.only(bottom: 10.sp),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 1,
            child: Text(
              serviceName,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: weight ?? FontWeight.normal,
                fontSize: fontSize ?? DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
                color: (color != null)
                    ? color
                    : !notService
                        ? theme.colorScheme.tertiary
                        : theme.colorScheme.tertiary.withOpacity(0.6),
                fontFamily: 'Inter-Medium',
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          Flexible(
            flex: 0,
            child: Text(
              servicePrice,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: priceFontSize ?? DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
                color: color ?? theme.colorScheme.tertiary,
                fontFamily: 'Inter-Medium',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ShowSlots extends ConsumerStatefulWidget {
  final DateTime? date;
  final List<String>? timeSlots;
  final int? masterSlotIndex;
  final String? selectedSlot;
  final DateTime? selectedDate;

  const ShowSlots({Key? key, this.date, this.timeSlots, this.masterSlotIndex, this.selectedSlot, this.selectedDate}) : super(key: key);

  @override
  _ShowSlotsState createState() => _ShowSlotsState();
}

class _ShowSlotsState extends ConsumerState<ShowSlots> {
  bool isExpanded = false;
  bool tooManySlots = false;
  int maxCount = 10;
  int remainingSlots = 0;
  String? preSelectedSlot;

  initState() {
    initialize();
    super.initState();
    // _createAppointmentProvider!.getAfterHourTime(master: homeController.salonMaster, date: _createAppointmentProvider!.selectedDate1!);
  }

  initialize() {
    computePreSelectedSlot();
    if (widget.timeSlots != null) {
      tooManySlots = widget.timeSlots!.length > maxCount;
      remainingSlots = widget.timeSlots!.length - maxCount;
    }
  }

  computePreSelectedSlot() {
    if (widget.date == widget.selectedDate) {
      preSelectedSlot = widget.selectedSlot;
    } else {
      preSelectedSlot = null;
    }
  }

  showMore() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  int count() => tooManySlots ? (isExpanded ? widget.timeSlots!.length : maxCount) : widget.timeSlots!.length;

  bool showAfterHours = false;
  @override
  Widget build(BuildContext context) {
    final _createAppointmentProvider = ref.watch(createAppointmentProvider);
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    initialize();

    return Column(
      children: [
        (widget.timeSlots == null || widget.timeSlots!.isEmpty)
            ? Container(
                padding: const EdgeInsets.only(top: 100),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    const Space(),
                    Text(
                      (AppLocalizations.of(context)?.unavailable ?? "Unavailable").toCapitalized(),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.normal,
                        fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
                        color: theme.primaryColor,
                        fontFamily: 'Inter-Medium',
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      (AppLocalizations.of(context)?.unavailable ?? "Unavailable").toCapitalized(),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.normal,
                        fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
                        color: theme.primaryColor,
                        fontFamily: 'Inter-Medium',
                      ),
                    )
                  ],
                ))
            : GridView.builder(
                shrinkWrap: true,
                itemCount: count(),
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 22),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: DeviceConstraints.getCrossAxisCount(context, small: 5, medium: 8, large: 10),
                  childAspectRatio: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  // print('9999');
                  // print(_createAppointmentProvider!.slots);
                  // print('000');
                  // print(_createAppointmentProvider!.slots[widget.masterSlotIndex!]);
                  // print('111');
                  // print(widget.timeSlots![index]);
                  return SlotWidget(
                    key: Key('item_${index}_text'),
                    onTap: () {
                      _createAppointmentProvider.onSlotChangeSingleMaster(context, widget.date, widget.timeSlots![index]);
                    },
                    slot: widget.timeSlots![index],
                    isAvailable: _createAppointmentProvider.slots[widget.masterSlotIndex!]!.contains(widget.timeSlots![index]),
                    isSelected: preSelectedSlot == null
                        ? false
                        : (_createAppointmentProvider.selectedAppointmentDate == widget.date
                                    ? (DateTime(widget.date!.year, widget.date!.month, widget.date!.day, 0, 0, 0).add(Duration(hours: int.parse(widget.timeSlots![index].split(":")[0]), minutes: int.parse(widget.timeSlots![index].split(":")[1]))).isAfter(
                                          DateTime(widget.date!.year, widget.date!.month, widget.date!.day, 0, 0, 0).add(Duration(
                                            hours: int.parse(preSelectedSlot!.split(":")[0]),
                                            minutes: int.parse(preSelectedSlot!.split(":")[1]) - 1,
                                          )),
                                        ))
                                    : false) &&
                                _createAppointmentProvider.selectedAppointmentSlot != null &&
                                _createAppointmentProvider.servicePrice != null &&
                                _createAppointmentProvider.selectedAppointmentDate == widget.date
                            ? (DateTime(widget.date!.year, widget.date!.month, widget.date!.day, 0, 0, 0).add(Duration(hours: int.parse(widget.timeSlots![index].split(":")[0]), minutes: int.parse(widget.timeSlots![index].split(":")[1]))).isBefore(
                                  DateTime(widget.date!.year, widget.date!.month, widget.date!.day, 0, 0, 0).add(Duration(
                                    hours: int.parse(_createAppointmentProvider.selectedSlotEndTime!.split(":")[0]),
                                    minutes: int.parse(_createAppointmentProvider.selectedSlotEndTime!.split(":")[1]) + 1,
                                  )),
                                ))
                            : false,
                  );
                },
              ),
      ],
    );
  }
}

class SlotWidget extends ConsumerWidget {
  final String? slot;
  final bool isSelected;
  final bool isAvailable;
  final Function? onTap;
  const SlotWidget({Key? key, this.slot, this.isSelected = false, this.isAvailable = false, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    ThemeType themeType = _salonProfileProvider.themeType;

    return InkWell(
      onTap: onTap as void Function()?,
      child: !isAvailable
          ? Ink(
              decoration: BoxDecoration(
                color: const Color(0xff232529).withOpacity(0.9),
                borderRadius: const BorderRadius.all(Radius.circular(2)),
              ),
              child: Center(
                child: Text(
                  slot ?? '',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.tertiary,
                    fontFamily: 'Inter-Medium',
                  ),
                ),
              ),
            )
          : Ink(
              decoration: BoxDecoration(
                color: isSelected ? theme.primaryColor : theme.dialogBackgroundColor, //  Colors.white,
                border: Border.all(color: Colors.grey),
                borderRadius: const BorderRadius.all(Radius.circular(2)),
              ),
              child: Center(
                child: Text(
                  slot ?? '',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: isSelected ? selectSlots(themeType, theme) : theme.colorScheme.tertiary,
                    fontFamily: 'Inter-Medium',
                  ),
                ),
              ),
            ),
    );
  }
}

String getTotalTime(String? appointmentTime) {
  int minute = 60;
  int time = int.parse(appointmentTime.toString());
  String totalMinutes = (time % minute).toString();
  String totalHours = (time / minute).floor().toString();

  if (totalMinutes == '0') {
    return '$totalHours hours';
  }
  if (totalHours == '0') {
    return '$totalMinutes mins';
  }
  return '$totalHours hours $totalMinutes mins';
}
