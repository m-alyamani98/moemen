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

class Alarm4 extends StatefulWidget {
  @override
  _Alarm4State createState() => _Alarm4State();
}

class _Alarm4State extends State<Alarm4> {
  bool _isAlarm4Enabled = false;
  TimeOfDay _alarm4Time = TimeOfDay(hour: 7, minute: 0);

  @override
  void initState() {
    super.initState();
    _loadSavedSettings();
  }

  Future<void> _loadSavedSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isAlarm4Enabled = prefs.getBool('morningAlarm') ?? false;
      _alarm4Time = TimeOfDay(
        hour: prefs.getInt('morningAlarmHour') ?? 7,
        minute: prefs.getInt('morningAlarmMinute') ?? 0,
      );
    });
    print('Loaded: $_isAlarm4Enabled at ${_alarm4Time.format(context)}');
  }

  void _handleMorningAlarmToggle(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    final notiService = NotiService();

    // Initialize notifications first
    await notiService.initNotification();

    setState(() => _isAlarm4Enabled = value);

    try {
      if (value) {
        await notiService.scheduleNotification(
          id: 8,
          title: AppStrings.werdAlarm.tr(),
          body: AppStrings.werdAlarmDesc.tr(),
          hour: _alarm4Time.hour,
          minute: _alarm4Time.minute,
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
      initialTime: _alarm4Time,
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

      setState(() => _alarm4Time = picked);

      // Save new time
      await prefs.setInt('Alarm4Hour', picked.hour);
      await prefs.setInt('Alarm4Minute', picked.minute);

      // Reschedule only if enabled
      if (_isAlarm4Enabled) {
        await notiService.cancelAllNotifications(); // Cancel old
        await notiService.scheduleNotification( // Schedule new
          id: 8,
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
          elevation: 4,
          child: ListTile(
            title: Row(
              children: [
                Text(
                  "${_alarm4Time.hour}:${_alarm4Time.minute.toString().padLeft(2, '0')} م",
                  style: TextStyle(fontSize: 16,color: ColorManager.textPrimary),
                ),
                IconButton(
                  icon: Icon(Icons.settings,color: ColorManager.iconPrimary,size: 18,),
                  onPressed: () => _selectTime(context),
                ),
              ],
            ),
            trailing: Switch(
              value: _isAlarm4Enabled,
              onChanged: (value) {
                setState(() {
                  _handleMorningAlarmToggle(!_isAlarm4Enabled);
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