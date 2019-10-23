import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_provider_architecture/provider_architecture/ui/base/base_view.dart';
import 'package:flutter_provider_architecture/provider_architecture/ui/splash_screen/SplashScreenViewModel.dart';
import 'package:flutter_provider_architecture/utils/Utils.dart';
import 'package:flutter_provider_architecture/utils/theme.dart';

class SplashScreenView extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreenView> with Utils {
  void showMessage(SplashScreenViewModel model) {
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
    return BaseView<SplashScreenViewModel>(
      onModelReady: (model) {
        model.gotoAuthenticatedScreen();
      },
      builder: (context, model, child) {
        showMessage(model);
        return Container(
          alignment: AlignmentDirectional.center,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            image: Utils.buildBackgroundImage(),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlutterLogo(
                size: 100,
              ),
              CircularProgressIndicator(
                value: null,
                valueColor: AlwaysStoppedAnimation(AppTheme.accentColor),
              ),
            ],
          ),
        );
      },
    );
  }
}
