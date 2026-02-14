import 'package:flutter/material.dart';
import 'package:frontend/core/router/app_router.dart';
import 'package:frontend/core/theme/f1_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DialogService {
  Future<void> showErrorDialog({
    required String title,
    required String message,
  }) async {
    final context = Routing.navigatorKey.currentContext;
    if (context != null) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: F1Theme.f1DarkGray,
          shape: RoundedRectangleBorder(
            borderRadius: F1Theme.mediumBorderRadius,
          ),
          title: Text(
            title,
            style: F1Theme.themeData.textTheme.headlineMedium?.copyWith(
              color: F1Theme.f1Red,
            ),
          ),
          content: Text(
            message,
            style: F1Theme.themeData.textTheme.bodyMedium?.copyWith(
              color: F1Theme.f1TextGray,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: Text(
                'OK',
                style: F1Theme.themeData.textTheme.labelLarge?.copyWith(
                  color: F1Theme.f1Red,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
