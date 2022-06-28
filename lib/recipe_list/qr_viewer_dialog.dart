import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class QRViewerDialog extends StatelessWidget {

  String jsonData;

  QRViewerDialog(this.jsonData);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0)),
      child: Container(
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            PrettyQr(
              size: 200,
              data: jsonData,
              errorCorrectLevel: QrErrorCorrectLevel.M,
              typeNumber: null,
              roundEdges: true,
            ),
          ],
        ),
      ),
    );
  }

}