import 'package:flutter/material.dart';
import 'package:frontend/core/theme/f1_theme.dart';
import 'package:sizer/sizer.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text(
          'Terms of Service',
          style: TextStyle(fontFamily: "Formula1Bold", color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(3.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection('1. Acceptance of Terms'),
            _buildContent(
              'By accessing and using Race Control, you accept and agree to be bound by the terms and provision of this agreement. Additionally, when using this application, you shall be subject to any posted guidelines or rules applicable to such services.',
            ),
            SizedBox(height: 2.h),
            _buildSection('2. Description of Service'),
            _buildContent(
              'Race Control is a Formula 1 race statistics and telemetry viewing application. The app provides access to race data, standings, telemetry information, and calendar features.',
            ),
            SizedBox(height: 2.h),
            _buildSection('3. Data Sources'),
            _buildContent(
              'Our application uses the following third-party APIs to provide race data and telemetry:\n\n'
              '• OpenF1 API - For real-time Formula 1 race telemetry and timing data\n'
              '• Jolpica API - For race schedules, standings, and race results\n\n'
              'We are not affiliated with, endorsed by, or connected to Formula 1, the FIA, or any Formula 1 teams.',
            ),
            SizedBox(height: 2.h),
            _buildSection('4. User Responsibilities'),
            _buildContent(
              'You agree to:\n\n'
              '• Use the service only for lawful purposes\n'
              '• Not attempt to gain unauthorized access to any part of the service\n'
              '• Not interfere with or disrupt the service\n'
              '• Not reproduce, duplicate, copy, or resell any part of the service',
            ),
            SizedBox(height: 2.h),
            _buildSection('5. Intellectual Property'),
            _buildContent(
              'The Race Control application, including all content, features, and functionality, is owned by us and is protected by international copyright, trademark, patent, trade secret, and other intellectual property laws. Formula 1, FIA, and team names, logos, and trademarks are the property of their respective owners.',
            ),
            SizedBox(height: 2.h),
            _buildSection('6. Disclaimer of Warranties'),
            _buildContent(
              'The service is provided "as is" without warranty of any kind. We do not warrant that the service will be uninterrupted, timely, secure, or error-free. Data provided through the OpenF1 and Jolpica APIs may be delayed or inaccurate.',
            ),
            SizedBox(height: 2.h),
            _buildSection('7. Limitation of Liability'),
            _buildContent(
              'In no event shall we be liable for any indirect, incidental, special, consequential, or punitive damages, including without limitation, loss of profits, data, use, goodwill, or other intangible losses.',
            ),
            SizedBox(height: 2.h),
            _buildSection('8. Changes to Terms'),
            _buildContent(
              'We reserve the right to modify these terms at any time. Your continued use of the application after any changes indicates your acceptance of the new terms.',
            ),
            SizedBox(height: 2.h),
            _buildSection('9. Contact Information'),
            _buildContent(
              'If you have any questions about these Terms of Service, please contact us through the app.',
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
