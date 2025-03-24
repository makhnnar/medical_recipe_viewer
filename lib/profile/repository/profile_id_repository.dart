import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_recipe_viewer/profile/model/profile.dart';

class ProfileIdRepository{

  CollectionReference documentos = FirebaseFirestore.instance.collection('documentos');

  Future<Profile> checkIfIdProfileExists(String id) async{
    print("document: $id");
    DocumentSnapshot snapshot = await documentos.doc(id).get();
    if (snapshot.exists) {
      return Profile(
          id: snapshot['id'],
          name: snapshot['name'],
          tipo: snapshot['tipo'],
          photo: snapshot['photo'],
          privateKey: snapshot['privateKey'],
          dir: ""
      );
    }
    return Profile(id: "", name: "", tipo: -1, photo: "", dir: "");
  }

}