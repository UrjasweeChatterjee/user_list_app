import 'package:flutter/material.dart';

import '../../../models/user.dart';

class UserCard extends StatelessWidget {
  final User user;
  final VoidCallback onTap;

  const UserCard({super.key, required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.grey.shade200,
          backgroundImage: NetworkImage(user.avatar),
          onBackgroundImageError: (exception, stackTrace) {
            debugPrint('Error loading avatar: $exception');
          },
          child: user.avatar.isEmpty 
              ? const Icon(Icons.person, size: 30, color: Colors.grey)
              : null,
        ),
        title: Text(user.fullName),
        subtitle: Text(user.email),
        onTap: onTap,
      ),
    );
  }
}
