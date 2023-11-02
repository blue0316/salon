import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../controller/salon/salon_profile_provider.dart';
import '../../../../models/cat_sub_service/services_model.dart';
import '../../../../utils/currency/currency.dart';

class CityMuseServiceTile extends ConsumerStatefulWidget {
  final PageController pageController;
  final List<ServiceModel> allServiceList;
  const CityMuseServiceTile(
      {super.key, required this.allServiceList, required this.pageController});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CityMuseServiceTileState();
}

class _CityMuseServiceTileState extends ConsumerState<CityMuseServiceTile> {
  // bool isNumberVisible = true;
  // void toggleVisibility() {
  //   setState(() {
  //     isNumberVisible = !isNumberVisible;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final _salonProfileProvider = ref.watch(salonProfileProvider);
    final SalonModel chosenSalon = _salonProfileProvider.chosenSalon;
    return ListView.builder(
      // shrinkWrap: true,
      //physics: const NeverScrollableScrollPhysics(),
      //   physics: NeverScrollableScrollPhysics(),
      // physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      controller: widget.pageController,
      itemCount: widget.allServiceList.length,
      //  physics: const ClampingScrollPhysics(),
      itemBuilder: (context, index) {
        serviceList.add(ServiceExpansionTile(
            serviceModel: widget.allServiceList,
            index: index,
            salonProfileProvider: _salonProfileProvider));
        return ExpandableWidget(serviceModel: widget.allServiceList[index]);
        //serviceList[index];

        //   Center(
        //   child: Text(
        //     "Content for ${tabs[index]}",
        //     style: TextStyle(fontSize: 20),
        //   ),
        // );
      },
      // onPageChanged: (index) {
      //   setState(() {
      //     _currentIndex = index;
      //   });
      // },
    );
  }
}

List<ServiceExpansionTile> serviceList = [];

class ServiceExpansionTile extends ConsumerStatefulWidget {
  final SalonProfileProvider salonProfileProvider;
  final List<ServiceModel> serviceModel;
  final int index;
  const ServiceExpansionTile(
      {super.key,
      required this.serviceModel,
      required this.index,
      required this.salonProfileProvider});

  @override
  ConsumerState<ServiceExpansionTile> createState() =>
      _ServiceExpansionTileState();
}

class _ServiceExpansionTileState extends ConsumerState<ServiceExpansionTile> {
  bool isNumberVisible = false;

