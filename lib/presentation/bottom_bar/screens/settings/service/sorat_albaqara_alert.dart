import 'package:easy_localization/easy_localization.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:moemen/app/resources/color_manager.dart';
import 'package:moemen/app/resources/strings_manager.dart';
import 'package:moemen/data/notification/local_notifications/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SoratAlbaqarahAlert extends StatefulWidget {
  @override
  _SoratAlbaqaraAlertState createState() => _SoratAlbaqaraAlertState();
}

class _SoratAlbaqaraAlertState extends State<SoratAlbaqarahAlert> {
  bool _isSoratAlbaqarahAlarmEnabled = false;
  TimeOfDay _soratAlbaqarahAlarmTime = TimeOfDay(hour: 2, minute: 30);

  @override
  void initState() {
    super.initState();
    _loadSavedSettings();
  }

  Future<void> _loadSavedSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isSoratAlbaqarahAlarmEnabled = prefs.getBool('soratAlbaqarahAlarm') ?? false;
      _soratAlbaqarahAlarmTime = TimeOfDay(
        hour: prefs.getInt('soratAlbaqarahAlarmHour') ?? 2,
        minute: prefs.getInt('soratAlbaqarahAlarmMinute') ?? 30,
      );
    });
  }

  void _handlesoratAlbaqarahAlarmToggle(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    setState(() => _isSoratAlbaqarahAlarmEnabled = value);



    await prefs.setBool('soratAlbaqarahAlarm', value);
    await prefs.setInt('soratAlbaqarahAlarmHour', _soratAlbaqarahAlarmTime.hour);
    await prefs.setInt('soratAlbaqarahAlarmMinute', _soratAlbaqarahAlarmTime.minute);
  }

  @override
  Widget build(BuildContext context) {
    return SwitchTileWidget(
      icon: FluentIcons.clock_alarm_48_regular,
      settingName: AppStrings.soratAlBaqarahAlarm.tr(),
      context: context,
      color: ColorManager.iconPrimary,
      angel: 0,
      isSwitched: _isSoratAlbaqarahAlarmEnabled,
      onTap: () {
        bool newValue = !_isSoratAlbaqarahAlarmEnabled;
        _handlesoratAlbaqarahAlarmToggle(newValue);

        if (newValue) {

          NotificationController.scheduleNewNotification(
            targetHour: 20,
            targetMinute: 30,
            title: AppStrings.sonanAlarm.tr(),
            message: AppStrings.soratAlBaqarahAlarm, );
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
                    inactiveThumbColor: ColorManager.iconPrimary, // Color of the thumb when inactive
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
