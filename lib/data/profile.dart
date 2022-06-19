class Profile {

  String id;
  String name;
  String lastName;

  Profile({
    required this.id,
    required this.name,
    required this.lastName
  });

  @override
  String toString() {
    return 'Profile{id: $id, name: $name, lastName: $lastName }';
  }
}