import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/firebase/collections.dart';
import 'package:bbblient/src/models/appointment/appointment.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/review.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/views/appointment/widgets/appointment_header.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:bbblient/src/views/widgets/buttons.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/theme_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReviewAppointments extends ConsumerStatefulWidget {
  final AppointmentModel appointment;
  final String appointmentId;

  const ReviewAppointments({Key? key, required this.appointment, required this.appointmentId}) : super(key: key);

  @override
  ConsumerState<ReviewAppointments> createState() => _ReviewAppointmentsState();
}

class _ReviewAppointmentsState extends ConsumerState<ReviewAppointments> {
  double rated = 0;
  bool ratingSelected = false;
  bool postAnonymously = false;

  String chipSelected = '';

  TextEditingController clientNameControler = TextEditingController();
  TextEditingController reviewControler = TextEditingController();
  List<String> badTags = [];
  List<String> goodTags = [];
  Set<String> choosenTagsMaster = {};
  Set<String> choosenTagsSalon = {};
  bool goodReview = false; // If review is good or bad

  @override
  void initState() {
    super.initState();
    fetchDetails();
  }

  void fetchDetails() async {
    // GET CUSTOMER NAME FROM APPOINTMENT
    clientNameControler.text = widget.appointment.customer!.name;
  }

  void toggleTagMaster({required String tag}) {
    if (choosenTagsMaster.contains(tag)) {
      choosenTagsMaster.remove(tag);
    } else {
      choosenTagsMaster.add(tag);
    }
    setState(() {});
  }

  void toggleTagSalon({required String tag}) {
    if (choosenTagsSalon.contains(tag)) {
      choosenTagsMaster.remove(tag);
    } else {
      choosenTagsSalon.add(tag);
    }
    setState(() {});
  }

  bool submittingReview = false;

