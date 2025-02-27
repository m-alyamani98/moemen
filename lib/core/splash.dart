import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:momen/app/resources/resources.dart';
import 'package:momen/app/resources/routes_manager.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 20), () {
      Navigator.pushReplacementNamed(context, Routes.newKhetmaRoute);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.splashBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/logoico.svg',
              width: AppSize.s200.r,
              height: AppSize.s200.r,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, Routes.newKhetmaRoute);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.lightBackground, // Button color
                foregroundColor: ColorManager.primary,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12), // Button padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50), // Rounded corners
                ),
                elevation: 5, // Shadow effect
              ),
              child: Text(
                AppStrings.startNow.tr(),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}