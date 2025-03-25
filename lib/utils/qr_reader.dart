import 'package:permission_handler/permission_handler.dart';
import 'package:secure_qr_scan_ecubix/secure_qr_scan_ecubix.dart';

Future<String> scanQR() async {
  final secureQrScanEcubixPlugin = SecureQrScanEcubix();
  await Permission.camera.request();
  String? barcode = await secureQrScanEcubixPlugin.getSecureQRCode();
  if (barcode != null) {
    print("scanQR: $barcode");
    return barcode;
  }
  return "";
}

String getWalletAddressFromQRReading(String qrCode){
  RegExp regExp = new RegExp(r'(?<="QRText":")(.*?)(?=")');
  var addrr = regExp.stringMatch(qrCode!);
  return addrr!;
}