import 'dart:io';
import 'package:bbblient/src/controller/image/image_utils.dart';
import 'package:bbblient/src/firebase/customer.dart';
import 'package:bbblient/src/models/customer/customer.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserProfileProvider with ChangeNotifier {
  late CustomerModel bnbUser;
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  bool detailsChanged = false;
  String? sex;
  DateTime? dob;
  String? profilePic;
  File? image;

  void setCustomerModer(CustomerModel customerModel) {
    bnbUser = customerModel;
    init(customerModel);
    notifyListeners();
  }

  onSexChange(String _sex) {
    sex = _sex;
    checkForChange();
    notifyListeners();
  }

  onDOBChange(DateTime _dob) {
    dob = _dob;
    checkForChange();
    notifyListeners();
  }

  onImagePick(File image) {
    this.image = image;
    checkForChange();
    notifyListeners();
  }

  init(CustomerModel _customer) {
    final PersonalInfo info = _customer.personalInfo;
    firstNameController.text = info.firstName ?? '';
    lastNameController.text = info.lastName ?? '';
    profilePic = _customer.profilePic;
    dob = info.dob ?? DateTime.now().subtract(const Duration(days: 365 * 26));
    sex = info.sex ?? '';
    notifyListeners();
  }

  Future onBack(context) async {
    await saveInfo(context: context);
  }

  Future saveInfo({required BuildContext context}) async {
    showToast(AppLocalizations.of(context)?.saveChanges ?? 'saving changes');
    bnbUser.personalInfo.firstName = firstNameController.text;
    bnbUser.personalInfo.lastName = lastNameController.text;
    bnbUser.personalInfo.sex = sex;
    bnbUser.personalInfo.dob = dob;
    if (profilePic != null && image != null) {
      String? _profilePic = await ImageUtilities().uploadImage('customerProfilePics', image!, context);
      if (_profilePic != null) {
        bnbUser.profilePic = _profilePic;
        bnbUser.profilePicUploaded = true;
        image = null;
        notifyListeners();
      }
    }
    await CustomerApi().updateCustomer(customerModel: bnbUser);
    var _customerModel = await CustomerApi().getCustomer();
    if (_customerModel != null) {
      init(_customerModel);
    }
    detailsChanged = false;
  }

  checkForChange() {
    printIt(firstNameController.text != bnbUser.personalInfo.firstName);
    printIt(lastNameController.text != bnbUser.personalInfo.lastName);
    printIt(dob != bnbUser.personalInfo.dob);
    printIt(sex != bnbUser.personalInfo.sex);
    printIt(image != null);
    if ((firstNameController.text != bnbUser.personalInfo.firstName) ||
        (lastNameController.text != bnbUser.personalInfo.lastName) ||
        (sex != bnbUser.personalInfo.sex) ||
        (dob != bnbUser.personalInfo.dob) ||
        image != null) {
      printIt('details changed = $detailsChanged');
      detailsChanged = true;
      notifyListeners();
    } else {
      printIt('details changed = $detailsChanged');
      detailsChanged = false;
      notifyListeners();
    }
  }
}
