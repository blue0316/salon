import 'package:bbblient/src/theme/glam_one.dart';
import 'package:bbblient/src/views/themes/glam_one/core/constants/image.dart';
import 'package:bbblient/src/views/themes/glam_one/core/constants/theme_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SalonReviews extends StatefulWidget {
  const SalonReviews({Key? key}) : super(key: key);

  @override
  State<SalonReviews> createState() => _SalonReviewsState();
}

class _SalonReviewsState extends State<SalonReviews> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 50.w, right: 50.w, bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "REVIEWS",
                style: GlamOneTheme.headLine2.copyWith(),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    GlamOneIcons.leftArrow,
                    height: 50.sp, // TODO: RESPONSIVE
                  ),
                  const SizedBox(width: 40), // TODO: RESPONSIVE
                  SvgPicture.asset(
                    GlamOneIcons.rightArrow,
                    height: 50.sp, // TODO: RESPONSIVE
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "4,5",
                style: GlamOneTheme.bodyText1.copyWith(),
              ),
              const SizedBox(width: 15),
              RatingBar.builder(
                initialRating: 5,
                minRating: 0,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemSize: 20,
                itemCount: 5,
                updateOnDrag: true,
                glowColor: Colors.yellow,
                glow: true,
                glowRadius: 10,
                unratedColor: Colors.blue,
                onRatingUpdate: (rating) {},
                itemBuilder: (context, _) {
                  return const Icon(
                    Icons.star,
                    color: GlamOneTheme.deepOrange,
                  );
                },
              ),
              const SizedBox(width: 10),
              Text(
                "23 Reviews",
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: GlamOneTheme.bodyText2.copyWith(
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Container(
            height: 220.h,
            // color: Colors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const ReviewCard(
                  avatar: GlamOneImages.review1,
                  reviewUser: 'Jocelyn Francis',
                  review: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis molestie, dictum est a, mattis.',
                  reviewStars: 5,
                ),
                const ReviewCard(
                  avatar: GlamOneImages.review2,
                  reviewUser: 'Skylar Vetrovs',
                  review: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis molestie, dictum est a, mattis.',
                  reviewStars: 3.5,
                ),
                const ReviewCard(
                  avatar: GlamOneImages.review3,
                  reviewUser: 'Jocelyn Francis',
                  review: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis molestie, dictum est a, mattis.',
                  reviewStars: 5,
                ),
              ],
            ),
          ),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  final String avatar, reviewUser, review;
  final double reviewStars;

  const ReviewCard({
    Key? key,
    required this.avatar,
    required this.reviewUser,
    required this.review,
    required this.reviewStars,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350.h,
      width: 100.w,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(top: 45),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(border: Border.all(color: GlamOneTheme.primaryColor, width: 2)),
              child: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 0,
                      child: Text(
                        reviewUser.toUpperCase(),
                        style: GlamOneTheme.bodyText1.copyWith(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: RatingBar.builder(
                        initialRating: reviewStars,
                        minRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemSize: 17,
                        itemCount: 5,
                        updateOnDrag: true,
                        onRatingUpdate: (rating) {},
                        itemBuilder: (context, _) {
                          return const Icon(
                            Icons.star,
                            color: GlamOneTheme.deepOrange,
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: SvgPicture.asset(GlamOneIcons.leftQuote, height: 15),
                        ),
                        SizedBox(
                          width: 80.w,
                          child: Text(
                            review,
                            maxLines: 4,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: GlamOneTheme.subTitle1.copyWith(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: SvgPicture.asset(GlamOneIcons.rightQuote, height: 15),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 60.h,
            width: 60.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: GlamOneTheme.primaryColor, width: 2),
            ),
            child: Image.asset(
              avatar,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}