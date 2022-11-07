// ignore_for_file: unnecessary_this

import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/bnb/bnb_provider.dart';
import 'package:bbblient/src/models/cat_sub_service/category_service.dart';
import 'package:bbblient/src/models/cat_sub_service/services_model.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/keys.dart';
import 'package:bbblient/src/utils/translation.dart';
import 'package:bbblient/src/utils/translation_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:translator/translator.dart' as trans;
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../theme/app_main_theme.dart';
import '../../../utils/icons.dart';
import '../../widgets/buttons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ServiceTile extends ConsumerStatefulWidget {
  final List<ServiceModel> services;
  final CategoryModel categoryModel;
  final bool initiallyExpanded;

  final ScrollController listViewController;
  const ServiceTile({
    Key? key,
    required this.services,
    required this.categoryModel,
    required this.listViewController,
    required this.initiallyExpanded,
  }) : super(key: key);

  @override
  _ServiceTileState createState() => _ServiceTileState();
}

class _ServiceTileState extends ConsumerState<ServiceTile> {
  Future<String> translate(value) async {
    final translator = trans.GoogleTranslator();
    var text;
    var _bnbProvider;
    try {
      Provider((ref) {
        // use ref to obtain other providers
        _bnbProvider = ref.watch(bnbProvider);
      });
      text = value != "" && value != null
          ? await translator
              .translate(value, to: _bnbProvider.getLocale.toString())
              .then((value) {
              return value.text;
            })
          : "";
    } catch (e) {}
    return text;
  }

  @override
  Widget build(BuildContext context) {
    final createAppointment = ref.watch(createAppointmentProvider);

    return ConstrainedContainer(
      child: ExpansionTile(
        initiallyExpanded: widget.initiallyExpanded,
        backgroundColor: Colors.white,
        title: Padding(
          padding: EdgeInsets.symmetric(
              vertical:
                  DeviceConstraints.getResponsiveSize(context, 0, 12, 24)),
          child: Row(
            children: [
              SizedBox(
                width: DeviceConstraints.getResponsiveSize(context, 40, 44, 56),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 35,
                // DeviceConstraints.getResponsiveSize(context, 20, 22, 24),
                width: MediaQuery.of(context).size.width / 15,
                // DeviceConstraints.getResponsiveSize(context, 20, 22, 24),
                child: Image.asset(
                  AppIcons.getPngIconFromCategoryId(
                      id: widget.categoryModel.categoryId),
                      
                  // color:
                  // AppTheme.creamBrown.withOpacity(0.2)
                  // Colors.black12
                  //  Colors.grey,
                  // currentColor: Colors.grey,
                ),
              ),
              SizedBox(
                width: DeviceConstraints.getResponsiveSize(context, 16, 22, 24),
              ),
              Text(
                widget.categoryModel.translations[
                    AppLocalizations.of(context)?.localeName ?? 'en'],
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(fontWeight: FontWeight.w500),
              )
            ],
          ),
        ),
        children: [
          ListView.builder(
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
                          createAppointment.toggleService(
                              serviceModel: service,
                              clearChosenMaster: false,
                              context: context);
                        },
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: EdgeInsets.only(left: 20.0.w, right: 8.w),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 18.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 9,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        top: 15.0.h,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 7,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    (service.description ==
                                                                null ||
                                                            service.description ==
                                                                "")
                                                        ? const SizedBox(
                                                            width: 15)
                                                        : GestureDetector(
                                                            onTap: () => showDialog<
                                                                    bool>(
                                                                context:
                                                                    context,
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    ShowServiceInfo(
                                                                        service)),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 5),
                                                              child: SizedBox(
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height /
                                                                    35,
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width /
                                                                    15,
                                                                child:
                                                                    SvgPicture
                                                                        .asset(
                                                                  AppIcons
                                                                      .informationSVG,
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height /
                                                                      35,
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width /
                                                                      15,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                    // SizedBox(
                                                    //   width: 8.w,
                                                    // ),
                                                    Expanded(
                                                      child: Text(
                                                        widget
                                                            .services[index]
                                                            .translations[
                                                                AppLocalizations.of(
                                                                            context)
                                                                        ?.localeName ??
                                                                    'en']
                                                            .toString(),

                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText1!
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300),
                                                        //overflow: TextOverflow.clip,
                                                        maxLines: 2,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 4.0.h),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 20.w,
                                                      ),
                                                      service.isFixedPrice
                                                          ? Text(
                                                              "${service.priceAndDuration.duration} ${AppLocalizations.of(context)?.min ?? "min"}",
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText1!
                                                                  .copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300,
                                                                      fontSize:
                                                                          13,
                                                                      color: AppTheme
                                                                          .lightGrey),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 1,
                                                            )
                                                          : Text(
                                                              "${service.priceAndDuration.duration} ${AppLocalizations.of(context)?.min ?? "min"} - ${service.priceAndDurationMax!.duration} ${AppLocalizations.of(context)?.min ?? "min"}",
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText1!
                                                                  .copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300,
                                                                      fontSize:
                                                                          13,
                                                                      color: AppTheme
                                                                          .lightGrey),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 1,
                                                            ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: Text(
                                              service.isFixedPrice
                                                  ? "${service.priceAndDuration.price} ${Keys.uah}"
                                                  : "${service.priceAndDuration.price} ${Keys.uah} - ${service.priceAndDurationMax!.price} ${Keys.uah}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 14,
                                                      color:
                                                          AppTheme.textBlack),
                                              overflow: TextOverflow.visible,
                                              maxLines: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                          ),
                                          child: BnbCheckCircle(
                                            value: createAppointment.isAdded(
                                                serviceModel: service),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox();
              })
        ],
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
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))),
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
                      Translation.getServiceName(
                          service: service,
                          langCode:
                              AppLocalizations.of(context)?.localeName ?? 'en'),
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
                style: const TextStyle(
                    color: AppTheme.white3, fontWeight: FontWeight.w400),
              )
            ],
          ),
        ));
  }
}

