import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:moemen/data/notification/firebase_notifications/api/firebase_api.dart';
import 'package:moemen/data/notification/firebase_notifications/firebase_options.dart';
import 'package:moemen/data/notification/local_notifications/notification_service.dart';

import 'app/resources/resources.dart';
import 'core/app.dart';
import 'core/bloc_observer.dart';
import 'di/di.dart';
import 'presentation/bottom_bar/viewmodel/home_viewmodel.dart';

final GetIt sl = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool firebaseInitialized = false;

  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      firebaseInitialized = true;
      debugPrint("✅ Firebase initialized successfully");
    } catch (e, st) {
      debugPrint("❌ Firebase initialization failed: $e\n$st");
    }
  }

  if (firebaseInitialized) {
    try {
      final FirebaseApi firebaseApi = FirebaseApi();
      await firebaseApi.initNotifications();
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

      final FirebaseMessaging messaging = FirebaseMessaging.instance;
      final String? token = await messaging.getToken();
      debugPrint("✅ FCM Token: $token");
    } catch (e) {
      debugPrint("❌ Error setting up Firebase messaging: $e");
    }

    await NotificationController.initializeLocalNotifications();
    await NotificationController.initializeIsolateReceivePort();
  }

  await EasyLocalization.ensureInitialized();
  await initAppModule();
  await setupServiceLocator();

  Bloc.observer = MyBlocObserver();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  Get.put(HomeViewModel());

  runApp(
    EasyLocalization(
      supportedLocales: const [arabicLocale, englishLocale],
      startLocale: arabicLocale,
      path: localisationPath,
      child: Phoenix(child: MyApp()),
    ),
  );
}

Future<void> setupServiceLocator() async {
  sl.registerLazySingleton<InternetConnectionChecker>(
    () => InternetConnectionChecker.createInstance(),
  );
  sl.registerLazySingleton<HomeViewModel>(() => HomeViewModel());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  debugPrint(
      "📩 Handling background notification: ${message.notification?.title}");
}
