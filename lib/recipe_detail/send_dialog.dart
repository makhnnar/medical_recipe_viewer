import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_recipe_viewer/recipe_detail/state/code_state.dart';
import 'package:medical_recipe_viewer/utils/qr_reader.dart';
import 'package:medical_recipe_viewer/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class SendDialog extends StatelessWidget {

  late CodeState _provider;

  SendDialog();

  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<CodeState>(context);
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
              Text(
                "Read a code or write the wallet address",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
              CustomTextField(
                  "Address",
                  (text){
                        _provider.setCode(text);
                  },
                  initValue: _provider.getCode(),
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
                            scanQR().then(
                                    (value) => {
                                  _provider.setCode(value)
                                }
                            );
                          },
                          child: Text("Read Code")
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
                              Navigator.of(context).pop();
                            },
                            child: Text("Send")
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

abstract class ReadCodeListener{

  void onCodeReaded(String result);

}
