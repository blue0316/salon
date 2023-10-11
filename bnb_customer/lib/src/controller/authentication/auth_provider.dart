// ignore_for_file: unnecessary_null_comparison

import 'dart:async';
import 'dart:convert';

import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/bnb/bnb_provider.dart';
import 'package:bbblient/src/firebase/admin.dart';
// import 'package:bbblient/src/firebase/bonus_referral_api.dart';
import 'package:bbblient/src/firebase/customer.dart';
import 'package:bbblient/src/models/customer/customer.dart';
// import 'package:bbblient/src/models/customer/customer_auth_error.dart';
import 'package:bbblient/src/models/enums/status.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
// import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/analytics.dart';
import 'package:bbblient/src/utils/error_codes.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/utils/notification/fcm_token.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/registration/quiz/register_quiz.dart';
import 'package:bbblient/src/views/widgets/dialogues/default.dart';
import 'package:bbblient/src/views/widgets/dialogues/dialogue_function.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:top_snackbar_flutter/custom_snack_bar.dart';
// import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:translator/translator.dart';

import '../create_apntmnt_provider/create_appointment_provider.dart';

class AuthProvider with ChangeNotifier {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  //       final TextEditingController firstnamecontroller = TextEditingController();
  // final TextEditingController lastnamecontroller = TextEditingController();
  String? verificationCode;
  bool userLoggedIn = false;
  User? user;
  late SharedPreferences sharedPreferences;
  late Timer _timer;
  String countryCode = '';
  String phoneNumber = '';
  String otp = '';
  String firstName = '';
  String lastName = '';
  String name = '';
  bool isNewUser = false;
  bool fromBooking = false;
  String? errorMessage;
  bool otpSent = false;
  bool nameSent = false;
  bool initialUserCreated = false;
  bool profileCompleted = true;
  bool profilePicUploaded = true;
  bool quizCompleted = true;
  Status otpStatus = Status.init;
  Status loginStatus = Status.init;
  Status saveNameStatus = Status.init;
  Status updateCustomerPersonalInfoStatus = Status.init;
  CustomerModel? currentCustomer;
  CustomerModel? currentCustomerWithoutOTP;
  int start = 60;
  late CreateAppointmentProvider createAppointment;
  TextEditingController phoneNoController = TextEditingController();

  Future signOut() async {
    initialUserCreated = false;
    user = null;
    currentCustomer = null;
    otpSent = false;
    phoneNumber = '';
    otp = '';
    disposeFields();
    userLoggedIn = false;
    await _auth.signOut();
    notifyListeners();
  }

  changeFromBooking() {
    fromBooking = true;
    notifyListeners();
  }

  changeFromBooking2() {
    fromBooking = false;
    notifyListeners();
  }

  createAppointmentProvider(CreateAppointmentProvider newcreateAppointment) {
    createAppointment = newcreateAppointment;

    notifyListeners();
  }

  disposeFields() {
    countryCode = '';
    phoneNumber = '';
    otp = '';
    otpSent = false;
    loginStatus = Status.init;
    otpStatus = Status.init;

    start = 60;
  }

  void setOtpSent(bool sent) {
    // phoneNumber = '';
    phoneNoController.clear();
    otpSent = sent;
    // _timer.cancel();
    notifyListeners();
  }

