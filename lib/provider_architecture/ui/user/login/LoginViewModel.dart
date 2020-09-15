import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_provider_architecture/firebase/firebase_database_util.dart';
import 'package:flutter_provider_architecture/model/auth.dart';
import 'package:flutter_provider_architecture/model/user_data.dart';
import 'package:flutter_provider_architecture/model/user_pref.dart';
import 'package:flutter_provider_architecture/provider_architecture/repository/api/ErrorResponse.dart';
import 'package:flutter_provider_architecture/provider_architecture/repository/api/login/login_cloud_repository.dart';
import 'package:flutter_provider_architecture/provider_architecture/ui/base/base_model.dart';
import 'package:flutter_provider_architecture/provider_architecture/ui/menu/navigationHomeScreen.dart';
import 'package:flutter_provider_architecture/provider_architecture/ui/user/login/LoginView.dart';
import 'package:flutter_provider_architecture/shared/global_config.dart';
import 'package:flutter_provider_architecture/utils/CustomProgressDialog.dart';
import 'package:flutter_provider_architecture/utils/Utils.dart';

class LoginViewModel extends BaseModel implements ErrorResponse {
  CustomProgressDialog customProgressDialog = CustomProgressDialog();

  Future<Map<String, dynamic>> authenticate(
      String email, String password, BuildContext context,
      [AuthMode mode = AuthMode.Login]) async {
    setState(ViewState.Busy);
    String message = 'Something went wrong.';

    // http.Response response;
    User user;
    if (mode == AuthMode.Login) {
      try {
        UserCredential authResult = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        if (authResult != null) user = authResult.user;
      } on PlatformException catch (error) {
        setState(ViewState.Idle);

        print(error.code);
        switch (error.code) {
          case 'ERROR_INVALID_EMAIL':
            message = 'Invalid email';
            break;
          case 'ERROR_USER_NOT_FOUND':
            message = 'User not found';
            break;
          case 'ERROR_WRONG_PASSWORD':
            message = 'Wrong password';
            break;
        }
      }
    } else {
      try {
        final UserCredential authResult = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        if (authResult != null) user = authResult.user;
      } on PlatformException catch (error) {
        setState(ViewState.Idle);

        print(error.code);
        switch (error.code) {
          case 'ERROR_INVALID_EMAIL':
            message = 'Invalid email';
            break;
          case 'ERROR_USER_NOT_FOUND':
            message = 'User not found';
            break;
          case 'ERROR_WRONG_PASSWORD':
            message = 'Wrong password';
            break;
        }
      }
    }

    if (user != null) {


      await UserPreferences().saveUserDetails(new UserData(
          email: user.email,
          id: user.uid,
          token: await user.getIdToken(),
          username: user.email,
          firstName: user.displayName,
          avatar: user.photoURL));
      UserPreferences().setAPIToken(await user.getIdToken());
      message = 'Login succeeded!';
      showMessage(message, false);
      // Utils.showMessage(message);
      setState(ViewState.Idle);
      await gotoAuthenticatedScreen();
      return {'success': true, 'message': 'success'};
    } else
      showMessage(message, false);
    // Utils.showMessage(message);
    return {'success': false, 'message': 'error occurred'};
  }

