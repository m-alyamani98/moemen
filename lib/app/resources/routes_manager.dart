import 'package:flutter/material.dart';
import 'package:moemen/core/splash.dart';
import 'package:moemen/domain/models/quran/khetma_model.dart';
import 'package:moemen/presentation/bottom_bar/screens/werd/view/daily_werd.dart';
import 'package:moemen/presentation/werd_builder/new_khetma.dart';
import '../../di/di.dart';
import '../../presentation/dhikr_builder/view/dhikr_builder_view.dart';
import '../../presentation/bottom_bar/view/home_view.dart';
import '../../presentation/surah_builder/view/surah_builder_view.dart';

class Routes {
  static const String homeRoute = "/home";
  static const String quranRoute = "/quran";
  static const String hadithRoute = "/hadith";
  static const String adhkarRoute = "/adhkar";
  static const String newKhetmaRoute = "/new_khetma";
  static const String customAdhkarRoute = "/customAdhkar";
  static const String customDhikrRoute = "/customDhikr";
  static const String pillarsRoute = "/pillars";
  static const String browsenetRoute = "/browse";
  static const String splashRoute = "/splash";
  static const String qiblaRoute = "/qibla";
  static const String khetmaRoute = "/khetma";
  static const String dailyWerdRoute = "/dailyWerd";
  static const String paymentRoute = '/payment';
}

class RoutesGenerator {
  static Route<dynamic>? getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.homeRoute:
        initQuranModule(); // Make sure this initializes QuranCubit
        initAdhkarModule();
        initPrayerTimingsModule();
        return MaterialPageRoute(builder: (_) => HomeView());
      case Routes.quranRoute:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => SurahBuilderView(
            quranList: args["quranList"],
            pageNo: args["pageNo"],
          ),
        );
      case Routes.adhkarRoute:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => DhikrBuilderView(
            adhkarList: args["adhkarList"],
            category: args["category"],
          ),
        );
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_) => SplashPage());
      case Routes.newKhetmaRoute:
        return MaterialPageRoute(builder: (_) => NewKhetmaPage());
      case Routes.dailyWerdRoute:
        final args = settings.arguments as Khetma;
        return MaterialPageRoute(
          builder: (_) => WerdScreen(initialKhetma: args),
        );
      default:
        return null;
    }
  }
}
