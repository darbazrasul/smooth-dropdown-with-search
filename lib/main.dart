import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_dropdown_with_search/widget/searchable_dropdown_style.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, child) {
        ScreenUtil.init(context, designSize: const Size(360, 690));
        return MaterialApp(
          title: 'Flutter Demo',
          home: Scaffold(
            appBar: AppBar(
              title: const Text('Smooth Dropdown with Search Demo'),
            ),
            body: Column(
              children: [
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: SearchableDropdown(
                    items: List.generate(100, (index) => 'Item $index'),
                    onChanged: (value) {
                      if (kDebugMode) {
                        print('Selected: $value');
                      }
                    },
                    hintText: 'Select an item',

                    value: null,
                    enabled: true,
                    maxHeight: 300.h,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
