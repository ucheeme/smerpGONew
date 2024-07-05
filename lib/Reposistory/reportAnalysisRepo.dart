import 'dart:convert';

import 'package:smerp_go/Reposistory/apiRepo.dart';
import 'package:smerp_go/model/response/report/salesAnalysis.dart';

import '../apiServiceLayer/apiService.dart';
import '../model/response/defaultApiResponse.dart';
import '../model/response/report/customRangeSales.dart';
import '../model/response/report/performingAnalysis.dart';
import '../model/response/report/productAnalysis.dart';
import '../utils/appUrl.dart';

class ReportAnalysisRepo extends ApiRepository{
  Future<Object> getSalesReport(int period,{String fromDate="",String toDate=""}) async {
    var response = await ApiService.makeApiCall(
        null, (period==4)?
    AppUrls().salesAnalysisRange(period, fromDate, toDate)
    :
    AppUrls().salesAnalysis(period),
        method: HTTP_METHODS.get);
    var r = handleSuccessResponse(response);
    if (r is DefaultApiResponse) {
      if (r.isSuccess) {
        if(period==0){
           SalesAnalysisThisWeek res = salesAnalysisThisWeekFromJson(json.encode(r.data));
          return res;
        }
        else if(period==2){
          SalesAnalysisThisMontkh res = salesAnalysisThisMontkhFromJson(json.encode(r.data));
          return res;
        }else if(period==4){
          SalesAnalysisM res = salesAnalysisMFromJson(json.encode(r.data));
          return res;
       }else{
          SalesAnalysisM res = salesAnalysisMFromJson(json.encode(r.data));
          return res;
        }

      } else {
        print("failed response here:${r}");
        return r;
      }
    }
    else {
      print("failed2 response here:${r}");
      handleErrorResponse(response);
      return errorResponse!;
    }
  }



  Future<Object> getProductReport(int period,{String fromDate="",String toDate=""}) async {
    var response = await ApiService.makeApiCall(
       null, (period==4)?
    AppUrls().productAnalysisRange(period, fromDate, toDate)
        :AppUrls().productAnalysis(period),
        method: HTTP_METHODS.get);
    var r = handleSuccessResponse(response);
    if (r is DefaultApiResponse) {
      if (r.isSuccess) {
        ProductAnalysis res = productAnalysisFromJson(json.encode(r.data));
        return res;
      } else {
        print("failed response here:${r}");
        return r;
      }
    }
    else {
      print("failed2 response here:${r}");
      handleErrorResponse(response);
      return errorResponse!;
    }
  }

  Future<Object> getBestPerformingProductReport() async {
    var response = await ApiService.makeApiCall(
        null, AppUrls().performingProductAnalysis(),
        method: HTTP_METHODS.get);
    var r = handleSuccessResponse(response);
    if (r is DefaultApiResponse) {
      if (r.isSuccess) {
        PerformingAnalysis res = performingAnalysisFromJson(json.encode(r.data));
        return res;
      } else {
        print("failed response here:${r}");
        return r;
      }
    }
    else {
      print("failed2 response here:${r}");
      handleErrorResponse(response);
      return errorResponse!;
    }
  }

  Future<Object> downloadReport(String saleType, String period,String type) async {
    var response = await ApiService.makeApiCall(
        null, AppUrls().downloadReportData(saleType, period,type),
        method: HTTP_METHODS.get);
    var r = handleSuccessResponse(response);
    // if (r is DefaultApiResponse) {  
    return r;
  }


  Future<Object> downloadReport2(String saleType, String startDate, String endDate,String type) async {
    var response = await ApiService.makeApiCall(
        null, AppUrls().downloadReportDataRange(saleType, startDate,endDate,type),
        method: HTTP_METHODS.get);
    var r = handleSuccessResponse(response);
    return r;
  }
}