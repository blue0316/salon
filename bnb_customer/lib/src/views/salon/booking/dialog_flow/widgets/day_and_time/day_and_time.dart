import 'dart:math';
import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/enums/status.dart';
import 'package:bbblient/src/models/salon_master/master.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
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

    await _createAppointmentProvider.initTimeOfDay();
    await _createAppointmentProvider.onDateChange(date);
    setState(() {
      loading = false;
    });
  }

  MasterModel? selectedMaster;
  bool isAnyoneSelected = false;

  @override
  Widget build(BuildContext context) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final _createAppointmentProvider = ref.watch(createAppointmentProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;
    ThemeType themeType = _salonProfileProvider.themeType;
    SalonModel salonModel = _salonProfileProvider.chosenSalon;

    if (_salonProfileProvider.isSingleMaster) {
      selectedMaster = _salonProfileProvider.allMastersInSalon[0];
    }

    return loading
        ? const CircularProgressIndicator(color: Colors.green)
        : Padding(
            padding: EdgeInsets.symmetric(
              horizontal: DeviceConstraints.getResponsiveSize(context, 17.w, 20.w, 20.w),
            ),
            child: (_createAppointmentProvider.salonMasters.isEmpty || _createAppointmentProvider.serviceableMasters.isEmpty)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Space(factor: 2),
                      Text(
                        "No master is available for your selected services",
                        style: theme.textTheme.bodyLarge!.copyWith(
                          fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
                          color: theme.colorScheme.tertiary, // defaultTheme ? AppTheme.textBlack : Colors.white,
                        ),
                      ),
                      // const SizedBox(height: 10),
                      const Spacer(),
                      DefaultButton(
                        borderRadius: 60,
                        onTap: () {
                          // Go to previous page
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
                  )
                : ListView(
                    shrinkWrap: true,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: _createAppointmentProvider.chosenServices
                            .map(
                              (service) => ServiceNameAndPrice(
                                serviceName: service.translations![AppLocalizations.of(context)?.localeName ?? 'en'].toString(),
                                servicePrice: service.isFixedPrice
                                    ? "${salonModel.selectedCurrency}${service.priceAndDuration!.price}"
                                    : service.isPriceRange
                                        ? "${salonModel.selectedCurrency}${service.priceAndDuration!.price} - ${salonModel.selectedCurrency}${service.priceAndDurationMax!.price}"
                                        : "${salonModel.selectedCurrency}${service.priceAndDuration!.price} - ${salonModel.selectedCurrency}∞",
                              ),
                            )
                            .toList(),
                      ),
                      SizedBox(height: 30.sp),
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

                      SizedBox(height: 20.sp),

                      // SELECT MASTER
                      if (!_salonProfileProvider.isSingleMaster)
                        SizedBox(
                          // color: Colors.blue,
                          height: 45.h,
                          child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() => isAnyoneSelected = true);

                                  // find random master

                                  final _random = Random();
                                  MasterModel randomMaster = _createAppointmentProvider.serviceableMasters[_random.nextInt(_createAppointmentProvider.serviceableMasters.length)];

                                  setState(() => selectedMaster = randomMaster);
                                },
                                child: Container(
                                  height: 45.h,
                                  decoration: BoxDecoration(
                                    color: isAnyoneSelected == true ? theme.primaryColor : Colors.transparent,
                                    borderRadius: BorderRadius.circular(70),
                                    border: Border.all(
                                      color: isAnyoneSelected == true ? theme.primaryColor : const Color(0XFF4A4A4A),
                                      width: 0.8,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 25),
                                    child: Center(
                                      child: Text(
                                        'Anyone',
                                        style: theme.textTheme.bodyLarge!.copyWith(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.normal,

                                          // color: (selectedMaster == master && isAnyoneSelected == false) ? selectSlots(themeType, theme) : theme.colorScheme.tertiary,
                                          color: (isAnyoneSelected) ? selectSlots(themeType, theme) : theme.colorScheme.tertiary,

                                          // color: (_createAppointmentProvider.serviceAgainstMaster
                                          //         .where(
                                          //           (element) => element.service!.serviceId == service.serviceId && element.isRandom!,
                                          //         )
                                          //         .toList()
                                          //         .isNotEmpty)
                                          //     ? selectMasterColor(themeType)
                                          //     : unSelectedMasterColor(themeType),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              SizedBox(
                                // color: Colors.lightBlueAccent,
                                height: 45.h,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _createAppointmentProvider.serviceableMasters.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    MasterModel master = _createAppointmentProvider.serviceableMasters[index];

                                    String? price = _createAppointmentProvider.priceAndDuration[master.masterId]?.price ?? '0';
                                    String? duration = _createAppointmentProvider.priceAndDuration[master.masterId]?.duration ?? '0';

                                    // if price and duration for a master is 0 return a white space
                                    // we dont want to create appointments with 0 values as price and duration
                                    if (price == '\$0' || duration == '0') return const SizedBox.shrink();

                                    return Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: GestureDetector(
                                          onTap: () async {
                                            setState(() => selectedMaster = master);
                                            setState(() => isAnyoneSelected = false);

                                            _createAppointmentProvider.selectMasterForBooking(master);

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
                                              color: (selectedMaster == master && isAnyoneSelected == false) ? theme.primaryColor : Colors.transparent,
                                              borderRadius: BorderRadius.circular(70),
                                              border: Border.all(
                                                color: (selectedMaster == master && isAnyoneSelected == false) ? theme.primaryColor : const Color(0XFF4A4A4A),
                                                width: 0.8,
                                              ),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 3, bottom: 3, right: 15.sp, left: 5.sp),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    height: 30.h,
                                                    width: 30.h,
                                                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(100),
                                                      child: (master.profilePicUrl != null && master.profilePicUrl != '')
                                                          ? CachedImage(url: master.profilePicUrl!, fit: BoxFit.cover)
                                                          : Image.asset(
                                                              AppIcons.masterDefaultAvtar,
                                                              fit: BoxFit.cover,
                                                            ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    Utils().getNameMaster(master.personalInfo),
                                                    style: theme.textTheme.bodyLarge!.copyWith(
                                                      fontSize: 14.sp,
                                                      fontWeight: FontWeight.normal,
                                                      color: (selectedMaster == master && isAnyoneSelected == false) ? selectSlots(themeType, theme) : theme.colorScheme.tertiary,
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

                      SizedBox(height: 50.sp),

                      // SELECT MASTER TIME
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              date = date.subtract(const Duration(days: 1));

                              _createAppointmentProvider.onDateChange(date);
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
                            ),
                          ),
                          SizedBox(width: 8.w),
                          InkWell(
                            onTap: () {
                              date = date.add(const Duration(days: 1));

                              _createAppointmentProvider.onDateChange(date);
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

                          _createAppointmentProvider.onDateChange(date);

                          // singleMasterTimeLineController.refreshGraph();
                        },
                        itemBuilder: (DateTime itemValue, DateTime? selected) {
                          var isSelected = selected?.difference(itemValue).inMilliseconds == 0;

                          return Column(
                            children: [
                              Text(
                                DateFormat("EE").format(itemValue).toUpperCase(),
                                style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.tertiary),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 10.h),
                              InkWell(
                                onTap: () {
                                  date = itemValue;
                                  _createAppointmentProvider.onDateChange(date);
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
                                            style: const TextStyle(fontSize: 14, color: AppTheme.white),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        height: 40.sp,
                                        width: 36.sp,
                                        decoration: BoxDecoration(
                                          color: _createAppointmentProvider.checkIfMasterIsWorking(itemValue) ? null : const Color.fromARGB(255, 53, 53, 54),
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(
                                            color: _createAppointmentProvider.checkIfMasterIsWorking(itemValue) ? theme.primaryColor : Colors.transparent, //  Colors.black,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${itemValue.day}',
                                            style: const TextStyle(fontSize: 14, color: AppTheme.white2),
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
                                  _createAppointmentProvider.onDateChange(date);
                                },
                                child: Container(
                                  height: 37.sp,
                                  // width: 40.sp,
                                  decoration: BoxDecoration(
                                    color: _createAppointmentProvider.timeOfDayIndexForSlots == 0 ? theme.primaryColor : Colors.transparent,
                                    border: Border.all(color: _createAppointmentProvider.timeOfDayIndexForSlots == 0 ? Colors.black : Colors.transparent),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20.sp),
                                    child: Center(
                                      child: Text(
                                        'morning'.toCapitalized(),
                                        maxLines: 2,
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.normal,
                                          fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
                                          color: _createAppointmentProvider.timeOfDayIndexForSlots == 0 ? Colors.white : theme.colorScheme.tertiary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  _createAppointmentProvider.timeOfDayIndexForSlots = 1;
                                  _createAppointmentProvider.onDateChange(date);
                                },
                                child: Container(
                                  height: 37.sp,
                                  decoration: BoxDecoration(
                                    color: _createAppointmentProvider.timeOfDayIndexForSlots == 1 ? theme.primaryColor : Colors.transparent,
                                    border: Border.all(color: _createAppointmentProvider.timeOfDayIndexForSlots == 1 ? Colors.black : Colors.transparent),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20.sp),
                                    child: Center(
                                      child: Text(
                                        'afternoon'.toCapitalized(),
                                        maxLines: 2,
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.normal,
                                          fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
                                          color: _createAppointmentProvider.timeOfDayIndexForSlots == 1 ? Colors.white : theme.colorScheme.tertiary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  _createAppointmentProvider.timeOfDayIndexForSlots = 2;
                                  _createAppointmentProvider.onDateChange(date);
                                },
                                child: Container(
                                  height: 37.sp,
                                  // width: 130.sp,
                                  decoration: BoxDecoration(
                                    color: _createAppointmentProvider.timeOfDayIndexForSlots == 2 ? theme.primaryColor : Colors.transparent,
                                    border: Border.all(color: _createAppointmentProvider.timeOfDayIndexForSlots == 2 ? Colors.black : Colors.transparent),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20.sp),
                                    child: Center(
                                      child: Text(
                                        'evening'.toCapitalized(),
                                        maxLines: 2,
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.normal,
                                          fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
                                          color: _createAppointmentProvider.timeOfDayIndexForSlots == 2 ? Colors.white : theme.colorScheme.tertiary,
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
                            : (_createAppointmentProvider.allAppointments[selectedMaster?.masterId] == null || _createAppointmentProvider.allAppointments[selectedMaster?.masterId]!.isEmpty)
                                ? Center(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: 30.sp),
                                      child: Center(
                                        child: Text(
                                          'Day off',
                                          style: theme.textTheme.bodyMedium?.copyWith(
                                            fontWeight: FontWeight.normal,
                                            fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
                                            color: theme.primaryColor,
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
                                                  'Day off',
                                                  style: theme.textTheme.bodyMedium?.copyWith(
                                                    fontWeight: FontWeight.normal,
                                                    fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
                                                    color: Colors.green, // theme.colorScheme.tertiary,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }

                                        return InkWell(
                                          onTap: () => _createAppointmentProvider.onAppointmentChange(selectedMaster!, _appointment),
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
                                                        color: selectSlots(themeType, theme), // theme.colorScheme.tertiary,
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
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                        );
                                      },
                                    ),
                                  ),

                      SizedBox(height: 20.sp),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 10.h, left: 2, right: 2),
                          child: Column(
                            children: [
                              DefaultButton(
                                borderRadius: 60,
                                onTap: () {
                                  if (selectedMaster == null) {
                                    showToast('Please select a master before proceeding');
                                    return;
                                  }

                                  if (_createAppointmentProvider.selectedAppointmentSlot == null) {
                                    showToast(AppLocalizations.of(context)?.chooseSlots ?? "choose slots");
                                    return;
                                  }

                                  // Next Page
                                  widget.tabController.animateTo(2);
                                },
                                color: dialogButtonColor(themeType, theme),
                                borderColor: theme.primaryColor,
                                textColor: loaderColor(themeType),
                                height: 60,
                                label: 'Select & Confirm',
                                suffixIcon: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: loaderColor(themeType),
                                  size: 18.sp,
                                ),
                                fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 30.h),
                    ],
                  ),
          );
  }
}

class ServiceNameAndPrice extends ConsumerWidget {
  final String serviceName, servicePrice;
  final bool notService;
  final double? fontSize;
  final FontWeight? weight;

  const ServiceNameAndPrice({
    Key? key,
    required this.serviceName,
    required this.servicePrice,
    this.notService = false,
    this.fontSize,
    this.weight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    return Padding(
      padding: EdgeInsets.only(bottom: 12.sp),
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
                color: !notService ? theme.colorScheme.tertiary : theme.colorScheme.tertiary.withOpacity(0.6),
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
                fontWeight: FontWeight.w500,
                fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
                color: theme.colorScheme.tertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MasterWithTime extends ConsumerStatefulWidget {
  final MasterModel master;
  final String? name, title, price, duration;
  final List<String>? appointments;

  const MasterWithTime({
    Key? key,
    required this.master,
    this.name,
    this.title,
    this.price,
    this.duration,
    this.appointments,
  }) : super(key: key);

  @override
  ConsumerState<MasterWithTime> createState() => _MasterWithTimeState();
}

class _MasterWithTimeState extends ConsumerState<MasterWithTime> {
  final int maxCount = 10;
  late bool slotsGreaterThanMaxCount;

  @override
  Widget build(BuildContext context) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final _createAppointmentProvider = ref.watch(createAppointmentProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;

    // if price and duration for a master is 0 return a white space
    //we dont want to create appointments with 0 values as price and duration
    if (widget.price == '\$0' || widget.duration == '0') return const SizedBox();

    //  in-case there is no appointments available then don't show salon in the first case as well
    if (widget.appointments == null || widget.appointments!.isEmpty) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 9, top: 5, right: 9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${widget.master.personalInfo!.firstName} ${widget.master.personalInfo!.lastName}",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp, color: Colors.white),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      widget.title!,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12.sp, color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(width: 5.sp),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${widget.price}",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp, color: Colors.white),
                    ),
                    Text(
                      widget.duration!,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12.sp, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 35.h),
          const Center(
            child: Text(
              'Day off',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    }

    // slotsGreaterThanMaxCount = (widget.appointments ?? []).length > maxCount;

    int slotCount = widget.appointments?.length ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 9, top: 15, right: 9),
          child: Container(
            color: Colors.green,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${widget.master.personalInfo!.firstName} ${widget.master.personalInfo!.lastName}",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.tertiary),
                    ),
                    SizedBox(height: 10.sp),
                    Text(
                      widget.title!,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.tertiary),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "PRICE: ${widget.price}",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.tertiary),
                    ),
                    Text(
                      'DURATION: ${widget.duration!}',
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.tertiary),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          itemCount: slotCount,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 25),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: DeviceConstraints.getCrossAxisCount(context, small: 5, medium: 8, large: 10),
            childAspectRatio: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            List<String> appointmentString = widget.appointments ?? [];
            final String _appointment = appointmentString[index];
            final bool _isSelected = _createAppointmentProvider.isMasterSelected(
              widget.master.masterId,
              _createAppointmentProvider.chosenDay,
              _appointment,
            );
            final bool _isAvailable = _createAppointmentProvider.availableAppointments[widget.master.masterId]!.contains(_appointment);

            //  in-case there is no appointments available then don't show salon in the first case as well
            if (widget.appointments == null || widget.appointments!.isEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 9, top: 5, right: 9),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${widget.master.personalInfo!.firstName} ${widget.master.personalInfo!.lastName}",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp, color: Colors.white),
                            ),
                            SizedBox(height: 5.h),
                            Text(
                              widget.title!,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12.sp, color: Colors.white),
                            ),
                          ],
                        ),
                        SizedBox(width: 5.sp),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${widget.price}",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp, color: Colors.white),
                            ),
                            Text(
                              widget.duration!,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12.sp, color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 35.h),
                  const Center(
                    child: Text(
                      'Day off',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            }

            return InkWell(
              onTap: () => _createAppointmentProvider.onAppointmentChange(widget.master, _appointment),
              child: _isSelected && _isAvailable
                  ? Ink(
                      decoration: const BoxDecoration(
                        color: Color(0xffFF5419),
                        borderRadius: BorderRadius.all(Radius.circular(2)),
                      ),
                      child: Center(
                        child: Text(
                          widget.appointments![index],
                          style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.tertiary),
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
                              widget.appointments![index],
                              style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.tertiary),
                            ),
                          ),
                        )
                      : Ink(
                          decoration: BoxDecoration(
                            color: Colors.yellow,
                            borderRadius: const BorderRadius.all(Radius.circular(2)),
                            border: Border.all(
                              color: Colors.grey,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              widget.appointments![index],
                              style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.tertiary),
                            ),
                          ),
                        ),
            );
          },
        ),
      ],
    );
  }
}
