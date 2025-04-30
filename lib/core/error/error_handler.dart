import 'package:flutter/material.dart';
import 'error_screen.dart';

class ErrorHandler {
  static void showError(
    BuildContext context,
    String message, {
    VoidCallback? onRetry,
    Duration? duration,
    bool showRetryButton = true,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: duration ?? const Duration(seconds: 3),
        action:
            (onRetry != null && showRetryButton)
                ? SnackBarAction(
                  label: 'إعادة المحاولة',
                  textColor: Colors.white,
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    onRetry();
                  },
                )
                : null,
      ),
    );
    // تسجيل الخطأ للتتبع
    logError('عرض رسالة خطأ للمستخدم', message);
  }

  static void showErrorScreen(
    BuildContext context,
    String message, {
    VoidCallback? onRetry,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ErrorScreen(message: message, onRetry: onRetry),
      ),
    );
    // تسجيل الخطأ للتتبع
    logError('عرض شاشة الخطأ', message);
  }

  static String getErrorMessage(dynamic error) {
    if (error is String) return error;

    if (error is Exception) {
      final errorString = error.toString().toLowerCase();

      if (errorString.contains('socketexception') ||
          errorString.contains('connection refused') ||
          errorString.contains('network is unreachable')) {
        return 'Unable to connect to server. Please check your internet connection.';
      } else if (errorString.contains('unauthorized') ||
          errorString.contains('unauthenticated')) {
        return 'Unauthorized. Please login again.';
      } else if (errorString.contains('not found')) {
        return 'The requested resource was not found.';
      } else if (errorString.contains('timeout')) {
        return 'Connection timed out. Please try again.';
      } else if (errorString.contains('bad request')) {
        return 'Invalid request. Please check your inputs.';
      }
    }

    return 'An unexpected error occurred. Please try again.';
  }

  static void logError(String message, dynamic error) {
    final timestamp = DateTime.now().toIso8601String();
    debugPrint('[$timestamp] Error: $message');
    debugPrint('Details: $error');
  }
}
