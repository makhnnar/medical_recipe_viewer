import 'package:flutter/cupertino.dart';

class ProfileCreationFieldState extends ChangeNotifier{

  String foto = "";
  String privAddr = "";
  String numeroIdentidad = "";

  String regPrivAddr = "([a-f]|[A-F]|[0-9]){40,64}";

}