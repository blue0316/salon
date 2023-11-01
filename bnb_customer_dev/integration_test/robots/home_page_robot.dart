// ignore_for_file: prefer_const_constructors

import 'package:bbblient/src/views/home/choose_category.dart';
import 'package:bbblient/src/views/home/home.dart';
import 'package:bbblient/src/views/home/search/search_field.dart';
import 'package:bbblient/src/views/home/widgets/banner_scroll.dart';
import 'package:bbblient/src/views/salon/salon_home/salon_services.dart';
import 'package:bbblient/src/views/salon/widgets/service_expension_tile.dart';
import 'package:bbblient/src/views/widgets/salon_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';


///The HomeScreenRobot
class HomeRobot{
  const HomeRobot(this.tester);
  final WidgetTester tester;


 ///[implementation of  home page tests here]
  
  Future<void> navigatingToHomePage()async{
    expect(find.byType(HomePageAppBar), findsOneWidget);
    expect(find.byType(SearchField), findsOneWidget);
    expect(find.byType(BannerScroll), findsOneWidget);
    expect(find.byType(ChooseCategory), findsOneWidget);   
    await tester.tap(find.byKey(const ValueKey("home")));
    await tester.pumpAndSettle();
    // expect(find.byType(TextFormField).first, findsOneWidget);
    // expect(find.text("Favourites"), findsOneWidget);
    
  }
 ///[implementation of checking for home page widget tests]
   
  Future<void> checkingForHomeScreenWidgets()async{
    await tester.tap(find.text("Favourites"), warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey("fav")), findsOneWidget);
    expect(find.byType(TextFormField), findsOneWidget);
    await tester.tap(find.text("Calendar"), warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey("cal")), findsOneWidget);
    await tester.tap(find.text("Profile"), warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey("user-prof")), findsOneWidget);
    await tester.tap(find.text("Notifications"), warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey("notif")), findsOneWidget);
   
  }

 ///[implement tapping on the home screen and making sure we find the available salons services according to the current location] 
      
  Future<void> tappingOnASalonOnTheHomeScreen()async{
    await tester.tap(find.text("Home"));
    await tester.pumpAndSettle();
    await Future.delayed(Duration(seconds: 2));
    await tester.tap(find.byType(SalonContainer).first);
    await tester.pumpAndSettle();
    await Future.delayed(Duration(seconds: 2));
    await tester.tap(find.text("services"));
    await tester.pumpAndSettle();
    expect(find.byType(SalonServices), findsOneWidget);
    expect(find.byType(ServiceTile).first, findsOneWidget);
    await tester.drag(find.byType(ServiceTile).first, Offset(0.0,-300));
    await tester.pumpAndSettle();
  }
  
  }