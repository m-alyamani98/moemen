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
              'assets/images/splash.svg',
              width: AppSize.s300.r,
              height: AppSize.s300.r,
            ),
            SizedBox(height: AppSize.s100.r),
            Center(
              child: SizedBox(
                width: AppSize.s250.r,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, Routes.newKhetmaRoute);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: ColorManager.primary,
                    backgroundColor: ColorManager.white,
                    textStyle: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(AppStrings.startNow.tr()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}