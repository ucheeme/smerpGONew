import 'dart:async';
import 'dart:io';
// import 'package:device_imei/device_imei.dart';
import 'package:device_imei/device_imei.dart';
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
import 'package:ots/ots.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smerp_go/Reposistory/catalogRepo.dart';
import 'package:smerp_go/Reposistory/notificationRepo.dart';
import 'package:smerp_go/Reposistory/orderHistoryCubitRepo/orderHistoryRepo.dart';
import 'package:smerp_go/apiServiceLayer/firebase_api.dart';
import 'package:smerp_go/cubit/bankDetail/bank_details_cubit.dart';
import 'package:smerp_go/cubit/notificationCubit/notification_cubit.dart';
import 'package:smerp_go/cubit/orderHistoryCubit/order_history_cubit.dart';
import 'package:smerp_go/cubit/reportAnalysisDownload/report_analysis_download_cubit.dart';


import 'package:smerp_go/screens/onboarding/splashScreen1.dart';

import 'package:smerp_go/utils/app_services/httpHelper.dart';
import 'package:smerp_go/utils/app_services/networkservice.dart';


import 'Reposistory/productListRepo.dart';
import 'Reposistory/reportAnalysisRepo.dart';
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
    print('Not running on Android, skipping');
    return;
  }
  FirebaseApp app = await Firebase.initializeApp();
  print('Initialized default app $app from Android resource');
}


Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform
    );
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
      print("Handling a background message: ${message.messageId}");
    }
    // Listneing to the foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    await FirebaseApi().initNotifications();

    // options: DefaultFirebaseOptions.currentPlatform,);
    FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
    FirebaseAnalytics.instance.logAppOpen();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }on PlatformException {
    print('Failed to get platform version.');
  } catch(e) {
    print("Failed to initialize Firebase: $e");
  }  // initializeDefaultFromAndroidResource();
  remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(minutes: 1),
    minimumFetchInterval: const Duration(hours: 1),
  ));
  await remoteConfig.fetchAndActivate();
  // deviceMIME= await DeviceImei().getDeviceImei();

  print("This is the device imei:$deviceMIME");
  runApp( MyApp());
  Get.put < NetworkStatusService > (NetworkStatusService(), permanent: true);
  // EasyLoading.init();
  HttpOverrides.global = MyHttpOverrides();
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
    print("this is the device ID: $deviceId");
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
  DeviceInfo? deviceInfo;
  @override
  void initState() {
    FirebaseMessaging.instance.getToken().then((devToken) {
     deviceToken = devToken!;
     print("this is device token: $deviceToken");
    });
    super.initState();
   // _getImei();
   //_getIMEI();
  }
  static const platform = const MethodChannel('samples.flutter.dev/imei');
  String _imeiNumber = 'Unknown';

  // Future<void> _getIMEI() async {
  //   String imeiNumber;
  //   try {
  //     final String result = await platform.invokeMethod('getIMEI');
  //     imeiNumber = 'IMEI number: $result';
  //   } on PlatformException catch (e) {
  //     imeiNumber = "Failed to get IMEI number: '${e.message}'.";
  //   }
  //
  //   setState(() {
  //     _imeiNumber = imeiNumber;
  //     deviceMIME=_imeiNumber;
  //   });
  //   print("I got the IMEI: $deviceMIME and $_imeiNumber");
  // }
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
        bloc.BlocProvider(create: (BuildContext context) => CatalogCubit( )),
        bloc.BlocProvider(create: (BuildContext context) => OrderHistoryCubit(orderHistoryRepo: OrderHistoryRepo() )),
        bloc.BlocProvider(create: (BuildContext context) => CollectionCubit(productListRepo: CollectionRepo() )),
        bloc.BlocProvider(create: (BuildContext context) => ReportAnalysisDownloadCubit( ReportAnalysisRepo() )),
        bloc.BlocProvider(create: (BuildContext context) => NotificationCubit(NotificationRepo())),
        bloc.BlocProvider(create: (BuildContext context) => BankDetailsCubit(CataloRepo())),
      ],
      child: ScreenUtilInit(
        designSize: Size(430, 954),
        minTextAdapt: true,
        // ensureScreenSize: true,
        builder: (BuildContext context, Widget? child) {
          return OTS(
            child: GetMaterialApp(
                title: 'Smerpgo',
                initialRoute: '/',
                getPages: [GetPage(name: '/', page: () =>
                    SplashScreen())],
                debugShowCheckedModeBanner: false,
             //  theme: Get.theme

            ),
          );
        },

      ),
    );
  }


}

