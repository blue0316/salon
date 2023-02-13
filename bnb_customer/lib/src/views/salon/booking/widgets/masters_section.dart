import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/create_apntmnt_provider/create_appointment_provider.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/backend_codings/owner_type.dart';
import 'package:bbblient/src/models/cat_sub_service/services_model.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/utils/keys.dart';
import 'package:bbblient/src/utils/time.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/salon/booking/booking_date_time.dart';
import 'package:bbblient/src/views/salon/widgets/person_avtar.dart';
import 'package:bbblient/src/views/salon/widgets/service_expension_tile.dart';
import 'package:bbblient/src/views/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';

class DialogMastersSection extends ConsumerStatefulWidget {
  final CreateAppointmentProvider createAppointment;
  final TabController tabController;
  final bool master;

  const DialogMastersSection({
    Key? key,
    required this.tabController,
    required this.createAppointment,
    this.master = false,
  }) : super(key: key);

  @override
  ConsumerState<DialogMastersSection> createState() => _DialogMastersSectionState();
}

class _DialogMastersSectionState extends ConsumerState<DialogMastersSection> {
  final ScrollController _mastresListController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final CreateAppointmentProvider _createAppointmentProvider = ref.watch(createAppointmentProvider);
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;
    bool defaultTheme = theme == AppTheme.lightTheme;

