import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moemen/app/resources/color_manager.dart';
import 'package:moemen/app/resources/routes_manager.dart';
import 'package:moemen/app/resources/strings_manager.dart';
import 'package:moemen/app/resources/values.dart';
import 'package:moemen/domain/models/quran/khetma_model.dart';
import 'package:moemen/presentation/bottom_bar/screens/quran/cubit/quran_cubit.dart';
import 'package:moemen/presentation/components/widget.dart';

class NewKhetmaPage extends StatefulWidget {
  @override
  _NewKhetmaPageState createState() => _NewKhetmaPageState();
}

class _NewKhetmaPageState extends State<NewKhetmaPage> {
  int duration = 1;
  String startingPoint = "";
  List<String> juzNames = [];
  String dailyPortion = "";
  String dailyPortion2 = "";
  String dailyPortion3 = "";
  Khetma? newKhetma;

  final Map<String, int> juzPortionMap = {
    "1 ${AppStrings.juz.tr()}": 1,
    "2 ${AppStrings.juzS.tr()}": 2,
    "3 ${AppStrings.juzM.tr()}": 3,
    "4 ${AppStrings.juzM.tr()}": 4,
    "5 ${AppStrings.juzM.tr()}": 5,
    "6 ${AppStrings.juzM.tr()}": 6,
    "7 ${AppStrings.juzM.tr()}": 7,
    "8 ${AppStrings.juzM.tr()}": 8,
    "9 ${AppStrings.juzM.tr()}": 9,
    "10 ${AppStrings.juzM.tr()}": 10,
  };

  final Map<String, int> hizbQuarterMap = {
    AppStrings.hizbQuarter.tr(): 1,
    AppStrings.hizbQuarterS.tr(): 2,
    "3 ${AppStrings.hizbQuarterM.tr()}": 3,
    AppStrings.hizb.tr(): 4, // 1 حزب = 4 أرباع
    "5 ${AppStrings.hizbQuarterM.tr()}": 5,
    "6 ${AppStrings.hizbQuarterM.tr()}": 6,
    "7 ${AppStrings.hizbQuarterM.tr()}": 7,
  };
  final Map<String, int> pagePortionMap = {
    AppStrings.onePage.tr(): 1,
  };

  List<DayPlan> _generateDays(
      PortionType portionType,
      int dailyAmount,
      int duration,
      int startValue,
      ) {
    final days = <DayPlan>[];
    int currentValue = startValue;

    for (int day = 1; day <= duration; day++) {
      final start = currentValue;
      final end = start + dailyAmount - 1;

      days.add(DayPlan(
        dayNumber: day,
        start: start,
        end: end,
        isCompleted: false,
      ));

      currentValue = end + 1;
    }

    return days;
  }

  @override
  void initState() {
    super.initState();
    QuranCubit cubit = QuranCubit.get(context);
    juzNames = cubit.getJuzNames();
    if (juzNames.isNotEmpty) {
      startingPoint = juzNames.first;
    }
  }

