import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smerp_go/model/response/report/monthSaleReport.dart';
import 'package:smerp_go/utils/mockdata/mockDataGraph.dart';
import '../Reposistory/apiRepo.dart';
import '../apiServiceLayer/apiService.dart';
import '../apiServiceLayer/api_status.dart';
import '../model/response/report/weekSaleReport.dart';
import '../utils/AppUtils.dart';
import '../utils/appUrl.dart';
import '../utils/app_services/helperClass.dart';

class ReportsControler extends GetxController{
  RxBool isLastWeek = false.obs;
  RxBool  isLastMonth= false.obs;
  RxBool isThisWeek = false.obs;
  RxBool isThisMonth = false.obs;
  RxBool isMonth = false.obs;
  RxBool isLoading = false.obs;
  // List<SalesByMonthSeries> saleReportData = [];
  // List<SalesByWeekSeries> saleReportDataWeek = [];
  //

  // bool checkIfEnabled(SearchReports type) {
  //   switch (type) {
  //     case SearchReports.lastweek:
  //       {
  //         saleReportDataWeek.clear();
  //         isLastMonth.value = false;
  //         isThisWeek.value = false;
  //         isThisMonth.value = false;
  //         isMonth.value = false;
  //         return isLastWeek.value = true;
  //       }
  //       break;
  //     case SearchReports.lastmonth:
  //       {
  //         saleReportData.clear();
  //         isLastWeek.value = false;
  //         isThisWeek.value = false;
  //         isThisMonth.value = false;
  //         isMonth.value = true;
  //         saleReportByMonth(DateTime.now().month-1);
  //         return isLastMonth.value = true;
  //       }
  //       break;
  //     case SearchReports.thisweek:
  //       {
  //         saleReportDataWeek.clear();
  //         isLastWeek.value = false;
  //         isThisMonth.value = false;
  //         isLastMonth.value = false;
  //         isMonth.value=false;
  //         saleReportByWeek();
  //         return isThisWeek.value = true;
  //       }
  //       break;
  //     case SearchReports.thismonth:
  //       {
  //         saleReportData.clear();
  //         isLastWeek.value = false;
  //         isLastMonth.value = false;
  //         isThisWeek.value = false;
  //         isMonth.value=true;
  //         saleReportByMonth(DateTime.now().month);
  //         return isThisMonth.value = true;
  //       }
  //       break;
  //   }
  // }

  Future getPdf(String fileName,Uint8List screenShot,{
    context
  }) async {
    pw.Document pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Expanded(
              child:  pw.Image(pw.MemoryImage(screenShot), fit: pw.BoxFit.contain)
          );
        },
      ),
    );
    String path = (await getTemporaryDirectory()).path;
    File pdfFile = await File('$path/$fileName.pdf').create();

    pdfFile.writeAsBytesSync(await pdf.save().whenComplete(() =>
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Download Complete")))));
   // await Share.shareFiles([pdfFile.path]);
  }

  Future shareFile(String fileName,Uint8List screenShot,) async {
    // final filename = basename(url);

    pw.Document pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Expanded(
              child:  pw.Image(pw.MemoryImage(screenShot), fit: pw.BoxFit.contain)
          );
        },
      ),
    );
    String path = (await getTemporaryDirectory()).path;
    File pdfFile = await File('$path/$fileName.pdf').create();

    pdfFile.writeAsBytesSync(await pdf.save());
     await Share.shareXFiles([pdfFile as XFile]);
  }

  Future<List<SaleReportData>> saleReportByMonth(int month,{isRefresh=
  false,
    RefreshController? refreshController})async{
    int year = DateTime.now().year;
    (isRefresh) ?isLoading.value=false:
    isLoading.value = true;

    var response = await ApiService.makeApiCall(null,
        AppUrls().reportByMonth(year,month),
        method: HTTP_METHODS.get );
    if(response is Success){
      try{
        var data = monthSalesReportFromJson(await response.response as String);
        if(data.isSuccess && data.data != null){
          isLoading.value = false;
          if(data.data!.sales.isEmpty){

          }else{
           for(var element in data.data!.sales ){
            //saleReportData.add(SalesByMonthSeries(data: element));
           }
          }
          isLoading.value = false;
          (isRefresh)?refreshController?.refreshCompleted():null;

          return data.data!.sales;
        }else{

        //  saleReportData=[];
          Get.snackbar("Sale Successful ",
            data.message,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: Duration(seconds: 3)
          );
          isLoading.value = false;


          return [];
        }
      }catch(e,trace){
        isLoading.value = false;
        AppUtils.debug(e.toString());
        AppUtils.debug(trace.toString());
        (isRefresh)?refreshController?.refreshFailed():null;
      }
    }else{
      isLoading.value = false;
      (isRefresh)?refreshController?.refreshFailed():null;
      var repo = ApiRepository();
      repo.handleErrorResponse(response);
    }
    return [];
  }

  Future<List<SaleReportDataWeek>> saleReportByWeek({isRefresh=
  false,
    RefreshController? refreshController})async{
    int year = DateTime.now().year;
    (isRefresh) ?isLoading.value=false:
    isLoading.value = true;

    var response = await ApiService.makeApiCall(null,
        AppUrls().reportByWeek(),
        method: HTTP_METHODS.get );
    if(response is Success){
      try{
        var data = reportSalesByWeekFromJson(await response.response as String);
        if(data.isSuccess && data.data != null){
          isLoading.value = false;
          if(data.data!.isEmpty){
           // saleReportDataWeek=[];
          }else{
            for(var element in data.data! ){
             // saleReportDataWeek.add(SalesByWeekSeries(data: element));
            }
          }
          isLoading.value = false;
          (isRefresh)?refreshController?.refreshCompleted():null;

          return data.data!;
        }else{

         // saleReportData=[];
          Get.snackbar("Sale Successful ",
              data.message,
              backgroundColor: Colors.red,
              colorText: Colors.white,
              duration: Duration(seconds: 3)
          );
          isLoading.value = false;


          return [];
        }
      }catch(e,trace){
        isLoading.value = false;
        AppUtils.debug(e.toString());
        AppUtils.debug(trace.toString());
        (isRefresh)?refreshController?.refreshFailed():null;
      }
    }else{
      isLoading.value = false;
      (isRefresh)?refreshController?.refreshFailed():null;
      var repo = ApiRepository();
      repo.handleErrorResponse(response);
    }
    return [];
  }
}