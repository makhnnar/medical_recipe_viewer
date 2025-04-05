import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_recipe_viewer/profile/model/profile.dart';
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
        CilcularImage(profile: profile),
        Expanded(
            flex: 1,
            child:Container(
                height: 50.0,
                margin: EdgeInsets.only(
                top: 15.0,
                left: 2.0,
                right: 2.0
                ),
                child:Text(
                    "${profile.name}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: tableColors['tColorContent']
                    ),
                )
            )
        ),
        Expanded(
          flex: 3,
          child: PrettyQr(
            size: 150,
            data: profile.dir,
            errorCorrectLevel: QrErrorCorrectLevel.M,
            typeNumber: null,
            roundEdges: true,
          ),
        ),
        Expanded(
            flex: 5,
            child:Column(
                  children: [
                    Container(
                        height: 50.0,
                        margin: EdgeInsets.only(
                            top: 15.0,
                            left: 2.0,
                            right: 2.0
                        ),
                        child:Text(
                          "${profile.dir}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: tableColors['tColorContent']
                          ),
                        )
                    )
                ],
            )
        ),
      ],
    );
  }

}

class CilcularImage extends StatelessWidget {
  const CilcularImage({
    Key? key,
    required this.profile,
  }) : super(key: key);

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(75.0),
        child: Image.memory(
          this.profile.getPhotoAsUint8List(),
          height: 150.0,
          width: 150.0,
          fit: BoxFit.fill,
          errorBuilder: (
              BuildContext context,
              Object exception,
              StackTrace? stackTrace
              ) {
            return Image.asset(
              'assets/img/avatar.png',
              height: 150.0,
              width: 150.0,
              fit: BoxFit.cover,
            );
          },
        ),
      ),
    );
  }
}