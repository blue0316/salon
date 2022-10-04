import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../theme/app_main_theme.dart';
import '../../../utils/icons.dart';
import '../widgets/card_widgets.dart';
import 'add_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyCards extends StatefulWidget {
  const MyCards({Key? key}) : super(key: key);

  @override
  _MyCardsState createState() => _MyCardsState();
}

class _MyCardsState extends State<MyCards> {
  final ScrollController _cardListController = ScrollController();
  int currentCard = 0;

  static const String name = "my name";
  static const String cardNo = "000000000000";

  List<String> creditCardImages = [
    AppIcons.creditCardBlackPNG,
    AppIcons.creditCardBluePNG,
    AppIcons.creditCardBlueGreyPNG,
    AppIcons.creditCardGreenPNG,
    AppIcons.creditCardOrangePNG,
    AppIcons.creditCardApplePNG,
  ];
  @override
  void dispose() {
    _cardListController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          AppLocalizations.of(context)?.myCards ?? "My cards",
          style: Theme.of(context).textTheme.bodyText1,
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // when no card is added
          // SizedBox(
          //   width: size.width,
          // ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(
          //     horizontal: 60,
          //     vertical: 40,
          //   ),
          //   child: Container(
          //     height: 174,
          //     width: 300,
          //     decoration: BoxDecoration(
          //       border: Border.all(
          //         color: lightGrey,
          //         width: 2,
          //       ),
          //       borderRadius: BorderRadius.circular(15),
          //     ),
          //     child: Center(
          //       child: Icon(
          //         Icons.add,
          //         color: lightGrey,
          //         size: 30,
          //       ),
          //     ),
          //   ),
          // )
          //showing Cards
          Padding(
            padding: EdgeInsets.only(
              top: 60.0.h,
              left: 60.w,
              right: 60.w,
              bottom: 85.h,
            ),
            child: CreditCard(
              cardImage: creditCardImages[currentCard],
              cardNumber: cardNo,
              name: name,
            ),
          ),
          Divider(),
          SizedBox(
            height: 40.h,
          ),
          SizedBox(
            height: 200.h,
            child: ListView.builder(
              controller: _cardListController,
              shrinkWrap: true,
              primary: false,
              itemCount: creditCardImages.length + 1,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddCard(),
                        ),
                      );
                    },
                    child: Ink(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppTheme.lightGrey,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          // color: creamBrownLight.withOpacity(0.5),
                        ),
                        width: 48,
                        margin: EdgeInsets.only(left: 20.w),
                        child: const Center(
                          child: Icon(
                            Icons.add,
                            color: AppTheme.lightGrey,
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          currentCard = index - 1;
                        });
                      },
                      child: CreditCard(
                        cardImage: creditCardImages[index - 1],
                        cardNumber: cardNo,
                        name: name,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
