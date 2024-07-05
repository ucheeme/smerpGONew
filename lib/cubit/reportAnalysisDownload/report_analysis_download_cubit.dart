import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smerp_go/model/response/defaultApiResponse.dart';
import 'package:smerp_go/model/response/report/yearSaleReport.dart';

import '../../Reposistory/reportAnalysisRepo.dart';
import '../../model/response/report/customRangeSales.dart';
import '../../model/response/report/performingAnalysis.dart';
import '../../model/response/report/productAnalysis.dart';
import '../../model/response/report/salesAnalysis.dart';
import '../../utils/AppUtils.dart';

part 'report_analysis_download_state.dart';

class ReportAnalysisDownloadCubit extends Cubit<ReportAnalysisDownloadState> {
  final ReportAnalysisRepo repo;
  ReportAnalysisDownloadCubit(this.repo) : super(ReportAnalysisDownloadInitial());

  void downloadSaleReport(String saleType, String period,String type)async{
    try{
      emit(ReportAnalysisDownloadLoadingState());
      final response= await repo.downloadReport(saleType,period,type);
      if(response is DefaultApiResponse){
        emit(DownloadReportSuccessState(response));
      }else{
        emit(ReportAnalysisDownloadErrorState(response as DefaultApiResponse));
      }
    }catch(e, strace){
      print("faileeeed: $e and $strace");
      emit(ReportAnalysisDownloadErrorState(AppUtils.defaultErrorResponse()));
    }
  }

  void downloadSaleReportRange(String saleType, String startDate,String endDate, String type)async{
    try{
      emit(ReportAnalysisDownloadLoadingState());
      final response= await repo.downloadReport2(saleType,startDate,endDate,type);
      if(response is DefaultApiResponse){
        emit(DownloadReportSuccessState(response));
      }else{
        emit(ReportAnalysisDownloadErrorState(response as DefaultApiResponse));
      }
    }catch(e, strace){
      print("faileeeed: $e and $strace");
      emit(ReportAnalysisDownloadErrorState(AppUtils.defaultErrorResponse()));
    }
  }

  void getSalesReportAnalysisThisWeek()async {
    try {
      emit(ReportAnalysisDownloadLoadingState());
      final response = await repo.getSalesReport(0);
      if (response is SalesAnalysisThisWeek) {
        emit(SaleAnalysisSuccess(response));
      } else {
        emit(ReportAnalysisDownloadErrorState(response as DefaultApiResponse));
      }
    } catch (e, strace) {
      print("faileeeed: $e and $strace");
      emit(ReportAnalysisDownloadErrorState(AppUtils.defaultErrorResponse()));
    }
  }

  void getSalesReportAnalysisRange(String startDate, String endDate)async{
    try{
      emit(ReportAnalysisDownloadLoadingState());
      final response= await repo.getSalesReport(4,fromDate: startDate,toDate:endDate);
      if(response is SalesAnalysisM){
       emit(SaleAnalysisRangeSuccess(response));
      }else{
        emit(ReportAnalysisDownloadErrorState(response as DefaultApiResponse));
      }
    }catch(e, strace){
      print("faileeeed: $e and $strace");
      emit(ReportAnalysisDownloadErrorState(AppUtils.defaultErrorResponse()));
    }
  }

  void getSalesReportAnalysisThisMonth()async{
    try{
      emit(ReportAnalysisDownloadLoadingState());
      final response = await repo.getSalesReport(2);
      if(response is SalesAnalysisThisMontkh){
         emit(SalesAnalysisThisMonthSuccess(response));
      }else{
        emit(ReportAnalysisDownloadErrorState(response as DefaultApiResponse));
      }
    }catch(e, strace){
      print("faileeeed: $e and $strace");
      emit(ReportAnalysisDownloadErrorState(AppUtils.defaultErrorResponse()));
    }
  }

  void getSalesReportAnalysisPast(int period)async{
    try{
      emit(ReportAnalysisDownloadLoadingState());
      final response = await repo.getSalesReport(period);
      if(response is SalesAnalysisM){
        emit(SalesAnalysisLastMonthLastWeekSuccess(response));
      }else{
        emit(ReportAnalysisDownloadErrorState(response as DefaultApiResponse));
      }
    }catch(e, strace){
      print("faileeeed: $e and $strace");
      emit(ReportAnalysisDownloadErrorState(AppUtils.defaultErrorResponse()));
    }
  }

  void getProductReportAnalysis(int period)async{
    try{
      emit(ReportAnalysisDownloadLoadingState());
     final response= await repo.getProductReport(period);
      if(response is ProductAnalysis){
        //print("I emitted");
        emit(ProductAnalysisSuccess(response));
      }else{
        emit(ReportAnalysisDownloadErrorState(response as DefaultApiResponse));
       // print("The type is: ${response.runtimeType}");
      }
    }catch(e, strace){
      print("faileeeed: $e and $strace");
      emit(ReportAnalysisDownloadErrorState(AppUtils.defaultErrorResponse()));
    }
  }

  void getProductReportAnalysisRange(String startDate, String endDate)async{
    try{
      emit(ReportAnalysisDownloadLoadingState());
      final response= await repo.getProductReport(4,fromDate: startDate,toDate:endDate);
      if(response is ProductAnalysis){
        emit(ProductAnalysisSuccess(response));
      }else{
        emit(ReportAnalysisDownloadErrorState(response as DefaultApiResponse));
      }
    }catch(e, strace){
      print("faileeeed: $e and $strace");
      emit(ReportAnalysisDownloadErrorState(AppUtils.defaultErrorResponse()));
    }
  }

  void getBestPerformingProductReportAnalysis()async{
    try{
      emit(ReportAnalysisDownloadLoadingState());
      final response= await repo.getBestPerformingProductReport();
      if(response is PerformingAnalysis){

        emit(PerformingProductAnalysisSuccess(response));

      }else{
        emit(ReportAnalysisDownloadErrorState(response as DefaultApiResponse));
      }
    }catch(e, strace){
      print("faileeeed: $e and $strace");
      emit(ReportAnalysisDownloadErrorState(AppUtils.defaultErrorResponse()));
    }
  }

  void resetState(){
    emit(ReportAnalysisDownloadInitial());
  }
}
