import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smerp_go/utils/AppUtils.dart';
import 'package:http/http.dart' as http;


String truncateText(String value,int start){
  if(value.length>start){
    return value.replaceRange(start, value.length, "...");
  }else{
    return value;
  }
}

String userAccessToken = "";
String clientAccessToken = "";
String actionBy = "";
String inventoryId="";
RxString userImage ="".obs;
RxString storeNPhone ="".obs;
RxString storeNEmail ="".obs;

class SharedPref {
  static read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    var  stringValue = prefs.getString(key)??"";
    return stringValue;
  }

  static save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  static saveBool(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  static Future<bool> getBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

  static remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}

bool checkIfProfileDataIsCompleted(){
  if(loginData!.firstName.toLowerCase()=="First name".toLowerCase()||loginData!.firstName.isEmpty
      ||loginData!.lastName.isEmpty
      ||loginData!.storeEmail==""||loginData!.storeName.isEmpty
      ||loginData!.avatar.isEmpty){
    return false;
  }else{
    return true;
  }
}

Future<String> fetchImageToBase64(String url) async {
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
   return base64Encode(response.bodyBytes);
  } else {
    throw Exception('Failed to load image');
  }
}

class SharedPrefKeys{
  static const loginValidationInfo = "loginInfo";
  static const loginRequestInfo = 'loginRequestInfo';
  static const checkedTerms = 'checkedTerms';
  static const enableBiometric = 'enableBiometric';
  static const bankList = 'bankList';
  static const firstTimeUser = "firstTimeUser";
  static const salesAnalysisThisWeek="salesAnalysisThisWeek";
  static const salesAnalysisLastWeek="salesAnalysisLastWeek";
  static const salesAnalysisLastMonth="salesAnalysisLastMonth";
  static const salesAnalysisThisMonth="salesAnalysisThisMonth";

  static const productAnalysisThisWeek="productAnalysisThisWeek";
  static const productAnalysisLastWeek="productAnalysisLastWeek";
  static const productAnalysisLastMonth="productAnalysisLastMonth";
  static const productAnalysisThisMonth="productAnalysisThisMonth";
  static const BestPerformingProductAnalysis="BestPerformingProductAnalysis";
}