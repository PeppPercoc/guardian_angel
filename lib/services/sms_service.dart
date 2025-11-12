import 'package:permission_handler/permission_handler.dart';
import 'package:sms_sender/sms_sender.dart';

class SmsService {
  static final SmsService _instance = SmsService._internal();

  factory SmsService() => _instance;

  SmsService._internal() {
    requestPermission();
  }

  Future<bool> requestPermission() async {
    var status = await Permission.sms.status;
    if (!status.isGranted) {
      status = await Permission.sms.request();
    }
    return status.isGranted;
  }

  Future<bool> sendSms(String message, String phoneNumber) async {
    final hasPermission = await requestPermission();
    if (!hasPermission) {
      return false;
    }

    try {
      // prendiamo la prima SIM disponibile sul dispositivo
      List<Map<String, dynamic>> simCards = await SmsSender.getSimCards();
      await SmsSender.sendSms(
        phoneNumber: phoneNumber,
        message: message,
        simSlot: simCards[0]['simSlot'],
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}
