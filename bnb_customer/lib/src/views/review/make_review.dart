// ignore_for_file: unused_local_variable

import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/firebase/appointments.dart';
import 'package:bbblient/src/firebase/collections.dart';
import 'package:bbblient/src/models/appointment/appointment.dart';
import 'package:bbblient/src/models/backend_codings/owner_type.dart';
import 'package:bbblient/src/models/review.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MakeReview extends ConsumerStatefulWidget {
  final AppointmentModel appointmentModel;
  const MakeReview({required this.appointmentModel, Key? key}) : super(key: key);

  @override
  _MakeReviewState createState() => _MakeReviewState();
}

class _MakeReviewState extends ConsumerState<MakeReview> {
  double _masterRating = 3;
  double _salonRating = 3;
  bool masterDisappointed = false;
  bool salonDisappointed = false;
  final TextEditingController _masterReview = TextEditingController();
  final TextEditingController _salonReview = TextEditingController();

  List<String> suggestions = ['Top quality', 'Individual approach', 'Light-hand', 'Good sense of humour', 'Goodwill', 'Reticence', 'Best tools', 'Politeness', 'Good design', 'Rapidity', 'Generosity of advice', 'Interesting person'];

  List<String> masterPositive = [
    'individual approach',
    'attentive master',
    'good sense of humor ',
    'reticence',
    'goodwill',
    'politeness',
    'nice talks ',
    'light-hand',
    'fast work',
    'good adviser',
    'explained the process ',
  ];

  List<String> masterPositiveUKR = [
    'індивідуальний підхід',
    'уважність',
    'гарне почуття гумору',
    'стриманість',
    'доброзичливість',
    'ввічливість',
    'приємна розмова',
    'легка рука',
    'швидко',
    'хороші поради',
    'пояснений процес',
  ];

  List<String> masterNegative = ['traumatized me', 'ignored my wishes', 'sloppy', 'inattentive master', 'disappointing result', "rude communication"];

  List<String> masterNegativeUKR = [
    'травмування',
    'ігнорування побажань',
    'неакуратність',
    'неуважніть',
    'результат розчарував',
    'грубе спілкування',
  ];

  List<String> salonPositive = [
    'great atmosphere',
    'cool music',
    'organized work (no delays)',
    'modern equipment',
    'quality cosmetics ',
    'comfortable seat',
    'hospitality/courtesy from staff',
    'delicious coffee or tea ',
    'good covid-19 prevention',
    'clean space',
    'convenient location',
    'good price/quality ratio',
  ];
  List<String> salonPositiveUKR = [
    'приємна атмосфера',
    'хороша музика',
    'організована робота (без затримок)',
    'сучасне обладнання',
    'якісна косметика',
    'зручне сидіння',
    'гостинний персонал',
    'смачні кава/чай',
    'хороша профілактика covid-19',
    'чистота',
    'зручне розташування',
    'хороші ціна/якість',
  ];

  List<String> salonNegative = [
    'tense atmosphere',
    'rude communication',
    'violation of hygienic norms',
    'uncomfortable seat',
    'low-quality cosmetics',
    'waited long',
    'quality doesn’t match price',
    'too loud music',
  ];

  List<String> salonNegativeUKR = [
    'неприємна атмосфера',
    'грубість',
    'порушення гігієнічних норм',
    'незручне сидіння',
    'косметика низької якості',
    'довге очікування',
    'ціна не відповідає якості',
    'занадто гучна музика',
  ];

  List<String> choosenTagsMaster = [];
  List<String> choosenTagsSalon = [];

  void toggleTagMaster({required String tag}) {
    if (choosenTagsMaster.contains(tag)) {
      choosenTagsMaster.removeAt(choosenTagsMaster.indexWhere((element) => element == tag));
    } else {
      choosenTagsMaster.add(tag);
    }
    setState(() {});
  }

  void toggleTagSalon({required String tag}) {
    if (choosenTagsSalon.contains(tag)) {
      choosenTagsSalon.removeAt(choosenTagsSalon.indexWhere((element) => element == tag));
    } else {
      choosenTagsSalon.add(tag);
    }
    setState(() {});
  }

