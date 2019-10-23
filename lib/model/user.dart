import 'package:flutter/material.dart';

class User {
  String id;
  String email;
  String token;

  String username;

  String firstName;

  String lastName;

  String avatar;

  User(
      {@required this.id,
      @required this.email,
      @required this.token,
      this.avatar,
      this.firstName,
      this.username});

  User.empty();

  factory User.fromJson(dynamic map) {
    return new User(
      id: map['id'],
      email: map['email'],
      token: map['token'],
      avatar: map['avatar'],
      firstName: map['firstName'],
      username: map['username'],
    );
  }
}
