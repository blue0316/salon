import 'package:flutter/material.dart';

class ThemeController extends ChangeNotifier {
  final landing = GlobalKey(debugLabel: "landing");
  final tags = GlobalKey(debugLabel: "tags");
  final promotions = GlobalKey(debugLabel: "promotions");
  final about = GlobalKey(debugLabel: "about");
  final sponsor = GlobalKey(debugLabel: "sponsor");
  final works = GlobalKey(debugLabel: "works");
  final price = GlobalKey(debugLabel: "price");
  final shop = GlobalKey(debugLabel: "shop");
  final team = GlobalKey(debugLabel: "team");
  final reviews = GlobalKey(debugLabel: "reviews");
  final writeToUs = GlobalKey(debugLabel: "write-to-us");
  final contacts = GlobalKey(debugLabel: "contact");
}
