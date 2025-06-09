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
    final currentLocale = context.locale; // Get current locale from EasyLocalization

    return Scaffold(
      // ... existing appBar code ...
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
                  final categoryKey = adhkar.category[currentLocale.languageCode] ?? adhkar.category['ar']!;
                  if (!map.containsKey(categoryKey)) {
                    map[categoryKey] = adhkar.icon;
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
                        categoryName: adhkarList
                            .firstWhere((a) => a.category[currentLocale.languageCode] == category.key)
                            .category['ar']!,
                      ),
                      context: context,
                      icon: category.value,
                      index: index,
                    );
                  },
                  itemCount: categories.length,
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

  Widget _adhkarIndexItem({
    required String adhkarId,
    required IconData icon,
    required String adhkarCategory,
    required List<AdhkarModel> adhkarList,
    required int index,
    required BuildContext context,
  }) {
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
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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