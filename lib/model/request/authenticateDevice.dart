import 'dart:convert';


AuthenticateDevice authenticateDeviceFromJson(String str) => AuthenticateDevice.fromJson(json.decode(str));

String authenticateDeviceToJson(AuthenticateDevice data) => json.encode(data.toJson());

class AuthenticateDevice {
    String actionBy;
    String actionOn;
    String deviceId;
    String deviceIMEI;
    int deviceType;

    AuthenticateDevice({
        required this.actionBy,
        required this.actionOn,
        required this.deviceId,
        required this.deviceIMEI,
        required this.deviceType});

  factory AuthenticateDevice.fromJson(Map<String, dynamic> json) {

  return AuthenticateDevice(
            actionBy: json['actionBy'], 
            actionOn: json['actionOn'], 
            deviceId: json['deviceId'],
            deviceIMEI: json['deviceIMEI'],
            deviceType: json['deviceType'], 
        );
    }

    Map<String, dynamic> toJson()=> {

        'actionBy' : actionBy,
        'actionOn': actionOn,
        'deviceId':deviceId,
        'deviceIMEI': deviceIMEI,
        'deviceType' : deviceType,
    };
}