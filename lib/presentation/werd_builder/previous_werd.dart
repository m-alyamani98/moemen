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
import 'package:moemen/presentation/bottom_bar/screens/quran/cubit/quran_cubit.dart';
import 'package:moemen/presentation/components/widget.dart';

class PreviousWerdsScreen extends StatelessWidget {
  final Khetma khetma;

  const PreviousWerdsScreen({super.key, required this.khetma});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          AppStrings.previousWerd.tr(),
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
      body: BlocBuilder<QuranCubit, QuranState>(
        builder: (context, state) {
          final cubit = context.read<QuranCubit>();

          return ListView.separated(
            padding: EdgeInsets.all(16.w),
            itemCount: khetma.currentDayIndex,
            separatorBuilder: (_, __) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              final day = khetma.days[index];
              final details = cubit.getWerdDetails(khetma, index);
              final Index = index  ;

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
                      Text(' ${AppStrings.alwerd.tr()} ${Index + 1}',style: TextStyle(color: ColorManager.primary),),
                      Text('${AppStrings.from.tr()} ${details['start']['surahs']} - ${AppStrings.ayah.tr()} ${details['start']['first_ayah'].numberInSurah}',style: TextStyle(color: ColorManager.red,),),
                      Text('${AppStrings.to.tr()} ${details['start']['surahs']} - ${AppStrings.ayah.tr()} ${details['end']['final_ayah'].numberInSurah}',style: TextStyle(color: ColorManager.red,),),
                      Text('${AppStrings.page.tr()} ${details['start']['page']} ${AppStrings.to.tr()} ${details['end']['page']}',style: TextStyle(color: ColorManager.grey,),),
                    ],
                  ),
                )
              );
            },
          );
        },
      ),
    );
  }
}