  void showNameSent(bool sent) {
    nameSent = sent;
    saveNameStatus = Status.success;
    notifyListeners();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (start == 0) {
          notifyListeners();
          timer.cancel();
        } else {
          start--;
          notifyListeners();
        }
      },
    );
  }

  void changeOTP(String val) {
    otp = val;
    notifyListeners();
  }

  handleError(error, context) {
    try {
      printIt('error: ' + error.toString());
      errorMessage = error.toString();
      notifyListeners();

      switch (error.code) {
        case 'ERROR_INVALID_VERIFICATION_CODE':
          showToast(AppLocalizations.of(context)?.invalid_phone_number ?? 'Invalid phone no !');
          printIt("The verification code is invalid");
          break;
        default:
          errorMessage = error.message;
          break;
      }
      notifyListeners();
    } catch (e) {
      printIt(e);
    }
  }

  void smsOTPSent(String verId, [int? forceCodeResend]) {
    verificationCode = verId;
    printIt(verificationCode);
    _showOTPScreen();
  }

  _showOTPScreen() {
    otpStatus = Status.success;
    otpSent = true;
    start = 60;
    phoneNoController.clear();
    // _timer.cancel();
    // startTimer();
    notifyListeners();
  }

  ConfirmationResult? webOTPConfirmationResult;
  ConfirmationResult? phoneVerificationResult;

  Future<void> verifyPhoneNumber({required BuildContext context, required String phone, required String code}) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    printIt("verifying phone number");
    printIt(phoneNumber);
    printIt(countryCode);
    String _phone = "$code$phone";
    printIt("Sending phone number");
    printIt(_phone);

    if (phone.length < 8 || phone.length > 10) {
      showToast(AppLocalizations.of(context)?.invalid_phone_number ?? 'Invalid phone No');
      otpStatus = Status.failed;
      notifyListeners();

      return;
    } else {
      otpStatus = Status.loading;
      notifyListeners();
      try {
        if (kIsWeb) {
          // print('******@@@@@@*******');
          // print(_phone);
          // print('******@@@@@@*******');

          webOTPConfirmationResult = await _auth.signInWithPhoneNumber(_phone.trim());

          // print('******@@@@@@*******');
          // print('web result - $webOTPConfirmationResult ');
          // print('******@@@@@@*******');

          final customerExists = await CustomerApi().checkIfCustomerExists(_phone.trim());
          if (!customerExists) {
            isNewUser = true;
            notifyListeners();
          }
          notifyListeners();

          _showOTPScreen();
        } else {
          printIt('kIsWeb is NOT TRUE!!!!');
          await _auth.verifyPhoneNumber(
            phoneNumber: _phone.trim(),
            codeAutoRetrievalTimeout: (String verId) {
              verificationCode = verId;
            },
            codeSent: smsOTPSent,
            timeout: const Duration(seconds: 60),
            verificationCompleted: (AuthCredential phoneAuthCredential) async {
              UserCredential result = await _auth.signInWithCredential(phoneAuthCredential);

              otpStatus = Status.success;

              notifyListeners();
            },
            verificationFailed: (FirebaseAuthException exception) {
              if (exception.code == 'invalid-phone-number') {
                errorMessage = exception.code;
                showToast(AppLocalizations.of(context)?.somethingWentWrong ?? 'Something went wrong');

                otpStatus == Status.failed;
                notifyListeners();
              } else {
                errorMessage = exception.code;
                showToast(ErrorCodes.getFirebaseErrorMessage(exception));
              }
              AdminApi().addAuthError(exception.toString(), _phone);
              otpStatus = Status.failed;
              notifyListeners();
            },
          );
          final customerExists = await CustomerApi().checkIfCustomerExists(_phone.trim());
          if (!customerExists) {
            isNewUser = true;
            notifyListeners();
          }
        }
      } on FirebaseAuthException catch (e) {
        otpStatus = Status.failed;
        notifyListeners();
        printIt("$e");
        showToast(ErrorCodes.getFirebaseErrorMessage(e));
        AdminApi().addAuthError(e.toString(), _phone);
      } catch (e) {
        otpStatus = Status.failed;

        errorMessage = e.toString();
        handleError(e, context);
        notifyListeners();
        AdminApi().addAuthError(e.toString(), _phone);
      }
    }
  }

  Future<void> verifyPhone({
    required BuildContext context,
    required String phoneNumber,
    required String countryCode,
  }) async {
    String _phone = "$countryCode$phoneNumber";
    // print(_phone);
    // // debugPrint('#####################################');

    // // debugPrint(countryCode);
    // // debugPrint(phoneNumber);
    // // debugPrint(_phone);
    // // debugPrint('#####################################');

    if (phoneNumber.length < 8 || phoneNumber.length > 10) {
      showToast(AppLocalizations.of(context)?.invalid_phone_number ?? 'Invalid phone No');
      return;
    }

    otpStatus = Status.loading;
    notifyListeners();
    try {
      if (kIsWeb) {
        webOTPConfirmationResult = await _auth.signInWithPhoneNumber(_phone.trim());
        notifyListeners();
        // print('${webOTPConfirmationResult}web result');
        final customerExists = await CustomerApi().checkIfCustomerExists(_phone.trim());
        if (!customerExists) {
          isNewUser = true;
          notifyListeners();
        }
        notifyListeners();

        _showOTPScreen();
      } else {
        phoneVerificationResult = await _auth.signInWithPhoneNumber(_phone.trim());
        notifyListeners();
      }

      _showOTPScreen();
    } on FirebaseAuthException catch (e) {
      otpStatus = Status.failed;
      notifyListeners();
      printIt("$e");
      showToast(ErrorCodes.getFirebaseErrorMessage(e));
      AdminApi().addAuthError(e.toString(), _phone);
    } catch (e) {
      otpStatus = Status.failed;

      errorMessage = e.toString();
      handleError(e, context);
      notifyListeners();
      AdminApi().addAuthError(e.toString(), _phone);
    }
  }

  Future<void> checkOtp(String confirmOtp) async {
    // print(phoneVerificationResult.toString());
    // print(phoneVerificationResult?.verificationId);

    try {
      UserCredential? _userResult = await webOTPConfirmationResult?.confirm(confirmOtp.trim());

      if (_userResult != null && _userResult.user != null) {
        printIt(_userResult.user);
        // await callBack();
        userLoggedIn = true;
        loginStatus = Status.success;
        printIt("New Login Status");
        printIt(loginStatus);
        notifyListeners();
      } else {
        loginStatus = Status.failed;
        printIt(" Login Status failed");
        printIt(loginStatus);
        notifyListeners();
        // showToast(AppLocalizations.of(context)?.errorOccurred ?? 'error occurred');
      }
    } on FirebaseAuthException catch (e) {
      loginStatus = Status.failed;
      notifyListeners();
      printIt("$e");
      String? error = ErrorCodes.getFirebaseErrorMessage(e);
    } catch (err) {
      loginStatus = Status.failed;
      notifyListeners();
      // handleError(e, context);
      printIt('Caught exception ');
      printIt(err);
    }
  }

  Future<Status> signIn({required BuildContext context, required WidgetRef ref, required callBack}) async {
    // print(otp);
    // print(verificationCode);
    // print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
    // printIt(otp);
    // printIt(verificationCode);
    BnbProvider _bnbProvider = ref.read(bnbProvider);
    var locale = _bnbProvider.getLocale;
    // printIt('locale');
    // printIt(locale);
    try {
      loginStatus = Status.loading;
      notifyListeners();

      UserCredential? _userResult;
      if (kIsWeb) {
        // printIt("It's webbb");
        _userResult = await webOTPConfirmationResult?.confirm(otp);
        // print('#################################');
        // print(_userResult);
        // // print('-------');
        // // print(_userResult?.user);
        // // print('-------');
        // // print(_userResult?.additionalUserInfo);
        // print('#################################');
        phoneNoController.clear();
      } else {
        final AuthCredential _authCredential = PhoneAuthProvider.credential(
          verificationId: verificationCode!,
          smsCode: otp,
        );
        _userResult = await _auth.signInWithCredential(_authCredential);
      }

      if (_userResult != null && _userResult.user != null) {
        // printIt(_userResult.user);
        await callBack();
        userLoggedIn = true;
        loginStatus = Status.success;
        // printIt("New Login Status");
        // printIt(loginStatus);
      } else {
        loginStatus = Status.failed;
        // printIt("New Login Status");
        // printIt(loginStatus);
        showToast(AppLocalizations.of(context)?.errorOccurred ?? 'error occurred');
      }

      // _timer.cancel();

      notifyListeners();
    } on FirebaseAuthException catch (e) {
      var translator = GoogleTranslator();
      loginStatus = Status.failed;
      notifyListeners();
      // printIt("$e");
      String? error = ErrorCodes.getFirebaseErrorMessage(e);
      if (error != null) {
        if (error == "invalid-verification-code") {
          showToast(AppLocalizations.of(context)?.invalidOTP ?? 'Invalid OTP');
        } else {
          if (locale != null && locale != 'en') {
            // printIt(locale);
            var translatederror = await translator.translate(ErrorCodes.getFirebaseErrorMessage(e)!, from: 'en', to: locale);
            // printIt('Else Error ');
            // printIt(translatederror);
            showToast(translatederror);
          } else {
            printIt('Firebase Error');
            showToast(ErrorCodes.getFirebaseErrorMessage(e));
          }
        }
      }
    } catch (e) {
      loginStatus = Status.failed;
      notifyListeners();
      handleError(e, context);
      printIt('Caught exception ');
      printIt(e);
    }
    return loginStatus;
  }

  String userMapString(User user) {
    return jsonEncode(<String, dynamic>{
      'phoneNumber': user.phoneNumber,
      'uid': user.uid,
    });
  }

  getUserInfo({required BuildContext context}) async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      userLoggedIn = false;
      return;
    }

    Analytics.setUser(user.uid);
    userLoggedIn = true;
    notifyListeners();
    CustomerModel? customerModel = await CustomerApi().getCustomer();

    if (customerModel != null) {
      currentCustomer = customerModel;
      profileCompleted = currentCustomer?.profileCompleted ?? false;
      profilePicUploaded = currentCustomer?.profileCompleted ?? false;
      quizCompleted = currentCustomer?.quizCompleted ?? false;
      firstName = currentCustomer?.personalInfo.firstName ?? '';
      lastName = currentCustomer?.personalInfo.lastName ?? '';
      name = firstName + '' + lastName;
      printIt('Name $name ');
    } else {
      if (!initialUserCreated) {
        printIt('userAbsent creating user');
        await createInitialCustomer(context: context);
      } else {
        printIt('cant get user');
        await signOut();
      }
    }
    notifyListeners();
  }

  addName({required BuildContext context}) async {
    try {
      saveNameStatus = Status.loading;
      notifyListeners();

      // printIt('I got to Add name ');

      if (firstName == null || firstName.isEmpty || lastName == null || lastName.isEmpty) {
        saveNameStatus = Status.failed;
        showNameSent(false);
        showToast(
            // AppLocalizations.of(context)?.pleaseFillInYourName ??
            "Please fill in your name");
      } else {
        CustomerModel? customerModel = await CustomerApi().getCustomer();
        if (customerModel != null) {
          PersonalInfo personalInfo = PersonalInfo(
              phone: customerModel.personalInfo.phone,
              firstName: firstName,
              // customerModel.personalInfo.firstName ?? ,
              lastName: lastName,
              description: customerModel.personalInfo.description ?? '',
              dob: customerModel.personalInfo.dob ?? DateTime.now().subtract(const Duration(days: 365 * 26)),
              email: customerModel.personalInfo.email ?? '',
              sex: customerModel.personalInfo.sex ?? '');
          await CustomerApi().updatePersonalInfo(customerId: customerModel.customerId, personalInfo: personalInfo);
          name = firstName + '' + lastName;
          notifyListeners();
          // printIt('Name $name ');
          showNameSent(true);
          await updateCurrentCustomer();
        }
      }

      notifyListeners();
    } catch (e) {
      // debugPrint(e.toString());
    }
  }

  Future<bool> updateCustomerPersonalInfo({required String customerId, required PersonalInfo personalInfo, String? gender}) async {
    printIt('Updating customer info');
    updateCustomerPersonalInfoStatus = Status.loading;
    notifyListeners();

    try {
      await CustomerApi().updatePersonalInfo(
        customerId: customerId,
        personalInfo: personalInfo,
        gender: gender,
      );

      currentCustomer!.personalInfo = personalInfo;

      updateCustomerPersonalInfoStatus = Status.success;
      notifyListeners();

      printIt('Customer info updated');
      return true;
    } catch (err) {
      printIt('Catch error on updateCustomerPersonalInfo() - $err');

      updateCustomerPersonalInfoStatus = Status.failed;
      notifyListeners();
      return false;
    }
  }

  updateCurrentCustomer() async {
    CustomerModel? customerModel = await CustomerApi().getCustomer();
    if (customerModel != null) {
      currentCustomer = customerModel;
      notifyListeners();
    }
  }

  addPosition({required LatLng latlng}) async {
    GeoFirePoint myLocation = Geoflutterfire().point(latitude: latlng.latitude, longitude: latlng.longitude);
    Position myPosition = Position(geoHash: myLocation.hash, geoPoint: GeoPoint(myLocation.latitude, myLocation.longitude));
    bool added = await CustomerApi().addCustomerLocation(newPosition: myPosition);
    if (added) {
      CustomerModel? customerModel = await CustomerApi().getCustomer();
      if (customerModel != null) {
        currentCustomer = customerModel;
        notifyListeners();
      }
    }
  }

  //pops up the quiz
  quizReminder(context, {int milliseconds = 3000}) {
    Future.delayed(Duration(milliseconds: milliseconds), () {
      if (currentCustomer != null) {
        if (!(currentCustomer?.quizCompleted ?? false)) {
          printIt('show dialogue to finish quiz');
          showMyDialog(
            context: context,
            child: DefaultDialogue(
              svg: AppIcons.puzzledGuy,
              text: AppLocalizations.of(context)?.answerFewQuestions ?? "Answer a few questions. It will help us understand what to suggest you",
              buttonText: AppLocalizations.of(context)?.yesPlease ?? "Continue",
              onConfirm: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RegisterQuiz()));
              },
              showSkipButton: true,
              skipText: AppLocalizations.of(context)?.noImOk ?? 'Not now',
              onSkip: () {},
            ),
          );
        }
      }
    });
  }

  createInitialCustomer({required BuildContext context}) async {
    String? fcmToken = await FCMTokenHandler.getFCMToken();
    // debugPrint("Sending phone Number");
    // debugPrint("$countryCode$phoneNumber");
    CustomerModel _initialCustomer = CustomerModel(
      createdAt: DateTime.now(),
      favSalons: [],
      personalInfo: PersonalInfo(
          firstName: firstName,
          lastName: lastName,
          // nameforNotification : "",
          phone: "$countryCode$phoneNumber"
          //  _auth.currentUser?.phoneNumber ?? '',
          ),
      profilePic: '',
      avgRating: 0,
      noOfRatings: 0,
      locations: [
        Position(geoHash: 'u8vwyxct5', geoPoint: const GeoPoint(50.44872086752114, 30.52221357822418)),
      ],
      profileCompleted: false,
      profilePicUploaded: false,
      quizCompleted: false,
      preferredGender: '',
      registeredSalons: [],
      fcmToken: fcmToken ?? '',
      preferredCategories: [],
      customerId: '',
      locale: 'uk',
      referralLink: '',
    );
    printIt('creating initial customer');
    printIt(_initialCustomer.toJson());
    await CustomerApi().updateCustomer(
      customerModel: _initialCustomer,
    );

    initialUserCreated = true;
    notifyListeners();

    await getUserInfo(context: context);

    // if (currentCustomer != null) {
    //   try {
    //     printIt("==========giving install bonus==========");
    // await BonusReferralApi().giveInstallBonus(
    //         customerId: currentCustomer!.customerId, context: context);
    //   } catch (e) {
    //     print("error while giving install bonus");
    //     printIt(e);
    //   }
    // }
    phoneNumber = '';
    notifyListeners();
  }

  // late CustomerModel customerFromSuccessfulRegistration;

  // void updateCurrentCustomerToFinishBooking(CustomerModel customerUpdate) {
  //   customerFromSuccessfulRegistration = customerUpdate;
  //   notifyListeners();
  // }

  void updateAuthPhoneNumber(String val) {
    phoneNumber = val;
    notifyListeners();
  }

  void updateAuthCountryCode(String val) {
    countryCode = val;
    notifyListeners();
  }

  void setCurrentCustomer(CustomerModel customer) {
    currentCustomer = customer;
    notifyListeners();
  }

  void setCurrentCustomerWithoutOTP({required String firstName, required String lastName, required String email}) {
    currentCustomerWithoutOTP = CustomerModel(
      customerId: phoneNoController.text,
      personalInfo: PersonalInfo(
        phone: phoneNoController.text,
        firstName: firstName,
        lastName: lastName,
        description: '',
        dob: DateTime.now().subtract(const Duration(days: 365 * 26)),
        email: email,
        sex: '',
      ),
      registeredSalons: [],
      createdAt: DateTime.now(),
      avgRating: 3.0,
      noOfRatings: 6,
      profilePicUploaded: false,
      profilePic: "",
      profileCompleted: false,
      quizCompleted: false,
      preferredGender: "male",
      preferredCategories: [],
      locations: [],
      fcmToken: "",
      locale: "en",
      favSalons: [],
      referralLink: "",
    );
    notifyListeners();
  }
}
