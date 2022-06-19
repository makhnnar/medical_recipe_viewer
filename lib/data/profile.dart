class Profile {

  String id;
  String name;
  String lastName;
  String photo;

  Profile({
    required this.id,
    required this.name,
    required this.lastName,
    required this.photo,
  });

  @override
  String toString() {
    return 'Profile{id: $id, name: $name, lastName: $lastName }';
  }
}