import 'dart:async';

import 'package:flutter_provider_architecture/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static void logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('id');
    prefs.remove('username');
    prefs.remove('firstName');
    prefs.remove('lastName');
    prefs.remove('email');
    prefs.remove('avatar');
    prefs.remove('API_TOKEN');
  }

  void saveBuildVersion(String supportedBuilds, String buildUnderReview) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('supportedBuilds', supportedBuilds);
    prefs.setString('buildUnderReview', buildUnderReview);
  }

  Future<String> getSupportedBuildVersion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get('supportedBuilds');
  }

  Future<String> getBuildUnderReview() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get('buildUnderReview');
  }

  Future<String> getServerKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get('serverKey');
  }

  Future<bool> saveUserDetails(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('id', user.id);
    prefs.setString('username', user.username);
    prefs.setString('firstName', user.firstName);
    prefs.setString('lastName', user.lastName);
    prefs.setString('email', user.email);
    prefs.setString('avatar', user.avatar);
    return true;
  }

  Future<User> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    User user = new User.empty();
    user.id = prefs.get("id");
    user.username = prefs.get("username");
    user.firstName = prefs.get("firstName");
    user.lastName = prefs.get("lastName");
    user.avatar = prefs.get('avatar');
    user.email = prefs.get('email');

    return user;
  }

  void saveFCMToken(String fcmToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (fcmToken != null) {
      prefs.setString("FCM_TOKEN", fcmToken);
    }
  }

  Future<String> getFCMToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('FCM_TOKEN');
  }

  void setAPIToken(String apiToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (apiToken != null) {
      prefs.setString("API_TOKEN", apiToken);
    }
  }

  Future<String> getAPIToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('API_TOKEN');
  }
}
