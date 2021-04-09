class User {
  final String firstName;
  final String lastName;
  final String email;
  bool rememberMe;

  User({this.firstName, this.lastName, this.email, this.rememberMe});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
    );
  }
  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'rememberMe': rememberMe,
    };
  }
}