    return SizedBox(
      width: double.infinity,
      // color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: DeviceConstraints.getResponsiveSize(context, 5, 20.w, 20.w),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Space(
                    factor: (_createAppointmentProvider.chosenSalon!.ownerType == OwnerType.salon && widget.master == false) ? 0.5 : 2,
                  ),
                  // -- ALL SERVICES
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "${AppLocalizations.of(context)?.all ?? "All"} ${AppLocalizations.of(context)?.services ?? "services"}",
                        style: AppTheme.bodyText1.copyWith(
                          color: defaultTheme ? AppTheme.creamBrown : Colors.white,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            _createAppointmentProvider.chosenMaster == null
                                ? "${_createAppointmentProvider.chosenServices.length} ${AppLocalizations.of(
                                      context,
                                    )?.selectedServices ?? "selected services"}"
                                : "${_createAppointmentProvider.mastersServicesMap[_createAppointmentProvider.chosenMaster?.masterId]?.length} ${AppLocalizations.of(
                                      context,
                                    )?.availableServices ?? "available services"}",
                            style: AppTheme.bodyText2.copyWith(
                              color: defaultTheme ? AppTheme.black : Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Space(factor: (_createAppointmentProvider.chosenSalon!.ownerType == OwnerType.salon && widget.master == false) ? 1 : 2),
                      ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final ServiceModel service = _createAppointmentProvider.chosenServices[index];

                          bool valid = true;
                          if (_createAppointmentProvider.ownerType == OwnerType.salon) {
                            if (_createAppointmentProvider.mastersServicesMap[_createAppointmentProvider.chosenMaster?.masterId] != null) {
                              valid = _createAppointmentProvider.mastersServicesMap[_createAppointmentProvider.chosenMaster?.masterId]!
                                  .where(
                                    (element) => element.serviceId == _createAppointmentProvider.chosenServices[index].serviceId,
                                  )
                                  .isNotEmpty;
                            } else {
                              valid = false;
                            }
                          }

                          Color selectedColor = defaultTheme ? const Color.fromARGB(255, 239, 239, 239) : const Color(0XFF202020);
                          BoxBorder? border = defaultTheme ? Border.all(width: 1.5, color: const Color.fromARGB(255, 239, 239, 239)) : Border.all(width: 2, color: const Color(0XFF202020));
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 5.h),
                            child: Container(
                              decoration: BoxDecoration(
                                color: valid ? selectedColor : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                border: valid ? null : border,
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 20,
                                  horizontal: DeviceConstraints.getResponsiveSize(context, 10, 15, 25),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    // -- SERVICE TITLE AND PRICE
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          service.translations[AppLocalizations.of(context)?.localeName ?? 'en'].toString(), // 'Eyebrow Tinting',
                                          style: AppTheme.bodyText1.copyWith(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16.sp,
                                            color: defaultTheme ? AppTheme.textBlack : Colors.white,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                        const Spacer(),
                                        Text(
                                          service.isFixedPrice ? "${service.priceAndDuration.price}${Keys.uah}" : "${service.priceAndDuration.price}${Keys.uah} - ${service.priceAndDurationMax!.price}${Keys.uah}",
                                          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16.sp,
                                                color: defaultTheme ? AppTheme.textBlack : Colors.white,
                                              ),
                                          overflow: TextOverflow.visible,
                                          maxLines: 1,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10.h),

                                    // SERVICE DURATION
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 20.h,
                                          width: 20.h,
                                          child: Center(
                                            child: SvgPicture.asset(
                                              AppIcons.clockSVG,
                                              color: defaultTheme ? AppTheme.textBlack : Colors.white,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        service.isFixedPrice
                                            ? Text(
                                                "${service.priceAndDuration.duration} minutes",
                                                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                                      fontSize: 14.sp,
                                                      color: defaultTheme ? AppTheme.textBlack : Colors.white,
                                                    ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              )
                                            : Text(
                                                "${service.priceAndDuration.duration} minutes - ${service.priceAndDurationMax!.duration} minutes",
                                                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                                      fontSize: 14.sp,
                                                      color: defaultTheme ? AppTheme.textBlack : Colors.white,
                                                    ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                        const Spacer(),
                                        (service.description == null || service.description == "")
                                            ? const SizedBox(width: 15)
                                            : GestureDetector(
                                                onTap: () => showDialog<bool>(
                                                  context: context,
                                                  builder: (BuildContext context) => ShowServiceInfo(service),
                                                ),
                                                child: SizedBox(
                                                  height: DeviceConstraints.getResponsiveSize(context, 12, 18, 18),
                                                  width: DeviceConstraints.getResponsiveSize(context, 12, 18, 18),
                                                  child: Center(
                                                    child: SvgPicture.asset(
                                                      AppIcons.informationSVG,
                                                      height: DeviceConstraints.getResponsiveSize(context, 12, 18, 18),
                                                      width: DeviceConstraints.getResponsiveSize(context, 12, 18, 18),
                                                      color: defaultTheme ? AppTheme.textBlack : Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: _createAppointmentProvider.chosenServices.length,
                      ),
                    ],
                  ),
                  const Space(factor: 2),

                  // -- SELECT MASTER
                  if (_createAppointmentProvider.chosenSalon!.ownerType == OwnerType.salon && widget.master == false)
                    AvailableMasters(
                      createAppointment: widget.createAppointment,
                      mastresListController: _mastresListController,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            DefaultButton(
              borderRadius: 60,
              onTap: () {
                final bool isMasterNull = widget.createAppointment.chosenMaster == null && widget.createAppointment.chosenSalon!.ownerType == OwnerType.salon;

                // print(isMasterNull);
                // print(widget.createAppointment.chosenSalon!.ownerType);

                if (isMasterNull) {
                  showToast(AppLocalizations.of(context)?.chooseMaster ?? 'choose master');
                  return;
                }

                debugPrint('Next Step');
                widget.tabController.animateTo(1);
              },
              color: defaultTheme ? Colors.black : theme.primaryColor,
              textColor: defaultTheme ? Colors.white : Colors.black,
              height: 60,
              label: 'Next step',
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}

class AvailableMasters extends ConsumerWidget {
  final CreateAppointmentProvider createAppointment;
  final ScrollController mastresListController;

  const AvailableMasters({
    Key? key,
    required this.createAppointment,
    required this.mastresListController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;
    bool defaultTheme = theme == AppTheme.lightTheme;

    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)?.availableMasters.toCapitalized() ?? 'Available masters',
            style: AppTheme.bodyText1.copyWith(
              color: defaultTheme ? AppTheme.textBlack : Colors.white,
            ),
          ),

          SizedBox(height: 20.h),

          // IF THERE ARE NOT AVAILABLE MASTERS
          if (createAppointment.availableMasters.isEmpty) ...[
            SizedBox(
              height: 100.h,
              width: 1.sw,
              child: Text(
                '${AppLocalizations.of(context)?.noMastersAvailableOn} ${Time().getDateInStandardFormat(
                  createAppointment.chosenDay,
                )}',
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: defaultTheme ? AppTheme.textBlack : Colors.white,
                    ),
              ),
            )
          ],

          // IF MASTERS ARE AVAILABLE
          if (createAppointment.availableMasters.isNotEmpty) ...[
            SizedBox(
              height: (185 + 48).h,
              width: 1.sw,
              child: ListView.builder(
                itemCount: createAppointment.availableMasters.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                controller: mastresListController,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Column(
                      children: [
                        MastersRowContainer1(
                          name: Utils().getNameMaster(createAppointment.availableMasters[index].personalInfo),
                          imageUrl: createAppointment.availableMasters[index].profilePicUrl,
                          rating: createAppointment.availableMasters[index].avgRating,
                          onTap: () async {
                            String res = await createAppointment.chooseMaster(
                              masterModel: createAppointment.availableMasters[index],
                              context: context,
                            );
                            printIt(res);

                            if (res == "choosen") {
                              showToast(AppLocalizations.of(context)?.selected ?? "selected");
                            } else {
                              showToast(AppLocalizations.of(context)?.notAvailable ?? "not available");
                            }
                          },
                          selected: createAppointment.chosenMaster?.masterId == createAppointment.availableMasters[index].masterId,
                        ),
                        const SizedBox(height: 4),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "${createAppointment.mastersServicesMap[createAppointment.availableMasters[index].masterId]?.length} ${AppLocalizations.of(
                                    context,
                                  )?.services ?? "services"}",
                              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                    color: defaultTheme ? AppTheme.textBlack : Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${createAppointment.mastersPriceDurationMap[createAppointment.availableMasters[index].masterId]?.price} ${Keys.uah}",
                              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                    color: defaultTheme ? AppTheme.textBlack : Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class MastersRowContainer1 extends ConsumerWidget {
  final String? name;
  final String? imageUrl;
  final double? rating;
  final Function onTap;
  final bool selected;

  const MastersRowContainer1({
    Key? key,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.onTap,
    required this.selected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    bool defaultTheme = (theme == AppTheme.lightTheme);

    Color boxSelectedColor = defaultTheme ? Colors.white : theme.primaryColor;
    Color unSelectedColor = defaultTheme ? Theme.of(context).scaffoldBackgroundColor : Colors.transparent;
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        decoration: BoxDecoration(
          // color: selected ? Colors.white : Theme.of(context).scaffoldBackgroundColor,
          color: selected ? boxSelectedColor : unSelectedColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            // color: selected ? AppTheme.creamBrownLight : Colors.transparent,
            color: selected ? (defaultTheme ? AppTheme.creamBrownLight : Colors.transparent) : boxSelectedColor,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 16.h),
          child: Center(
            child: PersonAvtar(
              personImageUrl: imageUrl,
              personName: name,
              radius: 35,
              showBorder: false,
              showRating: true,
              rating: rating,
              starSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}
