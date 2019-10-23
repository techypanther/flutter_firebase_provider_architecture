import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_provider_architecture/utils/AppConstants.dart'
    as AppConstants;
import 'package:flutter_provider_architecture/utils/theme.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  static String apiToken;
  static double deviceHeight = 0.0;
  static double deviceWidth = 0.0;
  static ScrollController followingPostsScrollController;
  static ScrollController notificationScrollController;
  static bool connected = true;
  static int commentPostId = 0;

  static void showMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        fontSize: 15,
        backgroundColor: Colors.black54,
        gravity: ToastGravity.BOTTOM,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_LONG);
  }

  static DecorationImage buildBackgroundImage() {
    return DecorationImage(
      fit: BoxFit.cover,
      colorFilter:
          ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
      image: AssetImage('assets/background.jpg'),
    );
  }

  static Widget loadingView() {
    return Center(
        child: Theme(
      data: ThemeData(accentColor: AppTheme.accentColor),
      child: CircularProgressIndicator(),
    ));
  }

  static Widget noDataMessage(String message) {
    return Container(
      child: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(color: AppTheme.greyColor, fontSize: 20),
        ),
      ),
    );
  }

  static getCachedAvatar(String avatarUrl) {
    return CachedNetworkImage(
      imageUrl: avatarUrl,
      imageBuilder: (context, imageProvider) => CircleAvatar(
        backgroundImage: imageProvider,
      ),
      placeholder: (context, url) => CircularProgressIndicator(
        strokeWidth: 1,
      ),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }

  static Future<bool> isInternetAvailable() async {
    var connectivityResult = await new Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      Utils.showMessage(AppConstants.noInternet);
      return false;
    } else {
      return true;
    }
  }
}
