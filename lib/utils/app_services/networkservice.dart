import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smerp_go/core/network/connectivity_status.dart';

import '../AppUtils.dart';

class NetworkStatusService extends GetxService {
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  NetworkStatusService() {
    _subscription = Connectivity().onConnectivityChanged.listen(
      _handleConnectivityChange,
    );
  }

  void _handleConnectivityChange(List<ConnectivityResult> results) {
    if (ConnectivityStatus.hasActiveConnection(results)) {
      return;
    }

    Get.snackbar(
      "NETWORK FAILURE",
      "Lost Internet Connection",
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
    isLoading.value = false;
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
