import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/create_apntmnt_provider/create_appointment_provider.dart';
import 'package:bbblient/src/models/backend_codings/owner_type.dart';
import 'package:bbblient/src/models/cat_sub_service/services_model.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/utils/keys.dart';
import 'package:bbblient/src/utils/time.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/salon/booking/booking_date_time.dart';
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
  const DialogMastersSection({Key? key, required this.tabController, required this.createAppointment}) : super(key: key);

  @override
  ConsumerState<DialogMastersSection> createState() => _DialogMastersSectionState();
}

class _DialogMastersSectionState extends ConsumerState<DialogMastersSection> {
  final ScrollController _mastresListController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final CreateAppointmentProvider _createAppointmentProvider = ref.watch(createAppointmentProvider);

    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: DeviceConstraints.getResponsiveSize(context, 5, 20.w, 20.w),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  const Space(factor: 0.5),
                  // -- ALL SERVICES
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "${AppLocalizations.of(context)?.all ?? "All"} ${AppLocalizations.of(context)?.services ?? "services"}",
                        style: AppTheme.bodyText1.copyWith(color: AppTheme.creamBrown),
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
                            style: AppTheme.bodyText2.copyWith(color: AppTheme.black),
                          ),
                        ],
                      ),
                      const Space(factor: 1),
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

                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 5.h),
                            child: Container(
                              decoration: BoxDecoration(
                                color: valid ? const Color.fromARGB(255, 239, 239, 239) : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: valid ? null : Border.all(width: 1.5, color: const Color.fromARGB(255, 239, 239, 239)),
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
                                          style: AppTheme.bodyText1.copyWith(fontWeight: FontWeight.w600, fontSize: 16.sp),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                        const Spacer(),
                                        Text(
                                          service.isFixedPrice ? "${service.priceAndDuration.price}${Keys.uah}" : "${service.priceAndDuration.price}${Keys.uah} - ${service.priceAndDurationMax!.price}${Keys.uah}",
                                          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16.sp,
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
                                              color: AppTheme.black,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        service.isFixedPrice
                                            ? Text(
                                                "${service.priceAndDuration.duration} minutes",
                                                style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 14.sp),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              )
                                            : Text(
                                                "${service.priceAndDuration.duration} minutes - ${service.priceAndDurationMax!.duration} minutes",
                                                style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 14.sp),
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
                if (isMasterNull) {
                  showToast(AppLocalizations.of(context)?.chooseMaster ?? 'choose master');
                  return;
                }

                debugPrint('Next Step');
                widget.tabController.animateTo(1);
              },
              color: Colors.black,
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
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)?.availableMasters.toCapitalized() ?? 'Available masters',
            style: AppTheme.bodyText1.copyWith(color: AppTheme.creamBrown),
          ),

          SizedBox(height: 20.h),

          // IF THERE ARE NOT AVAILABLE MASTERS
          if (createAppointment.availableMasters.isEmpty) ...[
            SizedBox(
              height: 100.h,
              width: 1.sw,
              child: Text(
                '${AppLocalizations.of(context)?.noMastersAvailableOn} ${Time().getDateInStandardFormat(createAppointment.chosenDay)}',
                style: Theme.of(context).textTheme.bodyText1!,
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
                        MastersRowContainer(
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
                                    color: AppTheme.textBlack,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${createAppointment.mastersPriceDurationMap[createAppointment.availableMasters[index].masterId]?.price} ${Keys.uah}",
                              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                    color: AppTheme.textBlack,
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
