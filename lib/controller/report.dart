import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:smerp_go/cubit/reportAnalysisDownload/report_analysis_download_cubit.dart';
import 'package:smerp_go/model/response/report/salesAnalysis.dart';
import 'package:smerp_go/utils/UserUtils.dart';
import 'package:smerp_go/utils/mockdata/tempData.dart' as tempData;
import '../cubit/products/product_cubit.dart';
import '../model/response/report/performingAnalysis.dart';
import '../model/response/report/productAnalysis.dart';

class ReportController extends GetxController {

  RxList<DateTime?> selectedDateRange = RxList();
  RxInt selectedFilterChoice = 0.obs;
  TextEditingController emailAddress = TextEditingController();
   SalesAnalysisThisWeek? salesAnalysis;
   ProductAnalysis? productAnalysis;
  PerformingAnalysis? performingAnalysis;
  RxList<ReportProduct> bestPerformingProductList = RxList();
  RxList<ReportProduct> bestPerformingProductListLastWeek = RxList();
  RxList<ReportProduct> bestPerformingProductListLastMonth = RxList();
  RxList<ReportProduct> bestPerformingProductListThisMonth = RxList();
  RxString dateChange = "Select date".obs;
  RxBool isReportAnalysis = false.obs;
  RxInt? period = 0.obs;
  RxInt inventoryPeriod = 0.obs;
  RxInt performingPeriod = 0.obs;
  TabController? bestPerformingProductTabController;
  List<String> saleReportTitles = ["Total sales", "Gross profit", "Offline sales", "Storefront sales"];
  List<String> inventoryReportTitles = ["Product sold", "New products",];

 // late ReportAnalysisDownloadCubit cubit;

  void getReportAnalysisInitialize(BuildContext context)  {
      // performingAnalysis = (tempData.performingAnalysis);
      // salesAnalysis = getCurrentSaleRecord(0);
      // productAnalysis = getCurrentProductRecord(0);
  }




  void setSalesAnalysisTempData(SaleAnalysisSuccess state) {
    print("ressssspppp: ${state.response.runtimeType}");
    switch (period!.value){
      case 0:tempData.saleAnalysisThisWeek=state.response;
      break;
      case 1:tempData.saleAnalysisLastWeek=state.response;
      break;
      case 2:tempData.saleAnalysisThisMonth=state.response;
      break;
      case 3: tempData.saleAnalysisLastMonth=state.response;
      break;
    }
  }

  void setProductAnalysisTempData(ProductAnalysisSuccess state) {
    print("resp: ${state.response.runtimeType}");
    switch (inventoryPeriod.value){
      case 0:tempData.productAnalysisThisWeek=state.response;
      break;
      case 1:tempData.productAnalysisLastWeek=state.response;
      break;
      case 2:tempData.productAnalysisThisMonth=state.response;
      break;
      case 3: tempData.productAnalysisLastMonth=state.response;
      break;
    }
  }

  // SalesAnalysisThisWeek getCurrentSaleRecord(int period){
  //   switch (period){
  //     case 0:
  //       {
  //        SalesAnalysisThisWeek? response =
  //             tempData.saleAnalysisThisWeek;
  //         return response!;
  //       }
  //
  //     case 1:
  //       {
  //         SalesAnalysisThisWeek? response =
  //             tempData.saleAnalysisLastWeek;
  //         return response!;
  //       }
  //     case 2:
  //       {
  //         SalesAnalysisThisWeek? response =  tempData.saleAnalysisThisMonth;
  //         return response!;
  //       }
  //     case 3:
  //       {
  //         SalesAnalysisThisWeek? response =   tempData.saleAnalysisLastMonth;
  //         return response!;
  //       }
  //
  //     default:
  //      return SalesAnalysisThisWeek(lastWeek: null);
  //   }
  // }

  ProductAnalysis getCurrentProductRecord(int period){
    switch (period){
      case 0:
        {
          ProductAnalysis? response =  tempData.productAnalysisThisWeek;
          return response!;
        }

      case 1:
        {
          ProductAnalysis? response =   tempData.productAnalysisLastWeek;
          return response!;
        }
      case 2:
        {
          ProductAnalysis? response =   tempData.productAnalysisThisMonth;
          return response!;
        }
      case 3:
        {
          ProductAnalysis? response =   tempData.productAnalysisLastMonth;
          return response!;
        }

      default:
        return ProductAnalysis(sold: 0,stock: 0);
    }
  }

  PerformingAnalysis? getPerformingAnalysis(){
    PerformingAnalysis? response =   tempData.performingAnalysis;
   return response;
  }
// Future<void> onRefresh()async{
//     cubit.getBestPerformingProductReportAnalysis();
// }


String checkQuantity(int value){
  if(value.toString().length>3){
    double response= value/1000;
    return "$response k+";
  // }else if( value.toString().length>4){
  //   double response= value/1000;
  //   return "$response k";
 }else if( value.toString().length>5){
    double response= value/100000;
    return "$response m+";
  }else{
    return "$value ";
  }
  return "";
}
}