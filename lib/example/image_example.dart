import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:smooth_dropdown_with_search/widget/searchable_dropdown_style.dart';

class ImageExample extends HookWidget {
  const ImageExample({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedValue = useState<String?>(null);
    final countries = ['USA', 'Canada', 'UK', 'Germany', 'France', 'Japan'];
    final flags = [
      'https://flagcdn.com/w80/us.png',
      'https://flagcdn.com/w80/ca.png',
      'https://flagcdn.com/w80/gb.png',
      'https://flagcdn.com/w80/de.png',
      'https://flagcdn.com/w80/fr.png',
      'https://flagcdn.com/w80/jp.png',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('With Images')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select a country:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            SearchableDropdown<String>(
              items: countries,
              imageUrls: flags,
              value: selectedValue.value,
              onChanged: (value) => selectedValue.value = value,
              hintText: 'Select a country',
              clearable: true,
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
