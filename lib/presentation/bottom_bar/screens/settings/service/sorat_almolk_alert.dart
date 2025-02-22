import 'package:easy_localization/easy_localization.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:momen/app/resources/color_manager.dart';
import 'package:momen/app/resources/strings_manager.dart';
import 'package:momen/data/notification/local_notifications/notification_service.dart';
import 'package:momen/presentation/components/widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SoratAlmolkAlert extends StatefulWidget {
  @override
  _SoratAlmolkAlertState createState() => _SoratAlmolkAlertState();
}

class _SoratAlmolkAlertState extends State<SoratAlmolkAlert> {

  bool _isSoratAlmolkAlarmEnabled = false;
  TimeOfDay _soratalmolkAlarmTime = TimeOfDay(hour: 21, minute: 00);

  @override
  void initState() {
    super.initState();
    _loadSavedSettings();
  }

  Future<void> _loadSavedSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isSoratAlmolkAlarmEnabled = prefs.getBool('soratalmolkAlarmAlarm') ?? false;
      _soratalmolkAlarmTime = TimeOfDay(
        hour: prefs.getInt('soratalmolkAlarmHour') ?? 21,
        minute: prefs.getInt('soratalmolkAlarmMinute') ?? 00,
      );
    });
  }

  void _handleMorningAlarmToggle(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    final notiService = NotiService();

    setState(() => _isSoratAlmolkAlarmEnabled = value);

    if (value) {
      await notiService.scheduleNotification(
        id: 4,
        title: AppStrings.adhkarAlarm.tr(),
        body: AppStrings.soratAlMolkAlarm.tr(),
        hour: _soratalmolkAlarmTime.hour,
        minute: _soratalmolkAlarmTime.minute,
      );
    } else {
      await notiService.cancelAllNotifications();
    }

    await prefs.setBool('SoratAlmolkAlarm', value);
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _soratalmolkAlarmTime,
    );

    if (picked != null) {
      final prefs = await SharedPreferences.getInstance();
      setState(() => _soratalmolkAlarmTime = picked);

      await prefs.setInt('soratalmolkAlarmHour', picked.hour);
      await prefs.setInt('soratalmolkAlarmMinute', picked.minute);

      if (_isSoratAlmolkAlarmEnabled) {
        await NotiService().scheduleNotification(
          id: 4,
          title: "soratalmolk",
          body: "soratalmolk",
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
      settingName: AppStrings.soratAlMolkAlarm.tr(),
      context: context,
      color: ColorManager.iconPrimary,
      angel: 0,
      isSwitched: _isSoratAlmolkAlarmEnabled,
      onTap: () {
        _handleMorningAlarmToggle(!_isSoratAlmolkAlarmEnabled);
      },
    );
  }
}
