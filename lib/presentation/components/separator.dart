import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/resources/resources.dart';

Widget getSeparator(BuildContext context) {
  return Padding(
    padding: EdgeInsets.only(top: AppPadding.p12.h),
    child: Container(
      width: double.infinity,
      height: AppSize.s1,
      color: ColorManager.separator,
    ),
  );
}
