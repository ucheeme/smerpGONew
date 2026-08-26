import 'package:smerp_go/Reposistory/catalogMutationRepo.dart';
import 'package:smerp_go/Reposistory/catalogRepo.dart';
import 'package:smerp_go/Reposistory/notificationRepo.dart';
import 'package:smerp_go/Reposistory/orderHistoryCubitRepo/orderHistoryRepo.dart';
import 'package:smerp_go/Reposistory/productListRepo.dart';
import 'package:smerp_go/Reposistory/reportAnalysisRepo.dart';
import 'package:smerp_go/core/repositories/i_bank_details_repository.dart';
import 'package:smerp_go/core/repositories/i_catalog_repository.dart';
import 'package:smerp_go/core/repositories/i_collection_repository.dart';
import 'package:smerp_go/core/repositories/i_notification_repository.dart';
import 'package:smerp_go/core/repositories/i_order_history_repository.dart';
import 'package:smerp_go/core/repositories/i_report_analysis_repository.dart';

/// Lightweight composition root for Cubit-backed repositories.
///
/// Keeps construction in one place so Cubits depend on interfaces, not
/// concrete classes. No third-party DI framework required.
class AppRepositories {
  AppRepositories._();

  static ICollectionRepository collection = CollectionRepo();
  static IOrderHistoryRepository orderHistory = OrderHistoryRepo();
  static INotificationRepository notification = NotificationRepo();
  static IBankDetailsRepository bankDetails = CataloRepo();
  static IReportAnalysisRepository reportAnalysis = ReportAnalysisRepo();
  static ICatalogRepository catalog = CatalogRepo();

  /// Test seam to swap implementations without touching widget trees.
  static void debugOverride({
    ICollectionRepository? collectionRepo,
    IOrderHistoryRepository? orderHistoryRepo,
    INotificationRepository? notificationRepo,
    IBankDetailsRepository? bankDetailsRepo,
    IReportAnalysisRepository? reportAnalysisRepo,
    ICatalogRepository? catalogRepo,
  }) {
    if (collectionRepo != null) {
      collection = collectionRepo;
    }
    if (orderHistoryRepo != null) {
      orderHistory = orderHistoryRepo;
    }
    if (notificationRepo != null) {
      notification = notificationRepo;
    }
    if (bankDetailsRepo != null) {
      bankDetails = bankDetailsRepo;
    }
    if (reportAnalysisRepo != null) {
      reportAnalysis = reportAnalysisRepo;
    }
    if (catalogRepo != null) {
      catalog = catalogRepo;
    }
  }

  static void debugReset() {
    collection = CollectionRepo();
    orderHistory = OrderHistoryRepo();
    notification = NotificationRepo();
    bankDetails = CataloRepo();
    reportAnalysis = ReportAnalysisRepo();
    catalog = CatalogRepo();
  }
}
