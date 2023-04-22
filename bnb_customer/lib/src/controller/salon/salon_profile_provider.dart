import 'package:bbblient/src/firebase/customer_web_settings.dart';
import 'package:bbblient/src/firebase/enquiry.dart';
import 'package:bbblient/src/firebase/master.dart';
import 'package:bbblient/src/firebase/products.dart';
import 'package:bbblient/src/firebase/salons.dart';
import 'package:bbblient/src/models/cat_sub_service/services_model.dart';
import 'package:bbblient/src/models/customer_web_settings.dart';
import 'package:bbblient/src/models/enquiry.dart';
import 'package:bbblient/src/models/enums/appointment_status.dart';
import 'package:bbblient/src/models/enums/status.dart';
import 'package:bbblient/src/models/products.dart';
import 'package:bbblient/src/models/review.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/salon/default_profile_view/salon_profile.dart';
import 'package:bbblient/src/views/themes/glam_one/glam_one.dart';
import 'package:bbblient/src/views/themes/utils/theme_color.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:collection/collection.dart';

// todo make salons and masters profile responsiblity here from salonSearchProvider
class SalonProfileProvider with ChangeNotifier {
  final SalonApi _salonApi = SalonApi();
  Status loadingStatus = Status.loading;

  late SalonModel chosenSalon;

  List<ReviewModel> salonReviews = [];
  List<ReviewModel> masterReviews = [];

  Map<String?, List<ServiceModel>> categoryServicesMap = {};

  // Products
  List<ProductCategoryModel> allProductCategories = [];
  List<ProductModel> allProducts = [];
  List<ProductBrandModel> allProductBrands = [];
  Map<String, List<ProductModel>> tabs = {}; // Populating products tab

  // List<ServiceModel> salonServices = [];

  CustomerWebSettings? themeSettings;
  ThemeData salonTheme = AppTheme.customLightTheme;
  // String? theme;

  ThemeType themeType = ThemeType.DefaultLight;

  Status enquiryStatus = Status.init;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController requestController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
// lf31oWACmY7UTCbnPNQ3
  Future<SalonModel?> init(context, salonId) async {
    try {
      loadingStatus = Status.loading;
      chosenSalon = (await _salonApi.getSalonFromId(salonId))!;
      // await Time().setTimeSlot(chosenSalon.timeSlotsInterval);
      themeSettings = await CustomerWebSettingsApi().getSalonTheme(salonId: salonId);
      themeType = getThemeTypeEnum(themeSettings?.theme?.testId);

      await getSalonReviews(salonId: salonId);
      await getProductsData(context, salonId: salonId);
      // await getSalonServices(salonId: salonId);
      loadingStatus = Status.success;
    } catch (e) {
      debugPrint(e.toString());
      loadingStatus = Status.failed;
    }
    notifyListeners();
    return chosenSalon;
  }

  Set availableThemes = {
    '0', // DefaultLight
    '1', // DefaultDark
    '2', // Glam
    '3', // Glam Barbershop
    '4', // Glam Gradient
    '5', // Barbershop
    '6', // Glam Light
    '7', // Glam Minimal Light
    '8', // Glam Minimal Dark
  };

  Widget getTheme() {
    if (availableThemes.contains(themeSettings?.theme?.testId)) {
      // If theme number is not in this set, it means that's a default theme
      switch (themeSettings?.theme?.testId) {
        case '0':
          salonTheme = getDefaultLightTheme(themeSettings?.theme?.colorCode);
          themeType = ThemeType.DefaultLight;
          notifyListeners();
          return const DefaultLandingTheme();

        case '1':
          salonTheme = getDefaultDarkTheme(themeSettings?.theme?.colorCode);
          themeType = ThemeType.DefaultDark;
          notifyListeners();
          return const DefaultLandingTheme();

        case '2':
          salonTheme = getGlamDataTheme(themeSettings?.theme?.colorCode);
          themeType = ThemeType.Glam;
          notifyListeners();
          break;

        case '3':
          salonTheme = getGlamBarbershopTheme(themeSettings?.theme?.colorCode);
          themeType = ThemeType.GlamBarbershop;

          notifyListeners();
          break;

        case '4':
          salonTheme = getGlamGradientTheme(themeSettings?.theme?.colorCode);
          themeType = ThemeType.GlamGradient;

          notifyListeners();
          break;

        case '5':
          salonTheme = getBarbershopTheme(themeSettings?.theme?.colorCode);
          themeType = ThemeType.Barbershop;

          notifyListeners();
          break;

        case '6':
          salonTheme = getGlamLightTheme(themeSettings?.theme?.colorCode);
          themeType = ThemeType.GlamLight;

          notifyListeners();
          break;

        case '7':
          salonTheme = getGlamMinimalLightTheme(themeSettings?.theme?.colorCode);
          themeType = ThemeType.GlamMinimalLight;

          notifyListeners();
          break;

        case '8':
          salonTheme = getGlamMinimalDarkTheme(themeSettings?.theme?.colorCode);
          themeType = ThemeType.GlamMinimalDark;

          notifyListeners();
          break;
      }

      return const GlamOneScreen(); // New Themes Base Widget
    } else {
      print('*****---*****');
      print('*****---*****');
      print('*****---*****');
      print('*****---*****');
      print('*****---*****');
      print('*****---*****');
      print('*****---*****');
      print('*****---*****');
      themeType = ThemeType.DefaultLight;
      notifyListeners();

      return const DefaultLandingTheme(); // Default landing theme
    }
  }

