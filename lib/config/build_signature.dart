import 'package:flutter/foundation.dart';

/// A human-readable build marker for debugging.
///
/// When logs don't match source code, it's often because the app/device is still
/// running an older build. Bump this string whenever you need to confirm a
/// rebuild picked up the latest code.
const String kBuildSignature = 'kick_track_2026-03-02_buildsig_01';

void logBuildSignature(String scope) {
  if (!kDebugMode) return;
  debugPrint('[build] $scope signature=$kBuildSignature');
}

