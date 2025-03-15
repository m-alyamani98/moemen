import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:moemen/data/notification/firebase_notifications/api/firebase_api.dart';
import 'package:moemen/data/notification/local_notifications/notification_service.dart';
import 'app/resources/resources.dart';
import 'core/app.dart';
import 'core/bloc_observer.dart';
import 'data/notification/firebase_notifications/firebase_options.dart';
import 'di/di.dart';
import 'presentation/bottom_bar/viewmodel/home_viewmodel.dart';

final GetIt sl = GetIt.instance;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      name : 'quran',
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  FirebaseApi firebaseApi = FirebaseApi();
  await firebaseApi.initNotifications();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  try {
    String? token = await messaging.getToken();
    print("FCM Token: $token");
  } catch (e) {
    print("Error fetching FCM token: $e");
  }

  /*initializeNotifications();

  await NotiService().initNotification();

  await LocalNotifications.init();
*/

  await NotificationController.initializeLocalNotifications();
  await NotificationController.initializeIsolateReceivePort();


  


  // Initialize other dependencies AFTER Firebase
  await EasyLocalization.ensureInitialized();
  await initAppModule();
  await setupServiceLocator();

  // Wakelock.enable();
  Bloc.observer = MyBlocObserver();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  Get.put(HomeViewModel());

  runApp(
    EasyLocalization(
      supportedLocales: const [arabicLocale, englishLocale],
      startLocale: arabicLocale,
      path: localisationPath,
      child: Phoenix(
        child: MyApp(),
      ),
    ),
  );
}

Future<void> setupServiceLocator() async {

  sl.registerLazySingleton<InternetConnectionChecker>(
        () => InternetConnectionChecker.createInstance(),
  );

  // HomeViewModel is safe here as a lazy singleton (only created when first used)
  sl.registerLazySingleton<HomeViewModel>(() => HomeViewModel());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling background notification: ${message.notification?.title}");
}

