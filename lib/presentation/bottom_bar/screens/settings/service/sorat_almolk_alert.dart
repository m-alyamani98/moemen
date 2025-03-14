import 'package:easy_localization/easy_localization.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:momen/app/resources/color_manager.dart';
import 'package:momen/app/resources/strings_manager.dart';
import 'package:momen/data/notification/local_notifications/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';


void requestNotificationPermission() async {
  if (await Permission.notification.isGranted) {
    // Permission granted, proceed with scheduling notifications
  } else {
    await Permission.notification.request();
  }
}

class SoratAlmolkAlert extends StatefulWidget {
  @override
  _SoratAlmolkAlertState createState() => _SoratAlmolkAlertState();
}

class _SoratAlmolkAlertState extends State<SoratAlmolkAlert> {
  bool _isSoratAlmolkAlarmEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadSavedSettingsM();
  }

  Future<void> _loadSavedSettingsM() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isSoratAlmolkAlarmEnabled = prefs.getBool('soratAlmolkAlarm') ?? false;
    });
  }


  void _handlesoratAlmolkAlarmToggle(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _isSoratAlmolkAlarmEnabled = value;
    });
    // Save settings
    await prefs.setBool('soratAlmolkAlarm', value);
  }




  @override
  Widget build(BuildContext context) {
    return SwitchTileWidget(
      icon: FluentIcons.clock_alarm_48_regular,
      settingName: AppStrings.soratAlMolkAlarm.tr(),
      context: context,
      color: ColorManager.iconPrimary,
      angel: 0,
      isSwitched: _isSoratAlmolkAlarmEnabled,
      onTap: () {
        bool newValue = !_isSoratAlmolkAlarmEnabled;
        _handlesoratAlmolkAlarmToggle(newValue);

        if (newValue) {

          NotificationController.scheduleNewNotification(
            targetHour: 20,
            targetMinute: 00,
            title: AppStrings.sonanAlarm.tr(),
            message: AppStrings.soratAlMolkAlarm.tr(), );
        } else {
          NotificationController.cancelNotifications();
        }
      },
    );
  }
}

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
    onPopNext();
  }
}
