import 'package:permission_handler/permission_handler.dart';
import 'package:secure_qr_scan_ecubix/secure_qr_scan_ecubix.dart';

Future<String> scanQR() async {
  final secureQrScanEcubixPlugin = SecureQrScanEcubix();
  await Permission.camera.request();
  String? barcode = await secureQrScanEcubixPlugin.getSecureQRCode();
  RegExp regExp = new RegExp(r'(?<="QRText":")(.*?)(?=")');
  barcode = regExp.stringMatch(barcode!);
  if (barcode != null) {
    print("scanQR: $barcode");
    return barcode;
  }
  return "";
}