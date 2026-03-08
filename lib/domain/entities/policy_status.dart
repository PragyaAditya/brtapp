class PolicyStatus {
  final bool isDeviceOwner;
  final bool isUninstallBlocked;
  final bool isPolicyApplied;
  final bool isProvisionedViaQR;
  final bool isFactoryResetDisabled;
  final String? frpAccount;

  PolicyStatus({
    required this.isDeviceOwner,
    required this.isUninstallBlocked,
    required this.isPolicyApplied,
    required this.isProvisionedViaQR,
    required this.isFactoryResetDisabled,
    this.frpAccount,
  });

  factory PolicyStatus.initial() => PolicyStatus(
    isDeviceOwner: false,
    isUninstallBlocked: false,
    isPolicyApplied: false,
    isProvisionedViaQR: false,
    isFactoryResetDisabled: false,
    frpAccount: null,
  );

  PolicyStatus copyWith({
    bool? isDeviceOwner,
    bool? isUninstallBlocked,
    bool? isPolicyApplied,
    bool? isProvisionedViaQR,
    bool? isFactoryResetDisabled,
    String? frpAccount,
  }) {
    return PolicyStatus(
      isDeviceOwner: isDeviceOwner ?? this.isDeviceOwner,
      isUninstallBlocked: isUninstallBlocked ?? this.isUninstallBlocked,
      isPolicyApplied: isPolicyApplied ?? this.isPolicyApplied,
      isProvisionedViaQR: isProvisionedViaQR ?? this.isProvisionedViaQR,
      isFactoryResetDisabled:
          isFactoryResetDisabled ?? this.isFactoryResetDisabled,
      frpAccount: frpAccount ?? this.frpAccount,
    );
  }
}