  Future<void> gotoAuthenticatedScreen() async {
    setState(ViewState.Busy);
    await Future.delayed(Duration(seconds: 3));
    // User _user = await UserPreferences().getUser();
    String token = await UserPreferences().getAPIToken();
    if (token != null && token.isNotEmpty) {
      setState(ViewState.Idle);
      FirebaseDatabaseUtil().initState();
      await Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (c, a1, a2) =>
              NavigationHomeScreen() /* PlacesSearchMapView('Restaurants') */,
          transitionsBuilder: (c, anim, a2, child) => new SlideTransition(
            position: new Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(anim),
            child: child,
          ),
          transitionDuration: Duration(milliseconds: animationDuration),
        ),
      );
    } else {
      setState(ViewState.Idle);
      await Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (c, a1, a2) => LoginView(),
          transitionsBuilder: (c, anim, a2, child) => new SlideTransition(
            position: new Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(anim),
            child: child,
          ),
          transitionDuration: Duration(milliseconds: animationDuration),
        ),
      );
    }
  }

  void loginUser(Map<String, dynamic> formData, Function play, Function stop,
      GlobalKey<FormState> _formKey, AuthMode authMode) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    play();
    _formKey.currentState.save();
    final Map<String, dynamic> successInformation = await authenticate(
        formData['email'], formData['password'], context, authMode);
    if (successInformation['success']) {
      stop();
    } else {
      stop();
    }
  }

  void loginViaGoogle(BuildContext context, FirebaseAnalytics analytics,
      Function playAnimation, Function stopAnimation) {
    try {
      setState(ViewState.Busy);
      playAnimation();
      LoginCloudRepository loginCloudRepository = new LoginCloudRepository();
      loginCloudRepository.googleInfo(context).then((b) async {
        if (b) {
          // customProgressDialog.dismiss(context);
          await getLoggedInUser();
          addSuccessLoginGoogleAnalytics(analytics);
          stopAnimation();
        } else {
          stopAnimation();
          // customProgressDialog.dismiss(context);
          Utils.showMessage("Account not found");
          addFailLoginGoogleAnalytics(analytics);
        }
      }).catchError((onError) {
        stopAnimation();
        addFailLoginGoogleAnalytics(analytics);
        // print('cancel dialog 2');
        // customProgressDialog.dismiss(context);
        print(onError);
      });
    } catch (e) {
      addFailLoginGoogleAnalytics(analytics);
      stopAnimation();
      print('cancel dialog 3');
      // customProgressDialog.dismiss(context);
      print(e);
    }
  }

  void loginWithFacebook(BuildContext context, FirebaseAnalytics analytics,
      Function playAnimation, Function stopAnimation) async {
    try {
      setState(ViewState.Busy);
      playAnimation();
      LoginCloudRepository loginCloudRepository = new LoginCloudRepository();
      loginCloudRepository.facebookInfo().then((b) async {
        if (b) {
          // customProgressDialog.dismiss(context);
          addSuccessLoginFBAnalytics(analytics);
          await getLoggedInUser();
          stopAnimation();
        } else {
          addFailLoginFBAnalytics(analytics);
          // customProgressDialog.dismiss(context);
          Utils.showMessage("Account not found");
          stopAnimation();
        }
      }).catchError((error) {
        stopAnimation();
        addFailLoginFBAnalytics(analytics);
        // customProgressDialog.dismiss(context);
        print('fb error 2 => $error');
      });
    } catch (e) {
      stopAnimation();
      addFailLoginFBAnalytics(analytics);
      // customProgressDialog.dismiss(context);
      print('fb error 3 => $e');
    }
  }

  void addSuccessLoginGoogleAnalytics(FirebaseAnalytics analytics) {
    analytics
        .logEvent(name: 'login_google_event', parameters: {'login': 'success'});
    analytics.logLogin(loginMethod: "google_login_success");
  }

  void addFailLoginGoogleAnalytics(FirebaseAnalytics analytics) {
    analytics
        .logEvent(name: 'login_google_event', parameters: {'login': 'fail'});
    analytics.logLogin(loginMethod: "google_login_fail");
  }

  void addSuccessLoginFBAnalytics(FirebaseAnalytics analytics) {
    analytics.logEvent(
        name: 'login_facebook_event', parameters: {'login': 'success'});
    analytics.logLogin(loginMethod: "facebook_login_success");
  }

  void addFailLoginFBAnalytics(FirebaseAnalytics analytics) {
    analytics
        .logEvent(name: 'login_facebook_event', parameters: {'login': 'fail'});
    analytics.logLogin(loginMethod: "facebook_login_fail");
  }

  void addSuccessLoginAnalytics(FirebaseAnalytics analytics) {
    analytics
        .logEvent(name: 'normal_login_event', parameters: {'login': 'success'});
    analytics.logLogin(loginMethod: "normal_login_success");
  }

  void addFailLoginAnalytics(FirebaseAnalytics analytics) {
    analytics
        .logEvent(name: 'normal_login_event', parameters: {'login': 'fail'});
    analytics.logLogin(loginMethod: "normal_login_fail");
  }

//logged in user profile
  Future<void> getLoggedInUser() async {
    await gotoAuthenticatedScreen();
  }

  @override
  void serverMessage(String message, bool isError) {
    showMessage(message, isError);
    setState(ViewState.Idle);
  }
}
