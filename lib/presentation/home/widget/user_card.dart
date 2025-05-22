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
          backgroundImage: NetworkImage(user.avatar),
          onBackgroundImageError: (exception, stackTrace) {
            debugPrint('Error loading avatar: $exception');
          },
        ),
        title: Text(user.fullName),
        subtitle: Text(user.email),
        onTap: onTap,
      ),
    );
  }
}
