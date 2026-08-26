import 'package:get/get.dart';
import 'package:smerp_go/model/response/LoginResponse.dart';

/// Owns auth/profile in-memory session fields that previously lived as
/// top-level globals in [UserUtils] / [AppUtils].
///
/// Existing call sites keep working through compatible getters/setters.
/// Prefer reading/writing via [AuthSession.instance] in new code.
class AuthSession {
  AuthSession._();

  static final AuthSession instance = AuthSession._();

  String accessToken = '';
  String clientAccessToken = '';
  String actionBy = '';
  String inventoryId = '';

  String? userIdentityValue;
  int? identitySource;
  String otpCreateAccount = '';
  String? userName;
  String? userFirstName;
  String? userEmail;
  String? userMerchantCode;
  LoginData? loginData;

  final RxString userImage = ''.obs;
  final RxString storeNPhone = ''.obs;
  final RxString storeNEmail = ''.obs;
  final RxString userBusinessName = ''.obs;
  final RxString userFirstNameS = ''.obs;

  bool get hasAccessToken => accessToken.isNotEmpty;

  void clear() {
    accessToken = '';
    clientAccessToken = '';
    actionBy = '';
    inventoryId = '';
    userIdentityValue = null;
    identitySource = null;
    otpCreateAccount = '';
    userName = null;
    userFirstName = null;
    userEmail = null;
    userMerchantCode = null;
    loginData = null;
    userImage.value = '';
    storeNPhone.value = '';
    storeNEmail.value = '';
    userBusinessName.value = '';
    userFirstNameS.value = '';
  }
}
