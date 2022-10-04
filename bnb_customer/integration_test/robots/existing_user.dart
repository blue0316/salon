
import 'package:bbblient/src/views/home/choose_category.dart';
import 'package:bbblient/src/views/home/home.dart';
import 'package:bbblient/src/views/home/search/search_field.dart';
import 'package:bbblient/src/views/home/widgets/banner_scroll.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class NotFirstTimeRobot{
  final WidgetTester tester;
  NotFirstTimeRobot(this.tester);

  Future<void> goToHomePage()async{
    expect(find.byType(HomePageAppBar), findsOneWidget);
    expect(find.byType(SearchField), findsOneWidget);
    expect(find.byType(BannerScroll), findsOneWidget);
    expect(find.byType(ChooseCategory), findsOneWidget);   
    await tester.tap(find.byKey(const ValueKey("home")));
    await tester.pumpAndSettle();
    expect(find.byType(TextFormField).first, findsOneWidget);
    expect(find.text("Favourites"), findsOneWidget);   
  }
  Future<void> ifUserIsloggedIn()async{
     await tester.tap(find.text("Profile"), warnIfMissed: false);
     await tester.pumpAndSettle();
     
     expect(find.byKey(const ValueKey("fav")), findsOneWidget);
     expect(find.byKey(const ValueKey("user-prof")), findsOneWidget);
     expect(find.byKey(const Key("logout")), findsOneWidget);
     expect(find.byKey(const Key("profile")), findsOneWidget);
     expect(find.byKey(const Key("settings")), findsOneWidget);
     expect(find.byKey(const Key("payments")), findsOneWidget);
     expect(find.byKey(const Key("bonuses")), findsOneWidget);
     expect(find.byKey(const Key("invite-friends")), findsOneWidget);
     expect(find.byKey(const Key("support-chats")), findsOneWidget);
     await tester.tap(find.text("Home"));
     await tester.pumpAndSettle();
  }


}