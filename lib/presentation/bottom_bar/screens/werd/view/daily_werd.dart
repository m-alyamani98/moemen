import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:momen/app/resources/color_manager.dart';
import 'package:momen/app/resources/routes_manager.dart';
import 'package:momen/app/resources/values.dart';
import 'package:momen/domain/models/quran/khetma_model.dart';
import 'package:momen/presentation/bottom_bar/screens/quran/cubit/quran_cubit.dart';
import 'package:momen/presentation/bottom_bar/screens/werd/cubit/werd_builder.dart';
import 'package:momen/presentation/components/separator.dart';
import 'package:momen/presentation/components/widget.dart';
import 'package:momen/presentation/surah_builder/view/surah_builder_view.dart';

class WerdScreen extends StatefulWidget {
  final Khetma? initialKhetma;

  const WerdScreen({Key? key, this.initialKhetma}) : super(key: key);

  @override
  _WerdScreenState createState() => _WerdScreenState();
}

class _WerdScreenState extends State<WerdScreen> {

  List<Khetma> get khetmaList => context.read<QuranCubit>().khetmaPlans;

  void fetchKhetma() {
    context.read<QuranCubit>().loadKhetmas().then((_) {
      if (mounted) setState(() {});
    });
  }


  @override
  void initState() {
    super.initState();
    debugPrint("Fetching Khetma data...");
    fetchKhetma();
  }



  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => context.read<QuranCubit>().loadKhetmas(),
      child: BlocConsumer<QuranCubit, QuranState>(
        listener: (context, state) {
          if (state is QuranErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is KhetmaFinishedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("تم إكمال الختمة بنجاح!"),
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
        buildWhen: (previous, current) => true,
        builder: (context, state) {
          if (state is QuranGetDataLoadingState) {
            return Center(child: CircularProgressIndicator());
          }

          final cubit = context.read<QuranCubit>();

          if (cubit.khetmaPlans.isEmpty) {
            return buildNoKhetmaUI(context);
          }

          try {
            final khetma = getActiveKhetma(cubit);
            final details = cubit.getCurrentWerdDetails(khetma);

            return Scaffold(
              body: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildCurrentWerdDetails(details, context, cubit, khetma),
                    buildProgressSection(khetma),
                  ],
                ),
              ),
            );
          } catch (e) {
            return buildErrorState(e.toString());
          }
        },
      ),
    );
  }

  Widget buildCurrentWerdDetails(
      Map<String, dynamic> details,
      BuildContext context,
      QuranCubit cubit,
      Khetma khetma,
      ) {
    // Fetch fresh details from the cubit
    final freshDetails = cubit.getCurrentWerdDetails(khetma);
    final start = freshDetails['start'] ?? {};
    final end = freshDetails['end'] ?? {};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Column(
          children: [
            SizedBox(height: AppSize.s20.r),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      getTitle(settingName: "من قوله تعالى", context: context),
                      getTitle(settingName: "${details['start']['juz']}", context: context),
                    ],
                  ),
                  SizedBox(height: AppSize.s90.r),
                  if (details['first_ayah'] != null)
                    Text(
                      details['first_ayah'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  SizedBox(height: AppSize.s90.r),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${details['start']['surahs']}   آية : ${details['start']['first_ayah'].numberInSurah}",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Text(
                        'صفحة : ${details['start']['page']}',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                  getSeparator(context),
                  SizedBox(height: AppSize.s20.r),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${details['end']['surahs']} آية :   ${details['end']['final_ayah'].numberInSurah}",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Text(
                        ' صفحة : ${details['end']['page']} ',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSize.s40.r),

          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: SizedBox(
                width: AppSize.s140.r,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => navigateToQuranPage(context, cubit, freshDetails),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: ColorManager.primary,
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text("قراءة الورد"),
                ),
              ),
            ),
            Center(
              child: SizedBox(
                width: AppSize.s140.r,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      final currentKhetma = getActiveKhetma(cubit);

                      await cubit.completeCurrentWerd(currentKhetma);

                      // Explicitly refresh UI
                      if (mounted) setState(() {});

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("تم تحديث التقدم بنجاح"),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("حدث خطأ: ${e.toString()}"),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: ColorManager.secondPrimary,
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text("أتممت القراءة"),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Khetma getActiveKhetma(QuranCubit cubit) {
    if (widget.initialKhetma != null) {
      final initialKhetma = widget.initialKhetma!;
      final index = cubit.khetmaPlans.indexWhere((k) => k.id == initialKhetma.id);

      if (index != -1) {
        return cubit.khetmaPlans[index].copyWith(
          currentDayIndex: initialKhetma.currentDayIndex.clamp(0, cubit.khetmaPlans[index].days.length - 1),
        );
      }
    }

    if (cubit.khetmaPlans.isEmpty) {
      throw Exception("No Khetma available");
    }

    final firstKhetma = cubit.khetmaPlans.first;
    return firstKhetma.copyWith(
      currentDayIndex: firstKhetma.currentDayIndex.clamp(0, firstKhetma.days.length - 1),
    );
  }
}