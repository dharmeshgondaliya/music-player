import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  static const PermissionHandler _permissionHandler =
      PermissionHandler.internal();

  const PermissionHandler.internal();

  static PermissionHandler get instance => _permissionHandler;

  Future<bool> checkAndAskStoragePermission() async {
    if (!await Permission.storage.isGranted) {
      await Permission.storage.request();
      await Permission.manageExternalStorage.request();
    }
    return await Permission.storage.isGranted ||
        await Permission.manageExternalStorage.isGranted;
  }
}
