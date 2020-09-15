import 'package:flutter/material.dart';

class UserData {
  String id;
  String email;
  String token;

  String username;

  String firstName;

  String lastName;

  String avatar;

  UserData(
      {@required this.id,
      @required this.email,
      @required this.token,
      this.avatar,
      this.firstName,
      this.username});

  UserData.empty();

  factory UserData.fromJson(dynamic map) {
    return new UserData(
      id: map['id'],
      email: map['email'],
      token: map['token'],
      avatar: map['avatar'],
      firstName: map['firstName'],
      username: map['username'],
    );
  }
}
