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

class Alarm2 extends StatefulWidget {
  @override
  _Alarm2State createState() => _Alarm2State();
}

class _Alarm2State extends State<Alarm2> {
  bool _isAlarm2Enabled = false;
  TimeOfDay _alarm2Time = TimeOfDay(hour: 7, minute: 0);

  @override
  void initState() {
    super.initState();
    _loadSavedSettings();
  }

  Future<void> _loadSavedSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isAlarm2Enabled = prefs.getBool('morningAlarm') ?? false;
      _alarm2Time = TimeOfDay(
        hour: prefs.getInt('morningAlarmHour') ?? 7,
        minute: prefs.getInt('morningAlarmMinute') ?? 0,
      );
    });
    print('Loaded: $_isAlarm2Enabled at ${_alarm2Time.format(context)}');
  }

  void _handleMorningAlarmToggle(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    final notiService = NotiService();

    // Initialize notifications first
    await notiService.initNotification();

    setState(() => _isAlarm2Enabled = value);

    try {
      if (value) {
        await notiService.scheduleNotification(
          id: 6,
          title: AppStrings.werdAlarm.tr(),
          body: AppStrings.werdAlarmDesc.tr(),
          hour: _alarm2Time.hour,
          minute: _alarm2Time.minute,
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
      initialTime: _alarm2Time,
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

      setState(() => _alarm2Time = picked);

      // Save new time
      await prefs.setInt('Alarm2Hour', picked.hour);
      await prefs.setInt('Alarm2Minute', picked.minute);

      // Reschedule only if enabled
      if (_isAlarm2Enabled) {
        await notiService.cancelAllNotifications(); // Cancel old
        await notiService.scheduleNotification( // Schedule new
          id: 6,
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
          elevation: 2,
          child: ListTile(
            title: Row(
              children: [
                Text(
                  "${_alarm2Time.hour}:${_alarm2Time.minute.toString().padLeft(2, '0')} م",
                  style: TextStyle(fontSize: 16,color: ColorManager.textPrimary),
                ),
                IconButton(
                  icon: Icon(Icons.settings,color: ColorManager.iconPrimary,size: 18,),
                  onPressed: () => _selectTime(context),
                ),
              ],
            ),
            trailing: Switch(
              value: _isAlarm2Enabled,
              onChanged: (value) {
                setState(() {
                  _handleMorningAlarmToggle(!_isAlarm2Enabled);
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
