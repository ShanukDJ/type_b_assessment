import 'package:flutter/foundation.dart';

abstract class BiometricService {
  Future<bool> isBiometricsAvailable();
  Future<bool> authenticate({String reason});
}

class BiometricServiceImpl implements BiometricService {
  final bool mockAvailability;
  final bool mockSuccess;

  BiometricServiceImpl({this.mockAvailability = true, this.mockSuccess = true});

  @override
  Future<bool> isBiometricsAvailable() async {
    try {
      if (kIsWeb) return false;
      return mockAvailability;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> authenticate({
    String reason = 'Please authenticate to log in to NewsBay',
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      return mockSuccess;
    } catch (_) {
      return false;
    }
  }
}
