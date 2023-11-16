// ignore_for_file: unnecessary_null_comparison

import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/authentication/auth_provider.dart';
import 'package:bbblient/src/firebase/customer.dart';
import 'package:bbblient/src/models/customer/customer.dart';
import 'package:bbblient/src/models/enums/gender.dart';
import 'package:bbblient/src/models/enums/status.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QuizProvider with ChangeNotifier {
  final PageController pageController = PageController();

  int currentPage = 0;
  // String? customerId;
  bool locationPermitted = false;
  bool notifPermitted = false;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  String usersSex = Sex.female;
  DateTime? dob;
  List<String> selectedCategories = [];
  String locale = "uk";
  Status saveInfoStatus = Status.init;
  Status locationPermissionStatus = Status.init;
  Status notificationPermissionStatus = Status.init;
  // List<CategoryModel> allCategories = [];

  String preferredGender = PreferredGender.women;

  changePage({required int i, required BuildContext context, required bool animatePage}) {
    if (currentPage != 1) {
      FocusScope.of(context).unfocus();
    }
    currentPage = i;
    if (animatePage) {
      pageController.jumpToPage(
        i,
      );
    }
    notifyListeners();
  }

  onNext({required BuildContext context}) {
    if (currentPage != 1) {
      FocusScope.of(context).unfocus();
    }

    pageController.jumpToPage(
      ++currentPage,
    );
  }

  onBack({required BuildContext context}) {
    if (currentPage != 0) {
      pageController.jumpToPage(
        --currentPage,
      );
    } else {
      Navigator.pop(context);
    }
  }

  setGender(String gender) {
    preferredGender = gender;
    Utils().vibratePositively();
    notifyListeners();
  }

  // setLocale(String locale) {
  //   this.locale = locale;
  //   Utils().vibratePositively();
  //   notifyListeners();
  // }

  setUsersGender(String gender) {
    usersSex = gender;
    notifyListeners();
  }

  setDob(DateTime dob) {
    this.dob = dob;
    notifyListeners();
  }

  // makeItems({required List<CategoryModel> categories}) {
  //   allCategories = categories;
  //   notifyListeners();
  // }

  onTapCategory({required String catId}) {
    if (selectedCategories.contains(catId)) {
      selectedCategories.removeAt(selectedCategories.indexWhere((element) => element == catId));
      Utils().vibrateNegatively();
      notifyListeners();
    } else {
      selectedCategories.add(catId);
      Utils().vibratePositively();
      notifyListeners();
    }
  }

  saveUserDetails({required BuildContext context, required WidgetRef ref}) async {
    try {
      saveInfoStatus = Status.loading;
      notifyListeners();
      showToast(AppLocalizations.of(context)?.saving ?? 'saving');
      //saving async not waiting fot it
      final AuthProviderController _auth = ref.read(authProvider);
      if (_auth.currentCustomer != null) _saveInfo(_auth.currentCustomer!);
      saveInfoStatus = Status.success;
      showToast(AppLocalizations.of(context)?.done ?? 'Done');
      Navigator.of(context).pop();
    } catch (e) {
      saveInfoStatus = Status.failed;
      notifyListeners();
    }
  }

  Future _saveInfo(CustomerModel customer) async {
    String _phoneNumber = FirebaseAuth.instance.currentUser?.phoneNumber ?? '';
    // String? _fcmToken = await FCMTokenHandler.getFCMToken();
    // final geo = Geoflutterfire();
    // GeoFirePoint? myLocation;

    //  LatLng? _currentLocation = await LocationUtils.getLocation();
    // if (_currentLocation != null) {
    // myLocation = geo.point(
    //     latitude: 0.0,
    //     //_currentLocation.latitude,
    //     longitude: 0.0
    //     // _currentLocation.longitude
    //     );
    //  }
    // debugPrint('3');
    customer.personalInfo = PersonalInfo(
      phone: _phoneNumber,
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      description: bioController.text,
      email: emailController.text,

      //sex: usersSex,
      dob: dob,
    );
    customer.locale = locale;

    // customer.preferredGender = preferredGender;
    customer.preferredCategories = selectedCategories;
    // customer.locations = [
    //   myLocation != null
    //       ? Position(
    //           geoHash: myLocation.hash,
    //           geoPoint: myLocation.geoPoint,
    //         )
    //       : Position().getDefaultPosition()
    // ];
    customer.fcmToken = "";
    // customer.fcmToken = _fcmToken ?? "";
    customer.quizCompleted = true;

    await CustomerApi().updateCustomer(customerModel: customer);
    printIt("==============CUSTOMER INFO UPDATED=============");
  }
}
