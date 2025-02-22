import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:momen/app/resources/color_manager.dart';
import 'package:momen/data/notification/local_notifications/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Alarm1 extends StatefulWidget {
  @override
  _Alarm1State createState() => _Alarm1State();
}

class _Alarm1State extends State<Alarm1> {
  bool _isAlarm1Enabled = false;
  TimeOfDay _alarm1Time = TimeOfDay(hour: 7, minute: 0);

  @override
  void initState() {
    super.initState();
    _loadSavedSettings();
  }

  Future<void> _loadSavedSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isAlarm1Enabled = prefs.getBool('morningAlarm') ?? false;
      _alarm1Time = TimeOfDay(
        hour: prefs.getInt('morningAlarmHour') ?? 7,
        minute: prefs.getInt('morningAlarmMinute') ?? 0,
      );
    });
    print('Loaded: $_isAlarm1Enabled at ${_alarm1Time.format(context)}');
  }

  void _handleMorningAlarmToggle(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    final notiService = NotiService();

    // Initialize notifications first
    await notiService.initNotification();

    setState(() => _isAlarm1Enabled = value);

    try {
      if (value) {
        await notiService.scheduleNotification(
          id: 5,
          title: "AppStrings.morningAdhkarReminder.tr()",
          body: "AppStrings.morningAdhkarNotificationBody.tr()",
          hour: _alarm1Time.hour,
          minute: _alarm1Time.minute,
        );
        print('Notification scheduled for ${_alarm1Time.format(context)}');
      } else {
        await notiService.cancelAllNotifications();
        print('All notifications canceled');
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
      initialTime: _alarm1Time,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            primaryColor: ColorManager.primary,
            hintColor: ColorManager.primary,
            colorScheme: ColorScheme.light(primary: ColorManager.primary),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final prefs = await SharedPreferences.getInstance();
      final notiService = NotiService();
      await notiService.initNotification();

      setState(() => _alarm1Time = picked);

      // Save new time
      await prefs.setInt('morningAlarmHour', picked.hour);
      await prefs.setInt('morningAlarmMinute', picked.minute);

      // Reschedule only if enabled
      if (_isAlarm1Enabled) {
        await notiService.cancelAllNotifications(); // Cancel old
        await notiService.scheduleNotification( // Schedule new
          id: 5,
          title: "AppStrings.morningAdhkarReminder.tr()",
          body: "AppStrings.morningAdhkarNotificationBody.tr()",
          hour: picked.hour,
          minute: picked.minute,
        );
        print('Notification rescheduled for ${picked.format(context)}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 2,
          child: ListTile(
            title: Row(
              children: [
                Text(
                  "${_alarm1Time.hour}:${_alarm1Time.minute.toString().padLeft(2, '0')}",
                  style: TextStyle(fontSize: 16, color: ColorManager.textPrimary),
                ),
                IconButton(
                  icon: Icon(Icons.settings, color: ColorManager.iconPrimary, size: 18),
                  onPressed: () => _selectTime(context),
                ),
              ],
            ),
            trailing: Switch(
              value: _isAlarm1Enabled,
              onChanged: (value) {
                _handleMorningAlarmToggle(value);
              },
              activeColor: ColorManager.primary,
              activeTrackColor: ColorManager.accentPrimary,
              inactiveThumbColor: Colors.grey,
              inactiveTrackColor: Colors.black12,
            ),
          ),
        ),
      ],
    );
  }
}