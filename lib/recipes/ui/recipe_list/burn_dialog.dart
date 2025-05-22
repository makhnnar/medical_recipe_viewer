import 'package:flutter/material.dart';

class BurnDialog extends StatelessWidget {

  dynamic acceptCallback;

  BurnDialog(this.acceptCallback);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0)),
      child: Container(
        height: 325,
        width: 325,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Are you sure you want to burn this recipe?",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold
              ),
            ),
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child:Container(
                      margin: EdgeInsets.only(
                          left: 8.0,
                          right: 4.0
                      ),
                      child:ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("cancel")
                      ),
                    )
                ),
                Expanded(
                    flex: 1,
                    child:Container(
                        margin: EdgeInsets.only(
                            left: 4.0,
                            right: 8.0
                        ),
                        child:ElevatedButton(
                          onPressed: () {
                            acceptCallback();
                            Navigator.of(context).pop();
                          },
                          child: Text("accept"),
                        )
                    )
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

}