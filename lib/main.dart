import 'dart:async';
import 'dart:io';
// import 'package:device_imei/device_imei.dart';
import 'package:device_info_plus/device_info_plus.dart';
// import 'package:device_information/device_information.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
// import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
// import 'package:mobile_device_identifier/mobile_device_identifier.dart';
// import 'package:ots/ots.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smerp_go/apiServiceLayer/firebase_api.dart';
import 'package:smerp_go/cubit/bankDetail/bank_details_cubit.dart';
import 'package:smerp_go/cubit/notificationCubit/notification_cubit.dart';
import 'package:smerp_go/cubit/orderHistoryCubit/order_history_cubit.dart';
import 'package:smerp_go/cubit/reportAnalysisDownload/report_analysis_download_cubit.dart';


import 'package:smerp_go/screens/onboarding/splashScreen1.dart';

import 'package:smerp_go/core/logging/app_error_reporter.dart';
import 'package:smerp_go/core/logging/app_logger.dart';
import 'package:smerp_go/core/repositories/app_repositories.dart';
import 'package:smerp_go/core/session/credential_storage.dart';
import 'package:smerp_go/core/session/credential_storage_keys.dart';
import 'package:smerp_go/core/session/session_manager.dart';
import 'package:smerp_go/utils/AppUtils.dart';
import 'package:smerp_go/utils/app_services/httpHelper.dart';
import 'package:smerp_go/utils/app_services/networkservice.dart';


import 'cubit/catalogCubit/catalog_cubit.dart';
import 'cubit/products/product_cubit.dart';
import 'firebase_options.dart';



String? deviceMIME="";
String deviceId = "";
String deviceName = "";
String deviceToken = "";
int deviceType = 0;
String platformOS = "";
String deviceModel = "";
String appleId = "1552300596";
String androidId = "com.fifthlab.smerpgo";
String updateMsg = "There is a new update available";
PackageInfo? packageInfo;
var sessionExpired = false;
var requireUpdate = false;
const isProduction = true;
var remoteConfig;

Future<void> initializeDefaultFromAndroidResource() async {
  if (defaultTargetPlatform != TargetPlatform.android || kIsWeb) {
    AppLogger.debug('Not running on Android, skipping', tag: 'Firebase');
    return;
  }
  FirebaseApp app = await Firebase.initializeApp();
  AppLogger.debug('Initialized default app $app from Android resource', tag: 'Firebase');
}


Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform
    );
    await AppErrorReporter.initialize();
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
      await Firebase.initializeApp();
      AppLogger.debug('Handling background message: ${message.messageId}', tag: 'FCM');
    }
    // Listneing to the foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      AppLogger.debug('Foreground FCM message received', tag: 'FCM');
      AppLogger.debug('Message data keys: ${message.data.keys.toList()}', tag: 'FCM');

      if (message.notification != null) {
        AppLogger.debug('Message contained notification payload', tag: 'FCM');
      }
    });

    await FirebaseApi().initNotifications();

    // options: DefaultFirebaseOptions.currentPlatform,);
    FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
    FirebaseAnalytics.instance.logAppOpen();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }on PlatformException {
    AppLogger.warning('Failed to get platform version.', tag: 'Firebase');
  } catch(e, trace) {
    AppLogger.error(e, trace, reason: 'Failed to initialize Firebase', tag: 'Firebase');
  }  // initializeDefaultFromAndroidResource();
  remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(minutes: 1),
    minimumFetchInterval: const Duration(hours: 1),
  ));
  await remoteConfig.setDefaults({
    CredentialStorageKeys.remoteConfigFlag:
        CredentialStorage.defaultSecureStorageEnabled,
  });
  await remoteConfig.fetchAndActivate();
  await SessionManager.restoreSessionFromStorage();
  // deviceMIME= await DeviceImei().getDeviceImei();

  AppUtils.debug("Device MIME type: $deviceMIME");
  if (MyHttpOverrides.isEnabled) {
    HttpOverrides.global = MyHttpOverrides();
  }
  runApp( MyApp());
  Get.put < NetworkStatusService > (NetworkStatusService(), permanent: true);
  // EasyLoading.init();
  // final _mobileDeviceIdentifier = MobileDeviceIdentifier().getDeviceId();
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
   packageInfo = await PackageInfo.fromPlatform();

  if (Platform.isAndroid) {
    AndroidDeviceInfo info = await deviceInfo.androidInfo;
    deviceId = info.id;
    deviceName = info.manufacturer;
    deviceModel = info.model!;
    // deviceToken = info.id!;
    deviceMIME = info.type;
    deviceType = 1;
  //print("this is the device ID: $deviceId :,$_mobileDeviceIdentifier");
  //   print("this is the device ID2: ${info}");
  }

  else if (Platform.isIOS) {
    IosDeviceInfo info = await deviceInfo.iosInfo;
    deviceId = info.identifierForVendor!;
    deviceName = info.name! + "' " + info.utsname.machine!;
    deviceModel = info.model!;
    deviceToken = info.localizedModel!;
    deviceType = 2;
    AppUtils.debug("Device ID initialized");
    //deviceType = info.systemName! + "ios" + info.systemVersion!;
  }
  else if (Platform.isLinux) {
    LinuxDeviceInfo info = await deviceInfo.linuxInfo;
  }
  else if (Platform.isMacOS) {
    MacOsDeviceInfo info = await deviceInfo.macOsInfo;
  }
  else if (Platform.isWindows) {
    WindowsDeviceInfo info = await deviceInfo.windowsInfo;
  }
  final info = await deviceInfo.deviceInfo;

}




class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  State<MyApp> createState() => _MyApp();
}
class _MyApp extends State<MyApp> {
  // final _deviceImeiPlugin = DeviceImei();
  bool getPermission = false;
  String message = "Please allow permission request!";
  @override
  void initState() {
    FirebaseMessaging.instance.getToken().then((devToken) {
      if (devToken != null) {
        deviceToken = devToken;
        AppUtils.debug("FCM device token acquired");
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark
    ));
    WidgetsFlutterBinding.ensureInitialized();
    return bloc.MultiBlocProvider(
      providers: [
        bloc.BlocProvider(
            create: (BuildContext context) =>
                CatalogCubit(catalogRepository: AppRepositories.catalog)),
        bloc.BlocProvider(
            create: (BuildContext context) => OrderHistoryCubit(
                orderHistoryRepo: AppRepositories.orderHistory)),
        bloc.BlocProvider(
            create: (BuildContext context) => CollectionCubit(
                productListRepo: AppRepositories.collection)),
        bloc.BlocProvider(
            create: (BuildContext context) =>
                ReportAnalysisDownloadCubit(AppRepositories.reportAnalysis)),
        bloc.BlocProvider(
            create: (BuildContext context) =>
                NotificationCubit(AppRepositories.notification)),
        bloc.BlocProvider(
            create: (BuildContext context) =>
                BankDetailsCubit(AppRepositories.bankDetails)),
      ],
      child: ScreenUtilInit(
        designSize: Size(430, 954),
        minTextAdapt: true,
        // ensureScreenSize: true,
        builder: (BuildContext context, Widget? child) {
          return  GetMaterialApp(
                title: 'Smerpgo',
                initialRoute: '/',
                getPages: [GetPage(name: '/', page: () => SplashScreen())],
                debugShowCheckedModeBanner: false,
             //  theme: Get.theme
            );
        },

      ),
    );
  }


}

