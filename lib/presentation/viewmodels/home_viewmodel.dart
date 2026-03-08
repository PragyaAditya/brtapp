import 'package:flutter/foundation.dart';
import '../../domain/entities/policy_status.dart';
import '../../domain/repositories/policy_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final PolicyRepository _policyRepository;

  PolicyStatus _status = PolicyStatus.initial();
  PolicyStatus get status => _status;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  HomeViewModel(this._policyRepository) {
    refreshStatus();
  }

  Future<void> refreshStatus() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _status = await _policyRepository.getPolicyStatus();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleUninstallBlocked(bool block) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final success = await _policyRepository.setUninstallBlocked(block);
      if (success) {
        await refreshStatus();
      } else {
        _error = "Failed to update policy. Ensure app is Device Owner.";
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleFactoryResetDisabled(bool disabled) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final success = await _policyRepository.setFactoryResetDisabled(disabled);
      if (success) {
        await refreshStatus();
      } else {
        _error = "Failed to update policy. Ensure app is Device Owner.";
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> setFRPAccount(String email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final success = await _policyRepository.setFRPAccount(email);
      if (success) {
        await refreshStatus();
      } else {
        _error = "Failed to set FRP account.";
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
