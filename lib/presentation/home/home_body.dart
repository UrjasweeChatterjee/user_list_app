import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../controllers/user_controller.dart';
import 'widget/user_list.dart';

class HomeBody extends StatelessWidget {
  final UserController controller;

  const HomeBody({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    if (controller.error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Fluttertoast.showToast(
          msg: controller.error!,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
      });
    }

    return RefreshIndicator(
      onRefresh: () => controller.fetchUsers(refresh: true),
      child:
          controller.isLoading && controller.users.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : UserList(
                users: controller.users,
                onUserSelected: (user) {
                  Navigator.pushNamed(
                    context,
                    '/user_details',
                    arguments: user.id,
                  );
                },
              ),
    );
  }
}