  showDoneDialog() {
    final _appointmentProvider = ref.watch(appointmentProvider);
    ThemeData theme = _appointmentProvider.salonTheme ?? AppTheme.customLightTheme;
    ThemeType themeType = _appointmentProvider.themeType ?? ThemeType.DefaultLight;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: 339,
                  height: 123,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  decoration: ShapeDecoration(
                    color: feedbackBGColor(themeType, theme),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    shadows: const [BoxShadow(color: Color(0x19000000), blurRadius: 25, offset: Offset(4, 7), spreadRadius: 0)],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 289,
                            child: Text(
                              'Thank you for your feedback!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: confirmationTextColor(themeType, theme),
                                fontSize: 15,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                height: 0.08,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 25.sp),
                      Container(
                        width: 258,
                        padding: const EdgeInsets.only(top: 10, left: 24, right: 24, bottom: 10),
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(width: 1, color: Color(0xFF9F9F9F)),
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Go Back',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: confirmationTextColor(themeType, theme),
                                    fontSize: 15.sp,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _appointmentProvider = ref.watch(appointmentProvider);
    ThemeData theme = _appointmentProvider.salonTheme ?? AppTheme.customLightTheme;
    ThemeType themeType = _appointmentProvider.themeType ?? ThemeType.DefaultLight;
    bool isLightTheme = (theme == AppTheme.customLightTheme);
    final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.portrait);

    return Scaffold(
      backgroundColor: scaffoldBGColor(themeType, theme),
      body: ListView(
        children: [
          Header(
            salonName: _appointmentProvider.salon?.salonName ?? '',
            salonLogo: _appointmentProvider.salon?.salonLogo,
            salonAddress: _appointmentProvider.salon?.address,
            salonPhone: _appointmentProvider.salon?.phoneNumber,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: DeviceConstraints.getResponsiveSize(context, 25, 0, 30.w),
            ),
            child: SizedBox(
              // height: 700,
              width: double.infinity,
              // color: Colors.orange,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  Text(
                    'Your Review',
                    style: theme.textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: DeviceConstraints.getResponsiveSize(context, 23.sp, 25.sp, 30.sp),
                      color: confirmationTextColor(themeType, theme),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.sp),
                  Text(
                    '${widget.appointment.customer!.name} how was your experience at ${(_appointmentProvider.salon?.salonName ?? '').toUpperCase()}?',
                    style: theme.textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.normal,
                      fontSize: DeviceConstraints.getResponsiveSize(context, 18.sp, 20.sp, 20.sp),
                      color: confirmationTextColor(themeType, theme),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 40.sp),
                  RatingBar.builder(
                    initialRating: 0,
                    minRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        rated = rating;
                        ratingSelected = true;

                        if (rating < 3) {
                          goodReview = false;
                          if (_appointmentProvider.isSingleMaster) {
                            badTags = getTranslatedTagsForMaster(context, false);
                          } else {
                            badTags = getTranslatedTagsForSalon(context, false);
                          }

                          choosenTagsMaster.clear();
                        } else {
                          goodReview = true;
                          if (_appointmentProvider.isSingleMaster) {
                            goodTags = getTranslatedTagsForMaster(context, true);
                          } else {
                            goodTags = getTranslatedTagsForSalon(context, true);
                          }
                          choosenTagsMaster.clear();
                        }
                      });
                    },
                  ),
                  SizedBox(height: 25.sp),
                  if (!ratingSelected)
                    Text(
                      'select your star rating',
                      style: theme.textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.normal,
                        fontSize: DeviceConstraints.getResponsiveSize(context, 17.sp, 20.sp, 20.sp),
                        color: confirmationTextColor(themeType, theme),
                      ),
                    ),
                  if (ratingSelected)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // SELECT TAGS
                        SizedBox(
                          // height: 200.h,
                          width: MediaQuery.of(context).size.width,
                          // color: Colors.brown,
                          child: Padding(
                            padding: EdgeInsets.all(isPortrait ? 8.sp : 15.sp),
                            child: Wrap(
                              runSpacing: 8.sp,
                              spacing: 8.sp,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              alignment: WrapAlignment.center,
                              children: [
                                for (String s in goodReview ? goodTags : badTags)
                                  GestureDetector(
                                    onTap: () {
                                      toggleTagMaster(tag: s);
                                    },
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 300),
                                      decoration: BoxDecoration(
                                        color: choosenTagsMaster.contains(s) ? theme.primaryColor : null,
                                        border: Border.all(
                                          color: choosenTagsMaster.contains(s)
                                              ? theme.primaryColor
                                              : isLightTheme
                                                  ? const Color(0XFFD2D2D2)
                                                  : const Color(0XFF545454),
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 4.sp),
                                        child: Text(
                                          s.toTitleCase(),
                                          style: theme.textTheme.bodyLarge?.copyWith(
                                            fontSize: DeviceConstraints.getResponsiveSize(context, 17.sp, 20.sp, 20.sp),
                                            color: choosenTagsMaster.contains(s) ? chooseReviewTag(themeType, theme) : valueColor(themeType, theme),
                                            letterSpacing: 0,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 15.sp),
                        TextField(
                          controller: clientNameControler,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: DeviceConstraints.getResponsiveSize(context, 17.sp, 19.sp, 20.sp),
                            color: confirmationTextColor(themeType, theme),
                          ),
                          decoration: InputDecoration(
                            hintText: 'Client Name',
                            hintStyle: const TextStyle(fontFamily: 'Inter'),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: textBorderColor(themeType, theme)),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: textBorderColor(themeType, theme)),
                            ),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: textBorderColor(themeType, theme)),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.sp),
                        Row(
                          children: [
                            Transform.scale(
                              scale: 1.2.sp,
                              child: Theme(
                                data: Theme.of(context).copyWith(unselectedWidgetColor: theme.colorScheme.tertiary),
                                child: Checkbox(
                                  checkColor: chooseReviewTag(themeType, theme),
                                  fillColor: MaterialStateProperty.all(theme.primaryColor),
                                  value: postAnonymously,
                                  onChanged: (value) {
                                    setState(() {
                                      postAnonymously = !postAnonymously;
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              'Post anonymously',
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: DeviceConstraints.getResponsiveSize(context, 17.sp, 19.sp, 20.sp),
                                color: confirmationTextColor(themeType, theme),
                              ),
                            ),
                          ],
                        ),
                        if (postAnonymously) SizedBox(height: 10.sp),
                        if (postAnonymously)
                          Text(
                            '${(_appointmentProvider.salon?.salonName ?? '').toUpperCase()} can still see your name',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: DeviceConstraints.getResponsiveSize(context, 17.sp, 19.sp, 20.sp),
                              color: const Color(0XFF818181),
                            ),
                          ),
                        SizedBox(height: 20.sp),
                        TextField(
                          controller: reviewControler,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: DeviceConstraints.getResponsiveSize(context, 17.sp, 19.sp, 20.sp),
                            color: confirmationTextColor(themeType, theme),
                          ),
                          decoration: InputDecoration(
                            hintText: 'Review comment',
                            hintStyle: const TextStyle(fontFamily: 'Inter'),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: textBorderColor(themeType, theme)),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: textBorderColor(themeType, theme)),
                            ),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: textBorderColor(themeType, theme)),
                            ),
                          ),
                          maxLength: null,
                          maxLines: null,
                        ),
                        SizedBox(height: isPortrait ? 50.sp : 100.sp),

