import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moemen/app/resources/color_manager.dart';
import 'package:moemen/app/resources/routes_manager.dart';
import 'package:moemen/app/resources/values.dart';
import 'package:moemen/presentation/components/widget.dart';

import 'alarm1.dart';
import 'alarm2.dart';
import 'alarm3.dart';
import 'alarm4.dart';
import 'alarm5.dart';

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
          "المنبه اليومي ",
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
            onPressed: () => Navigator.pop(context),
            icon: Icon(FluentIcons.chevron_left_48_regular,color: ColorManager.iconPrimary,),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            getTitle(settingName: "يمكنك تحديد وقت المنيه لتذكيرك بالورد اليومي", context: context),
            SizedBox(height: 20),
            Alarm1(),
            Alarm2(),
            Alarm3(),
            Alarm4(),
            Alarm5(),
          ],
        ),
      ),
    );
  }

}
