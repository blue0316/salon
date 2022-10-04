import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../theme/app_main_theme.dart';
import '../quiz/register_quiz.dart';

class EnterPromo extends StatelessWidget {
  const EnterPromo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Text(
          "promo code",
          style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: 30),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 20.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 170,
              height: 48,
              child: TextFormField(
                decoration: InputDecoration(
                    fillColor: Colors.white.withOpacity(.48),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    filled: true,
                    hintText: "Enter promo code"),
                cursorHeight: 16,
                textAlign: TextAlign.center,
                textAlignVertical: TextAlignVertical.center,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20.h,
        ),
        MaterialButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          height: 60,
          minWidth: size.width - 94,
          color: AppTheme.lightBlack,
          // inactive color = D8DDE8
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterQuiz()));
          },
          child: Text(
            "confirm",
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
      ],
    );
  }
}

class DoYouHavePromo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      height: 280.h,
      child: Column(
        children: [
          SizedBox(
            height: 50.h,
          ),
          Text(
            "Do you have promo \ncode?",
            style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: 30),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 30.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: size.width / 3,
                child: RadioListTile(
                  value: true,
                  groupValue: 1,
                  onChanged: (dynamic val) {},
                  title: Text("Yes"),
                ),
              ),
              SizedBox(
                width: size.width / 3,
                child: RadioListTile(
                  value: false,
                  groupValue: 1,
                  onChanged: (dynamic val) {},
                  title: Text("No"),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
