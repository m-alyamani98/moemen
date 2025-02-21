import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:momen/app/utils/app_prefs.dart';
import 'package:momen/di/di.dart';
import 'package:momen/domain/models/quran/khetma_model.dart';
import 'package:momen/presentation/bottom_bar/screens/werd/view/daily_werd.dart';
import 'package:momen/presentation/werd_builder/khetma_plan_page.dart';

import '../app/resources/resources.dart';
import '../presentation/custom_adhkar/cubit/custom_adhkar_cubit.dart';
import '../presentation/bottom_bar/cubit/bottom_bar_cubit.dart';
import '../presentation/bottom_bar/screens/adhkar/cubit/adhkar_cubit.dart';
import '../presentation/bottom_bar/screens/prayer_times/cubit/prayer_timings_cubit.dart';
import '../presentation/bottom_bar/screens/quran/cubit/quran_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatefulWidget {
  const MyApp._internal();

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


  static const MyApp _instance = MyApp._internal();

  factory MyApp() => _instance;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppPreferences _preferences = instance<AppPreferences>();
  String initialRoute = Routes.homeRoute; // Default route

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Handle the first launch logic synchronously
    _handleFirstLaunch();

    _preferences.getAppLocale().then((locale) => context.setLocale(locale));
  }

  // Synchronous first launch check
  Future<void> _handleFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

    if (isFirstLaunch) {
      await prefs.setBool('isFirstLaunch', false);
      setState(() {
        initialRoute = Routes.splashRoute; // Set to splash screen for first launch
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return SafeArea(
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (BuildContext context) => instance<HomeCubit>()..getLocation()..isThereABookMarked()),
              BlocProvider(create: (BuildContext context) => instance<QuranCubit>()..getQuranData()..getQuranSearchData()),
              //BlocProvider(create: (BuildContext context) => instance<QuranSliderProviderX>()),
              BlocProvider(create: (BuildContext context) => instance<PrayerTimingsCubit>()..getPrayerTimings()..isNetworkConnected()),
              BlocProvider(create: (BuildContext context) => instance<AdhkarCubit>()..getAdhkarData()),
              BlocProvider(create: (BuildContext context) => instance<CustomAdhkarCubit>()..getAllCustomAdhkar()),
            ],
            child: BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                return MaterialApp(
                  navigatorKey: MyApp.navigatorKey,
                  debugShowCheckedModeBanner: false,
                  localizationsDelegates: context.localizationDelegates,
                  supportedLocales: context.supportedLocales,
                  locale: context.locale,
                  theme: getApplicationLightTheme(),
                  initialRoute: initialRoute, // Use the computed initialRoute
                  onGenerateRoute: (settings) {
                    // Handle KhetmaPlanPage route
                    if (settings.name == Routes.dailyWerdRoute) {
                      final args = settings.arguments as Khetma;
                      return MaterialPageRoute(
                        builder: (_) => WerdScreen(initialKhetma: args),
                      );
                    }
                    // Handle other routes
                    return RoutesGenerator.getRoute(settings);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
