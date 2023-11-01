import 'package:bbblient/src/views/themes/gentle_touch_entry/mobile/mobile_view.dart';
import 'package:bbblient/src/views/themes/test_gentle_touch.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class GentleTouchEntry extends StatelessWidget {
  const GentleTouchEntry({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) => const GentleTouchTestingPhone(),
      tablet: (BuildContext context) => const GentleTouchTestingPhone(),
      desktop: (BuildContext context) => const GentleTouchTesting(),
      watch: (BuildContext context) => Container(color: Colors.purple),
    );
  }
}
