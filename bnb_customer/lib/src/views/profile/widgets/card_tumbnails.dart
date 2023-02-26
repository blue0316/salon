import 'package:flutter/material.dart';

import '../../../theme/app_main_theme.dart';

class CardTmbnl extends StatelessWidget {
  final bool selected;
  final String cardImage;

  const CardTmbnl({Key? key, required this.selected, required this.cardImage}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      width: 120,
      child: Stack(
        children: [
          Image.asset(cardImage),
          Positioned(
              top: 8,
              left: 8,
              child: CircleAvatar(
                radius: 12,
                backgroundColor: selected ? AppTheme.textBlack : Colors.grey[400],
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 10,
                  child: selected
                      ? const Center(
                          child: Icon(
                            Icons.check,
                            size: 18,
                            color: AppTheme.textBlack,
                          ),
                        )
                      : const SizedBox(),
                ),
              ))
        ],
      ),
    );
  }
}
