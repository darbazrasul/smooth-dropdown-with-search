import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:smooth_dropdown_with_search/widget/searchable_dropdown_style.dart';

class StyledExample extends HookWidget {
  const StyledExample({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedValue = useState<String?>(null);
    final items = List.generate(20, (index) => 'Option ${index + 1}');

    return Scaffold(
      appBar: AppBar(title: const Text('Custom Styling')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Styled Dropdown:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            SearchableDropdown<String>(
              items: items,
              value: selectedValue.value,
              onChanged: (value) => selectedValue.value = value,
              hintText: 'Choose an option',
              style: SearchableDropdownStyle(
                fieldHeight: 56,
                borderRadius: 12,
                borderColor: Colors.blue.shade300,
                borderColorFocused: Colors.blue.shade600,
                fieldBackgroundColor: Colors.blue.shade50,
                itemSelectedColor: Colors.blue.withValues(alpha: 0.15),
                itemHoverColor: Colors.blue.withValues(alpha: 0.05),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                iconColor: Colors.blue.shade700,
                selectedIconColor: Colors.blue.shade700,
              ),
              clearable: true,
            ),
          ],
        ),
      ),
    );
  }
}
