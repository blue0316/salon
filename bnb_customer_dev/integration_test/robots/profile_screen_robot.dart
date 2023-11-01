import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class ProfileScreenRobot{
  final WidgetTester tester;
  ProfileScreenRobot(this.tester);


 ///[implementation of profile screen widget tests]
   
  Future<void> checkingForProfileScreenWidgets()async{
    await tester.tap(find.text("Profile"), warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey("user-prof")), findsOneWidget);
    expect(find.byKey(const Key("logout")), findsOneWidget);
    expect(find.byKey(const Key("profile")), findsOneWidget);
    expect(find.byKey(const Key("settings")), findsOneWidget);
    expect(find.byKey(const Key("payments")), findsOneWidget);
    expect(find.byKey(const Key("bonuses")), findsOneWidget);
    expect(find.byKey(const Key("invite-friends")), findsOneWidget);
    expect(find.byKey(const Key("support-chats")), findsOneWidget);
  } 
}