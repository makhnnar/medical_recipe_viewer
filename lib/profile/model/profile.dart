class Profile {

  String id;
  String name;
  String lastName;
  String photo;
  String dir;

  Profile({
    required this.id,
    required this.name,
    required this.lastName,
    required this.photo,
    required this.dir,
  });

  @override
  String toString() {
    return 'Profile{id: $id, name: $name, lastName: $lastName, photo: $photo, dir: $dir}';
  }

  bool isEmpty() {
    return id.isEmpty && name.isEmpty && lastName.isEmpty && photo.isEmpty && dir.isEmpty;
  }

}