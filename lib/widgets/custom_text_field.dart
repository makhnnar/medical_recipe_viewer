import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_recipe_viewer/data/recipe.dart';
import 'package:medical_recipe_viewer/recipe_detail/recipe_detail_view.dart';
import 'package:medical_recipe_viewer/values/app_colors.dart';

class CustomTextField extends StatelessWidget {

  String label;

  final onChanged;

  String initValue = "";

  var txt = TextEditingController();

  CustomTextField(
      this.label,
      this.onChanged,
      {
        this.initValue = ""
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