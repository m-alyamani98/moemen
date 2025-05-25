import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moemen/presentation/bottom_bar/screens/prayer_times/view/prayer_timings_widget.dart';
import '../cubit/prayer_timings_cubit.dart';

class PrayerTimingsWrapper extends StatelessWidget {
  const PrayerTimingsWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PrayerTimingsCubit(), // Provide the cubit here
      child: const PrayerTimingsScreen(),
    );
  }
}