  showDoneDilog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              child: Container(
                height: 450,
                width: 340,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: SizedBox(
                        height: 250,
                        width: 260,
                        child: Image.asset(AppIcons.thankForReviewPNG),
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)?.thankYouForYourReview ?? "Thank you for your review!",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    MaterialButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      color: AppTheme.creamBrown,
                      height: 52,
                      minWidth: 240,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        AppLocalizations.of(context)?.okey ?? "Okey",
                        style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.white, fontSize: 18.sp),
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
                    )
                  ],
                ),
              ));
        });
  }

  bool submittingReview = false;

  Future submitReview() async {
    setState(() {
      submittingReview = true;
    });
    final _auth = ref.watch(authProvider);
    if (widget.appointmentModel.salonOwnerType == OwnerType.singleMaster) {
      showToast(AppLocalizations.of(context)?.submittingReview ?? 'submitting review');
      ReviewModel _review = ReviewModel(
        reviewId: '',
        appointmentId: widget.appointmentModel.appointmentId!,
        customerId: _auth.currentCustomer!.customerId,
        salonName: widget.appointmentModel.salon.name,
        review: _masterReview.text,
        rating: _masterRating,
        createdAt: DateTime.now(),
        choosenTags: choosenTagsMaster,
        salonId: widget.appointmentModel.salon.id,
        customerName: Utils().getName(_auth.currentCustomer!.personalInfo),
        customerPic: _auth.currentCustomer?.profilePic ?? "",
        masterId: widget.appointmentModel.salon.id,
      );
      printIt(_review.toJson());
      DocumentReference docref = await Collection.salons.doc(widget.appointmentModel.salon.id).collection('reviews').add(_review.toJson());
      await AppointmentApi().reviewAppointment(
        appointmentId: widget.appointmentModel.appointmentId!,
        masterReviewed: true,
        salonReviewed: true,
      );
      showDoneDilog();
    } else {
      showToast(AppLocalizations.of(context)?.submittingReview ?? 'submitting review');
      ReviewModel _salonReviewModel = ReviewModel(
        reviewId: '',
        appointmentId: widget.appointmentModel.appointmentId!,
        customerId: _auth.currentCustomer!.customerId,
        salonName: widget.appointmentModel.salon.name,
        review: _salonReview.text,
        rating: _salonRating,
        createdAt: DateTime.now(),
        choosenTags: choosenTagsSalon,
        salonId: widget.appointmentModel.salon.id,
        masterId: widget.appointmentModel.master!.id,
        customerName: Utils().getName(_auth.currentCustomer!.personalInfo),
        customerPic: _auth.currentCustomer?.profilePic ?? "",
      );
      printIt(_salonReviewModel.toJson());
      ReviewModel _masterReviewModel = ReviewModel(
        reviewId: '',
        appointmentId: widget.appointmentModel.appointmentId!,
        customerId: _auth.currentCustomer!.customerId,
        salonName: widget.appointmentModel.salon.name,
        review: _masterReview.text,
        rating: _masterRating,
        createdAt: DateTime.now(),
        choosenTags: choosenTagsMaster,
        salonId: widget.appointmentModel.salon.id,
        masterId: widget.appointmentModel.master!.id,
        customerName: Utils().getName(_auth.currentCustomer!.personalInfo),
        customerPic: _auth.currentCustomer?.profilePic ?? "",
      );
      printIt(_masterReviewModel.toJson());

      DocumentReference docref = await Collection.salons.doc(widget.appointmentModel.salon.id).collection('reviews').add(_salonReviewModel.toJson());
      DocumentReference docref1 = await Collection.masters.doc(widget.appointmentModel.master!.id).collection('reviews').add(_masterReviewModel.toJson());
      await AppointmentApi().reviewAppointment(
        appointmentId: widget.appointmentModel.appointmentId!,
        masterReviewed: true,
        salonReviewed: true,
      );
      showDoneDilog();
    }
  }

  @override
  Widget build(BuildContext context) {
    final _auth = ref.watch(authProvider);
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: SizedBox(
                    height: 15,
                    width: 15,
                    child: SvgPicture.asset(AppIcons.cancelSVG),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Text(
                AppLocalizations.of(context)?.rateService ?? "How do you rate the service?",
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
            RatingBar.builder(
              initialRating: 3,
              minRating: 1,
              maxRating: 5,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 0.0),
              itemBuilder: (context, _) {
                return SvgPicture.asset('assets/icons/flutterRating.svg');
              },
              onRatingUpdate: (rating) {
                setState(() {
                  if (rating < 3) {
                    _masterRating = rating;
                    masterDisappointed = true;
                    choosenTagsMaster.clear();
                  } else {
                    _masterRating = rating;
                    masterDisappointed = false;
                    choosenTagsMaster.clear();
                  }
                });
              },
              itemSize: 40.sp,
              glow: false,
              updateOnDrag: true,
              ignoreGestures: false,
            ),
            Padding(
              padding: EdgeInsets.all(18.0.sp),
              child: Wrap(
                runSpacing: 8.sp,
                spacing: 8.sp,
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.center,
                children: [
                  for (String s in masterDisappointed
                      ? (AppLocalizations.of(context)?.localeName == 'en')
                          ? masterNegative
                          : masterNegativeUKR
                      : (AppLocalizations.of(context)?.localeName == 'en')
                          ? masterPositive
                          : masterPositiveUKR)
                    GestureDetector(
                      onTap: () {
                        toggleTagMaster(tag: s);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                            color: choosenTagsMaster.contains(s) ? AppTheme.creamBrownLight : Colors.white,
                            border: Border.all(
                              color: choosenTagsMaster.contains(s) ? AppTheme.creamBrownLight : AppTheme.grey2,
                            ),
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 4.sp),
                            child: Text(
                              s,
                              style: choosenTagsMaster.contains(s)
                                  ? AppTheme.subTitle1.copyWith(color: Colors.white, fontSize: 13)
                                  : AppTheme.subTitle1.copyWith(
                                      color: AppTheme.lightGrey,
                                      fontSize: 13,
                                    ),
                            )),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(
              height: 8.h,
            ),
            Text(
              AppLocalizations.of(context)?.yourWishesOrComments ?? "Your wishes or comments for Master",
              style: Theme.of(context).textTheme.displaySmall!.copyWith(color: AppTheme.lightGrey),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 12.h,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextFormField(
                controller: _masterReview,
                maxLines: 4,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(12)),
                  focusColor: Colors.white,
                  fillColor: Colors.white,
                  filled: true,
                  hintText: AppLocalizations.of(context)?.tellUsAaboutMaster ?? "Tell us a bit more about master",
                ),
              ),
            ),
            if (widget.appointmentModel.salonOwnerType == OwnerType.salon) ...[
              Padding(
                padding: const EdgeInsets.only(
                  top: 30,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    AppLocalizations.of(context)?.tellUsAbouSalon ?? "And what about salon ?",
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ),
              ),
              RatingBar.builder(
                initialRating: 3,
                minRating: 1,
                maxRating: 5,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                itemBuilder: (context, _) {
                  return SvgPicture.asset('assets/icons/flutterRating.svg');
                },
                onRatingUpdate: (rating) {
                  setState(() {
                    if (rating < 3) {
                      _salonRating = rating;
                      salonDisappointed = true;
                      choosenTagsSalon.clear();
                    } else {
                      _salonRating = rating;
                      salonDisappointed = false;
                      choosenTagsSalon.clear();
                    }
                  });
                },
                itemSize: 40.sp,
                glow: false,
                updateOnDrag: true,
                ignoreGestures: false,
              ),
              Padding(
                padding: EdgeInsets.all(18.0.sp),
                child: Wrap(
                  runSpacing: 8.sp,
                  spacing: 8.sp,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.center,
                  children: [
                    for (String s in salonDisappointed
                        ? (AppLocalizations.of(context)?.localeName == 'en')
                            ? salonNegative
                            : salonNegativeUKR
                        : (AppLocalizations.of(context)?.localeName == 'en')
                            ? salonPositive
                            : salonPositiveUKR)
                      GestureDetector(
                        onTap: () {
                          toggleTagSalon(tag: s);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                              color: choosenTagsSalon.contains(s) ? AppTheme.creamBrownLight : Colors.white,
                              border: Border.all(
                                color: choosenTagsSalon.contains(s) ? AppTheme.creamBrownLight : AppTheme.grey2,
                              ),
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 4.sp),
                              child: Text(
                                s,
                                style: choosenTagsSalon.contains(s) ? AppTheme.subTitle1.copyWith(color: Colors.white, fontSize: 13) : AppTheme.subTitle1.copyWith(color: AppTheme.lightGrey, fontSize: 13),
                              )),
                        ),
                      ),
                  ],
                ),
              ),
              Text(
                AppLocalizations.of(context)?.yourWishesOrComments ?? "Your wishes or comments for Master",
                style: Theme.of(context).textTheme.displaySmall!.copyWith(color: AppTheme.lightGrey),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 12.h,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  controller: _salonReview,
                  maxLines: 4,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(12)),
                    focusColor: Colors.white,
                    fillColor: Colors.white,
                    filled: true,
                    hintText: AppLocalizations.of(context)?.tellUsAbouSalon ?? "Tell us a bit more about salon",
                  ),
                ),
              ),
            ],
            SizedBox(
              height: 38.h,
            ),
            MaterialButton(
              color: AppTheme.creamBrown,
              disabledColor: AppTheme.grey,
              onPressed: () async {
                submittingReview ? null : await submitReview();
              },
              height: 48.h,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              child: submittingReview
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.white),
                      ),
                    )
                  : Text(
                      AppLocalizations.of(context)?.continue_word ?? "continue",
                      style: const TextStyle(color: Colors.white),
                    ),
              minWidth: 1.sw - 48,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(AppLocalizations.of(context)?.remindMeLater ?? "Remind Me Later"),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
