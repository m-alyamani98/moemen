import 'package:easy_localization/easy_localization.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:moemen/app/resources/color_manager.dart';
import 'package:moemen/data/notification/local_notifications/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../app/resources/strings_manager.dart';

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


  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadSavedSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isAlarm1Enabled = prefs.getBool('morningAlarm') ?? false;
    });
  }

  void _handleAlarm1Toggle(bool value) async {
    final prefs = await SharedPreferences.getInstance();


    setState(() => _isAlarm1Enabled = value);

    await prefs.setBool('morningAlarm', value);
  }

  Future<void> selectTime(BuildContext context) async {
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


      setState(() => _alarm1Time = picked);


    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 2,
          child: SwitchTileWidget(
            settingName: "${_alarm1Time.hour}:${_alarm1Time.minute.toString().padLeft(2, '0')}",
            context: context,
            color: ColorManager.iconPrimary,
            angel: 0,
            isSwitched: _isAlarm1Enabled,
            onTap: () {
              bool newValue = !_isAlarm1Enabled;
              _handleAlarm1Toggle(newValue);

              if (newValue) {

                NotificationController.scheduleNewNotification(
                  targetHour: _alarm1Time.hour,
                  targetMinute: _alarm1Time.minute,
                  title: AppStrings.werdAlarm.tr(),
                  message: AppStrings.werdAlarmDesc.tr(), );
              } else {
                NotificationController.cancelNotifications();
              }
            }, onPress:(){ selectTime(context);},
          ),
        ),
      ],
    );
  }
}
// ignore: must_be_immutable
class SwitchTileWidget extends StatelessWidget {
  IconData? icon;
  Color color;
  double angel;
  String settingName;
  Function onPress;
  Function onTap;
  BuildContext context;
  bool isSwitched;

  SwitchTileWidget({
    Key? key,
    this.icon = Icons.settings,
    this.color = Colors.black,
    this.angel = 0.0,
    required this.settingName,
    required this.onPress,
    required this.onTap,
    required this.context,
    required this.isSwitched,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.0,vertical: 12),
      child: Row(
        children: [
          const Spacer(flex: 1),
          Text(
            settingName,
            style: TextStyle(fontSize: 22, color: ColorManager.textPrimary),
          ),
          IconButton(
            icon: Icon(Icons.settings, color: ColorManager.iconPrimary, size: 22),
            onPressed: () {
            onPress();}
          ),
          const Spacer(flex: 10),
          InkWell(
            onTap: () {
              onTap();
            },
            child: Row(
              children: [
                Transform.scale(
                  scale: 0.8,
                  child: Switch.adaptive(
                    activeColor: ColorManager.primary,
                    activeTrackColor: ColorManager.inactiveColor,
                    inactiveThumbColor: ColorManager.iconPrimary,
                    inactiveTrackColor: ColorManager.inactiveColor,
                    value: isSwitched,
                    onChanged: (value) {
                      onTap();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MyNavigatorObserver extends NavigatorObserver {
  final VoidCallback onPopNext;

  MyNavigatorObserver({required this.onPopNext});

  @override
  void didPopNext() {
    onPopNext(); // Call the callback when returning to the page
  }
}


