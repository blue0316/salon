// ignore_for_file: unnecessary_this

import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/extracted/expansion_tile.dart';
import 'package:bbblient/src/models/cat_sub_service/category_service.dart';
import 'package:bbblient/src/models/cat_sub_service/services_model.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/utils/keys.dart';
import 'package:bbblient/src/utils/translation.dart';
import 'package:bbblient/src/views/widgets/buttons.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  // Future<String> translate(value) async {
  //   final translator = trans.GoogleTranslator();
  //   var text;
  //   var _bnbProvider;
  //   try {
  //     Provider((ref) {
  //       // use ref to obtain other providers
  //       _bnbProvider = ref.watch(bnbProvider);
  //     });
  //     text = value != "" && value != null
  //         ? await translator.translate(value, to: _bnbProvider.getLocale.toString()).then((value) {
  //             return value.text;
  //           })
  //         : "";
  //   } catch (e) {}
  //   return text;
  // }

  @override
  Widget build(BuildContext context) {
    final createAppointment = ref.watch(createAppointmentProvider);
    var mediaQuery = MediaQuery.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: CustomExpansionTile(
          initiallyExpanded: widget.initiallyExpanded,
          iconColor: AppTheme.black,
          collapsedIconColor: AppTheme.black,
          tilePadding: EdgeInsets.zero,
          childrenPadding: const EdgeInsets.only(top: 5),
          trailing: const SizedBox.shrink(),
          backgroundColor: Colors.transparent,
          title: Container(
            color: Colors.white.withOpacity(0.7),
            height: 70,
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
                        ('${widget.categoryModel.translations[AppLocalizations.of(context)?.localeName ?? 'en']}').toUpperCase(),
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 18.sp, 18.sp),
                            ),
                      ),
                      if (DeviceConstraints.getDeviceType(mediaQuery) == DeviceScreenType.portrait)
                        if (widget.categoryModel.categoryId == '2')
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 10),
                              Container(height: 1.3, width: 35, color: Colors.black),
                              const SizedBox(height: 10),
                              Text(
                                'Save up to 15%',
                                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.sp,
                                      color: const Color(0XFFFF5C5C),
                                    ),
                              ),
                            ],
                          ),
                    ],
                  ),
                  if (DeviceConstraints.getDeviceType(mediaQuery) != DeviceScreenType.portrait)
                    if (widget.categoryModel.categoryId == '2')
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(width: 25),
                          Container(
                            height: 13,
                            width: 1.3,
                            color: Colors.black,
                          ),
                          const SizedBox(width: 25),
                          Text(
                            'Save up to 15%',
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0XFFFF5C5C),
                                ),
                          ),
                        ],
                      ),
                  const Spacer(),
                  Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(50)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      child: Text(
                        '${widget.services.length} Services',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontSize: DeviceConstraints.getResponsiveSize(context, 13.sp, 13.sp, 15.sp),
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 7),
                    child: Icon(Icons.expand_more),
                  ),
                ],
              ),
            ),
          ),
          children: [
            Container(
              color: Colors.white.withOpacity(0.7),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: DeviceConstraints.getResponsiveSize(context, 15, 30, 50),
                  vertical: 8,
                ),
                child: ListView.builder(
                  itemCount: widget.services.length,
                  shrinkWrap: true,
                  primary: false,
                  padding: const EdgeInsets.all(0),
                  itemBuilder: (context, index) {
                    final ServiceModel service = widget.services[index];
                    return ((service.priceAndDuration.price) != "0")
                        ? InkWell(
                            key: const ValueKey("tap-service"),
                            onTap: () {
                              // createAppointment.toggleService(
                              //   serviceModel: service,
                              //   clearChosenMaster: false,
                              //   context: context,
                              // );
                            },
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 9,
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 10.0.h),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                // -- SERVICES SUB TITLE WITH INFORMATION ICON --
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: Row(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Expanded(
                                                            flex: DeviceConstraints.getResponsiveSize(context, 1, 0, 0).toInt(),
                                                            child: Row(
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  widget.services[index].translations[AppLocalizations.of(context)?.localeName ?? 'en'].toString(),
                                                                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 18.sp, 18.sp),
                                                                      ),
                                                                  overflow: TextOverflow.ellipsis,
                                                                  maxLines: 2,
                                                                ),
                                                                const SizedBox(width: 12),
                                                                (service.description == null || service.description == "")
                                                                    ? const SizedBox.shrink()
                                                                    : GestureDetector(
                                                                        onTap: () => showDialog<bool>(
                                                                          context: context,
                                                                          builder: (BuildContext context) => ShowServiceInfo(service),
                                                                        ),
                                                                        child: SizedBox(
                                                                          height: DeviceConstraints.getResponsiveSize(context, 12, 12, 12),
                                                                          width: DeviceConstraints.getResponsiveSize(context, 12, 12, 12),
                                                                          child: Center(
                                                                            child: SvgPicture.asset(
                                                                              AppIcons.informationSVG,
                                                                              height: DeviceConstraints.getResponsiveSize(context, 12, 12, 12),
                                                                              width: DeviceConstraints.getResponsiveSize(context, 12, 12, 12),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: DeviceConstraints.getResponsiveSize(context, 10, 10, 10),
                                                ),
                                                // -- DURATION SECTION --
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      height: 12.h,
                                                      width: 12.h,
                                                      child: Center(
                                                        child: SvgPicture.asset(AppIcons.clockSVG, color: AppTheme.black),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 7),
                                                    service.isFixedDuration != null
                                                        ? service.isFixedDuration
                                                            ? Text(
                                                                "${service.priceAndDuration.duration} minutes",
                                                                style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 15.sp, fontWeight: FontWeight.w500),
                                                                overflow: TextOverflow.ellipsis,
                                                                maxLines: 1,
                                                              )
                                                            : Text(
                                                                "${service.priceAndDuration.duration} minutes - ${service.priceAndDurationMax!.duration} minutes",
                                                                style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w500),
                                                                overflow: TextOverflow.ellipsis,
                                                                maxLines: 1,
                                                              )
                                                        : Text(
                                                            "${service.priceAndDuration.duration} minutes",
                                                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 15.sp, fontWeight: FontWeight.w500),
                                                            overflow: TextOverflow.ellipsis,
                                                            maxLines: 1,
                                                          ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const Spacer(),

                                        Expanded(
                                          flex: 0,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              // CURRENT PRICE
                                              Text(
                                                service.isFixedPrice
                                                    ? "${Keys.dollars}${service.priceAndDuration.price}"
                                                    : service.isPriceStartAt
                                                        ? "${Keys.dollars}${service.priceAndDuration.price} - ${Keys.dollars}∞"
                                                        : "${Keys.dollars}${service.priceAndDuration.price} - ${Keys.dollars}${service.priceAndDurationMax!.price}",
                                                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16.sp,
                                                      color: AppTheme.textBlack,
                                                    ),
                                                overflow: TextOverflow.visible,
                                                maxLines: 1,
                                              ),
                                              if (service.priceAndDuration.price == '200') const SizedBox(height: 7),

                                              // PREVIOUS PRICE
                                              if (service.priceAndDuration.price == '200') // TODO: REMOVE THIS (DUMMY IMPLEMENTATION FOR UI)
                                                Text(
                                                  service.isFixedPrice
                                                      ? "${Keys.dollars}${service.priceAndDuration.price}"
                                                      : service.isPriceStartAt
                                                          ? "${Keys.dollars}${service.priceAndDuration.price} - ${Keys.dollars}∞"
                                                          : "${Keys.dollars}${service.priceAndDuration.price} - ${Keys.dollars}${service.priceAndDurationMax!.price}",
                                                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 14.sp,
                                                        color: Colors.red,
                                                        decoration: TextDecoration.lineThrough,
                                                      ),
                                                  overflow: TextOverflow.visible,
                                                  maxLines: 1,
                                                ),
                                            ],
                                          ),
                                        ),

                                        const SizedBox(width: 20),

                                        // -- ADD SERVICE ICON --
                                        Expanded(
                                          flex: 0,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              ServicesBnbCheckCircle(
                                                value: createAppointment.isAdded(serviceModel: service),
                                              ),
                                              // SizedBox(width: 10),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    const Space(factor: 0.7),
                                    if (index != widget.services.length - 1) const Divider(color: Colors.black, thickness: 1.3),
                                  ],
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
