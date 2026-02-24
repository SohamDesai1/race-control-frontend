import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/route_names.dart';
import 'package:frontend/core/theme/f1_theme.dart';
import 'package:frontend/presentation/auth/login/cubit/login_cubit.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: F1Theme.f1DarkGray,
        title: const Text('Logout', style: TextStyle(color: F1Theme.f1White)),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(color: F1Theme.f1TextGray),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: F1Theme.f1TextGray),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout', style: TextStyle(color: F1Theme.f1Red)),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await context.read<LoginCubit>().logout();
      if (context.mounted) {
        context.goNamed(RouteNames.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text(
          'Settings',
          style: TextStyle(fontFamily: "Formula1Bold", color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
        children: [
          _buildSectionHeader('Account'),
          SizedBox(height: 1.h),
          // _buildSettingsTile(
          //   icon: Icons.person_outline,
          //   title: 'Profile',
          //   subtitle: 'Manage your account details',
          //   onTap: () {},
          // ),
          // SizedBox(height: 1.h),
          _buildSettingsTile(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            subtitle: 'Push notifications and alerts',
            onTap: () {},
            trailing: Switch(
              value: true,
              onChanged: (value) {},
              activeColor: F1Theme.f1Red,
            ),
          ),
          SizedBox(height: 1.h),
          _buildSettingsTile(
            icon: Icons.logout,
            title: 'Logout',
            subtitle: 'Sign out of your account',
            onTap: () => _handleLogout(context),
            iconColor: F1Theme.f1Red,
          ),
          SizedBox(height: 3.h),
          _buildSectionHeader('Support'),
          SizedBox(height: 1.h),
          _buildSettingsTile(
            icon: Icons.help_outline,
            title: 'Help Center',
            subtitle: 'FAQs and support',
            onTap: () {
              context.pushNamed(RouteNames.faq);
            },
          ),
          SizedBox(height: 1.h),
          _buildSettingsTile(
            icon: Icons.feedback_outlined,
            title: 'Send Feedback',
            subtitle: 'Help us improve the app',
            onTap: () {
              context.pushNamed(RouteNames.sendFeedback);
            },
          ),
          SizedBox(height: 3.h),
          _buildSectionHeader('Legal'),
          SizedBox(height: 1.h),
          _buildSettingsTile(
            icon: Icons.description_outlined,
            title: 'Terms of Service',
            onTap: () {
              context.pushNamed(RouteNames.termsOfService);
            },
          ),
          SizedBox(height: 1.h),
          _buildSettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            onTap: () {
              context.pushNamed(RouteNames.privacyPolicy);
            },
          ),
          SizedBox(height: 4.h),
          Center(
            child: Text(
              'Race Control v1.0.0',
              style: TextStyle(
                fontFamily: 'Formula1Regular',
                fontSize: 12,
                color: F1Theme.f1TextGray,
              ),
            ),
          ),
          SizedBox(height: 1.h),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontFamily: 'Formula1Bold',
          fontSize: 12,
          color: F1Theme.f1Red,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 1),
      color: F1Theme.f1DarkGray,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: F1Theme.f1MediumGray,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor ?? F1Theme.f1White, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Formula1Regular',
            fontSize: 14,
            color: F1Theme.f1White,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(
                  fontFamily: 'Formula1Regular',
                  fontSize: 11,
                  color: F1Theme.f1TextGray,
                ),
              )
            : null,
        trailing:
            trailing ??
            Icon(Icons.chevron_right, color: F1Theme.f1TextGray, size: 20),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }
}
