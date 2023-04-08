import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/enums/status.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/home/search/widgets/salon_card.dart';
import 'package:bbblient/src/views/salon/salon_home/salon_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:bbblient/src/views/salon/salon_home/salon_profile_copy.dart';

class SearchAll extends ConsumerStatefulWidget {
  const SearchAll({Key? key}) : super(key: key);

  @override
  _SearchAllState createState() => _SearchAllState();
}

class _SearchAllState extends ConsumerState<SearchAll> {
  final TextEditingController _serchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final salonSearchController = ref.watch(salonSearchProvider);
    late Status status = Status.init;

    Future<bool> _willPopCallback() async {
      salonSearchController.salonsSearched.clear();
      salonSearchController.servicesSearched.clear();
      return true;
    }

    return WillPopScope(
      onWillPop: () async {
        return _willPopCallback();
      },
      child: Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 90.h,
                width: 1.sw,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        _willPopCallback();
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 45,
                        child: TextFormField(
                          focusNode: _focusNode,
                          controller: _serchController,
                          cursorHeight: 20,
                          keyboardType: TextInputType.text,
                          onChanged: (val) async {
                            if (val.length > 3) {
                              setState(() {
                                status = Status.loading;
                              });
                              if (mounted) {
                                await salonSearchController.loadSalonsResult(text: val);
                                await salonSearchController.loadServices(text: val);
                                await salonSearchController.loadMasters(text: val);
                                setState(() {
                                  status = Status.success;
                                });
                              }
                            }
                          },
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
                                    _serchController.clear();
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
                    ),
                    SizedBox(
                      width: 16.w,
                    )
                  ],
                ),
              ),
              if (status == Status.loading) ...[
                const CircularProgressIndicator(),
              ],
              if (salonSearchController.salonsForServicesSearched.isNotEmpty && salonSearchController.servicesSearched.isNotEmpty) ...[
                ListView.builder(
                    itemCount: salonSearchController.servicesSearched.length,
                    shrinkWrap: true,
                    primary: false,
                    itemBuilder: (context, index) {
                      SalonModel? salon;
                      int salonIndex = salonSearchController.salonsForServicesSearched.indexWhere((element) => element.salonId == salonSearchController.servicesSearched[index].salonId);
                      if (salonIndex != -1) {
                        salon = salonSearchController.salonsForServicesSearched[salonIndex];
                      }
                      printIt(salon?.salonId);
                      printIt(salonSearchController.servicesSearched[index].salonId);
                      return (salon != null)
                          ? GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SalonPage(
                                        salonId: salon?.salonId ?? "",
                                        switchSalon: true,
                                      ),
                                    ));
                              },
                              child: SalonSearchCard(salonModel: salon, serviceModel: salonSearchController.servicesSearched[index]))
                          : const SizedBox();
                    }),
              ],
              if (salonSearchController.salonsSearched.isNotEmpty) ...[
                ListView.builder(
                    itemCount: salonSearchController.salonsSearched.length,
                    shrinkWrap: true,
                    primary: false,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SalonPage(
                                    salonId: salonSearchController.salonsSearched[index].salonId,
                                    switchSalon: true,
                                  ),
                                ));
                          },
                          child: SalonOnlySearchCard(salonModel: salonSearchController.salonsSearched[index]));
                    }),
              ],
            ],
          ),
        )),
      ),
    );
  }
}
