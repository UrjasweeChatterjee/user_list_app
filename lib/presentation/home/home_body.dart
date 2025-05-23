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
      child: controller.isLoading && controller.users.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo is ScrollEndNotification &&
                    scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent * 0.8 &&
                    controller.hasMorePages &&
                    !controller.isLoading) {
                  // Load more data when user scrolls to 80% of the list
                  controller.loadNextPage();
                }
                return false;
              },
              child: Stack(
                children: [
                  UserList(
                    users: controller.users,
                    onUserSelected: (user) {
                      Navigator.pushNamed(
                        context,
                        '/user_details',
                        arguments: user.id,
                      );
                    },
                  ),
                  if (controller.isLoading && controller.users.isNotEmpty)
                    Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: const CircularProgressIndicator(),
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
