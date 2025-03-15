import 'dart:async';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:moemen/app/resources/color_manager.dart';
import 'package:moemen/app/resources/strings_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../data/notification/local_notifications/notification_service.dart';

void requestNotificationPermission() async {
  if (!await AwesomeNotifications().isNotificationAllowed()) {
    bool granted = await AwesomeNotifications().requestPermissionToSendNotifications();
    print('Notification permission granted: $granted');
  }
}


class MorningAlert extends StatefulWidget {
  @override
  _MorningAlertState createState() => _MorningAlertState();
}

class _MorningAlertState extends State<MorningAlert> {
  bool _isMorningAlarmEnabled = false;
  Timer? _timer;


  @override
  void initState() {
    super.initState();
    _loadSavedSettings();
    requestNotificationPermission();
  }


  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadSavedSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isMorningAlarmEnabled = prefs.getBool('morningAlarm') ?? false;
    });
  }

  void _handlemorningAlarmToggle(bool value) async {
    final prefs = await SharedPreferences.getInstance();


    setState(() => _isMorningAlarmEnabled = value);

    await prefs.setBool('morningAlarm', value);
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
        bool newValue = !_isMorningAlarmEnabled;
        _handlemorningAlarmToggle(newValue);

        if (newValue) {

          NotificationController.scheduleNewNotification(
            targetHour: 6,
            targetMinute: 00,
            title: AppStrings.adhkarAlarm.tr(),
            message: AppStrings.adhkarMorningAlarm.tr(), );
        } else {
          NotificationController.cancelNotifications();
        }
      },
    );
  }
}


// ignore: must_be_immutable
class SwitchTileWidget extends StatelessWidget {
  IconData? icon;
  Color color;
  double angel;
  String settingName;
  Function onTap;
  BuildContext context;
  bool isSwitched;

  SwitchTileWidget({
    Key? key,
    this.icon = Icons.settings,
    this.color = Colors.black,
    this.angel = 0.0,
    required this.settingName,
    required this.onTap,
    required this.context,
    required this.isSwitched,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 0),
            child: Transform.rotate(
              angle: angel, // Rotation angle for SVG or icon
              child: Icon(
                icon,
                size: 22,
                color: color,
              ),
            ),
          ),
          const Spacer(flex: 1),
          Text(
            settingName,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: 14,
              wordSpacing: 3,
              letterSpacing: 0.5,
            ),
          ),
          const Spacer(flex: 5),
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
                      onTap(); // Handle switch change
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
