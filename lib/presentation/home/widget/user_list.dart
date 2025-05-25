import 'package:flutter/material.dart';

import '../../../models/user.dart';
import 'user_card.dart';

class UserList extends StatelessWidget {
  final List<User> users;
  final Function(User) onUserSelected;
  final Function(User)? onEditUser;
  final Function(User)? onDeleteUser;

  const UserList({
    super.key,
    required this.users,
    required this.onUserSelected,
    this.onEditUser,
    this.onDeleteUser,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return UserCard(
          user: user, 
          onTap: () => onUserSelected(user),
          onEdit: onEditUser,
          onDelete: onDeleteUser,
        );
      },
    );
  }
}
