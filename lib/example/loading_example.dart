import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:smooth_dropdown_with_search/widget/searchable_dropdown_style.dart';

class LoadingExample extends HookWidget {
  const LoadingExample({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedValue = useState<String?>(null);
    final isLoading = useState(true);
    final items = useState<List<String>>([]);

    useEffect(() {
      Future.delayed(const Duration(seconds: 2), () {
        items.value = List.generate(50, (index) => 'Item ${index + 1}');
        isLoading.value = false;
      });
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(title: const Text('Loading State')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Async loaded dropdown:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            SearchableDropdown<String>(
              items: items.value,
              value: selectedValue.value,
              onChanged: (value) => selectedValue.value = value,
              hintText: 'Select an item',
              isLoading: isLoading.value,
              loadingWidget: const Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 12),
                    Text('Loading items...'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
