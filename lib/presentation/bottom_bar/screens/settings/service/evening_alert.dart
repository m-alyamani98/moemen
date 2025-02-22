import 'package:easy_localization/easy_localization.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:momen/app/resources/color_manager.dart';
import 'package:momen/app/resources/strings_manager.dart';
import 'package:momen/data/notification/local_notifications/notification_service.dart';
import 'package:momen/presentation/components/widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EveningAlert extends StatefulWidget {
  @override
  _EveningAlertState createState() => _EveningAlertState();
}

class _EveningAlertState extends State<EveningAlert> {

  // In your stateful widget
  bool _isEveningAlarmEnabled = false;
  TimeOfDay _eveningAlarmTime = TimeOfDay(hour: 17, minute: 30); // Default morning time

  @override
  void initState() {
    super.initState();
    _loadSavedSettings();
  }

  Future<void> _loadSavedSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isEveningAlarmEnabled = prefs.getBool('morningAlarm') ?? false;
      _eveningAlarmTime = TimeOfDay(
        hour: prefs.getInt('morningAlarmHour') ?? 17,
        minute: prefs.getInt('morningAlarmMinute') ?? 30,
      );
    });
  }

  void _handleMorningAlarmToggle(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    final notiService = NotiService();

    setState(() => _isEveningAlarmEnabled = value);

    if (value) {
      // Schedule notification when enabled
      await notiService.scheduleNotification(
        id: 2, // Unique ID for morning notification
        title: AppStrings.adhkarAlarm.tr(),
        body: AppStrings.adhkarEveningAlarm.tr(),
        hour: _eveningAlarmTime.hour,
        minute: _eveningAlarmTime.minute,
      );
    } else {
      // Cancel notification when disabled
      await notiService.cancelAllNotifications();
    }

    await prefs.setBool('morningAlarm', value);
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _eveningAlarmTime,
    );

    if (picked != null) {
      final prefs = await SharedPreferences.getInstance();
      setState(() => _eveningAlarmTime = picked);

      await prefs.setInt('morningAlarmHour', picked.hour);
      await prefs.setInt('morningAlarmMinute', picked.minute);

      // Reschedule if enabled
      if (_isEveningAlarmEnabled) {
        await NotiService().scheduleNotification(
          id: 2,
          title: AppStrings.adhkarAlarm.tr(),
          body: AppStrings.adhkarEveningAlarm.tr(),
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
      settingName: AppStrings.adhkarEveningAlarm.tr(),
      context: context,
      color: ColorManager.iconPrimary,
      angel: 0,
      isSwitched: _isEveningAlarmEnabled,
      onTap: () {
        _handleMorningAlarmToggle(!_isEveningAlarmEnabled);
      },
    );
  }
}
