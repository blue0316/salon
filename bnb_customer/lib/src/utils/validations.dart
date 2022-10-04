class Validator {
  //validates the email string
  String? email(val) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern as String);
    if (!regex.hasMatch(val)) {
      return 'Enter Valid Email';
    } else {
      return null;
    }
  }

  //validates the pass string
  String? password(val) {
    if (val.length < 6) {
      return "Password is too short";
    }

    return null;
  }

  static const Pattern phoneNoRegPattern = r'^(\+\d{1,2}\s?)?1?\-?\.?\s?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}$';
}
