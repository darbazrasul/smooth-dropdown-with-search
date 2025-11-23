import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:smooth_dropdown_with_search/widget/searchable_dropdown_style.dart';

class CustomObjectExample extends HookWidget {
  const CustomObjectExample({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedUser = useState<User?>(null);
    final users = [
      User('John Doe', 'john@example.com', 'Developer'),
      User('Jane Smith', 'jane@example.com', 'Designer'),
      User('Bob Johnson', 'bob@example.com', 'Manager'),
      User('Alice Brown', 'alice@example.com', 'Developer'),
      User('Charlie Wilson', 'charlie@example.com', 'QA Engineer'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Custom Objects')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select a team member:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            SearchableDropdown<User>(
              items: users,
              value: selectedUser.value,
              itemAsString: (user) => user.name,
              itemBuilder: (user) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      user.email,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      user.role,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              searchMatcher: (user, query) {
                return user.name.toLowerCase().contains(query.toLowerCase()) ||
                    user.email.toLowerCase().contains(query.toLowerCase()) ||
                    user.role.toLowerCase().contains(query.toLowerCase());
              },
              onChanged: (user) => selectedUser.value = user,
              hintText: 'Select a user',
              itemHeight: 90,
            ),
            const SizedBox(height: 24),
            if (selectedUser.value != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name: ${selectedUser.value!.name}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Email: ${selectedUser.value!.email}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Role: ${selectedUser.value!.role}',
                        style: const TextStyle(fontSize: 16),
                      ),
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

///=========
class User {
  final String name;
  final String email;
  final String role;

  User(this.name, this.email, this.role);
}
