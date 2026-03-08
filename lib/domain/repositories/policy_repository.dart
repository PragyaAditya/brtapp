import '../entities/policy_status.dart';

abstract class PolicyRepository {
  Future<bool> isDeviceOwnerActive();
  Future<bool> setUninstallBlocked(bool block);
  Future<bool> isUninstallBlocked();
  Future<bool> isProvisionedViaQR();
  Future<bool> setFactoryResetDisabled(bool disabled);
  Future<bool> isFactoryResetDisabled();
  Future<bool> setFRPAccount(String email);
  Future<PolicyStatus> getPolicyStatus();
}
