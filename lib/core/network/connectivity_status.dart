import 'package:connectivity_plus/connectivity_plus.dart';

/// Connectivity helpers kept separate from [GetxService] for testability.
class ConnectivityStatus {
  ConnectivityStatus._();

  static bool hasActiveConnection(List<ConnectivityResult> results) {
    return results.any(
      (result) =>
          result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.ethernet ||
          result == ConnectivityResult.vpn ||
          result == ConnectivityResult.other,
    );
  }
}
