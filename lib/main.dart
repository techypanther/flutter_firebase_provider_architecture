import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_provider_architecture/di/service_locator.dart';
import 'package:flutter_provider_architecture/provider_architecture/ui/splash_screen/SplashScreenView.dart';
import 'package:flutter_provider_architecture/utils/theme.dart';

void main() {

    setupLocator();
    runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Provider Demo',
      theme: ThemeData(
        accentColor: AppTheme.accentColor,
        primaryColor: AppTheme.primaryColor,
        buttonTheme: ThemeData.light().buttonTheme.copyWith(
              buttonColor: AppTheme.accentColor,
              textTheme: ButtonTextTheme.normal,
            ),
        scaffoldBackgroundColor: AppTheme.backgroundWhite,
        cardColor: AppTheme.backgroundWhite,
        textSelectionColor: AppTheme.primaryColor,
        errorColor: AppTheme.errorRed,
      ),
      home: SplashScreenView(),
    );
  }
}
