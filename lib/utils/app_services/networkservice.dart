import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:permission_handler/permission_handler.dart';

import '../AppUtils.dart';

class NetworkStatusService extends GetxService {
  NetworkStatusService() {
    Connectivity().onConnectivityChanged.listen(
          (status) async {
        _getNetworkStatus(status as ConnectivityResult);
      }, );
  }
  void _getNetworkStatus(ConnectivityResult status) {
    if (status == ConnectivityResult.mobile || status == ConnectivityResult.wifi) {
    // Get.snackbar("hkhk","");
    } else {
      Get.snackbar("NETWORK FAILURE",
          "Lost Internet Connection",
          backgroundColor: Colors.red,
          colorText: Colors.white,);
     isLoading.value= false;
    }
  }
}

