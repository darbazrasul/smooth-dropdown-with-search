import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:smooth_dropdown_with_search/widget/searchable_dropdown_style.dart';

class FormExample extends HookWidget {
  const FormExample({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final selectedCountry = useState<String?>(null);
    final selectedCity = useState<String?>(null);

    final countries = ['USA', 'Canada', 'UK', 'Germany', 'France'];
    final cities = {
      'USA': ['New York', 'Los Angeles', 'Chicago'],
      'Canada': ['Toronto', 'Vancouver', 'Montreal'],
      'UK': ['London', 'Manchester', 'Edinburgh'],
      'Germany': ['Berlin', 'Munich', 'Hamburg'],
      'France': ['Paris', 'Lyon', 'Marseille'],
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Form Integration')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Select Country:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              SearchableDropdown<String>(
                items: countries,
                value: selectedCountry.value,
                onChanged: (value) {
                  selectedCountry.value = value;
                  selectedCity.value = null; // بەتالردنەوەی کانتریەکان
                },
                hintText: 'Select country',
              ),
              const SizedBox(height: 24),
              const Text(
                'Select City:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              SearchableDropdown<String>(
                items: selectedCountry.value != null
                    ? cities[selectedCountry.value]!
                    : [],
                value: selectedCity.value,
                onChanged: (value) => selectedCity.value = value,
                hintText: 'Select city',
                enabled: selectedCountry.value != null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  if (selectedCountry.value != null &&
                      selectedCity.value != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Selected: ${selectedCity.value}, ${selectedCountry.value}',
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select both country and city'),
                      ),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
