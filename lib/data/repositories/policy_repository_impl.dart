import '../../domain/entities/policy_status.dart';
import '../../domain/repositories/policy_repository.dart';
import '../services/platform_service.dart';

class PolicyRepositoryImpl implements PolicyRepository {
  final PlatformService _platformService;

  PolicyRepositoryImpl(this._platformService);

  @override
  Future<bool> isDeviceOwnerActive() => _platformService.isDeviceOwnerActive();

  @override
  Future<bool> isUninstallBlocked() => _platformService.isUninstallBlocked();

  @override
  Future<bool> setUninstallBlocked(bool block) =>
      _platformService.setUninstallBlocked(block);

  @override
  Future<PolicyStatus> getPolicyStatus() async {
    final isOwner = await isDeviceOwnerActive();
    final isBlocked = await isUninstallBlocked();
    final isQr = await _platformService.isProvisionedViaQR();
    final isResetDisabled = await _platformService.isFactoryResetDisabled();

    return PolicyStatus(
      isDeviceOwner: isOwner,
      isUninstallBlocked: isBlocked,
      isPolicyApplied: isOwner && isBlocked,
      isProvisionedViaQR: isQr,
      isFactoryResetDisabled: isResetDisabled,
    );
  }

  @override
  Future<bool> isProvisionedViaQR() => _platformService.isProvisionedViaQR();

  @override
  Future<bool> setFactoryResetDisabled(bool disabled) =>
      _platformService.setFactoryResetDisabled(disabled);

  @override
  Future<bool> isFactoryResetDisabled() =>
      _platformService.isFactoryResetDisabled();

  @override
  Future<bool> setFRPAccount(String email) =>
      _platformService.setFRPAccount(email);
}
