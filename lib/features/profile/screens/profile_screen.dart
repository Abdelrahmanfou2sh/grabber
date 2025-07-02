import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
import '../../../core/error/error_handler.dart';
import '../../../core/widgets/theme_toggle_button.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../../auth/repositories/auth_repository.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = context.read<AuthRepository>();
    final currentUser = authRepository.currentUser;
    final userEmail = currentUser?.email ?? 'لا يوجد بريد إلكتروني';
    final userName = currentUser?.fullName ?? 'المستخدم';
    final userPhoto = currentUser?.image;

    return Scaffold(
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
      appBar: AppBar(
        title: const Text('الملف الشخصي'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              try {
                ErrorHandler.showError(context, 'هذه الميزة قيد التطوير');
              } catch (error) {
                ErrorHandler.showError(
                  context,
                  ErrorHandler.getErrorMessage(error),
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.green,
                  backgroundImage:
                      userPhoto != null ? NetworkImage(userPhoto) : null,
                  child: userPhoto == null
                      ? const Icon(
                          CupertinoIcons.person_alt,
                          size: 50,
                          color: Colors.white,
                        )
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              userName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              userEmail,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            if (currentUser != null) ...[
              const SizedBox(height: 10),
              Text(
                '@${currentUser.username}',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
            const SizedBox(height: 30),
            _buildProfileSection(
              context: context,
              title: 'معلومات الحساب',
              children: [
                _buildListTile(
                  icon: CupertinoIcons.person,
                  title: 'تعديل الملف الشخصي',
                  onTap: () => _handleFeatureNotReady(context),
                ),
                _buildListTile(
                  icon: CupertinoIcons.bell,
                  title: 'الإشعارات',
                  onTap: () => _handleFeatureNotReady(context),
                ),
                _buildListTile(
                  icon: CupertinoIcons.location,
                  title: 'العناوين',
                  onTap: () => _handleFeatureNotReady(context),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildProfileSection(
              context: context,
              title: 'الإعدادات',
              children: [
                _buildListTile(
                  icon: CupertinoIcons.settings,
                  title: 'الإعدادات',
                  trailing: const ThemeToggleButton(),
                ),
                _buildListTile(
                  icon: CupertinoIcons.doc_text,
                  title: 'الشروط والأحكام',
                  onTap: () => _handleFeatureNotReady(context),
                ),
                _buildListTile(
                  icon: CupertinoIcons.info,
                  title: 'عن التطبيق',
                  onTap: () => _handleFeatureNotReady(context),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => _handleLogout(context),
              child: const Text(
                'تسجيل الخروج',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection({
    required BuildContext context,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _handleFeatureNotReady(BuildContext context) {
    try {
      ErrorHandler.showError(context, 'هذه الميزة قيد التطوير');
    } catch (error) {
      ErrorHandler.showError(context, ErrorHandler.getErrorMessage(error));
    }
  }

  Future<void> _handleLogout(BuildContext context) async {
    try {
      final authCubit = context.read<AuthCubit>();
      await authCubit.signOut();
      if (context.mounted) context.go('/login');
    } catch (error) {
      if (context.mounted) {
        ErrorHandler.showError(
          context,
          ErrorHandler.getErrorMessage(error),
          onRetry: () async {
            if (context.mounted) context.go('/login');
          },
        );
      }
    }
  }
}
