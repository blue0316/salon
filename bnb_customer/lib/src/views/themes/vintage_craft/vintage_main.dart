import 'package:bbblient/src/views/themes/city_muse/city_muse_desktop/city_muse_desktop.dart';
import 'package:bbblient/src/views/themes/city_muse/city_muse_mobile/city_muse_mobile.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class VintageCraft extends StatelessWidget {
  const VintageCraft({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) => GlamMinimalPhone(),
      tablet: (BuildContext context) => GlamMinimalPhone(),
      desktop: (BuildContext context) => GlamMinimalDesktop(),
      watch: (BuildContext context) => Container(color: Colors.purple),
    );
  }
}
