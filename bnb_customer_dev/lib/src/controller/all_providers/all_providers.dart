import 'package:bbblient/src/controller/app_provider.dart';
import 'package:bbblient/src/controller/appointment/apointment_provider.dart';
import 'package:bbblient/src/controller/authentication/auth_provider.dart';
import 'package:bbblient/src/controller/bnb/bnb_provider.dart';
import 'package:bbblient/src/controller/create_apntmnt_provider/create_appointment_provider.dart';
import 'package:bbblient/src/controller/home/map_view_provider.dart';
import 'package:bbblient/src/controller/home/salon_search_provider.dart';
import 'package:bbblient/src/controller/quiz/quiz_provider.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/controller/search/search_provider.dart';
import 'package:bbblient/src/controller/user/user_provider.dart';
import 'package:bbblient/src/mongodb/db_service.dart';
import 'package:bbblient/src/views/themes/glam_one/controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final authStateChangesProvider = StreamProvider<User?>(
  (ref) => ref.watch(firebaseAuthProvider).authStateChanges(),
);

final createAppointmentProvider = ChangeNotifierProvider<CreateAppointmentProvider>(
  (ref) {
    final DatabaseProvider mongodbProvider = ref.watch(dbProvider);

    return CreateAppointmentProvider(
      mongodbProvider: mongodbProvider,
    );
  },
);

final appProvider = ChangeNotifierProvider<AppProvider>(
  (ref) => AppProvider(),
);

final dbProvider = ChangeNotifierProvider<DatabaseProvider>(
  (ref) => DatabaseProvider(),
);

final salonSearchProvider = ChangeNotifierProvider<SalonSearchProvider>(
  (ref) {
    final DatabaseProvider mongodbProvider = ref.watch(dbProvider);

    return SalonSearchProvider(
      mongodbProvider: mongodbProvider,
    );
  },
);

final searchProvider = ChangeNotifierProvider<SearchProvider>(
  (ref) => SearchProvider(),
);

final appointmentProvider = ChangeNotifierProvider<AppointmentProvider>(
  (ref) => AppointmentProvider(),
);

final authProvider = ChangeNotifierProvider<AuthProviderController>(
  (ref) {
    final DatabaseProvider mongodbProvider = ref.watch(dbProvider);

    return AuthProviderController(
      mongodbProvider: mongodbProvider,
    );
  },
);

final userProfileProvider = ChangeNotifierProvider<UserProfileProvider>(
  (ref) => UserProfileProvider(),
);

final bnbProvider = ChangeNotifierProvider<BnbProvider>(
  (ref) => BnbProvider(),
);

final quizProvider = ChangeNotifierProvider<QuizProvider>(
  (ref) => QuizProvider(),
);

final mapViewProvider = ChangeNotifierProvider<MapViewProvider>(
  (ref) => MapViewProvider(),
);

final salonProfileProvider = ChangeNotifierProvider<SalonProfileProvider>(
  (ref) {
    final DatabaseProvider mongodbProvider = ref.watch(dbProvider);

    return SalonProfileProvider(
      mongodbProvider: mongodbProvider,
    );
  },
);

final themeController = ChangeNotifierProvider<ThemeController>(
  (ref) => ThemeController(),
);
