class User {
  String name = '';
  String email = '';
  String phone = '';
  String address = '';
  double? latitude;
  double? longitude;

  // Singleton instance
  static final User _instance = User._internal();

  // Private constructor
  User._internal();

  // Factory constructor
  factory User() {
    return _instance;
  }

}
