import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_provider_architecture/model/user.dart';
import 'package:flutter_provider_architecture/model/user_pref.dart';
import 'package:flutter_provider_architecture/provider_architecture/repository/api/ErrorResponse.dart';
import 'package:flutter_provider_architecture/utils/CustomProgressDialog.dart';
import 'package:flutter_provider_architecture/utils/Utils.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginCloudRepository {
  ErrorResponse errorResponse;
  CustomProgressDialog customProgressDialog = CustomProgressDialog();

  Future<bool> googleInfo(BuildContext context) async {
    if (!await Utils.isInternetAvailable()) return false;
    await GoogleSignIn().signOut();
    GoogleSignInAccount googleSignInAccount = await GoogleSignIn().signIn();
    if (googleSignInAccount == null) {
      customProgressDialog.dismiss(context);
    }
    final GoogleSignInAuthentication googleAuth =
        await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final AuthResult authResult =
        await FirebaseAuth.instance.signInWithCredential(credential);
    FirebaseUser user = authResult.user;
    String token = (await user.getIdToken()).token;
    User loggedUser = new User(
      email: user.email,
      id: user.uid,
      token: token,
      avatar: user.photoUrl,
      firstName: user.displayName,
      username: user.email,
    );
    UserPreferences().saveUserDetails(loggedUser);
    UserPreferences().setAPIToken(token);

    return true;
  }

  Future<bool> facebookInfo() async {
    if (!await Utils.isInternetAvailable()) return false;
    final facebookLogin = FacebookLogin();
    facebookLogin.loginBehavior = FacebookLoginBehavior.nativeWithFallback;
    await facebookLogin.logOut();
    final result = await facebookLogin.logIn(['email', 'public_profile']);
    print(result.status);
    print(result.toString());
    print(result.accessToken.token);
    print(result.errorMessage);

    FacebookAccessToken myToken = result.accessToken;

    AuthCredential credential =
        FacebookAuthProvider.getCredential(accessToken: myToken.token);
    try {
      final AuthResult authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);

      FirebaseUser user = authResult.user;

      String token = (await user.getIdToken()).token;

      User loggedUser = new User(
        email: user.email,
        id: user.uid,
        token: token,
        avatar: user.photoUrl,
        firstName: user.displayName,
        username: user.email,
      );

      UserPreferences().saveUserDetails(loggedUser);
      UserPreferences().setAPIToken(token);
    } on PlatformException catch (error) {
      List<String> errors = error.toString().split(',');
      if (errors[1].contains('same email')) {
        print("Error: " + errors[1]);
        return false;
      }
    } catch (error) {
      print(error);
      return false;
    }
    return true;
  }
}
