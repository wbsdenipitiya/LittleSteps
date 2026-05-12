import 'dart:io' show Platform;
import 'package:device_info_plus/device_info_plus.dart';

class EmulatorService {
  static final EmulatorService _instance = EmulatorService._internal();
  factory EmulatorService() => _instance;
  EmulatorService._internal();

  bool? _isEmulator;

  /// Checks if the application is currently running on an emulator or simulator.
  Future<bool> isEmulator() async {
    if (_isEmulator != null) return _isEmulator!;

    try {
      final deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        // Comprehensive checks for Android emulator models, brands, and hardware
        _isEmulator = !androidInfo.isPhysicalDevice ||
            androidInfo.fingerprint.startsWith('generic') ||
            androidInfo.fingerprint.startsWith('unknown') ||
            androidInfo.hardware.contains('goldfish') ||
            androidInfo.hardware.contains('ranchu') ||
            androidInfo.model.contains('google_sdk') ||
            androidInfo.model.contains('Emulator') ||
            androidInfo.model.contains('Android SDK built for x86') ||
            androidInfo.manufacturer.contains('Genymotion') ||
            androidInfo.product.contains('sdk_gphone');
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        _isEmulator = !iosInfo.isPhysicalDevice;
      } else {
        _isEmulator = false; // Web/Desktop are not mobile emulators
      }
    } catch (e) {
      // ignore: avoid_print
      print("EmulatorService Error: $e");
      _isEmulator = false;
    }

    return _isEmulator!;
  }
}

final emulatorService = EmulatorService();
