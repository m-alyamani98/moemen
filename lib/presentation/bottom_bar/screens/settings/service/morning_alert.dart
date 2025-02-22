import 'package:easy_localization/easy_localization.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:in_app_purchase/in_app_purchase.dart'; // Import the in_app_purchase library
import 'package:momen/app/resources/color_manager.dart';
import 'package:momen/app/resources/routes_manager.dart';
import 'package:momen/app/resources/strings_manager.dart';
import 'package:momen/app/resources/values.dart';
import 'package:momen/data/notification/local_notifications/notification_service.dart';
import 'package:momen/presentation/components/widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MorningAlert extends StatefulWidget {
  @override
  _MorningAlertState createState() => _MorningAlertState();
}

class _MorningAlertState extends State<MorningAlert> {

  bool _isMorningAlarmEnabled = false;
  TimeOfDay _morningAlarmTime = TimeOfDay(hour: 15, minute: 40); // Default morning time

  @override
  void initState() {
    super.initState();
    _loadSavedSettings();
  }

  Future<void> _loadSavedSettings() async {
    final prefs = await SharedPreferences.getInstance();
    bool savedAlarm = prefs.getBool('morningAlarm') ?? false;
    print('Loaded morningAlarm: $savedAlarm'); // Debug print
    setState(() {
      _isMorningAlarmEnabled = savedAlarm;
      _morningAlarmTime = TimeOfDay(
        hour: prefs.getInt('morningAlarmHour') ?? 15,
        minute: prefs.getInt('morningAlarmMinute') ?? 40,
      );
    });
  }


  void _handleMorningAlarmToggle(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    final notiService = NotiService();

    // Initialize notifications first
    await notiService.initNotification();

    setState(() => _isMorningAlarmEnabled = value);

    try {
      if (value) {
        await notiService.scheduleNotification(
          id: 1,
          title: "AppStrings.morningAdhkarReminder.tr()",
          body: "AppStrings.morningAdhkarNotificationBody.tr()",
          hour: _morningAlarmTime.hour,
          minute: _morningAlarmTime.minute,
        );
      } else {
        await notiService.cancelAllNotifications();
      }

      // Save to SharedPreferences
      await prefs.setBool('morningAlarm', value);
      print('Successfully saved morningAlarm: $value'); // Debug
    } catch (e) {
      print('Error saving/scheduling: $e'); // Handle errors
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _morningAlarmTime,
    );

    if (picked != null) {
      final prefs = await SharedPreferences.getInstance();
      final notiService = NotiService();
      await notiService.initNotification();

      setState(() => _morningAlarmTime = picked);

      // Save new time
      await prefs.setInt('morningAlarmHour', picked.hour);
      await prefs.setInt('morningAlarmMinute', picked.minute);

      // Reschedule only if enabled
      if (_isMorningAlarmEnabled) {
        await notiService.cancelAllNotifications(); // Cancel old
        await notiService.scheduleNotification( // Schedule new
          id: 1,
          title: "AppStrings.morningAdhkarReminder.tr()",
          body: "AppStrings.morningAdhkarNotificationBody.tr()",
          hour: picked.hour,
          minute: picked.minute,
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return SwitchTileWidget(
      icon: FluentIcons.weather_sunny_48_regular,
      settingName: AppStrings.adhkarMorningAlarm.tr(),
      context: context,
      color: ColorManager.iconPrimary,
      angel: 0,
      isSwitched: _isMorningAlarmEnabled,
      onTap: () {
        _handleMorningAlarmToggle(!_isMorningAlarmEnabled);
      },
    );
  }
}
