import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moemen/app/resources/color_manager.dart';
import 'package:moemen/app/resources/resources.dart';
import 'package:moemen/app/resources/routes_manager.dart';
import 'package:moemen/app/resources/values.dart';

class QiblahScreen extends StatefulWidget {
  const QiblahScreen({super.key});

  @override
  State<QiblahScreen> createState() => _QiblahScreenState();
}

Animation<double>? animation;
AnimationController? _animationController;
double begin = 0.0;

class _QiblahScreenState extends State<QiblahScreen> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    animation = Tween(begin: 0.0, end: 0.0).animate(_animationController!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text(
              AppStrings.qiblaDirection.tr(),
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: ColorManager.primary),
            ),
            leading: IconButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QiblahScreen(), // Replace with the page you want to navigate to
                ),
              ),
              icon: SvgPicture.asset(
                'assets/images/logoico.svg',
                width: AppSize.s20.r,
                height: AppSize.s20.r,
              ),
            ),
            actions:[
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(FluentIcons.chevron_left_48_regular,color: ColorManager.iconPrimary,),

              )
            ]
        ),
        body: StreamBuilder(
          stream: FlutterQiblah.qiblahStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(alignment: Alignment.center, child: const CircularProgressIndicator(color: Colors.white,));
            }

            final qiblahDirection = snapshot.data;
            animation = Tween(begin: begin, end: (qiblahDirection!.qiblah * (pi / 180) * -1)).animate(_animationController!);
            begin = (qiblahDirection.qiblah * (pi / 180) * -1);
            _animationController!.forward(from: 0);

            return Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${qiblahDirection.direction.toInt()}°",
                      style: const TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                        height: 500,
                        child: AnimatedBuilder(
                          animation: animation!,
                          builder: (context, child) => Transform.rotate(
                              angle: animation!.value,
                              child: Image.asset(
                                'assets/images/qibla.png',
                              )),
                        ))
                  ]),
            );
          },
        ),
      ),
    );
  }
}