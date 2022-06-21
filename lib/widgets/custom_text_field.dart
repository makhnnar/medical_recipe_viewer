import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_recipe_viewer/data/recipe.dart';
import 'package:medical_recipe_viewer/recipe_detail/recipe_detail_view.dart';
import 'package:medical_recipe_viewer/values/app_colors.dart';

class CustomTextField extends StatelessWidget {

  String label;

  final onChanged;

  CustomTextField(
      this.label,
      this.onChanged
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 16
      ),
      child: TextFormField(
        decoration: InputDecoration(
          border: UnderlineInputBorder(),
          labelText: label,
        ),
        onChanged: onChanged,
      ),
    );
  }

}