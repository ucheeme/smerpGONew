import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';
import 'package:smerp_go/core/logging/app_logger.dart';
import 'package:smerp_go/core/logging/sensitive_log_sanitizer.dart';
import '../core/network/api_constants.dart';
import '../main.dart';
import '../model/response/defaultApiResponse.dart';
import '../utils/AppUtils.dart';
import '../utils/UserUtils.dart';
import '../utils/appUrl.dart';
import 'api_status.dart';
import 'package:path_provider/path_provider.dart';

enum HTTP_METHODS {
  post, put, patch, get, delete
}

class ApiService{
  static Future<Object> makeApiCall(dynamic request, String endpoint,
      {bool requireAccess = true, bool isAdmin = false,
        HTTP_METHODS method =  HTTP_METHODS.post}) async{
    try{
      var url = Uri.parse(endpoint);
      var body = request != null ? json.encode(request.toJson()) : null;
      var headers =  requireAccess ? {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${isAdmin ? clientAccessToken : userAccessToken}',
      } : {
        'Content-Type': 'application/json',
        'accept': '*/*',
      };
      _logRequest(url: url, headers: headers, body: body, method: method);
      Response? response;
      switch (method) {
        case HTTP_METHODS.post:
          response = await _withTimeout(http.post(url,
             headers: headers,
              body: body
          ));
          break;
        case HTTP_METHODS.put:
          response = await _withTimeout(http.put(url,
              headers: headers,
              body: body,

          ));
          break;
        case HTTP_METHODS.patch:
          response = await _withTimeout(http.patch(url,
              headers: headers,
              body: body
          ));
          break;
        case HTTP_METHODS.get:
          AppUtils.debug("trying a get request");
          response = await _withTimeout(http.get(url,
              headers: headers,
          ));
          break;
        case HTTP_METHODS.delete:
          response = await _withTimeout(http.delete(url,
              headers: headers,
              body: body
          ));
          break;
      }

      _logResponse(url: url, response: response);
      if (ApiResponseCodes.success == response.statusCode){
        return  Success(response.statusCode,response.body);
      }else if(response.headers['www-authenticate']!=null){
        if (response.headers['www-authenticate']!.contains(
            "The token expired")){
          return TokenExpired(response.statusCode,"Token Expired");
        }
        return  Failure(response.statusCode,response.body);
      }

      if (ApiResponseCodes.resourcenotfound == response.statusCode){
        return  Failure(response.statusCode,response.body);
      }
      if(response.statusCode == 400||response.statusCode==404){
        return  Failure(response.statusCode,
           response.body);
      }
      else{
        return  Failure(response.statusCode,response.body);
      }


    }on TimeoutException {
      return NetWorkFailure();
    }on HttpException{
      return  NetWorkFailure();

    }on FormatException{
      return  UnExpectedError();

    } catch (e, trace) {
      AppLogger.error(e, trace, reason: 'makeApiCall', tag: 'API');
      return  UnExpectedError();
    }
  }

