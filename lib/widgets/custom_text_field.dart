import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {

  String label;

  final onChanged;

  String initValue = "";

  TextInputType typeOfKeyBoard;

  var txt = TextEditingController();

  CustomTextField(
      this.label,
      this.onChanged,
      {
        this.initValue = "",
        this.typeOfKeyBoard = TextInputType.name
      }
  );

  @override
  Widget build(BuildContext context) {
    txt.text = initValue;
    txt.selection =TextSelection.fromPosition(
      TextPosition(offset: txt.text.length),
    );
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 16
      ),
      child: TextFormField(
        controller: txt,
        keyboardType: typeOfKeyBoard,
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(),
          border: UnderlineInputBorder(),
          errorStyle: TextStyle(
            color: Colors.redAccent,
          ),
          hoverColor: Theme.of(context).hoverColor,
          hintStyle: TextStyle(
            color: Colors.black,
          ),
          prefixStyle: TextStyle(
            color: Colors.black,
          ),
          counterStyle: TextStyle(
            color: Colors.black,
          ),
          labelStyle: TextStyle(
            color: Colors.black,
          ),
          floatingLabelStyle: TextStyle(
            color: Colors.black,
          ),
          labelText: label,
        ),
        onChanged: onChanged,
        //onFieldSubmitted: onChanged,
      ),
    );
  }

}