  void _createKhetmaPlan() {
    final cubit = QuranCubit.get(context);
    Khetma? createdKhetma;

    // Validate inputs
    if (dailyPortion.isEmpty && dailyPortion2.isEmpty && dailyPortion3.isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(AppStrings.error.tr()),
          content: Text(AppStrings.errorKhetma.tr()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text("OK",style: TextStyle(color: ColorManager.primary),),
            ),
          ],
        ),
      );
      return;
    }

    PortionType portionType;
    int dailyAmount;

    if (dailyPortion2.isNotEmpty) {
      portionType = PortionType.Juz;
      dailyAmount = juzPortionMap[dailyPortion2]!;
    } else if (dailyPortion.isNotEmpty) {
      portionType = PortionType.HizbQuarter;
      dailyAmount = hizbQuarterMap[dailyPortion]!;
    } else {
      portionType = PortionType.Page;
      dailyAmount = pagePortionMap[dailyPortion3]!;
    }

    // Calculate startValue based on portion type
    final selectedJuzNumber = cubit.getJuzNumberFromName(startingPoint);
    int startValue;

    switch (portionType) {
      case PortionType.Juz:
        startValue = selectedJuzNumber;
        break;
      case PortionType.HizbQuarter:
        startValue = (selectedJuzNumber - 1) * 8 + 1;
        break;
      case PortionType.Page:
        startValue = cubit.getPageForJuz(selectedJuzNumber);
        break;
    }

    final days = <DayPlan>[];
    int current = startValue;

    for (int day = 1; day <= duration; day++) {
      final end = current + dailyAmount - 1;
      days.add(DayPlan(
        dayNumber: day,
        start: current,
        end: end,
      ));
      current = end + 1;
    }

    // Check if a Khetma already exists
    final existingKhetma = cubit.khetmaPlans.isNotEmpty ? cubit.khetmaPlans.first : null;

    if (existingKhetma != null) {
      final updatedKhetma = existingKhetma.copyWith(
        name: "ختمة محدثة",
        startDate: DateTime.now(),
        durationDays: duration,
        portionType: portionType,
        dailyAmount: dailyAmount,
        startValue: startValue,
        days: days,
        currentDayIndex: 0,
      );
      cubit.updateKhetma(updatedKhetma);
      createdKhetma = updatedKhetma;
    } else {
      final newKhetma = Khetma(
        name: "ختمة جديدة",
        startDate: DateTime.now(),
        durationDays: duration,
        portionType: portionType,
        dailyAmount: dailyAmount,
        startValue: startValue,
        days: days,
      );
      cubit.createKhetmaPlan(
        name: "ختمة جديدة",
        startingPoint: startingPoint,
        duration: duration,
        dailyWirdType: portionType,
        dailyAmount: dailyAmount,
      );
      createdKhetma = newKhetma;
    }

    Navigator.pushNamed(context, Routes.homeRoute);

    // Show success dialog with "OK" button
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppStrings.newKhetma.tr()),
        content: Text("${AppStrings.newKhetmaCreation.tr()} 🎉"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx); // Close dialog
              Navigator.pushNamed(context, Routes.dailyWerdRoute);
            },
            child: Text("OK",style: TextStyle(
              color:ColorManager.textPrimary,
            ),),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          AppStrings.newKhetma.tr(),
          style: Theme.of(context).textTheme.titleSmall?.copyWith(color: ColorManager.primary),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              'assets/images/logoico.svg',
              width: AppSize.s20.r,
              height: AppSize.s20.r,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getTitle(settingName: AppStrings.titleNewKhetma.tr(), context: context),
              SizedBox(height: AppSize.s16.r),
              getTitle(settingName: AppStrings.startFrom.tr(), context: context),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Dropdown<String>(
                  value: startingPoint,
                  items: juzNames.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      startingPoint = newValue!;
                    });
                  },
                  width: AppSize.s300.r,
                ),
              ),
              SizedBox(height: AppSize.s16.r),
              getTitle(settingName: AppStrings.titleDurationSelection.tr(), context: context),
              SizedBox(height: AppSize.s16.r),
              getTitle(settingName: AppStrings.durationSelection.tr(), context: context),
              Container(
                decoration: BoxDecoration(
                  color: ColorManager.accentGrey,
                  borderRadius: BorderRadius.circular(10),
                ),
                height: AppSize.s40.r,
                width: AppSize.s300.r,
                padding: EdgeInsets.symmetric(horizontal: AppPadding.p20.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: AppSize.s50.r),
                    Text(
                      "$duration  ${AppStrings.days.tr()}",
                      style: TextStyle(
                        fontSize: AppSize.s14.r,
                        color: ColorManager.textPrimary,
                      ),
                    ),
                    Row(
                      children: [
                        IconButtonWidget(
                          icon: Icons.remove,
                          onTap: () {
                            if (duration > 1) {
                              setState(() {
                                duration--;
                              });
                            }
                          },
                        ),
                        IconButtonWidget(
                          icon: Icons.add,
                          onTap: () {
                            setState(() {
                              duration++;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSize.s16.r),
              getTitle(settingName: AppStrings.werdSelection.tr(), context: context),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Dropdown<String>(
                    value: dailyPortion2,
                    items: ["", ...juzPortionMap.keys]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dailyPortion2 = newValue!;
                        dailyPortion = "";
                        dailyPortion3 = "";
                      });
                    },
                    width: AppSize.s100.r,
                  ),
                  getTitle(settingName: AppStrings.or.tr(), context: context),
                  Dropdown<String>(
                    value: dailyPortion,
                    items: ["", ...hizbQuarterMap.keys]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dailyPortion = newValue!;
                        dailyPortion2 = "";
                        dailyPortion3 = "";
                      });
                    },
                    width: AppSize.s100.r,
                  ),
                ],
              ),
              SizedBox(height: AppSize.s16.r),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  getTitle(settingName: AppStrings.or.tr(), context: context),
                  ToggleButtons(
                    isSelected: pagePortionMap.keys.map((e) => e == dailyPortion3).toList(),
                    onPressed: (int index) {
                      setState(() {
                        dailyPortion = "";
                        dailyPortion2 = "";
                        dailyPortion3 = pagePortionMap.keys.elementAt(index);
                      });
                    },
                    borderRadius: BorderRadius.circular(10),
                    selectedColor: Colors.white,
                    color: Colors.black,
                    fillColor: ColorManager.primary, // Background when selected
                    disabledColor: Colors.black,
                    constraints: BoxConstraints(minWidth: 80, minHeight: 40), // Button size
                    renderBorder: false, // Remove border to keep the design clean
                    children: pagePortionMap.keys.map((portion) {
                      bool isSelected = portion == dailyPortion3;
                      return Container(
                        decoration: BoxDecoration(
                          color: isSelected ? ColorManager.primary : ColorManager.accentGrey, // Background before selection
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
                        child: Text(
                          portion,
                          style: TextStyle(
                            color:ColorManager.textPrimary,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              SizedBox(height: AppSize.s100.r),
              Center(
                child: SizedBox(
                  width: AppSize.s250.r,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _createKhetmaPlan,
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
                    child: Text(AppStrings.newKhetma.tr()),
                  ),
                ),
              ),
              SizedBox(height: AppSize.s20.r),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.homeRoute);
                    },
                    child: getTitle(settingName: AppStrings.skip.tr(), context: context),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}