  void toggleVisibility() {
    setState(() {
      isNumberVisible = !isNumberVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _salonProfileProvider = ref.watch(salonProfileProvider);

    if (_salonProfileProvider.isNumberVisible) {}
    return SizedBox(
      //height: _salonProfileProvider.isNumberVisible ? 300 : 60,
      child: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isNumberVisible = !isNumberVisible;
                  });
                  _salonProfileProvider.toggleVisibility();
                },
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 12.0, right: 12, top: 20),
                  child: Container(
                    height: 30,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          (widget.serviceModel[widget.index].translations?[AppLocalizations.of(context)?.localeName ?? 'en'] ??
                                          widget.serviceModel[widget.index]
                                              .translations?['en'] ??
                                          '')
                                      .sublist(' ')
                                      .length >
                                  3
                              ? (widget.serviceModel[widget.index].translations?[
                                          AppLocalizations.of(context)?.localeName ??
                                              'en'] ??
                                      widget.serviceModel[widget.index]
                                          .translations?['en'] ??
                                      '')
                                  .split(" ")
                                  .sublist(0, 3)
                                  .join(' ')
                              : widget.serviceModel[widget.index].translations?[
                                      AppLocalizations.of(context)?.localeName ?? 'en'] ??
                                  widget.serviceModel[widget.index].translations?['en'] ??
                                  '',
                          style: GoogleFonts.openSans(
                            color: widget.salonProfileProvider.salonTheme
                                .textTheme.displaySmall!.color,
                            fontSize: 18,
                            //   fontFamily: 'Open Sans',
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                        Container(
                          width: 24,
                          height: 24,
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(),
                          child: SvgPicture.asset(
                            "assets/test_assets/arrow_down.svg",
                            color: widget.salonProfileProvider.salonTheme
                                .textTheme.displaySmall!.color,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          (widget.serviceModel[widget.index].isPriceRange)
                              ? "${getCurrency(widget.salonProfileProvider.chosenSalon.countryCode!)}${widget.serviceModel[widget.index].priceAndDuration!.price ?? '0'}-${getCurrency(widget.salonProfileProvider.chosenSalon.countryCode!)}${widget.serviceModel[widget.index].priceAndDurationMax!.price ?? '0'}"
                              : (widget.serviceModel[widget.index]
                                      .isPriceStartAt)
                                  ? "${getCurrency(widget.salonProfileProvider.chosenSalon.countryCode!)}${widget.serviceModel[widget.index].priceAndDuration!.price ?? '0'}+"
                                  : "${getCurrency(widget.salonProfileProvider.chosenSalon.countryCode!)}${widget.serviceModel[widget.index].priceAndDuration!.price ?? '0'}",
                          textAlign: TextAlign.right,
                          style: GoogleFonts.openSans(
                            color: widget.salonProfileProvider.salonTheme
                                .textTheme.displaySmall!.color,
                            fontSize: 18,
                            // fontFamily: 'Open Sans',
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                      ],
                    ),
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Color(0xff9f9f9f)))),
                  ),
                ),
              ),
              // serviceList[index]
            ],
          ),
          if (isNumberVisible)
            Container(
              color:
                  _salonProfileProvider.salonTheme.appBarTheme.backgroundColor,
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12.0, right: 12),
                          child: SizedBox(
                            //  width: 180,
                            child: Text(
                              widget.serviceModel[widget.index].translations?[
                                      AppLocalizations.of(context)
                                              ?.localeName ??
                                          'en'] ??
                                  widget.serviceModel[widget.index]
                                      .translations?['en'] ??
                                  '',
                              style: GoogleFonts.openSans(
                                color: widget.salonProfileProvider.salonTheme
                                    .textTheme.displaySmall!.color,
                                fontSize: 18,
                                //   fontFamily: 'Open Sans',
                                fontWeight: FontWeight.w500,
                                height: 0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // const SizedBox(width: 6),
                      SvgPicture.asset("assets/test_assets/arrow_up.svg"),
                      //  Spacer(),
                      const Gap(20),
                      Text(
                        (widget.serviceModel[widget.index].isPriceRange)
                            ? "${getCurrency(widget.salonProfileProvider.chosenSalon.countryCode!)}${widget.serviceModel[widget.index].priceAndDuration!.price ?? '0'}-${getCurrency(widget.salonProfileProvider.chosenSalon.countryCode!)}${widget.serviceModel[widget.index].priceAndDurationMax!.price ?? '0'}"
                            : (widget.serviceModel[widget.index].isPriceStartAt)
                                ? "${getCurrency(widget.salonProfileProvider.chosenSalon.countryCode!)}${widget.serviceModel[widget.index].priceAndDuration!.price ?? '0'}+"
                                : "${getCurrency(widget.salonProfileProvider.chosenSalon.countryCode!)}${widget.serviceModel[widget.index].priceAndDuration!.price ?? '0'}",
                        textAlign: TextAlign.right,
                        style: GoogleFonts.openSans(
                          color: widget.salonProfileProvider.salonTheme
                              .textTheme.displaySmall!.color,
                          fontSize: 15,
                          // fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      ),
                      const Gap(10),
                    ],
                  ),
                  // const Gap(10),
                  // Image.asset("assets/hair.png"),
                  // const Gap(10),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12),
                    child: Text(
                        widget.serviceModel[widget.index].description ?? '',
                        style: GoogleFonts.openSans(
                          fontSize: 16,
                          height: 1,
                          fontWeight: FontWeight.w400,
                          //color: const Color(0xff282828)
                        )),
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class ExpandableWidget extends ConsumerStatefulWidget {
  final ServiceModel serviceModel;

  const ExpandableWidget({super.key, required this.serviceModel});

  @override
  _ExpandableWidgetState createState() => _ExpandableWidgetState();
}

class _ExpandableWidgetState extends ConsumerState<ExpandableWidget> {
  bool isExpanded = false;

  void toggleExpand() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _salonProfileProvider = ref.watch(salonProfileProvider);
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: toggleExpand,
          child: Container(
            height: 60,
            padding: const EdgeInsets.only(left: 20, right: 20),
            decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xff41403c)))),
            child: Row(
              children: <Widget>[
                Text(
                  (widget.serviceModel.translations?[
                                      AppLocalizations.of(context)
                                              ?.localeName ??
                                          'en'] ??
                                  widget.serviceModel.translations?['en'] ??
                                  '')
                              .toString()
                              .split(" ")
                              .length >
                          3
                      ? (widget.serviceModel.translations?[
                                  AppLocalizations.of(context)?.localeName ??
                                      'en'] ??
                              widget.serviceModel.translations?['en'] ??
                              '')
                          .toString()
                          .split(" ")
                          .sublist(0, 3)
                          .join(" ")
                      : (widget.serviceModel.translations?[
                                  AppLocalizations.of(context)?.localeName ??
                                      'en'] ??
                              widget.serviceModel.translations?['en'] ??
                              '')
                          .toString(),
                  style: GoogleFonts.openSans(
                    color: _salonProfileProvider
                        .salonTheme.textTheme.displaySmall!.color,
                    fontSize: 18,
                    //   fontFamily: 'Open Sans',
                    fontWeight: FontWeight.w500,
                    height: 0,
                  ),
                ),
                const SizedBox(
                    width: 20.0), // Space between the first and second widget
                SvgPicture.asset(
                  "assets/test_assets/arrow_down.svg",
                  color: _salonProfileProvider
                      .salonTheme.textTheme.displaySmall!.color,
                ),
                const Spacer(), // Spacing to push the third widget to the far right
                Text(
                  (widget.serviceModel.isPriceRange)
                      ? "${getCurrency(_salonProfileProvider.chosenSalon.countryCode!)}${widget.serviceModel.priceAndDuration!.price ?? '0'}-${getCurrency(_salonProfileProvider.chosenSalon.countryCode!)}${widget.serviceModel.priceAndDurationMax!.price ?? '0'}"
                      : (widget.serviceModel.isPriceStartAt)
                          ? "${getCurrency(_salonProfileProvider.chosenSalon.countryCode!)}${widget.serviceModel.priceAndDuration!.price ?? '0'}+"
                          : "${getCurrency(_salonProfileProvider.chosenSalon.countryCode!)}${widget.serviceModel.priceAndDuration!.price ?? '0'}",
                  textAlign: TextAlign.right,
                  style: GoogleFonts.openSans(
                    color: _salonProfileProvider
                        .salonTheme.textTheme.displaySmall!.color,
                    fontSize: 15,
                    // fontFamily: 'Open Sans',
                    fontWeight: FontWeight.w500,
                    height: 0,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isExpanded) // Conditionally show children when expanded
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              color:
                  _salonProfileProvider.salonTheme.appBarTheme.backgroundColor,
              // height: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(10),
                  if ((widget.serviceModel.translations?[
                                  AppLocalizations.of(context)?.localeName ??
                                      'en'] ??
                              widget.serviceModel.translations?['en'] ??
                              '')
                          .toString()
                          .split(" ")
                          .length >
                      3)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            widget.serviceModel.translations?[
                                    AppLocalizations.of(context)?.localeName ??
                                        'en'] ??
                                widget.serviceModel.translations?['en'] ??
                                '',
                            textAlign: TextAlign.left,
                            style: GoogleFonts.openSans(
                              color: _salonProfileProvider
                                  .salonTheme.textTheme.displaySmall!.color,
                              fontSize: 18,
                              //   fontFamily: 'Open Sans',
                              fontWeight: FontWeight.w500,
                              height: 0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: SvgPicture.asset(
                            "assets/test_assets/arrow_up.svg",
                            color: _salonProfileProvider
                                .salonTheme.textTheme.displaySmall!.color,
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Text(
                            (widget.serviceModel.isPriceRange)
                                ? "${getCurrency(_salonProfileProvider.chosenSalon.countryCode!)}${widget.serviceModel.priceAndDuration!.price ?? '0'}-${getCurrency(_salonProfileProvider.chosenSalon.countryCode!)}${widget.serviceModel.priceAndDurationMax!.price ?? '0'}"
                                : (widget.serviceModel.isPriceStartAt)
                                    ? "${getCurrency(_salonProfileProvider.chosenSalon.countryCode!)}${widget.serviceModel.priceAndDuration!.price ?? '0'}+"
                                    : "${getCurrency(_salonProfileProvider.chosenSalon.countryCode!)}${widget.serviceModel.priceAndDuration!.price ?? '0'}",
                            textAlign: TextAlign.right,
                            style: GoogleFonts.openSans(
                              color: _salonProfileProvider
                                  .salonTheme.textTheme.displaySmall!.color,
                              fontSize: 15,
                              // fontFamily: 'Open Sans',
                              fontWeight: FontWeight.w500,
                              height: 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  const Gap(20),
                  if (widget.serviceModel.servicePhoto != null &&
                      widget.serviceModel.servicePhoto!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: CachedImage(
                        url: widget.serviceModel.servicePhoto.toString(),
                        height: 282,
                        width: 339,
                      ),
                    ),
                  const Gap(20),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      widget.serviceModel.description ?? '',
                      style: GoogleFonts.openSans(
                        color: _salonProfileProvider
                            .salonTheme.textTheme.titleSmall!.color,
                        fontSize: 16,
                        //   fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w400,
                        height: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
