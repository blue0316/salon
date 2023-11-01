import 'package:bbblient/main.dart';
import 'package:bbblient/src/views/onboarding/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class OnboardingRobot {
  const OnboardingRobot(this.tester);
  final WidgetTester tester;

   ///[implementation the onboarding screen tests]
   
  Future<void> navigatingToOnboarding() async {
    expect(find.byType(MyApp), findsOneWidget);
    
      expect(find.byType(OnBoardingPage), findsOneWidget);
      await tester.tap(find.byType(TextButton).first);
      await tester.tap(find.byType(TextButton).last);
      await tester.pumpAndSettle();
    
    }           
  
 
 }


