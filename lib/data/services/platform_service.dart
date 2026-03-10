import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class PlatformService {
  static const MethodChannel _channel = MethodChannel(
    'com.example.device_owner/policy',
  );

  Future<bool> isDeviceOwnerActive() async {
    try {
      final bool isActive = await _channel.invokeMethod('isDeviceOwnerActive');
      return isActive;
    } on PlatformException catch (e) {
      debugPrint("Failed to check device owner status: '${e.message}'.");
      return false;
    }
  }

  Future<bool> setUninstallBlocked(bool blocked) async {
    try {
      final bool result = await _channel.invokeMethod('setUninstallBlocked', {
        'blocked': blocked,
      });
      return result;
    } on PlatformException catch (e) {
      debugPrint("Failed to set uninstall block: '${e.message}'.");
      return false;
    }
  }

  Future<bool> isUninstallBlocked() async {
    try {
      final bool isBlocked = await _channel.invokeMethod('isUninstallBlocked');
      return isBlocked;
    } on PlatformException catch (e) {
      debugPrint("Failed to check uninstall block status: '${e.message}'.");
      return false;
    }
  }

  Future<bool> isProvisionedViaQR() async {
    try {
      final bool isQr = await _channel.invokeMethod('isProvisionedViaQR');
      return isQr;
    } on PlatformException catch (e) {
      debugPrint("Failed to check QR provisioning status: '${e.message}'.");
      return false;
    }
  }

  Future<bool> setFactoryResetDisabled(bool disabled) async {
    try {
      final bool result = await _channel.invokeMethod(
        'setFactoryResetDisabled',
        {'disabled': disabled},
      );
      return result;
    } on PlatformException catch (e) {
      debugPrint("Failed to set factory reset restriction: '${e.message}'.");
      return false;
    }
  }

  Future<bool> isFactoryResetDisabled() async {
    try {
      final bool isDisabled = await _channel.invokeMethod(
        'isFactoryResetDisabled',
      );
      return isDisabled;
    } on PlatformException catch (e) {
      debugPrint("Failed to check factory reset status: '${e.message}'.");
      return false;
    }
  }

  Future<bool> setFRPAccount(String email) async {
    try {
      final bool result = await _channel.invokeMethod('setFRPAccount', {
        'email': email,
      });
      return result;
    } on PlatformException catch (e) {
      debugPrint("Failed to set FRP account: '${e.message}'.");
      return false;
    }
  }

  Future<String?> getFRPAccount() async {
    try {
      final String? account = await _channel.invokeMethod('getFRPAccount');
      return account;
    } on PlatformException catch (e) {
      debugPrint("Failed to get FRP account: '${e.message}'.");
      return null;
    }
  }
}
