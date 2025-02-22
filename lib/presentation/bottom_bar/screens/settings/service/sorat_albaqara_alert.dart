import 'package:easy_localization/easy_localization.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:momen/app/resources/color_manager.dart';
import 'package:momen/app/resources/strings_manager.dart';
import 'package:momen/data/notification/local_notifications/notification_service.dart';
import 'package:momen/presentation/components/widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SoratAlbaqarahAlert extends StatefulWidget {
  @override
  _SoratAlbaqarahAlertState createState() => _SoratAlbaqarahAlertState();
}

class _SoratAlbaqarahAlertState extends State<SoratAlbaqarahAlert> {

  bool _isSoratAlbaqarahAlarmEnabled = false;
  TimeOfDay _soratalbaqarahAlarmTime = TimeOfDay(hour: 21, minute: 00);

  @override
  void initState() {
    super.initState();
    _loadSavedSettings();
  }

  Future<void> _loadSavedSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isSoratAlbaqarahAlarmEnabled = prefs.getBool('soratalbaqarahAlarmAlarm') ?? false;
      _soratalbaqarahAlarmTime = TimeOfDay(
        hour: prefs.getInt('soratalbaqarahAlarmHour') ?? 21,
        minute: prefs.getInt('soratalbaqarahAlarmMinute') ?? 00,
      );
    });
  }

  void _handleMorningAlarmToggle(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    final notiService = NotiService();

    setState(() => _isSoratAlbaqarahAlarmEnabled = value);

    if (value) {
      await notiService.scheduleNotification(
        id: 3,
        title: AppStrings.adhkarAlarm.tr(),
        body: AppStrings.soratAlBaqarahAlarm.tr(),
        hour: _soratalbaqarahAlarmTime.hour,
        minute: _soratalbaqarahAlarmTime.minute,
      );
    } else {
      await notiService.cancelAllNotifications();
    }

    await prefs.setBool('SoratAlbaqarahAlarm', value);
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _soratalbaqarahAlarmTime,
    );

    if (picked != null) {
      final prefs = await SharedPreferences.getInstance();
      setState(() => _soratalbaqarahAlarmTime = picked);

      await prefs.setInt('soratalbaqarahAlarmHour', picked.hour);
      await prefs.setInt('soratalbaqarahAlarmMinute', picked.minute);

      if (_isSoratAlbaqarahAlarmEnabled) {
        await NotiService().scheduleNotification(
          id: 3,
          title: AppStrings.adhkarAlarm.tr(),
          body: AppStrings.soratAlBaqarahAlarm.tr(),
          hour: picked.hour,
          minute: picked.minute,
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return SwitchTileWidget(
      icon: FluentIcons.clock_48_regular,
      settingName: AppStrings.soratAlBaqarahAlarm.tr(),
      context: context,
      color: ColorManager.iconPrimary,
      angel: 0,
      isSwitched: _isSoratAlbaqarahAlarmEnabled,
      onTap: () {
        _handleMorningAlarmToggle(!_isSoratAlbaqarahAlarmEnabled);
      },
    );
  }
}
