import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../app/resources/resources.dart';
import '../screens/Home/view/home_screen.dart';
import '../screens/adhkar/view/adhkar_screen.dart';
import '../screens/prayer_times/cubit/prayer_timings_cubit.dart';
import '../screens/quran/view/quran_screen.dart';
import '../screens/settings/view/settings_screen.dart';
import '../screens/werd/view/daily_werd.dart';

class HomeViewModel {
  HomeViewModel();

  List<Widget> screens = [
    const HomeScreen(),
    WerdScreen(),
    const QuranScreen(),
    SettingsScreen(),
  ];

  // Return appropriate title based on screen index
  Widget getTitle(int index, BuildContext context) {
    switch (index) {
      case 0: // Home screen
        return BlocBuilder<PrayerTimingsCubit, PrayerTimingsState>(
          builder: (context, state) {
            final prayerCubit = context.read<PrayerTimingsCubit>();

            if (state is GetLocationLoadingState) {
              return Text(
                AppStrings.noLocationFound.tr(),
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              );
            }

            if (state is GetLocationErrorState) {
              return Text(
                state.error,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              );
            }

            return Text(
              prayerCubit.recordLocation.$1.isNotEmpty
                  ? "${prayerCubit.recordLocation.$1}, ${prayerCubit.recordLocation.$2}"
                  : AppStrings.noLocationFound.tr(),
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        );
      case 1:
        return Text(AppStrings.werd.tr());
      case 2:
        return Text(AppStrings.fahras.tr());
      case 3:
        return Text(AppStrings.settings.tr());
      default:
        return const SizedBox.shrink();
    }
  }
}