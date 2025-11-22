import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_dropdown_with_search/example/basic_example.dart';
import 'package:smooth_dropdown_with_search/example/image_example.dart';

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
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSectionTitle('Examples'),
                Builder(
                  builder: (innerCtx) {
                    return _buildExampleCard(
                      innerCtx,
                      'Basic Dropdown',
                      'Simple dropdown with string items',
                      () => Navigator.push(
                        innerCtx,
                        MaterialPageRoute(builder: (_) => const BasicExample()),
                      ),
                    );
                  },
                ),
                Builder(
                  builder: (innerCtx) {
                    return _buildExampleCard(
                      innerCtx,
                      'With Images',
                      'Dropdown with image support',
                      () => Navigator.push(
                        innerCtx,
                        MaterialPageRoute(builder: (_) => const ImageExample()),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildExampleCard(
    BuildContext context,
    String title,
    String description,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
