import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/icons.dart';

const double cardRatio = 295 / 174;

class CreditCard extends StatefulWidget {
  final String? cardNumber;
  final String? name;
  final String cardImage;

  const CreditCard({Key? key, this.cardNumber, this.name, required this.cardImage}) : super(key: key);

  @override
  _CreditCardState createState() => _CreditCardState();
}

class _CreditCardState extends State<CreditCard> {
  @override
  Widget build(BuildContext context) {
    print(widget.name);
    return AspectRatio(
      aspectRatio: cardRatio,
      child: Stack(
        children: [
          Container(
            child: Image.asset(widget.cardImage),
          ),
          Positioned(
            bottom: 38.h,
            left: 28.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.cardNumber != null &&
                    widget.name != null &&
                    widget.cardImage != AppIcons.creditCardApplePNG) ...[
                  Text(
                    widget.name!,
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                  ),
                  SizedBox(
                    height: 14.h,
                  ),
                  SizedBox(
                    height: 15,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: widget.cardNumber!.length,
                        itemBuilder: (_, index) {
                          if (index <= 11) {
                            if (index == 3 || index == 7 || index == 11) {
                              return GreyDotCard(
                                padding: true,
                              );
                            } else {
                              return GreyDotCard(
                                padding: false,
                              );
                            }
                          } else {
                            return Text(
                              widget.cardNumber![index],
                              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                            );
                          }
                        }),
                  ),
                  // Row(
                  //   children: [
                  //     FourDots(),
                  //     FourDots(),
                  //     FourDots(),
                  //     Text(
                  //       widget.cardNumber,
                  //       style: Theme.of(context).textTheme.bodyText2.copyWith(
                  //             color: Colors.white,
                  //             fontSize: 13,
                  //           ),
                  //     ),
                  //   ],
                  // ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GreyDotCard extends StatelessWidget {
  final bool padding;

  const GreyDotCard({Key? key, required this.padding}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 4,
          backgroundColor: Colors.white.withOpacity(0.7),
        ),
        if (!padding) ...[
          SizedBox(
            width: 4,
          ),
        ],
        if (padding) ...[
          SizedBox(
            width: 16.w,
          )
        ]
      ],
    );
  }
}

class FourDots extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 4,
          backgroundColor: Colors.white.withOpacity(0.7),
        ),
        SizedBox(
          width: 4,
        ),
        CircleAvatar(
          radius: 4,
          backgroundColor: Colors.white.withOpacity(0.7),
        ),
        SizedBox(
          width: 4,
        ),
        CircleAvatar(
          radius: 4,
          backgroundColor: Colors.white.withOpacity(0.7),
        ),
        SizedBox(
          width: 4,
        ),
        CircleAvatar(
          radius: 4,
          backgroundColor: Colors.white.withOpacity(0.7),
        ),
        SizedBox(
          width: 16.w,
        )
      ],
    );
  }
}
