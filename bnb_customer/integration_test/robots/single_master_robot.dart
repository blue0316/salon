
import 'package:bbblient/src/views/salon/booking/booking_date_time.dart';
import 'package:bbblient/src/views/salon/master/master_service.dart';
import 'package:bbblient/src/views/salon/salon_home/salon_masters.dart';
import 'package:bbblient/src/views/salon/widgets/service_expension_tile.dart';
import 'package:bbblient/src/views/widgets/salon_widgets.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';



class SingleMasterRobot{
  final WidgetTester tester;
  SingleMasterRobot(this.tester);
  

  ///[implementation of single masters tests]
  Future<void> selectingAMaster()async{
    await tester.tap(find.byType(SalonContainer).first);
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 2));
    await tester.tap(find.text("masters"));
    await tester.pumpAndSettle();
    expect(find.byType(SaloonMasters), findsOneWidget);
    await tester.drag(find.byType(SingleChildScrollView).first, const Offset(0.0,-300));
    await tester.tap(find.byKey(const ValueKey("tap-master"), ).at(1),);
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 2));
  }
  ///[choosing a single master]
  Future<void> choosingAMasterService()async{
    await tester.tap(find.text("services"));
    await tester.pumpAndSettle();
    expect(find.byType(MasterServices), findsOneWidget);
    await Future.delayed(const Duration(seconds: 2));
    expect(find.byType(ServiceTile), findsWidgets);
    await tester.tap(find.byType(ExpansionTile).first);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key("tap-service")).first);
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 2));  
  }
  
///[booking a masters service]
  Future<void> bookingAMastersService()async{
    await tester.tap(find.text("Book Now"));
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 2));  
    
  }

  ///[selecting booking time]
  Future<void> selectingBookingTime()async{
    final time = DateTime.now();
     if( time.hour < 20.45){
      await tester.tap(find.byType(MastersRowContainer).first,);
      
      await tester.drag(find.byType(MastersRowContainer).first, const Offset(0.0,-300)); 
      
      await tester.tap(find.text("10:30"));
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));expect(find.byType(BotToast), findsNothing);
    }else{
      await tester.tap(find.text('${time.day + 1}'));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(MastersRowContainer).first,);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));
      await tester.drag(find.byType(MastersRowContainer).first, const Offset(0.0,-300));  
      await tester.tap(find.text("13:00"));
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));

    }
   await Future.delayed(const Duration(seconds: 2));
   await tester.tap(find.text("Continue"));
   await tester.pumpAndSettle();
   await Future.delayed(const Duration(seconds: 2));
   
     }

     ///[confirm masters booking]
 Future<void> confirmSingleMastersBooking()async{
   await tester.tap(find.text("confirm"));
   await tester.pumpAndSettle();
   await Future.delayed(const Duration(seconds: 2));
   
   await tester.tap(find.text("Request booking"));
   await tester.pumpAndSettle();
   await Future.delayed(const Duration(seconds: 2));
   await tester.tap(find.text("Great"));
   await tester.pumpAndSettle();
   await Future.delayed(const Duration(seconds: 2));
   
 }
}