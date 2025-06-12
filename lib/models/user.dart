class User {
  String name;
  String email;
  String phone;
  String address;
  double? latitude;
  double? longitude;

  User({
    this.name = '',
    this.email = '',
    this.phone = '',
    this.address = '',
    this.latitude,
    this.longitude,
  });

  // static final User _instance = User._internal();
  //
  // factory User() {
  //   return _instance;
  // }
  //
  // User._internal();
}
