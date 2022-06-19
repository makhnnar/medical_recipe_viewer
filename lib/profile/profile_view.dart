import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_recipe_viewer/data/profile.dart';
import 'package:medical_recipe_viewer/data/recipe.dart';
import 'package:medical_recipe_viewer/values/app_colors.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class ProfileView extends StatelessWidget {

  Profile profile;

  ProfileView(this.profile);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:CrossAxisAlignment.center,
      children: [
        Container(
          height: 50,
        ),
        Container(
          height: 150,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(75.0),
            child: Image.network(
              this.profile.photo,
              height: 150.0,
              width: 150.0,
              fit: BoxFit.fill,
              errorBuilder: (
                  BuildContext context,
                  Object exception,
                  StackTrace? stackTrace
                  ) {
                return Image.asset(
                  'assets/img/people.jpg',
                  height: 150.0,
                  width: 150.0,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
        ),
        Expanded(
            flex: 1,
            child:Text(
                "${profile.name} ${profile.lastName}",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: tableColors['tColorContent']
                ),
            )
        ),
        Expanded(
          flex: 3,
          child: PrettyQr(
            size: 150,
            data: 'https://www.facebook.com',
            errorCorrectLevel: QrErrorCorrectLevel.M,
            typeNumber: null,
            roundEdges: true,
          ),
        ),
        Expanded(
            flex: 5,
            child:Column(
                  children: [
                    Text(""),
                    Row(
                      children: [

                      ],
                    ),
                    Text(""),
                    Row(
                      children: [
                        Icon(Icons.note_add_rounded),
                        Text("")
                      ],
                    )
                ],
            )
        ),
      ],
    );
  }

}