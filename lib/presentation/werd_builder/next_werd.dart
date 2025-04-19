import 'package:easy_localization/easy_localization.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moemen/app/resources/color_manager.dart';
import 'package:moemen/app/resources/routes_manager.dart';
import 'package:moemen/app/resources/strings_manager.dart';
import 'package:moemen/app/resources/values.dart';
import 'package:moemen/domain/models/quran/khetma_model.dart';

import '../bottom_bar/screens/quran/cubit/quran_cubit.dart';

class NextWerd extends StatelessWidget {

  final Khetma khetma;

  const NextWerd({super.key, required this.khetma});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<QuranCubit>();
    final upcoming = cubit.getUpcomingWerdsDetails(khetma);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          AppStrings.nextWerd.tr(),
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
      body: upcoming.isEmpty
          ? Center(
          child: Text(
            "noUpcomingWerds",
            style: TextStyle(fontSize: 18.sp),
          ))
          : ListView.separated(
        padding: EdgeInsets.all(16.w),
        itemCount: upcoming.length,
        separatorBuilder: (_, __) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          final details = upcoming[index];
          final originalIndex = khetma.currentDayIndex + index + 1;

          return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: ColorManager.iconPrimary,
                  width: 0.1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: ColorManager.grey,
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(' ${AppStrings.alwerd.tr()} ${originalIndex + 1}',style: TextStyle(color: ColorManager.primary),),
                    Text('${AppStrings.from.tr()} ${details['start']['surahs']} - ${AppStrings.ayah.tr()} ${details['start']['first_ayah'].numberInSurah}',style: TextStyle(color: ColorManager.secondPrimary,),),
                    Text('${AppStrings.to.tr()} ${details['start']['surahs']} - ${AppStrings.ayah.tr()} ${details['end']['final_ayah'].numberInSurah}',style: TextStyle(color: ColorManager.secondPrimary,),),
                    Text('${AppStrings.page.tr()} ${details['start']['page']} ${AppStrings.to.tr()} ${details['end']['page']}',style: TextStyle(color: ColorManager.grey,),),
                  ],
                ),
              )
          );
        },
      ),
    );
  }
}