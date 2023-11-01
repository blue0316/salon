import 'package:bbblient/src/firebase/collections.dart';
import 'package:bbblient/src/models/backend_codings/bonus_type.dart';
import 'package:bbblient/src/models/bonus_model.dart';
import 'package:bbblient/src/models/bonus_setttings_model.dart';
import 'package:bbblient/src/models/customer/customer.dart';
import 'package:bbblient/src/models/referral.dart';
import 'package:bbblient/src/utils/notification/referral_notification.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/widgets/dialogues/referral_dilouges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BonusReferralApi {
  BonusReferralApi._privateConstructor();
  static final BonusReferralApi _instance = BonusReferralApi._privateConstructor();
  factory BonusReferralApi() {
    return _instance;
  }

  Future<BonusSettings?> getBonusSettings() async {
    try {
      DocumentSnapshot snap = await Collection.appData.doc('referralSettings').get();
      if (snap.exists) {
        BonusSettings bonusSettings = BonusSettings.fromJson(snap.data() as Map<String, dynamic>);
        return bonusSettings;
      } else {
        return null;
      }
    } catch (e) {
      printIt(e);
      return null;
    }
  }

  Future<String> addBonus({required BonusModel bonusModel}) async {
    try {
      DocumentReference documentId = await Collection.bonuses.add(bonusModel.toJson()).onError((error, stackTrace) => printIt(error));
      return documentId.id;
    } catch (e) {
      printIt(e);
      return '';
    }
  }

  Future<bool> invalidateBonus({required BonusModel bonusModel, required String usedAppointmentId}) async {
    try {
      bonusModel.used = true;
      bonusModel.usedAt = DateTime.now();
      bonusModel.usedApntmtId = usedAppointmentId;
      await Collection.bonuses.doc(bonusModel.bonusId).update(bonusModel.toJson());
      return true;
    } catch (e) {
      printIt(e);
      return false;
    }
  }

  Future<bool> validateBonus({required String bonusId}) async {
    try {
      DocumentSnapshot doc = await Collection.bonuses.doc(bonusId).get();
      BonusModel bonusModel = BonusModel.fromJson(doc.data() as Map<String, dynamic>);
      bonusModel.bonusId = doc.id;
      bonusModel.used = false;
      bonusModel.usedAt = DateTime.now();
      bonusModel.usedApntmtId = '';
      bonusModel.validated = true;
      await Collection.bonuses.doc(bonusModel.bonusId).update(bonusModel.toJson());
      return true;
    } catch (e) {
      printIt(e);
      return false;
    }
  }

  Future<List<BonusModel>> getBonuses({required String customerId}) async {
    List<BonusModel> bonuses = [];
    QuerySnapshot snapshot = await Collection.bonuses.where('owner', isEqualTo: customerId).where("validated", isEqualTo: true).where("used", isEqualTo: false).where("expiresAt", isGreaterThan: DateTime.now()).get();
    for (QueryDocumentSnapshot doc in snapshot.docs) {
      try {
        BonusModel bonusModel = BonusModel.fromJson(doc.data() as Map<String, dynamic>);
        bonusModel.bonusId = doc.id;
        bonuses.add(bonusModel);
      } catch (e) {
        printIt(e);
      }
    }
    return bonuses;
  }

  Future<String> createReferral({required ReferralModel referralModel}) async {
    try {
      DocumentReference docref = await Collection.referrals.add(referralModel.toJson()).onError((error, stackTrace) => printIt(error));
      return docref.id;
    } catch (e) {
      printIt(e);
      return '';
    }
  }

  Future<bool> alreadyReferred({required String referredById, required String referredToId}) async {
    QuerySnapshot _docref = await Collection.referrals.where('referredToId', isEqualTo: referredToId).limit(3).get();
    QuerySnapshot _docref1 = await Collection.referrals.where('referredById', isEqualTo: referredById).where('referredToId', isEqualTo: referredToId).limit(3).get();
    QuerySnapshot _docref2 = await Collection.referrals.where('referredById', isEqualTo: referredToId).where('referredToId', isEqualTo: referredById).limit(3).get();
    printIt('referral check');
    printIt(_docref.docs.length);
    printIt(_docref.docs.isEmpty);
    printIt(_docref2.docs.length);
    printIt(_docref2.docs.isEmpty);
    if (_docref2.docs.isEmpty && _docref.docs.isEmpty && _docref1.docs.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future giveInstallBonus({required String customerId, required BuildContext context}) async {
    // checking if install bonus is active
    BonusSettings? bonusSettings = await getBonusSettings();
    if (bonusSettings != null && bonusSettings.installBonusActive) {
      QuerySnapshot snap = await Collection.bonuses
          .where(
            'owner',
            isEqualTo: customerId,
          )
          .where(
            'bonusType',
            isEqualTo: BonusTypes.installBonus,
          )
          .get();

      printIt('bonuses found length ${snap.docs.length}');
      //checking if bonus is already given
      if (snap.docs.isEmpty) {
        printIt('giving bonuses ${bonusSettings.installBonusesAmounts}');
        if (bonusSettings.installBonusesAmounts.isNotEmpty) {
          int bonusesGiven = 0;
          for (int i = 0; i < bonusSettings.installBonusesAmounts.length; i++) {
            BonusModel bonus = BonusModel(
              amount: bonusSettings.installBonusesAmounts[i],
              bonusType: BonusTypes.installBonus,
              owner: customerId,
              expiresAt: DateTime.now().add(
                Duration(days: bonusSettings.installBonusesValidity[i]),
              ),
              bonusId: '',
              createdAt: DateTime.now(),
              expired: false,
              used: false,
              usedApntmtId: '',
              usedAt: DateTime.now(),
              validated: true,
            );
            bonusesGiven++;
            await Collection.bonuses.add(
              bonus.toJson(),
            );
            printIt('added bonus $i ${bonus.toJson()}');
          }
          if (bonusesGiven > 0) {
            showSuccessDialog(
              context: context,
              onTap: () {},
              message: AppLocalizations.of(context)?.youGotTwoWelcomeBonuses ?? 'You got two welcome bonuses',
            );
            // showToast("you received $bonusesGiven welcome bonuses");
          }
        }
      }
    }
  }

  Future giveReferralBonuses({required BuildContext context, required CustomerModel referredTo, required CustomerModel referredBy}) async {
    bool _alreadyReferred = await alreadyReferred(referredById: referredBy.customerId, referredToId: referredTo.customerId);
    if (_alreadyReferred) {
      showErrorDialog(context: context, message: 'you have already been referred');
    } else {
      BonusSettings? bonusSettings = await getBonusSettings();
      if (bonusSettings != null) {
        if (bonusSettings.referralsActive) {
          printIt(referredBy.customerId);
          printIt(referredTo.customerId);
          if (referredBy.customerId != referredTo.customerId) {
            printIt(referredBy.createdAt.difference(referredTo.createdAt).inHours.abs());
            List<String> bonusIds = [];
            if (referredBy.createdAt.difference(referredTo.createdAt).inHours.abs() < bonusSettings.doubleHours) {
              for (int i = 0; i < bonusSettings.referralBonusesAmounts.length; i++) {
                String bonusId = await addBonus(
                    bonusModel: BonusModel(
                  bonusType: BonusTypes.referralBonus,
                  amount: bonusSettings.referralBonusesAmounts[i],
                  expired: false,
                  expiresAt: DateTime.now().add(Duration(days: bonusSettings.referralBonusesValidity[i])),
                  createdAt: DateTime.now(),
                  bonusId: '',
                  owner: referredBy.customerId,
                  used: false,
                  usedApntmtId: '',
                  usedAt: DateTime.now(),
                  validated: false,
                ));
                bonusIds.add(bonusId);
              }
            } else if (referredBy.createdAt.difference(referredTo.createdAt).inHours.abs() > bonusSettings.doubleHours) {
              String bonusId = await addBonus(
                  bonusModel: BonusModel(
                bonusType: BonusTypes.referralBonus,
                amount: bonusSettings.referralBonusesAmounts[0],
                expired: false,
                expiresAt: DateTime.now().add(Duration(days: bonusSettings.referralBonusesValidity[0])),
                createdAt: DateTime.now(),
                bonusId: '',
                owner: referredBy.customerId,
                used: false,
                usedApntmtId: '',
                usedAt: DateTime.now(),
                validated: false,
              ));
              bonusIds.add(bonusId);
            }
            await ReferralNotification.sendReferralInstallNotification(customerBy: referredBy, referredTo: referredTo);
            await Collection.referrals.add(
              ReferralModel(
                referralId: '',
                referredById: referredBy.customerId,
                referredToId: referredTo.customerId,
                referredByBonusId: bonusIds,
                referredToBonusId: [],
                createdAt: DateTime.now(),
                doubleBonusGiven: bonusIds.length > 1,
              ).toJson(),
            );
          } else {
            showErrorDialog(context: context, message: 'One can be one\'s great friend.,\n but referrals are for other friends');
          }
        }
      }
    }
  }
}
