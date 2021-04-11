class User {
  final String firstName;
  final String lastName;
  final String email;
  bool rememberMe;

  User({this.firstName, this.lastName, this.email, this.rememberMe});

  User copyWith(
      {String firstName, String lastName, String email, bool rememberMe}) {
    return User(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      rememberMe: rememberMe ?? this.rememberMe,
    );
  }

  User.fromJson(Map<String, dynamic> json)
      : firstName = json['firstName'],
        lastName = json['lastName'],
        email = json['email'];

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'rememberMe': rememberMe,
    };
  }
}
