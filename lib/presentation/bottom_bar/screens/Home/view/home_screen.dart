import 'package:flutter/material.dart';
import 'package:moemen/data/notification/local_notifications/notification_service.dart';
import 'package:moemen/presentation/bottom_bar/screens/adhkar/view/adhkar_screen.dart';
import 'package:moemen/presentation/bottom_bar/screens/prayer_times/view/prayer_timings_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(2),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PrayerTimingsScreen(),
            SizedBox(height: 30,),
            AdhkarScreen(),
          ],
        ),
      ),
    );
  }
}
