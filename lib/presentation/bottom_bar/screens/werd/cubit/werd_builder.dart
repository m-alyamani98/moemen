import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:momen/app/resources/color_manager.dart';
import 'package:momen/app/resources/values.dart';
import 'package:momen/domain/models/quran/khetma_model.dart';
import 'package:momen/presentation/bottom_bar/screens/quran/cubit/quran_cubit.dart';
import 'package:momen/presentation/surah_builder/view/surah_builder_view.dart';
import 'package:momen/presentation/werd_builder/new_khetma.dart';


Widget buildErrorState(String error) {
  return Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 40.w, color: Colors.red),
          SizedBox(height: 16.h),
          Text(
            "حدث خطأ في تحميل الخطة:",
            style: TextStyle(fontSize: 16.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            error,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

Widget buildProgressSection(Khetma khetma) {
  final safeIndex = khetma.currentDayIndex.clamp(0, khetma.days.length - 1);
  final progress = khetma.days.isNotEmpty
      ? (safeIndex / khetma.durationDays).clamp(0.0, 1.0)
      : 0.0;
  final nextWerd = khetma.durationDays - khetma.currentDayIndex;

  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildProgressItem("الأوراد السابقة :", khetma.currentDayIndex),
          buildProgressItem("المتبقية  :", nextWerd),
        ],
      ),
      const SizedBox(height: 8),
      LinearProgressIndicator(
        value: progress,
        minHeight: 8.h,
        backgroundColor: Colors.grey[200],
        valueColor: AlwaysStoppedAnimation<Color>(ColorManager.primary),
        borderRadius: BorderRadius.circular(8.r),
      ),
      SizedBox(height: 12.h),
      Text(
        'الختمة الحالية',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ],
  );
}

Widget buildProgressItem(String title, int value) {
  return Row(
    children: [
      Text(title, style: TextStyle(fontSize: 14, color: Colors.grey),),
      Text("$value", style: TextStyle(fontSize: 14, color: Colors.grey),),
    ],
  );
}


Widget buildNoKhetmaUI(BuildContext context) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.auto_stories, size: 80.w, color: Colors.grey),
        SizedBox(height: 20.h),
        Text(
          "لا يوجد ختمة حالية",
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 20.h),
        Center(
          child: SizedBox(
            width: AppSize.s250,
            height: 50,
            child: ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewKhetmaPage(),
                ),
              ),
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
              child: Text("إنشاء ختمة جديدة"),
            ),
          ),
        ),
      ],
    ),
  );
}


void navigateToQuranPage(BuildContext context, QuranCubit cubit, Map<String, dynamic> details) {
  final startPage = details['start']['page'];
  debugPrint("Navigating to page: $startPage"); // Debugging log

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => SurahBuilderView(
        quranList: cubit.quranData,
        pageNo: startPage,
      ),
    ),
  );
}
