import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_recipe_viewer/recipes/model/recipe.dart';

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
        decoration: InputDecoration(
          border: UnderlineInputBorder(),
          labelText: label,
        ),
        //onChanged: onChanged,
        onFieldSubmitted: onChanged,
      ),
    );
  }

}