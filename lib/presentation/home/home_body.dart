import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../controllers/user_controller.dart';
import '../../models/user.dart';
import 'widget/user_list.dart';

class HomeBody extends StatelessWidget {
  final UserController controller;

  const HomeBody({super.key, required this.controller});

  // Show dialog to edit user information
  void _showEditUserDialog(BuildContext context, User user, UserController controller) {
    final TextEditingController firstNameController = TextEditingController(text: user.firstName);
    final TextEditingController lastNameController = TextEditingController(text: user.lastName);
    final TextEditingController emailController = TextEditingController(text: user.email);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit User'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
              ),
              TextField(
                controller: lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              // Create updated user object
              final updatedUser = User(
                id: user.id,
                firstName: firstNameController.text,
                lastName: lastNameController.text,
                email: emailController.text,
                avatar: user.avatar,
              );
              
              try {
                // Call the update method
                await controller.updateUser(user.id, updatedUser);
                Navigator.pop(context);
                
                // Show success message
                Fluttertoast.showToast(
                  msg: 'User updated successfully',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                );
              } catch (e) {
                // Show error message
                Fluttertoast.showToast(
                  msg: 'Failed to update user: $e',
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // Show confirmation dialog before deleting a user
  void _showDeleteConfirmationDialog(BuildContext context, User user, UserController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete ${user.fullName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                // Call the delete method
                final success = await controller.deleteUser(user.id);
                Navigator.pop(context);
                
                // Show success message
                if (success) {
                  Fluttertoast.showToast(
                    msg: 'User deleted successfully',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                  );
                } else {
                  Fluttertoast.showToast(
                    msg: 'Failed to delete user',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                  );
                }
              } catch (e) {
                // Show error message
                Fluttertoast.showToast(
                  msg: 'Failed to delete user: $e',
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Show error toast if there's an error
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
          : controller.users.isEmpty && controller.error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text('Error: ${controller.error}', textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => controller.fetchUsers(refresh: true),
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                )
              : controller.users.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.people_outline, size: 48, color: Colors.grey),
                          SizedBox(height: 16),
                          Text('No users found'),
                        ],
                      ),
                    )
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
                    onEditUser: (user) {
                      _showEditUserDialog(context, user, controller);
                    },
                    onDeleteUser: (user) {
                      _showDeleteConfirmationDialog(context, user, controller);
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
