// ignore_for_file: unnecessary_this

import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/extracted/expansion_tile.dart';
import 'package:bbblient/src/models/cat_sub_service/category_service.dart';
import 'package:bbblient/src/models/cat_sub_service/services_model.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/utils/translation.dart';
import 'package:bbblient/src/views/widgets/buttons.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NewServiceTile extends ConsumerStatefulWidget {
  final List<ServiceModel> services;
  final CategoryModel categoryModel;
  final bool initiallyExpanded;

  final ScrollController listViewController;
  const NewServiceTile({
    Key? key,
    required this.services,
    required this.categoryModel,
    required this.listViewController,
    required this.initiallyExpanded,
  }) : super(key: key);

  @override
  _NewServiceTileState createState() => _NewServiceTileState();
}

class _NewServiceTileState extends ConsumerState<NewServiceTile> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    final _salonProfileProvider = ref.watch(salonProfileProvider);
    final createAppointment = ref.watch(createAppointmentProvider);

    SalonModel salonModel = _salonProfileProvider.chosenSalon;

    final ThemeData theme = _salonProfileProvider.salonTheme;
    bool isLightTheme = (theme == AppTheme.customLightTheme);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: CustomExpansionTile(
          initiallyExpanded: widget.initiallyExpanded,
          iconColor: Colors.black,
          collapsedIconColor: Colors.black,
          tilePadding: EdgeInsets.zero,
          childrenPadding: EdgeInsets.zero,
          trailing: const SizedBox.shrink(),
          backgroundColor: const Color(0XFF0A0A0A).withOpacity(0.6),
          onExpansionChanged: (bool val) {
            setState(() => isExpanded = !isExpanded);
          },
          title: Container(
            color: !isExpanded ? const Color(0XFF0A0A0A).withOpacity(0.6) : null, //  theme.canvasColor.withOpacity(0.7),
            height: 55.sp,
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: DeviceConstraints.getResponsiveSize(context, 15, 30, 50)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        ('${widget.categoryModel.translations[AppLocalizations.of(context)?.localeName ?? 'en'] ?? widget.categoryModel.translations['en']}').toUpperCase(),
                        style: theme.textTheme.displayLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 18.sp, 18.sp),
                          color: isLightTheme ? Colors.black : Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      color: theme.canvasColor,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      child: Text(
                        '${widget.services.length} ${AppLocalizations.of(context)?.services ?? 'Services'}',
                        style: theme.textTheme.titleSmall!.copyWith(
                          fontSize: DeviceConstraints.getResponsiveSize(context, 13.sp, 13.sp, 15.sp),
                          // fontWeight: FontWeight.w400,
                          color: theme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 7),
                    child: RotatedBox(
                      quarterTurns: -1,
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: const Color(0XFF919191),
                        size: 20.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          children: [
            Container(
              color: !isExpanded ? const Color(0XFF0A0A0A).withOpacity(0.6) : null, //  theme.canvasColor.withOpacity(0.7),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: DeviceConstraints.getResponsiveSize(context, 15, 30, 50),
                  vertical: 12.sp,
                ),
                child: ListView.builder(
                  itemCount: widget.services.length,
                  shrinkWrap: true,
                  primary: false,
                  padding: const EdgeInsets.all(0),
                  itemBuilder: (context, index) {
                    final ServiceModel service = widget.services[index];
                    return ((service.priceAndDuration!.price) != "0")
                        ? InkWell(
                            key: const ValueKey("tap-service"),
                            onTap: () {
                              createAppointment.toggleService(
                                serviceModel: service,
                                clearChosenMaster: false,
                                context: context,
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 7.sp),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.sp),
                                  border: Border.all(
                                    color: createAppointment.isAdded(serviceModel: service) ? theme.primaryColor : const Color(0XFF2F2F2F),
                                    width: createAppointment.isAdded(serviceModel: service) ? 1 : 0.5,
                                  ),
                                ),
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 13.sp, horizontal: 18.sp),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          // -- SERVICES SUB TITLE WITH INFORMATION ICON --
                                          Text(
                                            '${widget.services[index].translations?[AppLocalizations.of(context)?.localeName ?? 'en'] ?? widget.services[index].translations?['en']}'.toCapitalized(),
                                            style: theme.textTheme.displayMedium!.copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 18.sp, 18.sp),
                                              color: isLightTheme ? Colors.black : Colors.white,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                          SizedBox(height: 10.sp),

                                          // -- DURATION SECTION --
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height: 15.h,
                                                width: 15.h,
                                                child: Center(
                                                  child: FaIcon(
                                                    FontAwesomeIcons.clock,
                                                    color: const Color(0XFF908D8D),
                                                    size: 15.h,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 15.sp),
                                              service.isFixedDuration != null
                                                  ? service.isFixedDuration
                                                      ? Text(
                                                          "${service.priceAndDuration!.duration} ${AppLocalizations.of(context)?.min ?? 'min'}",
                                                          style: theme.textTheme.displayMedium!.copyWith(
                                                            fontSize: 15.sp,
                                                            fontWeight: FontWeight.w500,
                                                            color: const Color(0XFF908D8D),
                                                          ),
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 1,
                                                        )
                                                      : Text(
                                                          "${service.priceAndDuration!.duration}  ${AppLocalizations.of(context)?.min ?? 'min'} - ${service.priceAndDurationMax!.duration}  ${AppLocalizations.of(context)?.min ?? 'min'}",
                                                          style: theme.textTheme.displayMedium!.copyWith(
                                                            fontSize: 15.sp,
                                                            fontWeight: FontWeight.w500,
                                                            color: const Color(0XFF908D8D),
                                                          ),
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 1,
                                                        )
                                                  : Text(
                                                      "${service.priceAndDuration!.duration}  ${AppLocalizations.of(context)?.min ?? 'min'}",
                                                      style: theme.textTheme.displayMedium!.copyWith(
                                                        fontSize: 15.sp,
                                                        fontWeight: FontWeight.w500,
                                                        color: const Color(0XFF908D8D),
                                                      ),
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      // const Spacer(),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          // CURRENT PRICE
                                          Text(
                                            service.isFixedPrice
                                                ? "${salonModel.selectedCurrency}${service.priceAndDuration!.price}"
                                                : service.isPriceStartAt
                                                    ? "${salonModel.selectedCurrency}${service.priceAndDuration!.price} - ${salonModel.selectedCurrency}∞"
                                                    : "${salonModel.selectedCurrency}${service.priceAndDuration!.price} - ${salonModel.selectedCurrency}${service.priceAndDurationMax!.price}",
                                            style: theme.textTheme.displayMedium!.copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15.sp,
                                              color: isLightTheme ? Colors.black : Colors.white,
                                              fontFamily: "Inter-Bold",
                                            ),
                                            overflow: TextOverflow.visible,
                                            maxLines: 1,
                                          ),

                                          SizedBox(height: 10.sp),
                                          (service.description == null || service.description == "")
                                              ? const SizedBox.shrink()
                                              : GestureDetector(
                                                  onTap: () => showDialog<bool>(
                                                    context: context,
                                                    builder: (BuildContext context) => ShowServiceInfo(service),
                                                  ),
                                                  child: SizedBox(
                                                    height: DeviceConstraints.getResponsiveSize(context, 20.sp, 20.sp, 20.sp),
                                                    width: DeviceConstraints.getResponsiveSize(context, 20.sp, 20.sp, 20.sp),
                                                    child: Center(
                                                      child: SvgPicture.asset(
                                                        AppIcons.informationSVG,
                                                        height: DeviceConstraints.getResponsiveSize(context, 20.sp, 20.sp, 20.sp),
                                                        width: DeviceConstraints.getResponsiveSize(context, 20.sp, 20.sp, 20.sp),
                                                        color: const Color(0XFF908D8D),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox();
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ShowServiceInfo extends StatelessWidget {
  final ServiceModel service;
  const ShowServiceInfo(this.service, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        contentPadding: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
        content: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppTheme.lightBlack,
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      Translation.getServiceName(service: service, langCode: AppLocalizations.of(context)?.localeName ?? 'en'),
                      style: const TextStyle(color: AppTheme.white3),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.clear_rounded,
                      size: 22,
                      color: AppTheme.white3,
                    ),
                  )
                ],
              ),
              const Space(),
              Text(
                (service.description == null || service.description == "")
                    ? "Опис відсутній" //means no description available
                    : service.description!,
                style: const TextStyle(color: AppTheme.white3, fontWeight: FontWeight.w400),
              )
            ],
          ),
        ));
  }
}

extension ForWeb on String {
  String forWeb({required bool web}) => web ? this.replaceFirst('assets/', '') : this;
}

class ShowAdditionaFeatureInfo extends StatelessWidget {
  final String feature;
  final authprovider;
  const ShowAdditionaFeatureInfo(this.authprovider, this.feature, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        contentPadding: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
        content: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppTheme.lightBlack,
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Flexible(
                    child: Text(
                      "",
                      // Translation.getServiceName(
                      //     service: service,
                      //     langCode:
                      //         AppLocalizations.of(context)?.localeName ?? 'en'),
                      style: TextStyle(color: AppTheme.white3),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.clear_rounded,
                      size: 22,
                      color: AppTheme.white3,
                    ),
                  )
                ],
              ),
              const Space(),
              // TranslationWidget(
              //     // fromString: chatMessages.content,
              //     toLanguageCode: authprovider.getLocale.toString(),
              //     message: feature,
              //     builder: (stringg) {
              //       return Text(
              //         // (service.description == null || service.description == "")
              //         //     ? "Опис відсутній" //means no description available
              //         //     : service.description!,
              //         stringg,
              //         style: const TextStyle(
              //             color: AppTheme.white3, fontWeight: FontWeight.w400),
              //       );
              //     }),
              if (feature == "disposableMaterialsOnly") ...[
                Text(
                  // (service.description == null || service.description == "")
                  //     ? "Опис відсутній" //means no description available
                  //     : service.description!,
                  authprovider.getLocale.toString() == "en" ? "Disposable Materials Only" : "Тільки одноразові матеріали",
                  style: const TextStyle(color: AppTheme.white3, fontWeight: FontWeight.w400),
                )
              ],
              if (feature == "accessibilityForPersonsWithReducedMobility") ...[
                Text(
                  // (service.description == null || service.description == "")
                  //     ? "Опис відсутній" //means no description available
                  //     : service.description!,
                  authprovider.getLocale.toString() == "en" ? "Accessibility for persons with reduced mobility" : "Доступність для маломобільних людей",
                  style: const TextStyle(color: AppTheme.white3, fontWeight: FontWeight.w400),
                )
              ],
              if (feature == "womanOwnedBusiness") ...[
                Text(
                  // (service.description == null || service.description == "")
                  //     ? "Опис відсутній" //means no description available
                  //     : service.description!,
                  authprovider.getLocale.toString() == "en" ? "Woman Owned Business" : "Жіночий бізнес",
                  style: const TextStyle(color: AppTheme.white3, fontWeight: FontWeight.w400),
                )
              ],
              if (feature == "noPets") ...[
                Text(
                  // (service.description == null || service.description == "")
                  //     ? "Опис відсутній" //means no description available
                  //     : service.description!,
                  authprovider.getLocale.toString() == "en" ? "No pets" : "Без тварин",
                  style: const TextStyle(color: AppTheme.white3, fontWeight: FontWeight.w400),
                )
              ],
              if (feature == "parallelService") ...[
                Text(
                  // (service.description == null || service.description == "")
                  //     ? "Опис відсутній" //means no description available
                  //     : service.description!,
                  authprovider.getLocale.toString() == "en" ? "Parallel Service" : "Паралельний сервіс",
                  style: const TextStyle(color: AppTheme.white3, fontWeight: FontWeight.w400),
                )
              ],
              if (feature == "parking") ...[
                Text(
                  // (service.description == null || service.description == "")
                  //     ? "Опис відсутній" //means no description available
                  //     : service.description!,
                  authprovider.getLocale.toString() == "en" ? "Parking" : "Парковка",
                  style: const TextStyle(color: AppTheme.white3, fontWeight: FontWeight.w400),
                )
              ],
              if (feature == "medicalPracticeLicense") ...[
                Text(
                  // (service.description == null || service.description == "")
                  //     ? "Опис відсутній" //means no description available
                  //     : service.description!,
                  authprovider.getLocale.toString() == "en" ? "Medical Practice License" : "Ліцензія на медичну практику",
                  style: const TextStyle(color: AppTheme.white3, fontWeight: FontWeight.w400),
                )
              ],
              if (feature == "wifi") ...[
                Text(
                  // (service.description == null || service.description == "")
                  //     ? "Опис відсутній" //means no description available
                  //     : service.description!,
                  authprovider.getLocale.toString() == "en" ? "Wi-Fi " : "Wi-Fi ",
                  style: const TextStyle(color: AppTheme.white3, fontWeight: FontWeight.w400),
                )
              ],
              if (feature == "coffee") ...[
                Text(
                  // (service.description == null || service.description == "")
                  //     ? "Опис відсутній" //means no description available
                  //     : service.description!,
                  authprovider.getLocale.toString() == "en" ? "Coffee/tea" : "Кава/чай",
                  style: const TextStyle(color: AppTheme.white3, fontWeight: FontWeight.w400),
                )
              ],
              if (feature == "cocktails") ...[
                Text(
                  // (service.description == null || service.description == "")
                  //     ? "Опис відсутній" //means no description available
                  //     : service.description!,
                  authprovider.getLocale.toString() == "en" ? "Cocktails" : "Коктейлі",
                  style: const TextStyle(color: AppTheme.white3, fontWeight: FontWeight.w400),
                )
              ],
              if (feature == "shop") ...[
                Text(
                  // (service.description == null || service.description == "")
                  //     ? "Опис відсутній" //means no description available
                  //     : service.description!,
                  authprovider.getLocale.toString() == "en" ? "Shop" : "Магазин",
                  style: const TextStyle(color: AppTheme.white3, fontWeight: FontWeight.w400),
                )
              ],
              if (feature == "childrenRoom") ...[
                Text(
                  // (service.description == null || service.description == "")
                  //     ? "Опис відсутній" //means no description available
                  //     : service.description!,
                  authprovider.getLocale.toString() == "en" ? "Children Room" : "Дитяча кімната",
                  style: const TextStyle(color: AppTheme.white3, fontWeight: FontWeight.w400),
                )
              ],
              if (feature == "antiCovidMeasures") ...[
                Text(
                  // (service.description == null || service.description == "")
                  //     ? "Опис відсутній" //means no description available
                  //     : service.description!,
                  authprovider.getLocale.toString() == "en" ? "Anti-covid measures" : "Антиковідні заходи ",
                  style: const TextStyle(color: AppTheme.white3, fontWeight: FontWeight.w400),
                )
              ],
              if (feature == "instrumentsSterilization") ...[
                Text(
                  // (service.description == null || service.description == "")
                  //     ? "Опис відсутній" //means no description available
                  //     : service.description!,
                  authprovider.getLocale.toString() == "en" ? "Instruments sterilization" : "Стерилізація інструментів",
                  style: const TextStyle(color: AppTheme.white3, fontWeight: FontWeight.w400),
                )
              ],
              if (feature == "masterWithSpeechDisability") ...[
                Text(
                  // (service.description == null || service.description == "")
                  //     ? "Опис відсутній" //means no description available
                  //     : service.description!,
                  authprovider.getLocale.toString() == "en" ? "Master with speech disability" : "Майстер із порушенням мовлення",
                  style: const TextStyle(color: AppTheme.white3, fontWeight: FontWeight.w400),
                )
              ],
              if (feature == "medicalDegree") ...[
                Text(
                  // (service.description == null || service.description == "")
                  //     ? "Опис відсутній" //means no description available
                  //     : service.description!,
                  authprovider.getLocale.toString() == "en" ? "Medical degree" : "Медична освіта",
                  style: const TextStyle(color: AppTheme.white3, fontWeight: FontWeight.w400),
                )
              ],
              if (feature == "masterWithHearingDisability") ...[
                Text(
                  // (service.description == null || service.description == "")
                  //     ? "Опис відсутній" //means no description available
                  //     : service.description!,
                  authprovider.getLocale.toString() == "en" ? "Master with hearing disability" : "Майстер із порушенням слуху",
                  style: const TextStyle(color: AppTheme.white3, fontWeight: FontWeight.w400),
                )
              ],

              if (feature == "petFriendly") ...[
                Text(
                  // (service.description == null || service.description == "")
                  //     ? "Опис відсутній" //means no description available
                  //     : service.description!,
                  authprovider.getLocale.toString() == "en" ? "Pet friendly" : "Дозволено з тваринами",
                  style: const TextStyle(color: AppTheme.white3, fontWeight: FontWeight.w400),
                )
              ],
              if (feature == "ownOffice") ...[
                Text(
                  // (service.description == null || service.description == "")
                  //     ? "Опис відсутній" //means no description available
                  //     : service.description!,
                  authprovider.getLocale.toString() == "en" ? "Own office" : "Власний кабінет",
                  style: const TextStyle(color: AppTheme.white3, fontWeight: FontWeight.w400),
                )
              ],
              if (feature == "covidVaccinated") ...[
                Text(
                  // (service.description == null || service.description == "")
                  //     ? "Опис відсутній" //means no description available
                  //     : service.description!,
                  authprovider.getLocale.toString() == "en" ? "Covid-19 vaccinated" : "Вакцинованість проти Covid-19",
                  style: const TextStyle(color: AppTheme.white3, fontWeight: FontWeight.w400),
                )
              ],
            ],
          ),
        ));
  }
}
