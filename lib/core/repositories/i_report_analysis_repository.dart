/// Report analysis / download data access for Cubits.
abstract class IReportAnalysisRepository {
  Future<Object> getSalesReport(
    int period, {
    String fromDate = '',
    String toDate = '',
  });

  Future<Object> getProductReport(
    int period, {
    String fromDate = '',
    String toDate = '',
  });

  Future<Object> getBestPerformingProductReport();

  Future<Object> downloadReport(String saleType, String period, String type);

  Future<Object> downloadReport2(
    String saleType,
    String startDate,
    String endDate,
    String type,
  );
}