  getSalonReviews({required String salonId}) async {
    salonReviews.clear();
    salonReviews = await SalonApi().getSalonReviews(salonId: salonId);
  }

  // getSalonServices({required String salonId}) async {
  //   print('get services here');
  //   salonServices.clear();
  //   salonServices = await SalonApi().getSalonServices(salonId: salonId);
  //   print('*****');
  //   print(salonServices);
  //   print('*****');
  // }

  getMasterReviews({required String masterId}) async {
    masterReviews.clear();
    masterReviews = await MastersApi().getMasterReviews(masterId: masterId);
    printIt('got ${masterReviews.length} master reviews');
    notifyListeners();
  }

  // Send Enquiry to Firebase
  void sendEnquiryToSalon(BuildContext context, {required String salonId}) async {
    if (nameController.text == '' || phoneController.text == '' || requestController.text == '') {
      showToast(AppLocalizations.of(context)?.emptyFields ?? "Fields cannot be empty, please fill required fields");
      return;
    }

    enquiryStatus = Status.loading;
    Future.delayed(const Duration(milliseconds: 100), () => notifyListeners());

    try {
      EnquiryModel _newEnquiry = EnquiryModel(
        customerName: nameController.text,
        customerPhone: phoneController.text,
        customerRequest: requestController.text,
        salonId: salonId,
        createdAt: DateTime.now(),
        status: AppointmentStatus.requested,
      );
      Status res = await EnquiryApi().createEnquiry(_newEnquiry);

      if (res == Status.success) {
        enquiryStatus = Status.success;
        showToast('Your Enquiry has been sent');
      } else {
        enquiryStatus = Status.failed;
        showToast(AppLocalizations.of(context)?.errorOccurred ?? "Something went wrong, please try again");
      }
      Future.delayed(const Duration(milliseconds: 100), () => notifyListeners());
    } catch (e) {
      enquiryStatus = Status.failed;
      Future.delayed(const Duration(milliseconds: 100), () => notifyListeners());

      printIt('Error on sendEnquiryToSalon() - ${e.toString()}');
      showToast(AppLocalizations.of(context)?.errorOccurred ?? "Something went wrong, please try again");
      return null;
    }
  }

  getProductsData(context, {required String salonId}) async {
    allProductCategories.clear();
    allProducts.clear();
    tabs.clear();

    // Get all brands
    allProductBrands = await ProductsApi().getAllProductBrands(salonId: salonId);

    // Get Salon Product Categories
    allProductCategories = await ProductsApi().getAllProductCategory(salonId: salonId);

    // Get Salon Products
    allProducts = await ProductsApi().getSalonProducts(salonId: salonId);

    // Split into categories
    for (ProductModel product in allProducts) {
      for (String? productCategoryId in (product.categoryIdList ?? [])) {
        ProductCategoryModel? found = allProductCategories.firstWhereOrNull(
          (cat) => cat.categoryId == productCategoryId,
        );

        if (found != null) {
          String? translation = found.translations![AppLocalizations.of(context)?.localeName];

          if (translation != null) {
            // Doing this because if loaleName (e.g 'en') doesn't exist in translations map, it throws null
            if (tabs.containsKey(translation)) {
              tabs[translation] = [...tabs[translation]!, product];
            } else {
              tabs[translation] = [product];
            }
          }
        }
      }
    }

    notifyListeners();
  }

  // Future _initSalon({required SalonModel salonModel}) async {
  //   salonMasters.clear();
  //   categoryServicesMap.clear();
  //   salonServices.clear();
  //   salonReviews.clear();

  //   loadingStatus = Status.loading;
  //   notifyListeners();
  //   List<MasterModel> _masters = await MastersApi().getAllMaster(salonModel.salonId);
  //   List<ServiceModel> _servicesList = await CategoryServicesApi().getSalonServices(salonId: salonModel.salonId);
  //   printIt(_servicesList.length);
  //   List<ServiceModel> _servicesValidList = [];
  //   List<String> _mastersServices = [];

  //   if (_servicesList.isNotEmpty && _masters.isNotEmpty) {
  //     for (MasterModel master in _masters) {
  //       _mastersServices.addAll(master.serviceIds ?? []);
  //     }
  //     printIt(_mastersServices);
  //     printIt(salonModel.ownerType);

  //     if (salonModel.ownerType == OwnerType.singleMaster) {
  //       salonServices = _servicesList;
  //       _servicesValidList = _servicesList;
  //     } else {
  //       for (ServiceModel _service in _servicesList) {
  //         if (_mastersServices.contains(_service.serviceId)) {
  //           printIt('service valid');
  //           printIt(_service.serviceId);
  //           _servicesValidList.add(_service);
  //         } else {
  //           printIt(" removed ${_service.serviceId}");
  //         }
  //       }
  //     }
  //     printIt(_servicesList.length);
  //     printIt(_servicesValidList.length);
  //     printIt(salonServices.length);
  //     salonMasters = _masters;
  //     loadingStatus = Status.success;
  //     notifyListeners();
  //   } else {
  //     loadingStatus = Status.failed;
  //     notifyListeners();
  //   }

  //   for (ServiceModel _service in _servicesValidList) {
  //     if (categoryServicesMap[_service.categoryId] == null) {
  //       categoryServicesMap[_service.categoryId] = [];
  //     }
  //     categoryServicesMap[_service.categoryId]!.add(_service);
  //     if (categoryServicesMap != {}) {
  //       loadingStatus = Status.success;
  //       notifyListeners();
  //     } else {
  //       loadingStatus = Status.failed;
  //       notifyListeners();
  //     }
  //   }
  // }
}
