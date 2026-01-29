import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:web/web.dart' as html;

class DeviceChecker {
  static bool isMobileDevice() {
    if (kIsWeb) {
      // Get actual user agent from browser
      final userAgent = html.window.navigator.userAgent.toLowerCase();

      // Check for mobile devices
      return userAgent.contains('mobile') ||
          userAgent.contains('android') ||
          userAgent.contains('iphone') ||
          userAgent.contains('ipad') ||
          userAgent.contains('ipod') ||
          userAgent.contains('blackberry') ||
          userAgent.contains('windows phone');
    }
    return true; // For native apps
  }

  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 768;
  }

  static bool isTouchDevice() {
    if (kIsWeb) {
      // Check if device has touch capability
      return html.window.navigator.maxTouchPoints != null &&
          html.window.navigator.maxTouchPoints! > 0;
    }
    return true;
  }

  static bool shouldAllowAccess(BuildContext context) {
    if (kIsWeb) {
      // Combine checks: user agent, screen size, and touch capability
      final isMobile = isMobileDevice();
      final isSmall = isSmallScreen(context);
      final hasTouch = isTouchDevice();

      // Allow if it's a mobile user agent OR (has touch AND small screen)
      return isMobile || (hasTouch && isSmall);
    }
    return true; // Native apps always allowed
  }

  static String getDeviceInfo() {
    if (kIsWeb) {
      final userAgent = html.window.navigator.userAgent;
      final screenWidth = html.window.screen?.width ?? 0;
      final screenHeight = html.window.screen?.height ?? 0;
      final hasTouch = html.window.navigator.maxTouchPoints ?? 0;

      return '''
User Agent: $userAgent
Screen: ${screenWidth}x$screenHeight
Touch Points: $hasTouch
      ''';
    }
    return 'Native App';
  }
}
