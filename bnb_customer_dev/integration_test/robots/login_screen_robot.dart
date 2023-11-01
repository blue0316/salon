import 'package:bbblient/src/views/registration/authenticate/phone/otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class LoginRobots{
  const LoginRobots(this.tester);
  final WidgetTester tester;

  ///logging in[implementation of login tests here]
    
  Future<void> loginIn()async{
    await tester.tap(find.text("Favourites"), warnIfMissed: false);
    await tester.pumpAndSettle();
   // this function tests for users login with tests phone number and otp
    expect(find.byType(TextFormField).last, findsOneWidget);
    await tester.enterText(find.byType(TextFormField).last, "123456789");
    await tester.tap(find.byType(MaterialButton), warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(find.byType(OTPField), findsOneWidget);
    await tester.enterText(find.byType(OTPField), "123456");
    await tester.tap(find.byType(MaterialButton));
    await tester.pumpAndSettle();    
  }
}