extension ForWeb on String {
  String forWeb({required bool web}) =>
      web ? this.replaceFirst('assets/', '') : this;
}

class ShowAdditionaFeatureInfo extends StatelessWidget {
  final String feature;
  final authprovider;
  const ShowAdditionaFeatureInfo(this.authprovider, this.feature, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        contentPadding: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))),
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
                  authprovider.getLocale.toString() == "en"
                      ? "Disposable Materials Only"
                      : "Тільки одноразові матеріали",
                  style: const TextStyle(
                      color: AppTheme.white3, fontWeight: FontWeight.w400),
                )
              ],
              if (feature == "accessibilityForPersonsWithReducedMobility") ...[
                Text(
                  // (service.description == null || service.description == "")
                  //     ? "Опис відсутній" //means no description available
                  //     : service.description!,
                  authprovider.getLocale.toString() == "en"
                      ? "Accessibility for persons with reduced mobility"
                      : "Доступність для маломобільних людей",
                  style: const TextStyle(
                      color: AppTheme.white3, fontWeight: FontWeight.w400),
                )
              ],
              if (feature == "noPets") ...[
                Text(
                  // (service.description == null || service.description == "")
                  //     ? "Опис відсутній" //means no description available
                  //     : service.description!,
                  authprovider.getLocale.toString() == "en"
                      ? "No pets"
                      : "Без тварин",
                  style: const TextStyle(
                      color: AppTheme.white3, fontWeight: FontWeight.w400),
                )
              ],
              if (feature == "parking") ...[
                Text(
                  // (service.description == null || service.description == "")
                  //     ? "Опис відсутній" //means no description available
                  //     : service.description!,
                  authprovider.getLocale.toString() == "en"
                      ? "Parking"
                      : "Парковка",
                  style: const TextStyle(
                      color: AppTheme.white3, fontWeight: FontWeight.w400),
                )
              ],
              if (feature == "wifi") ...[
                Text(
                  // (service.description == null || service.description == "")
                  //     ? "Опис відсутній" //means no description available
                  //     : service.description!,
                  authprovider.getLocale.toString() == "en"
                      ? "Wi-Fi "
                      : "Wi-Fi ",
                  style: const TextStyle(
                      color: AppTheme.white3, fontWeight: FontWeight.w400),
                )
              ],
              if (feature == "coffee") ...[
                Text(
                  // (service.description == null || service.description == "")
                  //     ? "Опис відсутній" //means no description available
                  //     : service.description!,
                  authprovider.getLocale.toString() == "en"
                      ? "Coffee/tea"
                      : "Кава/чай",
                  style: const TextStyle(
                      color: AppTheme.white3, fontWeight: FontWeight.w400),
                )
              ],
              if (feature == "antiCovidMeasures") ...[
                Text(
                  // (service.description == null || service.description == "")
                  //     ? "Опис відсутній" //means no description available
                  //     : service.description!,
                  authprovider.getLocale.toString() == "en"
                      ? "Anti-covid measures"
                      : "Антиковідні заходи ",
                  style: const TextStyle(
                      color: AppTheme.white3, fontWeight: FontWeight.w400),
                )
              ],
              if (feature == "instrumentsSterilization") ...[
                Text(
                  // (service.description == null || service.description == "")
                  //     ? "Опис відсутній" //means no description available
                  //     : service.description!,
                  authprovider.getLocale.toString() == "en"
                      ? "Instruments sterilization"
                      : "Стерилізація інструментів",
                  style: const TextStyle(
                      color: AppTheme.white3, fontWeight: FontWeight.w400),
                )
              ],
              if (feature == "masterWithSpeechDisability") ...[
                Text(
                  // (service.description == null || service.description == "")
                  //     ? "Опис відсутній" //means no description available
                  //     : service.description!,
                  authprovider.getLocale.toString() == "en"
                      ? "Master with speech disability"
                      : "Майстер із порушенням мовлення",
                  style: const TextStyle(
                      color: AppTheme.white3, fontWeight: FontWeight.w400),
                )
              ],
              if (feature == "medicalDegree") ...[
                Text(
                  // (service.description == null || service.description == "")
                  //     ? "Опис відсутній" //means no description available
                  //     : service.description!,
                  authprovider.getLocale.toString() == "en"
                      ? "Medical degree"
                      : "Медична освіта",
                  style: const TextStyle(
                      color: AppTheme.white3, fontWeight: FontWeight.w400),
                )
              ],
              if (feature == "masterWithHearingDisability") ...[
                Text(
                  // (service.description == null || service.description == "")
                  //     ? "Опис відсутній" //means no description available
                  //     : service.description!,
                  authprovider.getLocale.toString() == "en"
                      ? "Master with hearing disability"
                      : "Майстер із порушенням слуху",
                  style: const TextStyle(
                      color: AppTheme.white3, fontWeight: FontWeight.w400),
                )
              ],

              if (feature == "petFriendly") ...[
                Text(
                  // (service.description == null || service.description == "")
                  //     ? "Опис відсутній" //means no description available
                  //     : service.description!,
                  authprovider.getLocale.toString() == "en"
                      ? "Pet friendly"
                      : "Дозволено з тваринами",
                  style: const TextStyle(
                      color: AppTheme.white3, fontWeight: FontWeight.w400),
                )
              ],
              if (feature == "ownOffice") ...[
                Text(
                  // (service.description == null || service.description == "")
                  //     ? "Опис відсутній" //means no description available
                  //     : service.description!,
                  authprovider.getLocale.toString() == "en"
                      ? "Own office"
                      : "Власний кабінет",
                  style: const TextStyle(
                      color: AppTheme.white3, fontWeight: FontWeight.w400),
                )
              ],
              if (feature == "covidVaccinated") ...[
                Text(
                  // (service.description == null || service.description == "")
                  //     ? "Опис відсутній" //means no description available
                  //     : service.description!,
                  authprovider.getLocale.toString() == "en"
                      ? "Covid-19 vaccinated"
                      : "Вакцинованість проти Covid-19",
                  style: const TextStyle(
                      color: AppTheme.white3, fontWeight: FontWeight.w400),
                )
              ],
            ],
          ),
        ));
  }
}
