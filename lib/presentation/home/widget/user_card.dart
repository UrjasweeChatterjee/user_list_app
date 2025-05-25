import 'package:flutter/material.dart';

import '../../../models/user.dart';

class UserCard extends StatelessWidget {
  final User user;
  final VoidCallback onTap;
  final Function(User)? onEdit;
  final Function(User)? onDelete;

  const UserCard({
    super.key, 
    required this.user, 
    required this.onTap, 
    this.onEdit, 
    this.onDelete
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        children: [
          ListTile(
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
          if (onEdit != null || onDelete != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (onEdit != null)
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => onEdit!(user),
                      tooltip: 'Edit User',
                    ),
                  if (onDelete != null)
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => onDelete!(user),
                      tooltip: 'Delete User',
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
