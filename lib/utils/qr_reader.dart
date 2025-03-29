import 'dart:convert';

import 'package:permission_handler/permission_handler.dart';
import 'package:secure_qr_scan_ecubix/secure_qr_scan_ecubix.dart';

Future<String> scanQR() async {
  final secureQrScanEcubixPlugin = SecureQrScanEcubix();
  await Permission.camera.request();
  String? barcode = await secureQrScanEcubixPlugin.getSecureQRCode();
  if (barcode != null) {
    return getContentOnQRReading(barcode);
  }
  return "";
}

//the content of the QR code is a json string, so we need to decode it
String getContentOnQRReading(String qrCode){
  Map<String, dynamic> jsonData = jsonDecode(qrCode);
  String qrText = jsonData["QRText"];
  return qrText;
}