                        DefaultButton(
                          borderRadius: 60,
                          onTap: () async {
                            setState(() {
                              submittingReview = true;
                            });

                            showToast((AppLocalizations.of(context)?.submittingReview ?? 'submitting review').toTitleCase());

                            ReviewModel _review = ReviewModel(
                              reviewId: '',
                              appointmentId: widget.appointmentId,
                              customerId: widget.appointment.customer!.id,
                              salonName: widget.appointment.salon.name,
                              review: reviewControler.text,
                              rating: rated,
                              createdAt: DateTime.now(),
                              choosenTags: choosenTagsMaster.toList(),
                              salonId: widget.appointment.salon.id,
                              customerName: clientNameControler.text,
                              customerPic: widget.appointment.customer!.pic ?? '',
                              masterId: widget.appointment.salon.id,
                            );

                            // print(widget.appointment.salon.id);
                            // print(widget.appointment.customer!.id);

                            DocumentReference _docRef = Collection.salons
                                .doc(
                                  widget.appointment.salon.id,
                                )
                                .collection('reviews')
                                .doc();

                            _review.reviewId = _docRef.id;

                            await _docRef.set(_review.toJson(), SetOptions(merge: true));

                            setState(() {
                              submittingReview = false;
                            });

                            showDoneDialog();
                          },
                          color: confirmButton(themeType, theme),
                          textColor: reviewButtonText(themeType),
                          height: 60.sp,
                          label: 'Send Review',
                          fontSize: DeviceConstraints.getResponsiveSize(context, 18.sp, 20.sp, 20.sp),
                          fontWeight: FontWeight.w600,
                          noBorder: true,
                          isLoading: submittingReview,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

List<String> getTranslatedTagsForMaster(context, bool positiveOrNegative) {
  switch (positiveOrNegative) {
    case false:
      return [
        AppLocalizations.of(context)?.traumatizedMe ?? 'traumatized me',
        AppLocalizations.of(context)?.ignoredMyWishes ?? 'ignored my wishes',
        AppLocalizations.of(context)?.sloppy ?? 'sloppy',
        AppLocalizations.of(context)?.inattentiveMaster ?? 'inattentive master',
        AppLocalizations.of(context)?.disappointingResult ?? 'disappointing result',
        AppLocalizations.of(context)?.rudeCommunication ?? "rude communication",
      ];

    default:
      return [
        AppLocalizations.of(context)?.individualApproach ?? 'individual approach',
        AppLocalizations.of(context)?.attentiveMaster ?? 'attentive master',
        AppLocalizations.of(context)?.goodSenseOfHumor ?? 'good sense of humor ',
        AppLocalizations.of(context)?.reticence ?? 'reticence',
        AppLocalizations.of(context)?.goodwill ?? 'goodwill',
        AppLocalizations.of(context)?.politeness ?? 'politeness',
        AppLocalizations.of(context)?.niceTalks ?? 'nice talks ',
        AppLocalizations.of(context)?.lightHand ?? 'light-hand',
        AppLocalizations.of(context)?.fastWork ?? 'fast work',
        AppLocalizations.of(context)?.goodAdviser ?? 'good adviser',
        AppLocalizations.of(context)?.explainedTheProcess ?? 'explained the process ',
      ];
  }
}

List<String> getTranslatedTagsForSalon(context, bool positiveOrNegative) {
  switch (positiveOrNegative) {
    case false:
      return [
        AppLocalizations.of(context)?.tenseAtmosphere ?? 'tense atmosphere',
        AppLocalizations.of(context)?.rudeCommunication ?? 'rude communication',
        AppLocalizations.of(context)?.violationOfHygienicNorms ?? 'violation of hygienic norms',
        AppLocalizations.of(context)?.usingCardatSalon ?? 'uncomfortable seat',
        AppLocalizations.of(context)?.lowQualityCosmetics ?? 'low-quality cosmetics',
        AppLocalizations.of(context)?.waitedLong ?? 'waited long',
        AppLocalizations.of(context)?.qualityDontMatch ?? 'quality doesn’t match price',
        AppLocalizations.of(context)?.tooLoudMusic ?? 'too loud music',
      ];

    default:
      return [
        AppLocalizations.of(context)?.greatAtmosphere ?? 'great atmosphere',
        AppLocalizations.of(context)?.coolMusic ?? 'cool music',
        AppLocalizations.of(context)?.organizedWork ?? 'organized work (no delays)',
        AppLocalizations.of(context)?.modernEquipment ?? 'modern equipment',
        AppLocalizations.of(context)?.qualityCosmetics ?? 'quality cosmetics ',
        AppLocalizations.of(context)?.comfortableSeat ?? 'comfortable seat',
        AppLocalizations.of(context)?.hospitalityFromStaff ?? 'hospitality/courtesy from staff',
        AppLocalizations.of(context)?.deliciousCoffee ?? 'delicious coffee or tea ',
        AppLocalizations.of(context)?.goodCovid19 ?? 'good covid-19 prevention',
        AppLocalizations.of(context)?.cleanSpace ?? 'clean space',
        AppLocalizations.of(context)?.convenientLocation ?? 'convenient location',
        AppLocalizations.of(context)?.goodPriceRation ?? 'good price/quality ratio',
      ];
  }
}
