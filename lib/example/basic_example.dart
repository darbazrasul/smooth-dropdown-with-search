import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:smooth_dropdown_with_search/widget/searchable_dropdown_style.dart';

class BasicExample extends HookWidget {
  const BasicExample({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedValue = useState<String?>(null);
    final fruits = [
      'Apple',
      'Banana',
      'Cherry',
      'Date',
      'Elderberry',
      'Fig',
      'Grape',
      'Honeydew',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Basic Example')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select a fruit:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            SearchableDropdown<String>(
              items: fruits,
              value: selectedValue.value,
              onChanged: (value) => selectedValue.value = value,
              hintText: 'Select a fruit',
            ),
            const SizedBox(height: 24),
            if (selectedValue.value != null)
              Text(
                'Selected: ${selectedValue.value}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
