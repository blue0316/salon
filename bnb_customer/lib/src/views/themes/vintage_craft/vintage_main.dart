import 'package:bbblient/src/views/themes/city_muse/city_muse_desktop/city_muse_desktop.dart';
import 'package:bbblient/src/views/themes/city_muse/city_muse_mobile/city_muse_mobile.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'desktop/vintage_desktop.dart';

class VintageCraft extends StatelessWidget {
  const VintageCraft({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) => Container(color: Colors.brown),
      tablet: (BuildContext context) => Container(color: Colors.green[800]),
      desktop: (BuildContext context) => const VintageCraftDesktop(),
      watch: (BuildContext context) => Container(color: Colors.purple),
    );
  }
}
