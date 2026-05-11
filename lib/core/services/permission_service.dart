import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static final PermissionService _instance = PermissionService._internal();
  factory PermissionService() => _instance;
  PermissionService._internal();

  /// Requests clinical and educational permissions.
  Future<void> requestInitialPermissions() async {
    // 1. Notification Permission (Professional Standard)
    final status = await Permission.notification.status;
    if (status.isDenied || status.isLimited) {
      await Permission.notification.request();
    }

    // 2. Connectivity check is handled by the OS once added to the manifest.
  }

  Future<bool> hasNotificationPermission() async {
    return await Permission.notification.isGranted;
  }
}
