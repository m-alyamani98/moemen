import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moemen/app/utils/extensions.dart';
import '../../../../../app/resources/resources.dart';
import '../../../../../domain/models/adhkar/adhkar_model.dart';
import '../cubit/adhkar_cubit.dart';
import 'dart:ui' as ui;
import 'all_adhkar_screen.dart';

class AdhkarScreen extends StatelessWidget {
  const AdhkarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale; // Get current locale

    return BlocBuilder<AdhkarCubit, AdhkarState>(
      builder: (context, state) {
        AdhkarCubit cubit = AdhkarCubit.get(context);
        List<AdhkarModel> adhkarList = cubit.adhkarList;

        return Padding(
          padding: const EdgeInsets.all(2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AllAdhkarScreen()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorManager.white,
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  height: 50,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.allAdhkar.tr(),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(color: ColorManager.textPrimary),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: AppSize.s20.h,
              ),
              ConditionalBuilder(
                condition: adhkarList.isNotEmpty,
                builder: (BuildContext context) {
                  // Get unique categories with their icons
                  final categories = adhkarList
                      .fold<Map<String, IconData>>({}, (map, adhkar) {
                    final categoryKey = adhkar.category[currentLocale.languageCode] ?? adhkar.category['ar']!;
                    if (!map.containsKey(categoryKey)) {
                      map[categoryKey] = adhkar.icon;
                    }
                    return map;
                  }).entries.toList();

                  return SizedBox(
                    height: 400,
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
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
                                .category['ar'] ?? '',
                          ),
                          context: context,
                          icon: category.value,
                          index: index,
                        );
                      },
                      itemCount: 9, // Dynamic item count
                    ),
                  );
                },
                fallback: (BuildContext context) {
                  return const Center(
                    child: CircularProgressIndicator(color: ColorManager.primary),
                  );
                },
              ),
            ],
          ),
        );
      },
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
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8),
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
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}