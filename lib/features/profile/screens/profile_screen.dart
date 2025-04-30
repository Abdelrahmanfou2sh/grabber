import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
import '../../../core/error/error_handler.dart';
import '../../../core/widgets/theme_toggle_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
      appBar: AppBar(title: const Text('الملف الشخصي'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.green,
              child: Icon(
                CupertinoIcons.person_alt,
                size: 50,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'اسم المستخدم',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'user@example.com',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            ListTile(
              leading: const Icon(CupertinoIcons.person),
              title: const Text('تعديل الملف الشخصي'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                try {
                  // التنقل إلى صفحة تعديل الملف الشخصي
                  ErrorHandler.showError(context, 'هذه الميزة قيد التطوير');
                } catch (error) {
                  ErrorHandler.showError(
                    context,
                    ErrorHandler.getErrorMessage(error),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(CupertinoIcons.bell),
              title: const Text('الإشعارات'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                try {
                  // التنقل إلى صفحة الإشعارات
                  ErrorHandler.showError(context, 'هذه الميزة قيد التطوير');
                } catch (error) {
                  ErrorHandler.showError(
                    context,
                    ErrorHandler.getErrorMessage(error),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(CupertinoIcons.location),
              title: const Text('العناوين'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                try {
                  // التنقل إلى صفحة العناوين
                  ErrorHandler.showError(context, 'هذه الميزة قيد التطوير');
                } catch (error) {
                  ErrorHandler.showError(
                    context,
                    ErrorHandler.getErrorMessage(error),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(CupertinoIcons.settings),
              title: const Text('الإعدادات'),
              trailing: const ThemeToggleButton(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () async {
                try {
                  // تنفيذ عملية تسجيل الخروج
                  await Future.delayed(
                    const Duration(seconds: 1),
                  ); // محاكاة عملية تسجيل الخروج
                  if (context.mounted) context.go('/login');
                } catch (error) {
                  if (context.mounted) {
                    ErrorHandler.showError(
                      context,
                      ErrorHandler.getErrorMessage(error),
                      onRetry: () async {
                        // إعادة محاولة تسجيل الخروج
                        if (context.mounted) context.go('/login');
                      },
                    );
                  }
                }
              },
              child: const Text(
                'تسجيل الخروج',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
