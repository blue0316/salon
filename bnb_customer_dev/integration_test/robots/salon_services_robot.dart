// ignore_for_file: prefer_const_constructors

import 'package:bbblient/src/views/salon/booking/booking_date_time.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';


class SalonServicesBookingRobot{

  const SalonServicesBookingRobot(this.tester);
  final WidgetTester tester;


  ///[implement tapping on the available service expansion tile] 
  
  Future<void> selectingASaloonService()async{
    await tester.tap(find.text("services"));
    await tester.pumpAndSettle();
    await Future.delayed(Duration(seconds: 2));
    await tester.tap(find.byType(ExpansionTile).first);
    await tester.pumpAndSettle();
    await Future.delayed(Duration(seconds: 2));
    await tester.tap(find.byKey(const Key("tap-service")).first);
    await tester.pumpAndSettle();
    await Future.delayed(Duration(seconds: 2));  
    
  }

  ////[implement tapping on the book-button]
    
  Future<void> tapOnBookKey()async{
    await tester.tap(find.byKey(const ValueKey("book-key")));
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 2));
    
   }
   ///[implementation of tests for scrolling down, selecting a master and  tapping on the available time slots]
   
  Future<void> selectingAMaster()async{
    final time = DateTime.now();
    //await tester.tap(find.text('${time.day + 3}')); 
    //await tester.pumpAndSettle();
    await tester.tap(find.byType(MastersRowContainer).last);
    await tester.pumpAndSettle();
    await tester.drag(find.byType(MastersRowContainer).last, Offset(0.0,-800));
    await Future.delayed(const Duration(seconds: 2));
 
   // final day = TimeOfDay.now();
     if(time.hour < 20.45){
       await tester.tap(find.text("20:15"));
     // await tester.tap(find.byType(TimeSlotContainer).at(0));
      await tester.pumpAndSettle();
      expect(find.byType(BotToast), findsNothing);
    }else{
     // await tester.tap(find.byKey(ValueKey("next")));
      await tester.pumpAndSettle();
      await tester.tap(find.text('${time.day + 1}'));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(MastersRowContainer).first,);
      await tester.pumpAndSettle();
      await tester.drag(find.byType(TimeSlotContainer).first, Offset(0.0,-300));
      await tester.tap(find.text("9:00"));
      await tester.pumpAndSettle();
    }   
    await Future.delayed(const Duration(seconds: 5));
   
   }

     ////[implementation of tests for confirming a booking after time slots and master have been chosen]
  
   Future<void> conirmMastersBooking()async{
    await tester.tap(find.text("Continue"));
    await tester.pumpAndSettle();
    await Future.delayed(Duration(seconds: 2));
    await tester.tap(find.byKey(Key("confirm-key")));
    await tester.pumpAndSettle();
   }

   ///[implement confirm booking]
   
  Future<void> confirmBooking()async{
    await Future.delayed(const Duration(seconds:2));
    await tester.tap(find.byKey(const Key("request-booking")));
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 2));
  }


    ////[implementation of test for successful pop up message]
    
   Future<void> successfulBooking()async{
    await tester.tap(find.byKey(Key("great-key")));
    await tester.pumpAndSettle();
    await Future.delayed(Duration(seconds: 2));  
   }

     ///[implementation of notification screen widgets tests]
  
   Future<void> navigatingToNotifScreen()async{
    await tester.tap(find.text("Notifications"), warnIfMissed: false);
    await tester.pumpAndSettle();
    await Future.delayed(Duration(seconds: 5));
    expect(find.byKey(const ValueKey("notif")), findsOneWidget);  
    await tester.tap(find.text("Home"));
    await tester.pumpAndSettle();     
   }
}