  static Future<Object> makeApiCall2(dynamic request, String endpoint,
      {bool requireAccess = true, bool isAdmin = false,
        HTTP_METHODS method =  HTTP_METHODS.post}) async{
    try{
      var url = Uri.parse(endpoint);
      var body = request != null ? json.encode(request.toJson()) : null;
      var headers =  requireAccess ? {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${isAdmin ? clientAccessToken : userAccessToken}',
      } :
      {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      _logRequest(url: url, headers: headers, body: body, method: method);
      Response? response;
      switch (method) {
        case HTTP_METHODS.post:
          response = await _withTimeout(http.post(url,
              headers: headers,
              body: body
          ));
          break;
        case HTTP_METHODS.put:
          response = await _withTimeout(http.put(url,
              headers: headers,
              body: body
          ));
          break;
        case HTTP_METHODS.patch:
          response = await _withTimeout(http.patch(url,
              headers: headers,
              body: body
          ));
          break;
        case HTTP_METHODS.get:
          AppUtils.debug("trying a get request");
          response = await _withTimeout(http.get(url,
              headers: headers
          ));
          break;
        case HTTP_METHODS.delete:
          response = await _withTimeout(http.delete(url,
              headers: headers,
              body: body
          ));
          break;
      }

      _logResponse(url: url, response: response);
      if (ApiResponseCodes.success == response.statusCode){
        return  Success(response.statusCode,response.body);
      }
      if (ApiResponseCodes.resourcenotfound == response.statusCode){
        return  Success(response.statusCode,response.body);
      }
      if (ApiResponseCodes.authorizationError == response.statusCode){
        return ForbiddenAccess(response.statusCode, response.body);
      }
      if (ApiResponseCodes.forbidden== response.statusCode){
        return ForbiddenAccess(response.statusCode, response.body);
      }
      if(response.statusCode == 400||response.statusCode==404){
        return  Failure(response.statusCode, response.body);
      }
      else{
        return  Failure(response.statusCode,"Error Occurred");
      }

    }on TimeoutException {
      return NetWorkFailure();
    }on HttpException{
      return  NetWorkFailure();

    }on FormatException{
      return  UnExpectedError();

    } catch (e) {
      return  UnExpectedError();
    }
  }





  static Future<Object> getApiCallWithQueryParams(Map<String, String> query, String endpoint, {bool requireAccess = true, bool isAdmin = false}) async{
    try {
      var headers =  requireAccess ? {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${isAdmin ? clientAccessToken : userAccessToken}',
      } : {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      Uri url ;
      url = isProduction ?  Uri.https(AppUrls.rawBaseUrl, endpoint, query): Uri.http(AppUrls.rawBaseUrl, endpoint, query);
      AppUtils.debug("/****rest call request starts****/");
      AppUtils.debug("url: $url");
      AppUtils.debug("headers: ${SensitiveLogSanitizer.redactHeaders(headers)}");
      var response  = await _withTimeout(http.get(url,
        headers: headers,
      ));
      AppUtils.debug("/****rest call response starts****/");
      AppUtils.debug("status code: ${response.statusCode}");
      AppUtils.debug("rest response: "+response.body);
      if (ApiResponseCodes.success == response.statusCode){
        return  Success(response.statusCode,response.body);
      }
      if (ApiResponseCodes.resourcenotfound == response.statusCode || ApiResponseCodes.internalServerError == response.statusCode){
        return  Failure(response.statusCode,(defaultApiResponseFromJson(response.body)));
      }
      else{
        return  Failure(response.statusCode,"Error Occurred");
      }
    }on TimeoutException {
      return NetWorkFailure();
    }on HttpException{
      return  NetWorkFailure();
    }on FormatException{
      return  UnExpectedError();
    }catch (e){
      return UnExpectedError();
    }
  }
  static Future<File> downloadFile(String url, String filename) async {
    http.Client client =  http.Client();
    try {
      var req = await _withTimeout(client.get(Uri.parse(url)));
      var bytes = req.bodyBytes;
      String dir = (await getApplicationDocumentsDirectory()).path;
      File file =  File('$dir/$filename');
      await file.writeAsBytes(bytes);
      return file;
    } finally {
      client.close();
    }
  }
  static Future<Object> uploadDoc(File file, String url, String docType) async {
    try {
      var headers =   {
        'Accept': 'application/json',
        'Authorization': 'Bearer $userAccessToken',
      };
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll(headers);
    request.fields['DocumentType'] = docType;
    request.files.add(
        http.MultipartFile(
            'Image',
            file.readAsBytes().asStream(),
            file.lengthSync(),
            filename: file.path.split("/").last
        )
    );
      AppUtils.debug("/****rest call request starts****/");
      AppUtils.debug("url: $url");
      AppUtils.debug("headers: ${SensitiveLogSanitizer.redactHeaders(headers)}");
    var res = await request.send().timeout(ApiConstants.requestTimeout);
    final response = await res.stream.bytesToString();
    AppUtils.debug("/****rest call response starts****/");
    AppUtils.debug("status code: ${res.statusCode}");
    AppUtils.debug("rest response: "+response);
    if (ApiResponseCodes.success == res.statusCode){
      return  Success(res.statusCode,response);
    }
    if (ApiResponseCodes.resourcenotfound == res.statusCode || ApiResponseCodes.internalServerError == res.statusCode){
      return  Failure(res.statusCode,(defaultApiResponseFromJson(response)));
    }
    else{
      return  Failure(res.statusCode,"Error Occurred");
    }
    }on TimeoutException {
      return NetWorkFailure();
    }on HttpException{
      return  NetWorkFailure();

    }on FormatException{
      return  UnExpectedError();

    }catch (e){
      return UnExpectedError();
    }
  }

  static Future<Response> _withTimeout(Future<Response> request) {
    return request.timeout(ApiConstants.requestTimeout);
  }

  static void _logRequest({
    required Uri url,
    required Map<String, String> headers,
    required String? body,
    HTTP_METHODS? method,
  }) {
    AppUtils.debug("/****rest call request starts****/");
    AppUtils.debug("url: $url");
    AppUtils.debug(
      "headers: ${SensitiveLogSanitizer.redactHeaders(headers)}",
    );
    AppUtils.debug("body: ${SensitiveLogSanitizer.redactBody(body)}");
    if (method != null) {
      AppUtils.debug("method: $method");
    }
  }

  static void _logResponse({
    required Uri url,
    required Response response,
  }) {
    AppUtils.debug("/****rest call response starts****/");
    AppUtils.debug("url: $url");
    AppUtils.debug("status code: ${response.statusCode}");
    AppUtils.debug("rest response: ${response.body}");
  }
}
