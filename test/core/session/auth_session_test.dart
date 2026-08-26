import 'package:flutter_test/flutter_test.dart';
import 'package:smerp_go/Reposistory/catalogMutationRepo.dart';
import 'package:smerp_go/Reposistory/catalogRepo.dart';
import 'package:smerp_go/Reposistory/notificationRepo.dart';
import 'package:smerp_go/Reposistory/orderHistoryCubitRepo/orderHistoryRepo.dart';
import 'package:smerp_go/Reposistory/productListRepo.dart';
import 'package:smerp_go/Reposistory/reportAnalysisRepo.dart';
import 'package:smerp_go/core/repositories/app_repositories.dart';
import 'package:smerp_go/core/repositories/i_bank_details_repository.dart';
import 'package:smerp_go/core/repositories/i_catalog_repository.dart';
import 'package:smerp_go/core/repositories/i_collection_repository.dart';
import 'package:smerp_go/core/repositories/i_notification_repository.dart';
import 'package:smerp_go/core/repositories/i_order_history_repository.dart';
import 'package:smerp_go/core/repositories/i_report_analysis_repository.dart';
import 'package:smerp_go/core/session/auth_session.dart';
import 'package:smerp_go/utils/AppUtils.dart';
import 'package:smerp_go/utils/UserUtils.dart';

void main() {
  group('AuthSession', () {
    tearDown(() {
      AuthSession.instance.clear();
    });

    test('UserUtils facades read and write AuthSession', () {
      userAccessToken = 'token-a';
      clientAccessToken = 'token-b';
      actionBy = 'actor-1';
      inventoryId = 'inv-9';
      userImage.value = 'https://cdn.example.com/a.png';

      expect(AuthSession.instance.accessToken, 'token-a');
      expect(AuthSession.instance.clientAccessToken, 'token-b');
      expect(AuthSession.instance.actionBy, 'actor-1');
      expect(AuthSession.instance.inventoryId, 'inv-9');
      expect(AuthSession.instance.userImage.value, 'https://cdn.example.com/a.png');
      expect(AuthSession.instance.hasAccessToken, isTrue);
    });

    test('AppUtils profile facades read and write AuthSession', () {
      userIdentityValue = 'merchant-1';
      identitySource = 1;
      otpCreateAccout = '123456';
      userName = 'Ada Lovelace';
      userFirstName = 'Ada';
      userEmail = 'ada@example.com';
      userMerchantCode = 'MC001';
      userBusinessName.value = 'Ada Store';
      userFirstNameS.value = 'Ada';

      expect(AuthSession.instance.userIdentityValue, 'merchant-1');
      expect(AuthSession.instance.identitySource, 1);
      expect(AuthSession.instance.otpCreateAccount, '123456');
      expect(AuthSession.instance.userName, 'Ada Lovelace');
      expect(AuthSession.instance.userMerchantCode, 'MC001');
      expect(AuthSession.instance.userBusinessName.value, 'Ada Store');
      expect(AuthSession.instance.userFirstNameS.value, 'Ada');
    });

    test('clear resets auth and profile fields including Rx values', () {
      userAccessToken = 'token-a';
      storeNPhone.value = '0800';
      storeNEmail.value = 'a@b.com';
      userIdentityValue = 'merchant-1';
      userMerchantCode = 'MC001';
      userBusinessName.value = 'Ada Store';

      AuthSession.instance.clear();

      expect(userAccessToken, isEmpty);
      expect(clientAccessToken, isEmpty);
      expect(actionBy, isEmpty);
      expect(inventoryId, isEmpty);
      expect(userImage.value, isEmpty);
      expect(storeNPhone.value, isEmpty);
      expect(storeNEmail.value, isEmpty);
      expect(userIdentityValue, isNull);
      expect(userMerchantCode, isNull);
      expect(userBusinessName.value, isEmpty);
      expect(userFirstNameS.value, isEmpty);
      expect(otpCreateAccout, isEmpty);
      expect(AuthSession.instance.hasAccessToken, isFalse);
    });
  });

  group('AppRepositories', () {
    tearDown(() {
      AppRepositories.debugReset();
    });

    test('defaults expose concrete implementations behind interfaces', () {
      expect(AppRepositories.collection, isA<ICollectionRepository>());
      expect(AppRepositories.collection, isA<CollectionRepo>());
      expect(AppRepositories.orderHistory, isA<IOrderHistoryRepository>());
      expect(AppRepositories.orderHistory, isA<OrderHistoryRepo>());
      expect(AppRepositories.notification, isA<INotificationRepository>());
      expect(AppRepositories.notification, isA<NotificationRepo>());
      expect(AppRepositories.bankDetails, isA<IBankDetailsRepository>());
      expect(AppRepositories.bankDetails, isA<CataloRepo>());
      expect(AppRepositories.reportAnalysis, isA<IReportAnalysisRepository>());
      expect(AppRepositories.reportAnalysis, isA<ReportAnalysisRepo>());
      expect(AppRepositories.catalog, isA<ICatalogRepository>());
      expect(AppRepositories.catalog, isA<CatalogRepo>());
    });

    test('debugOverride swaps implementations for tests', () {
      final fake = _FakeOrderHistoryRepo();
      AppRepositories.debugOverride(orderHistoryRepo: fake);
      expect(identical(AppRepositories.orderHistory, fake), isTrue);
    });
  });
}

class _FakeOrderHistoryRepo implements IOrderHistoryRepository {
  @override
  Future<Object> getOrderHistory() async => <Object>[];
}
