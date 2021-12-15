class Profile {

  String id;
  String name;
  String lastName;

  Profile({
    this.id,
    this.name,
    this.lastName
  });

  @override
  String toString() {
    return 'Profile{id: $id, name: $name, lastName: $lastName }';
  }
}