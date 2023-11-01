import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'desktop/vintage_desktop.dart';
import 'mobile/vintage_mobile.dart';

class VintageCraft extends StatelessWidget {
  const VintageCraft({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) => const VintageCraftMobile(),
      tablet: (BuildContext context) => const VintageCraftMobile(),
      desktop: (BuildContext context) => const VintageCraftDesktop(),
      watch: (BuildContext context) => Container(color: Colors.purple),
    );
  }
}
