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
      print('Permesso SMS negato');
      return false;
    }

    try {
      // sendSms è un metodo statico che richiede parametri named
      await SmsSender.sendSms(phoneNumber: phoneNumber, message: message);
      print('SMS inviato a $phoneNumber: $message');
      return true;
    } catch (e) {
      print('Errore inviando SMS: $e');
      return false;
    }
  }
}
