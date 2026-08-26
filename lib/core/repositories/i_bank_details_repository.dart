import 'package:smerp_go/model/request/bankDetails.dart';

/// Bank details data access for Cubits.
abstract class IBankDetailsRepository {
  Future<Object> getBankDetails();

  Future<Object> createBankDetails(StoreBankDetail request);
}
