import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'booking_date_time.dart';
import 'widgets/booking_header.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BookingChooseService extends StatefulWidget {
  const BookingChooseService({Key? key}) : super(key: key);

  @override
  _BookingChooseServiceState createState() => _BookingChooseServiceState();
}

class _BookingChooseServiceState extends State<BookingChooseService> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              height: 1.sh,
              width: 1.sw,
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  const BookingHeader(
                    small: true,
                  ),
                  Text(
                    // todo
                    AppLocalizations.of(context)?.chooseMaster ??
                        "Choose a service or services",
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(left: 25.w, right: 25.w, top: 36.h),
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        hintText:
                            AppLocalizations.of(context)?.search ?? "Search",
                        hintStyle:
                            Theme.of(context).textTheme.headline4!.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                ),
                        prefixIcon: SizedBox(
                          height: 13,
                          width: 13,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SvgPicture.asset(AppIcons.lensGreySVG),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding:
                          EdgeInsets.only(top: 28.h, left: 40.w, bottom: 20.h),
                      child: const Text(
                        "Selected: 1",
                        maxLines: 1,
                      ),
                    ),
                  ),
                  // ListView.builder(
                  //     itemCount: servicesType.length,
                  //     shrinkWrap: true,
                  //     primary: false,
                  //     padding: EdgeInsets.all(0),
                  //     itemBuilder: (context, index) {
                  //       return SizedBox();
                  //       // return ServiceExpensionTile(
                  //       //   services: services.where((element) => element.categoryId == servicesType[index]).toList(),
                  //       //   serviceType: servicesType[index],
                  //       // );
                  //     }),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: SizedBox(
                height: 60.h,
                width: 1.sw,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.arrow_back,
                                color: AppTheme.textBlack,
                              ),
                              SizedBox(
                                width: 16.w,
                              ),
                              Text(
                                AppLocalizations.of(context)?.back ?? "Back",
                                style: Theme.of(context).textTheme.subtitle1,
                              )
                            ],
                          ),
                        )),
                    Flexible(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => const BookingDateTime()));
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: AppTheme.creamBrown,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(28),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)?.continue_word ??
                                  "Continue",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
