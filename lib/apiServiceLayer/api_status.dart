class ApiResponseCodes {
  static const success = 200;
  static const created = 201;
  static const accepted = 202;
  static const badrequest = 400;
  static const existingUser = 403;
  static const internalServerError = 500;
  static const authorizationError = 401;
  static const forbidden = 403;
  static const resourcenotfound = 404;
  static const methodnotallowed = 405;
  static const conflict = 409;
  static const preconditionFailed = 412;
  static const requestEntityTooLarge = 413;
  static const notImplemented = 501;
  static const serviceUnavailable = 501;
  static const newDevice = 180;
  static const incompleteRegistration = 190;
  static  const changePassword = -60;
  static  const json = "2.0";
}

class ForbiddenAccess {
  int code = 403;
  Object response;
  ForbiddenAccess(this.code,this.response);
}
class UnExpectedError {
  int code = 0;
  String message = "An unexpected error occured";
}
class Success {
  int? code;
  Object response;
  Success(this.code, this.response);
}

class Failure {
  int? code;
  Object errorResponse;
  Failure(this.code, this.errorResponse);
}
class NetWorkFailure {
  int code = 500;
  String message = "Network Failure";
}

class TokenExpired {
  int code = 400;
  String message = "Authentication Expired";
  TokenExpired(this.code,this.message);
}