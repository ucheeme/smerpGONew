part of 'report_analysis_download_cubit.dart';

abstract class ReportAnalysisDownloadState extends Equatable {
  const ReportAnalysisDownloadState();
}

class ReportAnalysisDownloadInitial extends ReportAnalysisDownloadState {
  @override
  List<Object> get props => [];
}

class ReportAnalysisDownloadLoadingState extends ReportAnalysisDownloadState {
  @override
  List<Object> get props => [];
}

class ReportAnalysisDownloadErrorState extends ReportAnalysisDownloadState{
  final DefaultApiResponse errorResponse;
  ReportAnalysisDownloadErrorState(this.errorResponse);
  @override
  // TODO: implement props
  List<Object?> get props => [errorResponse];
}
class DownloadReportSuccessState extends ReportAnalysisDownloadState{
  final DefaultApiResponse errorResponse;
  DownloadReportSuccessState(this.errorResponse);
  @override
  // TODO: implement props
  List<Object?> get props => [errorResponse];
}
class SaleAnalysisSuccess extends ReportAnalysisDownloadState{
  final SalesAnalysisThisWeek response;
  SaleAnalysisSuccess(this.response);
  @override
  List<Object> get props =>[response];
}

class SaleAnalysisRangeSuccess extends ReportAnalysisDownloadState{
  final SalesAnalysisM response;
  SaleAnalysisRangeSuccess(this.response);
  @override
  List<Object> get props =>[response];
}

class PerformingProductAnalysisSuccess extends ReportAnalysisDownloadState{
  final PerformingAnalysis response;
  PerformingProductAnalysisSuccess(this.response);
  @override
  List<Object> get props =>[response];
}

class ProductAnalysisSuccess extends ReportAnalysisDownloadState{
  final ProductAnalysis response;
  ProductAnalysisSuccess(this.response);
  @override
  List<Object> get props =>[response];
}

class SalesAnalysisLastMonthLastWeekSuccess extends ReportAnalysisDownloadState{
  final SalesAnalysisM response;
  SalesAnalysisLastMonthLastWeekSuccess(this.response);
  @override
  List<Object> get props=>[response];
}

class SalesAnalysisThisMonthSuccess extends ReportAnalysisDownloadState{
  final SalesAnalysisThisMontkh response;
  SalesAnalysisThisMonthSuccess(this.response);
  @override
  List<Object> get props=>[response];
}