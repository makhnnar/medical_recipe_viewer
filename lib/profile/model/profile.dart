class Profile {

  String id;
  String name;
  int tipo;
  String photo;
  String dir;

  Profile({
    required this.id,
    required this.name,
    required this.tipo,
    required this.photo,
    required this.dir,
  });

  @override
  String toString() {
    return 'Profile{id: $id, name: $name, tipo: $tipo, photo: $photo, dir: $dir}';
  }

  bool isEmpty() {
    return id.isEmpty && name.isEmpty && tipo<0 && photo.isEmpty && dir.isEmpty;
  }

}