import 'package:bbblient/src/firebase/collections.dart';
import 'package:bbblient/src/models/enquiry.dart';
import 'package:bbblient/src/models/enums/status.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EnquiryApi {
  EnquiryApi._privateConstructor();

  static final EnquiryApi _instance = EnquiryApi._privateConstructor();

  factory EnquiryApi() {
    return _instance;
  }

  Future<Status> createEnquiry(EnquiryModel enquiry) async {
    try {
      DocumentReference _docRef = Collection.enquiries.doc();

      await _docRef.set(enquiry.toJson());

      return Status.success;
    } catch (e) {
      printIt('Error on createEnquiry() - ${e.toString()}');
      return Status.failed;
    }
  }
}
