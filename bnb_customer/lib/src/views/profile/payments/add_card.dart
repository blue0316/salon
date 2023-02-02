import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../theme/app_main_theme.dart';
import '../../../utils/icons.dart';
import '../../widgets/buttons.dart';
import '../widgets/card_tumbnails.dart';
import '../widgets/card_widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddCard extends StatefulWidget {
  const AddCard({Key? key}) : super(key: key);

  @override
  _AddCardState createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
  final ScrollController _cardListController = ScrollController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _cardNoController = TextEditingController();
  final TextEditingController _expDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  int currentCard = 0;

  String firstName = "";
  String lastName = "";
  String cardNo = "";

  List<String> creditCardImages = [
    AppIcons.creditCardBlackPNG,
    AppIcons.creditCardBluePNG,
    AppIcons.creditCardBlueGreyPNG,
    AppIcons.creditCardGreenPNG,
    AppIcons.creditCardOrangePNG,
    AppIcons.creditCardApplePNG,
  ];

  List<String> creditCardTumbnails = [
    AppIcons.creditCardBlackTumbnailPNG,
    AppIcons.creditCardBlueTumbnailPNG,
    AppIcons.creditCardBlueGreyTumbnailPNG,
    AppIcons.creditCardGreenTumbnailPNG,
    AppIcons.creditCardOrangeTumbnailPNG,
    AppIcons.creditCardAppleTumbnailPNG,
  ];

  InputDecoration textFieldDecoration = InputDecoration(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    hintStyle: const TextStyle(fontFamily: "Montserrat", fontSize: 14, fontWeight: FontWeight.w400, color: AppTheme.textBlack),
    labelStyle: const TextStyle(fontFamily: "Montserrat", fontSize: 14, fontWeight: FontWeight.w400, color: AppTheme.textBlack),
  );

  TextStyle textFieldStyle = const TextStyle(fontFamily: "Montserrat", fontSize: 14, fontWeight: FontWeight.w400, color: AppTheme.textBlack);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          AppLocalizations.of(context)?.addCards ?? "Add cards",
          style: Theme.of(context).textTheme.bodyText1,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 60.0.h,
                left: 60.w,
                right: 60.w,
                bottom: 85.h,
              ),
              child: CreditCard(
                cardImage: creditCardImages[currentCard],
                name: _firstNameController.text + " " + _lastNameController.text,
                cardNumber: _cardNoController.text,
              ),
            ),
            SizedBox(
              height: 120,
              child: ListView.builder(
                controller: _cardListController,
                shrinkWrap: true,
                primary: false,
                itemCount: creditCardImages.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          currentCard = index;
                        });
                      },
                      child: CardTmbnl(
                        selected: index == currentCard,
                        cardImage: creditCardTumbnails[index],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)?.firstName ?? "First Name",
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    TextFormField(
                      controller: _firstNameController,
                      decoration: textFieldDecoration,
                      style: textFieldStyle,
                      onChanged: (val) {
                        setState(() {
                          firstName = val;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(AppLocalizations.of(context)?.lastName ?? "Last Name"),
                    const SizedBox(
                      height: 4,
                    ),
                    TextFormField(
                      controller: _lastNameController,
                      decoration: textFieldDecoration,
                      style: textFieldStyle,
                      onChanged: (val) {
                        setState(() {
                          lastName = val;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(AppLocalizations.of(context)?.cardNo ?? "Card No"),
                    const SizedBox(
                      height: 4,
                    ),
                    TextFormField(
                      controller: _cardNoController,
                      decoration: textFieldDecoration.copyWith(
                        suffixIcon: InkWell(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (_) => ScanCard(),
                            //   ),
                            // );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: SvgPicture.asset(AppIcons.cardScanSVG),
                          ),
                        ),
                      ),
                      style: textFieldStyle,
                      onChanged: (val) {
                        setState(() {
                          cardNo = val;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Exp. Date"),
                            const SizedBox(
                              height: 4,
                            ),
                            SizedBox(
                              width: 0.4.sw,
                              child: TextFormField(
                                controller: _expDateController,
                                decoration: textFieldDecoration,
                                style: textFieldStyle,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 0.4.sw,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("CVV"),
                              const SizedBox(
                                height: 4,
                              ),
                              TextFormField(
                                controller: _cvvController,
                                decoration: textFieldDecoration.copyWith(suffixIcon: const Icon(Icons.info_outline)),
                                style: textFieldStyle,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            BnbMaterialButton(
              onTap: () {},
              title: "Add",
              minWidth: 140,
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
