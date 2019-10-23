import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_provider_architecture/provider_architecture/ui/base/base_view.dart';
import 'package:flutter_provider_architecture/provider_architecture/ui/menu/NavigationMenuViewModel.dart';
import 'package:flutter_provider_architecture/shared/global_config.dart';
import 'package:flutter_provider_architecture/utils/Utils.dart';
import 'package:flutter_provider_architecture/utils/theme.dart';

class NavigationMenuView extends StatefulWidget {
  // User user;
  // NavigationMenuView(this.user);

  @override
  _NavigationMenuViewState createState() => _NavigationMenuViewState();
}

class _NavigationMenuViewState extends State<NavigationMenuView> {
  @override
  void initState() {
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
        return Drawer(
          child: Column(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(
                    model.user != null && model.user.firstName != null
                        ? '${model.user.firstName}'
                        : ''),
                accountEmail:
                    Text(model.user != null ? '${model.user.email}' : ''),
                currentAccountPicture: CircleAvatar(
                  backgroundColor:
                      Theme.of(context).platform == TargetPlatform.iOS
                          ? Colors.blue
                          : Colors.white,
                  child: Text(
                    // 'PV',
                    model.user != null
                        ? model.user.firstName != null
                            ? '${model.user.firstName.substring(0, 1).toUpperCase()}'
                            : '${model.user.email.substring(0, 1).toUpperCase()}'
                        : '',
                    style:
                        TextStyle(fontSize: 40.0, color: AppTheme.accentColor),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    ListTile(
                      leading:
                          Icon(Icons.my_location, color: AppTheme.accentColor),
                      title: Text(
                        'Places',
                        style: TextStyle(color: AppTheme.accentColor),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        if (screen != 1) model.gotoPlaces(context);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.chat, color: AppTheme.accentColor),
                      title: Text(
                        'Chat',
                        style: TextStyle(color: AppTheme.accentColor),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        if (screen != 2) model.gotoChat(context);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.supervisor_account,
                          color: AppTheme.accentColor),
                      title: Text(
                        'About us',
                        style: TextStyle(color: AppTheme.accentColor),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        if (screen != 3) model.gotoAboutus(context);
                      },
                    ),
                  ],
                ),
              ),
              Container(
                color: AppTheme.accentColor,
                width: double.infinity,
                height: 0.3,
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app, color: AppTheme.accentColor),
                title: Text(
                  'Logout',
                  style: TextStyle(color: AppTheme.accentColor),
                ),
                onTap: () {
                  model.logout(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
