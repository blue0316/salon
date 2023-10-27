// ignore_for_file: file_names
import 'dart:html' as html;
import 'dart:async';
import 'package:bbblient/main.dart';
import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/app_provider.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/firebase/category_services.dart';
import 'package:bbblient/src/models/cat_sub_service/category_service.dart';
import 'package:bbblient/src/models/cat_sub_service/services_model.dart';
import 'package:bbblient/src/models/enums/status.dart';
import 'package:bbblient/src/routes.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SalonPage extends ConsumerStatefulWidget {
  static const route = 'salon';
  final String salonId;

  final bool switchSalon;
  final String locale;
  final List<ServiceModel> chosenServices;
  final bool showBackButton;
  final bool showBooking;

  const SalonPage({
    Key? key,
    required this.salonId,
    this.locale = "uk",
    this.showBackButton = true,
    this.showBooking = false,
    this.switchSalon = true,
    this.chosenServices = const [],
  }) : super(key: key);
  @override
  _SaloonProfileState createState() => _SaloonProfileState();
}

class _SaloonProfileState extends ConsumerState<SalonPage> {
  final _mainScrollController = ScrollController();
  final ScrollController _scrollController = ScrollController();
  final PageController _pageController = PageController();
  late SalonProfileProvider _salonProfileProvider;
  int _activeTab = 0;
  bool choosen = false;
  List<CategoryModel>? categories;
  List<ServiceModel>? services;

  @override
  void initState() {
    // final _bnbProvider = ref.read(bnbProvider);
    // print(widget.locale);
    // _bnbProvider.changeLocale(locale: const Locale('uk'));
    final AppProvider _appProvider = ref.read(appProvider);
    super.initState();
    // debugPrint('==========');

    _appProvider.selectSalonFirstRoute();

    printIt(_appProvider.firstRoute);
    final _salonSearchProvider = ref.read(salonSearchProvider);

    _salonSearchProvider.init(widget.salonId).then(
          (value) => WidgetsBinding.instance.addPostFrameCallback(
            (_) async {
              categories = value;
            },
          ),
        );
    _salonProfileProvider = ref.read(salonProfileProvider);
    _salonProfileProvider.init(context, widget.salonId).then(
          (salon) => WidgetsBinding.instance.addPostFrameCallback(
            (_) async {
              // here we set the time interval instead of the 15mins preset available
              await init(salon);
            },
          ),
        );
  }

  init(salon) async {
    // Time().timeSlotSize = Duration(minutes: salon!.timeSlotsInterval!);
    // Time().timeSlotSizeInt = salon!.timeSlotsInterval!;
    // await Time().setTimeSlot(salon!.timeSlotsInterval);
    categories = await CategoryServicesApi().getCategories();
    // await CategoryServicesApi().getSalonServices(salonId: widget.salonId);
    final _createAppointmentProvider = ref.read(createAppointmentProvider);
    final repository = ref.watch(bnbProvider);
    final _salonSearchProvider = ref.read(salonSearchProvider);
    final _salonProfileProvider = ref.read(salonProfileProvider);

    _createAppointmentProvider.cle();

    // Change Language based on salon
    // String salonLocale = _salonProfileProvider.chosenSalon.locale;
    // repository.changeLocale(locale: Locale(salonLocale));

    // ---------- GET BROWSER LANGUAGE ----------
    String browserLanguage = html.window.navigator.language;

    if (browserLanguage.isNotEmpty && browserLanguage.length >= 2) {
      String browserLocale = browserLanguage.substring(0, 2);

      if (availableLocales.contains(browserLocale)) {
        repository.changeLocale(locale: Locale(browserLocale));
      } else {
        repository.changeLocale(locale: const Locale('en'));
      }
    } else {
      repository.changeLocale(locale: const Locale('en'));
    }

    if (widget.switchSalon) {
      _createAppointmentProvider.setSalon(
        salonModel: salon,
        context: context,
        servicesFromSearch: widget.chosenServices,
        categories: _salonSearchProvider.categories,
      );

      // get all categories in create appointment provider class
      // _createAppointmentProvider.setAllCategories(_salonSearchProvider.categories);

      await _salonProfileProvider.getSalonReviews(salonId: widget.salonId);
      await _salonProfileProvider.getProductsData(context, salonId: widget.salonId);

      Future.delayed(const Duration(milliseconds: 1000), () async {
        if (mounted) {
          if (_createAppointmentProvider.chosenServices.isNotEmpty) {
            setState(() {});
            await Future.delayed(const Duration(milliseconds: 300), () {
              _mainScrollController.animateTo(300, duration: const Duration(milliseconds: 800), curve: Curves.ease);
            });
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _mainScrollController.dispose();
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _salonProfileProvider = ref.watch(salonProfileProvider);

    return _salonProfileProvider.loadingStatus == Status.loading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : _salonProfileProvider.loadingStatus == Status.failed
            ? const ErrorScreen()
            : _salonProfileProvider.getTheme(widget.showBooking);
  }
}
