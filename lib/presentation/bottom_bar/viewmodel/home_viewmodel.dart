import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:momen/domain/models/quran/khetma_model.dart';
import 'package:momen/presentation/bottom_bar/screens/Home/view/home_screen.dart';
import 'package:momen/presentation/bottom_bar/screens/prayer_times/view/prayer_timings_screen.dart';
import 'package:momen/presentation/bottom_bar/screens/quran/cubit/quran_cubit.dart';
import 'package:momen/presentation/bottom_bar/screens/werd/view/daily_werd.dart';
import '../../../../../app/resources/resources.dart';
import '../screens/adhkar/view/adhkar_screen.dart';
import '../screens/quran/view/quran_screen.dart';
import '../screens/settings/view/settings_screen.dart';


class HomeViewModel {
  HomeViewModel();

  List<Widget> screens = [
    const HomeScreen(),
    WerdScreen(),
    const QuranScreen(),
    const SettingsScreen(),
  ];

  List<String> titles = [
    AppStrings.home.tr(),
    AppStrings.werd.tr(),
    AppStrings.fahras.tr(),
    AppStrings.settings.tr(),
  ];
}
