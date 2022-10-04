import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/views/home/search/search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'widgets/booking_header.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// todo add this flow too
class BookingChooseMaster extends StatefulWidget {
  const BookingChooseMaster({Key? key}) : super(key: key);

  @override
  _BookingChooseMasterState createState() => _BookingChooseMasterState();
}

class _BookingChooseMasterState extends State<BookingChooseMaster> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const BookingHeader(
              small: true,
            ),
            Text(
              AppLocalizations.of(context)?.chooseMaster ?? "Choose a master",
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(fontSize: 20, fontWeight: FontWeight.w400),
            ),
            const SearchField(),
            SizedBox(
              height: 60.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: 30.0.w, right: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(),
                  Container(
                    height: 30,
                    width: 95,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: AppTheme.creamBrown,
                    ),
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)?.seeAll ?? "See all",
                        style: Theme.of(context)
                            .textTheme
                            .headline2!
                            .copyWith(fontSize: 14),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 40.h,
            ),
            // SizedBox(
            //   height: 180.h,
            //   child: ListView.builder(
            //       itemCount: 7,
            //       shrinkWrap: true,
            //       scrollDirection: Axis.horizontal,
            //       itemBuilder: (context, index) {
            //         return Padding(
            //           padding: EdgeInsets.only(left: 40.0.w, right: 8.w),
            //           child: const PersonAvtar(
            //             personImageUrl: "https://randomuser.me/api/portraits/women/8.jpg",
            //             personName: "Valeriy Lev",
            //             radius: 35,
            //             showBorder: false,
            //             showRating: true,
            //             rating: 3.5,
            //             starSize: 15,
            //           ),
            //         );
            //       }),
            // ),
          ],
        ),
      ),
    );
  }
}
