import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smerp_go/model/response/LoginResponse.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/response/defaultApiResponse.dart';

final currencyFormatter =  NumberFormat("#,##0.00", "en_US");


class AppUtils{
  static String convertDateTimeDisplay(String date, String format) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat(format);
    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = serverFormater.format(displayDate);
    return formatted;
  }

  static String convertDate(DateTime now) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy HH:mm');
    final String formatted = formatter.format(now);
    return formatted;
  }
  static String convertDateSystem(DateTime now) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String formatted = formatter.format(now);
    return formatted;
  }

  static DefaultApiResponse defaultErrorResponse({String? msg = "error occurred"}){
    var returnValue =  DefaultApiResponse(isSuccess: false, message: msg!,data: null);
    return returnValue;
  }

  static void showSnack(String msg, BuildContext? context){
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 4),
      ));
    });
  }

  static Image imageFromBase64String(String base64String, double size)  {
    return Image.memory(base64Decode(base64String), width: size, height: size, fit: BoxFit.fill,);
  }
  static void showSuccessSnack(String msg, BuildContext? context){
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 4),
        backgroundColor: Colors.green,
      ));
    });
  }
  // static DefaultApiResponse defaultErrorResponse(){
  //   var returnValue =  DefaultApiResponse();
  //   var  result = Result();
  //   result.responseCode = "400";
  //   result.message = "error occurred";
  //   result.success = false;
  //   returnValue.result = result;
  //  return returnValue;
  // }
  static void debug(String msg){
    if (kDebugMode) {
      print(msg);
    }
  }

  static void showAlertDialog(BuildContext context, onTap, {String? msg}) {
    Widget okButton = ElevatedButton(onPressed: onTap, child: const Text("OK"));
    AlertDialog alert = AlertDialog(content:  Text(msg ?? "Action Successful!"),
      actions: [okButton],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  static String currency(BuildContext context) {
    var format = NumberFormat.simpleCurrency(name: "NGN");
  //  return format.currencySymbol;
    return "NGN";
  }
}
bool validateEmail(String value) {
  Pattern pattern =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?)*$";
  RegExp regex = RegExp(pattern as String);
  if (!regex.hasMatch(value)) {
    return false;
  }
  else {
    return true;
  }
}
bool validateMobile(String value) {
  String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  RegExp regExp =  RegExp(pattern);
  if (value.isEmpty) {
    return false;
  }
  if (value.length != 11) {
    return false;
  }
  else if (!regExp.hasMatch(value)) {
    return false;
  }
  return true;
}

var isLoading =Rx(false);
var isSignUpViaPhone = Rx(true);
String? userIdentityValue;
int? identitySource;
String otpCreateAccout= "";
String? userName;
String? userFirstName;
var userBusinessName="".obs;
String? userEmail;
String? userMerchantCode;
LoginData? loginData;
RxString userFirstNameS="".obs;
var isProductCategoryHasRun = Rx(false);
var isProductUnitCategoryHasRun = Rx(false);
var isInventoryListHasRun =false;
var isSalesListHasRun = Rx(false);
var isOrderListHasRun = Rx(false);
var isCatalogListHasRun = Rx(false);
var saleIsEmpty= RxBool(false);
var productIsEmpty= RxBool(false);
var orderListIsEmpty= RxBool(false);
RxBool isKeyboardOpen = false.obs;
bool isPasswordValid(String password) {
  if (password.length < 8) return false;
  if (!password.contains(RegExp(r"[a-z]"))) return false;
  if (!password.contains(RegExp(r"[A-Z]"))) return false;
  if (!password.contains(RegExp(r"[0-9]"))) return false;
  if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) return false;
  return true;
}
double getItemListContainerHeight(int length){
  switch(length){
    case 1: return 120.h;
    case 2: return 200.h;
    case 3: return 270.h;
    case 4: return 420.h;
    case 5: return 380.h;
    default: return 400.h;
  }
}
void onShare(BuildContext context,dynamic text) async {
  final box = context.findRenderObject() as RenderBox?;

  // subject is optional but it will be used
  // only when sharing content over email
  await Share.share(text,
      subject: "Share",
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
}

void copytext(String text, BuildContext context) {
  final snackBar = SnackBar(
    content: Text('Copied $text to Clipboard'),
  );
  Clipboard.setData(ClipboardData(text: text)).then((value) {
   //only if ->
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  });
}

void launchCaller() async {
  final url = Uri.parse('tel:+2348067822133');

  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}