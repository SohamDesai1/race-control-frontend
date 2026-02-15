import 'package:flutter/material.dart';
import 'package:frontend/core/theme/f1_theme.dart';
import 'package:sizer/sizer.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text(
          'Privacy Policy',
          style: TextStyle(fontFamily: "Formula1Bold", color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(3.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection('1. Introduction'),
            _buildContent(
              'Race Control ("we," "our," or "us") respects your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application.',
            ),
            SizedBox(height: 2.h),
            _buildSection('2. Information We Collect'),
            _buildContent(
              'We collect the following types of information:\n\n'
              '• Account Information: When you register, we collect your email address and basic profile information\n'
              '• Usage Data: We collect data about how you interact with the app\n'
              '• Race Data: We fetch data from OpenF1 and Jolpica APIs to display race information, telemetry, and standings',
            ),
            SizedBox(height: 2.h),
            _buildSection('3. Data Sources'),
            _buildContent(
              'Our application uses the following third-party APIs:\n\n'
              '• OpenF1 API - Provides real-time Formula 1 telemetry and timing data\n'
              '• Jolpica API - Provides race schedules, standings, and results\n\n'
              'These APIs operate under their own privacy policies. We encourage you to review their privacy policies.',
            ),
            SizedBox(height: 2.h),
            _buildSection('4. How We Use Your Information'),
            _buildContent(
              'We use the information we collect to:\n\n'
              '• Provide, maintain, and improve our services\n'
              '• Display race data, telemetry, and standings\n'
              '• Send you important updates and notifications\n'
              '• Analyze usage patterns to enhance user experience',
            ),
            SizedBox(height: 2.h),
            _buildSection('5. Data Storage and Security'),
            _buildContent(
              'Your data is stored securely using industry-standard encryption. We implement appropriate technical and organizational measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction.',
            ),
            SizedBox(height: 2.h),
            _buildSection('6. Third-Party Services'),
            _buildContent(
              'We use third-party services for:\n\n'
              '• Authentication (supabase)\n'
              '• API data sources (OpenF1, Jolpica)\n\n'
              'These third parties have their own privacy policies and data handling practices.',
            ),
            SizedBox(height: 2.h),
            _buildSection('7. Children\'s Privacy'),
            _buildContent(
              'Our service is not intended for children under 13 years of age. We do not knowingly collect personal information from children under 13.',
            ),
            SizedBox(height: 2.h),
            _buildSection('8. Changes to This Policy'),
            _buildContent(
              'We may update this privacy policy from time to time. We will notify you of any changes by posting the new policy on this page and updating the "last updated" date.',
            ),
            SizedBox(height: 2.h),
            _buildSection('9. Contact Us'),
            _buildContent(
              'If you have any questions about this Privacy Policy, please contact us through the app.',
            ),
            SizedBox(height: 4.h),
            Center(
              child: Text(
                'Last updated: February 2026',
                style: TextStyle(
                  fontFamily: 'Formula1Regular',
                  fontSize: 12,
                  color: F1Theme.f1TextGray,
                ),
              ),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Formula1Bold',
          fontSize: 16,
          color: F1Theme.f1White,
        ),
      ),
    );
  }

  Widget _buildContent(String text) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Formula1Regular',
        fontSize: 13,
        color: F1Theme.f1TextGray,
        height: 1.6,
      ),
    );
  }
}
