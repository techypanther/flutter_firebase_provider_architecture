import 'package:flutter/material.dart';
import 'package:flutter_provider_architecture/model/user_data.dart';
import 'package:flutter_provider_architecture/model/user_pref.dart';
import 'package:flutter_provider_architecture/provider_architecture/repository/api/ErrorResponse.dart';
import 'package:flutter_provider_architecture/provider_architecture/ui/about/AboutUsView.dart';
import 'package:flutter_provider_architecture/provider_architecture/ui/base/base_model.dart';
import 'package:flutter_provider_architecture/provider_architecture/ui/chat/GroupChatView.dart';
import 'package:flutter_provider_architecture/provider_architecture/ui/place/PlacesSearchMapView.dart';
import 'package:flutter_provider_architecture/provider_architecture/ui/user/login/LoginView.dart';
import 'package:flutter_provider_architecture/provider_architecture/ui/widgets/animation/scale_transition.dart';
import 'package:flutter_provider_architecture/shared/global_config.dart';

class NavigationMenuViewModel extends BaseModel implements ErrorResponse {
  UserData user;
  bool isFirst = true;

  @override
  void serverMessage(String message, bool isError) {
    showMessage(message, isError);
    setState(ViewState.Idle);
  }

  void initUser() async {
    this.user = await UserPreferences().getUser();
    notifyListeners();
  }

  void gotoChat(BuildContext context) async {
    await Navigator.of(context).push(
      ScaleRoute(
        page: GroupChatView(),
      ),
    );
  }

  void gotoPlaces(BuildContext context) async {
    await Navigator.of(context)
        .push(ScaleRoute(page: PlacesSearchMapView('Restaurants')));
  }

  void gotoAboutus(BuildContext context) async {
    await Navigator.of(context).push(ScaleRoute(page: AboutUsView()));
  }

  void logout(BuildContext context) async {
    UserPreferences.logOut();
    await Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(
          pageBuilder: (c, a1, a2) => LoginView(),
          transitionsBuilder: (c, anim, a2, child) => new SlideTransition(
            position: new Tween<Offset>(
              begin: const Offset(-1.0, 0.0),
              end: Offset.zero,
            ).animate(anim),
            child: child,
          ),
          transitionDuration: Duration(milliseconds: animationDuration),
        ),
        (Route<dynamic> route) => false);
  }
}
