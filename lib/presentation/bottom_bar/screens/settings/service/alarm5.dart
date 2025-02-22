import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:momen/app/resources/color_manager.dart';
import 'package:momen/app/resources/strings_manager.dart';
import 'package:momen/data/notification/local_notifications/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Alarm5 extends StatefulWidget {
  @override
  _Alarm5State createState() => _Alarm5State();
}

class _Alarm5State extends State<Alarm5> {
  bool _isAlarm5Enabled = false;
  TimeOfDay _alarm5Time = TimeOfDay(hour: 7, minute: 0);

  @override
  void initState() {
    super.initState();
    _loadSavedSettings();
  }

  Future<void> _loadSavedSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isAlarm5Enabled = prefs.getBool('morningAlarm') ?? false;
      _alarm5Time = TimeOfDay(
        hour: prefs.getInt('morningAlarmHour') ?? 7,
        minute: prefs.getInt('morningAlarmMinute') ?? 0,
      );
    });
    print('Loaded: $_isAlarm5Enabled at ${_alarm5Time.format(context)}');
  }

  void _handleMorningAlarmToggle(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    final notiService = NotiService();

    // Initialize notifications first
    await notiService.initNotification();

    setState(() => _isAlarm5Enabled = value);

    try {
      if (value) {
        await notiService.scheduleNotification(
          id: 9,
          title: AppStrings.werdAlarm.tr(),
          body: AppStrings.werdAlarmDesc.tr(),
          hour: _alarm5Time.hour,
          minute: _alarm5Time.minute,
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
      initialTime: _alarm5Time,
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

      setState(() => _alarm5Time = picked);

      // Save new time
      await prefs.setInt('Alarm5Hour', picked.hour);
      await prefs.setInt('Alarm5Minute', picked.minute);

      // Reschedule only if enabled
      if (_isAlarm5Enabled) {
        await notiService.cancelAllNotifications(); // Cancel old
        await notiService.scheduleNotification( // Schedule new
          id: 9,
          title: AppStrings.werdAlarm.tr(),
          body: AppStrings.werdAlarmDesc.tr(),
          hour: picked.hour,
          minute: picked.minute,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 5,
          child: ListTile(
            title: Row(
              children: [
                Text(
                  "${_alarm5Time.hour}:${_alarm5Time.minute.toString().padLeft(2, '0')} م",
                  style: TextStyle(fontSize: 16,color: ColorManager.textPrimary),
                ),
                IconButton(
                  icon: Icon(Icons.settings,color: ColorManager.iconPrimary,size: 18,),
                  onPressed: () => _selectTime(context),
                ),
              ],
            ),
            trailing: Switch(
              value: _isAlarm5Enabled,
              onChanged: (value) {
                setState(() {
                  _handleMorningAlarmToggle(!_isAlarm5Enabled);
                });
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
