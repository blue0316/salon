import 'package:flutter/material.dart';

import '../../../controller/salon/salon_profile_provider.dart';
import '../../../models/review.dart';

///get ratings for salon

double getTotalRatings(List<ReviewModel> reviews) {
  ///values for the different ratings
  int oneStar = 33;
  int twoStar = 29;
  int threeStar = 40;
  int fourStar = 29;
  int fiveStar = 252;

//get total tyoes of ratings for salon
  int totalOneRating = 0;
  int totalTwoRating = 0;
  int totalThreeRating = 0;
  int totalFourRating = 0;
  int totalFiveRating = 0;

  for (var rev in reviews) {
    if (rev.rating == 1) {
      totalOneRating++;
    }
    if (rev.rating == 2) {
      totalTwoRating++;
    }
    if (rev.rating == 3) {
      totalThreeRating++;
    }
    if (rev.rating == 4) {
      totalFourRating++;
    }
    if (rev.rating == 5) {
      totalFiveRating++;
    }
  }

  //That's a weighted average, where you weigh each rating with the number of votes it got:

  double totalRatings = ((totalFiveRating * fiveStar +
          totalFourRating * fourStar +
          totalThreeRating * threeStar +
          totalTwoRating * twoStar +
          totalOneRating * oneStar) /
      (fiveStar + fourStar + threeStar + twoStar + oneStar));
  return totalRatings.toDouble();
}

InputDecoration textFieldStyle(
    String hintText, SalonProfileProvider _salonProfileProvider) {
  return InputDecoration(
    
      hintText: hintText,
      filled: _salonProfileProvider.salonTheme.inputDecorationTheme.filled,
      fillColor:
          _salonProfileProvider.salonTheme.inputDecorationTheme.fillColor,
      border: _salonProfileProvider.salonTheme.inputDecorationTheme.border,
      enabledBorder:
          _salonProfileProvider.salonTheme.inputDecorationTheme.enabledBorder,
      focusedBorder:
          _salonProfileProvider.salonTheme.inputDecorationTheme.focusedBorder);
}
