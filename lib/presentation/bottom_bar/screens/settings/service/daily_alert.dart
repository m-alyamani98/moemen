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
import 'package:momen/presentation/components/separator.dart';
import 'package:momen/presentation/components/widget.dart';

class DailyAlert extends StatefulWidget {
  @override
  _DailyAlertState createState() => _DailyAlertState();
}

class _DailyAlertState extends State<DailyAlert> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          "دعم التطبيق ",
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: ColorManager.primary),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: SvgPicture.asset(
            'assets/images/logoico.svg',
            width: AppSize.s20.r,
            height: AppSize.s20.r,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, Routes.homeRoute),
            icon: Icon(FluentIcons.chevron_left_48_regular,color: ColorManager.iconPrimary,),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(top: AppPadding.p18.h),
        child: ListView(
          children: [
            SwitchTileWidget(
              icon: FluentIcons.weather_sunny_48_regular,
              settingName: AppStrings.adhkarMorningAlarm.tr(),
              onTap: () {},
              context: context,
              color: ColorManager.iconPrimary,
              angel: 0,
              isSwitched: true,
            ),
            getSeparator(context),
            ElevatedButton(
                onPressed:() {
                }, child: Text('Send'),
                )
          ],
        ),
      )
    );
  }

}
