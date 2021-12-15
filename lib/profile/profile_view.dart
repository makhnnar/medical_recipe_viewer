import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_recipe_viewer/data/profile.dart';
import 'package:medical_recipe_viewer/data/recipe.dart';

class ProfileView extends StatelessWidget {

  Profile profile;

  ProfileView(this.profile);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Image.asset('assets/img/girl.jpg'),
            Column(
              children: [
                Text(""),
                Text("")
              ],
            )
          ],
        ),
        Image.asset('assets/img/girl.jpg'),
        Text(""),
        Row(
          children: [
            Icon(Icons.note_add_rounded),
            Text("")
          ],
        )
      ],
    );
  }

}