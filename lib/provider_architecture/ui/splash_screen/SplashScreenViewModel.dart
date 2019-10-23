import 'package:flutter/material.dart';
import 'package:flutter_provider_architecture/firebase/firebase_database_util.dart';
import 'package:flutter_provider_architecture/model/user_pref.dart';
import 'package:flutter_provider_architecture/provider_architecture/repository/api/ErrorResponse.dart';
import 'package:flutter_provider_architecture/provider_architecture/ui/base/base_model.dart';
import 'package:flutter_provider_architecture/provider_architecture/ui/menu/navigationHomeScreen.dart';
import 'package:flutter_provider_architecture/provider_architecture/ui/user/login/LoginView.dart';
import 'package:flutter_provider_architecture/shared/global_config.dart';

class SplashScreenViewModel extends BaseModel implements ErrorResponse {
  @override
  void serverMessage(String message, bool isError) {
    showMessage(message, isError);
    setState(ViewState.Idle);
  }

  void gotoAuthenticatedScreen() async {
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
}
