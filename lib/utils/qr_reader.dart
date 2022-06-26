import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;

Future<String> scanQR() async {
  await Permission.camera.request();
  String? barcode = await scanner.scan();
  if (barcode != null) {
    print(barcode);
    return barcode;
  }
  return "";
}