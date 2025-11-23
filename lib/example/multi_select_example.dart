import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:smooth_dropdown_with_search/widget/searchable_dropdown_style.dart';

class MultiSelectExample extends HookWidget {
  const MultiSelectExample({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedItems = useState<List<String>>([]);
    final skills = [
      'Flutter',
      'Dart',
      'React',
      'JavaScript',
      'Python',
      'Java',
      'Swift',
      'Kotlin',
      'TypeScript',
      'Go',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Multi-Select')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select skills:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            SearchableDropdown<String>(
              items: skills,
              multiSelect: true,
              selectedItems: selectedItems.value,
              onMultiSelectChanged: (selected) =>
                  selectedItems.value = selected,
              hintText: 'Select your skills',
              closeOnSelect: false,
              onChanged: (String? value) {},
            ),
            const SizedBox(height: 24),
            if (selectedItems.value.isNotEmpty) ...[
              const Text(
                'Selected Skills:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: selectedItems.value
                    .map(
                      (skill) => Chip(
                        label: Text(skill),
                        onDeleted: () {
                          selectedItems.value = selectedItems.value
                              .where((s) => s != skill)
                              .toList();
                        },
                      ),
                    )
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
