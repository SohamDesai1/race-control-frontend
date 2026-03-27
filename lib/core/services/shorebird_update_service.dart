import 'package:flutter/foundation.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

enum ShorebirdUpdateOutcome {
  updated,
  noUpdateAvailable,
  unsupportedPlatform,
  failed,
}

class ShorebirdUpdateService {
  ShorebirdUpdateService({ShorebirdUpdater? updater})
    : _updater = updater ?? ShorebirdUpdater();

  final ShorebirdUpdater _updater;

  Future<int?> readCurrentPatchNumber() async {
    if (kIsWeb) {
      return null;
    }

    final currentPatch = await _updater.readCurrentPatch();
    return currentPatch?.number;
  }

  Future<ShorebirdUpdateOutcome> checkForUpdatesAndInstall() async {
    if (kIsWeb) {
      return ShorebirdUpdateOutcome.unsupportedPlatform;
    }

    final status = await _updater.checkForUpdate();

    if (status == UpdateStatus.outdated) {
      try {
        await _updater.update();
        return ShorebirdUpdateOutcome.updated;
      } on UpdateException {
        return ShorebirdUpdateOutcome.failed;
      }
    }

    return ShorebirdUpdateOutcome.noUpdateAvailable;
  }
}
