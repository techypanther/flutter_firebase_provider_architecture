import 'package:flutter_provider_architecture/provider_architecture/ui/about/AboutUsViewModel.dart';
import 'package:flutter_provider_architecture/provider_architecture/ui/chat/GroupChatViewModel.dart';
import 'package:flutter_provider_architecture/provider_architecture/ui/home/HomeViewModel.dart';
import 'package:flutter_provider_architecture/provider_architecture/ui/menu/NavigationMenuViewModel.dart';
import 'package:flutter_provider_architecture/provider_architecture/ui/place/PlacesSearchMapViewModel.dart';
import 'package:flutter_provider_architecture/provider_architecture/ui/splash_screen/SplashScreenViewModel.dart';
import 'package:flutter_provider_architecture/provider_architecture/ui/user/login/LoginViewModel.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerFactory(() {
    return SplashScreenViewModel();
  });

  locator.registerFactory(() {
    return LoginViewModel();
  });

  locator.registerFactory(() {
    return AboutUsViewModel();
  });

  locator.registerFactory(() {
    return NavigationMenuViewModel();
  });

  locator.registerFactory(() {
    return GroupChatViewModel();
  });

  locator.registerFactory(() {
    return PlacesSearchMapViewModel();
  });

  locator.registerFactory(() {
    return HomeViewModel();
  });
}
