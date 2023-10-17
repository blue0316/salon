import 'package:flutter/material.dart';

import '../../../../controller/salon/salon_profile_provider.dart';

class ProductSliderIndicator extends StatelessWidget {
  const ProductSliderIndicator({
    super.key,
    required int selectedProductIndex,
    required SalonProfileProvider salonProfileProvider,
    required this.length,
  })  : _selectedProductIndex = selectedProductIndex,
        _salonProfileProvider = salonProfileProvider;

  final int _selectedProductIndex;
  final double length;
  final SalonProfileProvider _salonProfileProvider;

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: const SliderThemeData(
        thumbShape: RoundSliderThumbShape(
          enabledThumbRadius: 1,
        ),
        overlayColor: Color(0x29eb1555),
        activeTrackColor: Color(0xff868686),
        inactiveTrackColor: Color(0xffCACACA),
        thumbColor: Colors.white,
      ),
      child: Slider(
          value: _selectedProductIndex.toDouble(),
          thumbColor: Colors.transparent,
          //overlayColor: ,
          min: 0.0,
          max: length,
          onChanged: (value1) {
            // setState(() {
            //   value = value1;
            // });
          }),
    );
  }
}
