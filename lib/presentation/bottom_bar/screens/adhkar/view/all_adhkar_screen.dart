import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moemen/app/utils/extensions.dart';
import '../../../../../app/resources/resources.dart';
import '../../../../../domain/models/adhkar/adhkar_model.dart';
import '../cubit/adhkar_cubit.dart';
import 'dart:ui' as ui;

class AllAdhkarScreen extends StatelessWidget {
  AllAdhkarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          AppStrings.allAdhkar.tr(),
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
            icon: Icon(FluentIcons.chevron_left_48_regular, color: ColorManager.iconPrimary),
          )
        ],
      ),
      body: BlocBuilder<AdhkarCubit, AdhkarState>(
        builder: (context, state) {
          AdhkarCubit cubit = AdhkarCubit.get(context);
          List<AdhkarModel> adhkarList = cubit.adhkarList;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: ConditionalBuilder(
              condition: adhkarList.isNotEmpty,
              builder: (BuildContext context) {
                final categories = adhkarList.fold<Map<String, IconData>>({}, (map, adhkar) {
                  if (!map.containsKey(adhkar.category)) {
                    map[adhkar.category] = adhkar.icon;
                  }
                  return map;
                }).entries.toList();

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 30,
                    mainAxisSpacing: 15,
                    childAspectRatio: 1.0,
                  ),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return _adhkarIndexItem(
                      adhkarId: (index + 1).toString().tr(),
                      adhkarCategory: category.key,
                      adhkarList: cubit.getAdhkarFromCategory(
                        adhkarList: adhkarList,
                        category: category.key,
                      ),
                      context: context,
                      icon: category.value,
                      index: index,
                    );
                  },
                  itemCount: cubit.getAdhkarCategories(adhkarList: adhkarList).length,
                );
              },
              fallback: (BuildContext context) {
                return const Center(
                  child: CircularProgressIndicator(color: ColorManager.primary),
                );
              },
            ),
          );
        },
      ),
    );
  }


  Widget _adhkarIndexItem(
      {required String adhkarId,
        required IconData icon,
        required String adhkarCategory,
        required List<AdhkarModel> adhkarList,
        required int index,
        // required String pageNo,
        required BuildContext context}) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppPadding.p5.h),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            Routes.adhkarRoute,
            arguments: {
              'adhkarList': adhkarList,
              'category': adhkarCategory,
            },
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: ColorManager.iconPrimary,
              width: 0.1,
            ),
            boxShadow: [
              BoxShadow(
                color: ColorManager.accentGrey,
                spreadRadius: 2,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center vertically
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 40,
                  color: ColorManager.accentPrimary,
                ),
                const SizedBox(height: 10),
                Text(
                  adhkarCategory,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontFamily: FontConstants.elMessiriFontFamily,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
