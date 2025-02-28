import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:momen/app/resources/color_manager.dart';
import 'package:momen/app/resources/routes_manager.dart';
import 'package:momen/app/resources/values.dart';

class PreviousWerd extends StatefulWidget {
  @override
  _NextPreviousState createState() => _NextPreviousState();
}

class _NextPreviousState extends State<PreviousWerd> {


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
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          ],
        ),
      ),
    );
  }
}
