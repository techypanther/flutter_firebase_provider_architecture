import 'package:flutter/material.dart';
import 'package:flutter_provider_architecture/provider_architecture/ui/about/AboutUsView.dart';
import 'package:flutter_provider_architecture/provider_architecture/ui/base/base_view.dart';
import 'package:flutter_provider_architecture/provider_architecture/ui/chat/GroupChatView.dart';
import 'package:flutter_provider_architecture/provider_architecture/ui/menu/NavigationMenuViewModel.dart';
import 'package:flutter_provider_architecture/provider_architecture/ui/menu/drawerUserController.dart';
import 'package:flutter_provider_architecture/provider_architecture/ui/menu/homeDrawer.dart';
import 'package:flutter_provider_architecture/provider_architecture/ui/place/PlacesSearchMapView.dart';
import 'package:flutter_provider_architecture/utils/Utils.dart';
import 'package:flutter_provider_architecture/utils/theme.dart';

class NavigationHomeScreen extends StatefulWidget {
  @override
  _NavigationHomeScreenState createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  Widget screenView;
  DrawerIndex drawerIndex;
  AnimationController sliderAnimationController;

  @override
  void initState() {
    drawerIndex = DrawerIndex.HOME;
    screenView = PlacesSearchMapView('Restaurants');
    super.initState();
  }

  void showMessage(NavigationMenuViewModel model) {
    try {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (model.shouldShowMessage) {
          model.messageIsShown();
          Utils.showMessage(model.message);
        }
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<NavigationMenuViewModel>(
      builder: (context, model, child) {
        if (model.isFirst) {
          model.initUser();
          model.isFirst = false;
        }
        showMessage(model);

        return Container(
          color: AppTheme.backgroundWhite,
          child: SafeArea(
            top: false,
            bottom: false,
            child: Scaffold(
              backgroundColor: AppTheme.backgroundWhite,
              body: DrawerUserController(
                logout: model.logout,
                screenIndex: drawerIndex,
                drawerWidth: MediaQuery.of(context).size.width * 0.75,
                animationController: (AnimationController animationController) {
                  sliderAnimationController = animationController;
                },
                onDrawerCall: (DrawerIndex drawerIndexdata) {
                  changeIndex(drawerIndexdata);
                },
                screenView: screenView,
                user: model.user,
              ),
            ),
          ),
        );
      },
    );
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      if (drawerIndex == DrawerIndex.HOME) {
        setState(() {
          screenView = PlacesSearchMapView('Restaurants');
        });
      } else if (drawerIndex == DrawerIndex.Chat) {
        setState(() {
          screenView = GroupChatView();
        });
      } else if (drawerIndex == DrawerIndex.About) {
        setState(() {
          screenView = AboutUsView();
        });
      } else {
        //do in your way......
      }
    }
  }
}
