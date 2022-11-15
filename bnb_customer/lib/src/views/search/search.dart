import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/search/search_provider.dart';
import 'package:bbblient/src/models/cat_sub_service/services_model.dart';
import 'package:bbblient/src/models/enums/status.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/utils/translation.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/salon/salon_home/salon_profile.dart';
import 'package:bbblient/src/views/search/salon_card.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Search extends ConsumerStatefulWidget {
  final String locale;
  const Search({Key? key, this.locale = "uk"}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends ConsumerState<Search> {
  final TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final SearchProvider searchController = ref.read(searchProvider);
    searchController.init(widget.locale);
  }

  @override
  void dispose() {
    super.dispose();
    //final SearchProvider searchController = ref.read(searchProvider);
    //searchController.disposeFields();
  }

  @override
  Widget build(BuildContext context) {
    final SearchProvider searchController = ref.watch(searchProvider);

    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 75),
            height: 45,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                Expanded(
                  child: TextFormField(
                    autofocus: true,
                    focusNode: searchController.focusNode,
                    controller: textController,
                    cursorHeight: 20,
                    keyboardType: TextInputType.text,
                    onChanged: searchController.onSearchChange,
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SvgPicture.asset(
                            AppIcons.lensGreySVG,
                          ),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              textController.clear();
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: SvgPicture.asset(AppIcons.closeRoundSVG),
                          ),
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        hintText: AppLocalizations.of(context)?.searchServices ?? "Search services, salons, masters..."),
                  ),
                ),
                SizedBox(
                  width: 16.w,
                )
              ],
            ),
          ),
          if (searchController.showServices)
            Expanded(
              child: Loader(
                status: searchController.serviceStatus,
                iconPadding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 3),
                child: (searchController.parentServices.isNotEmpty)
                    ? Container(
                        color: Colors.white,
                        margin: const EdgeInsets.only(top: 32),
                        child: ListView.builder(
                            itemCount: searchController.parentServices.length,
                            padding: const EdgeInsets.only(top: 12),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final ParentServiceModel _service = searchController.parentServices[index];
                              final String serviceName =
                                  Translation.translate(map: _service.translations, langCode: searchController.langCode) ?? "";

                              return InkWell(
                                onTap: () {
                                  searchController.onSelectService(_service, textController);
                                },
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          AppIcons.lensSVG,
                                          color: AppTheme.creamBrown,
                                          height: 14,
                                        ),
                                        const SpaceHorizontal(
                                          width: 10,
                                        ),
                                        Text(serviceName, style: Theme.of(context).textTheme.bodyText1),
                                      ],
                                    )),
                              );
                            }),
                      )
                    : Container(
                        alignment: Alignment.topCenter,
                        padding: const EdgeInsets.only(top: 32),
                        child: SvgPicture.asset(AppIcons.noSearchResultUk)),
              ),
            )
          else
            Expanded(
              child: Loader(
                status: searchController.salonStatus,
                iconPadding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 3),
                child: Container(
                    margin: const EdgeInsets.only(left: 8, right: 8, top: 32),
                    child: (searchController.salonServicesMap.keys.isNotEmpty)
                        ? ListView.builder(
                            itemCount: searchController.salonServicesMap.keys.length,
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(top: 12),
                            itemBuilder: (context, index) {
                              final SalonModel salon = searchController.salonServicesMap.keys.toList()[index];
                              final List<ServiceModel> services = searchController.salonServicesMap[salon] ?? [];
                              return SalonSearchCard(
                                salonModel: salon,
                                services: services,
                                onServiceTap: (service, salon) {
                                  //todo open salon from here
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SalonPage(
                                        
                                        salonId: salon.salonId,
                                        switchSalon: true,
                                        chosenServices: [service],
                                      ),
                                    ),
                                  );
                                },
                              );
                            })
                        : Container(
                            alignment: Alignment.topCenter,
                            padding: const EdgeInsets.only(top: 32),
                            child: SvgPicture.asset(AppIcons.noSearchResultUk))),
              ),
            ),
        ],
      ),
    );
  }
}
