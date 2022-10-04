import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ErrorCodes {
  static const List<String> _errorCodes = [
    "session-expired"
        "custom-token-mismatch",
    "invalid-custom-token",
    "user-disabled",
    "user-not-found",
    "weak-password",
    "email-already-in-use",
    "invalid-email",
    "operation-not-allowed",
    "account-exists-with-different-credential",
    "invalid-credential",
    "wrong-password",
    "invalid-verification-id",
    "expired-action-code",
    "invalid-phone-number",
    "missing-client-identifier",
    "invalid-verification-code",
  ];

  static getError(String errorCode) {
    if (errorCode == '') {
      return null;
    } else if (_errorCodes.contains(errorCode)) {
      return errorCode;
    } else {
      return null;
    }
  }

  static String? getFirebaseErrorMessage(FirebaseAuthException e) {
    debugPrint('==============');
    debugPrint('Error code : ${e.code}');
    debugPrint('Error message : ${e.message}');
    String? error = getError(e.code);
    if (error != null) {
      return error;
    }
    debugPrint('!!!!!!!!!!!!!!!!');
    debugPrint('cannot find any custom relative message, so printing a default firebase message');
    debugPrint('!!!!!!!!!!!!!!!!');

    return e.message;
  }
}
