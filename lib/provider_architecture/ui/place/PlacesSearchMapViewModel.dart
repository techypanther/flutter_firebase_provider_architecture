import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_provider_architecture/model/error.dart';
import 'package:flutter_provider_architecture/model/place_response.dart';
import 'package:flutter_provider_architecture/model/result.dart';
import 'package:flutter_provider_architecture/model/user.dart';
import 'package:flutter_provider_architecture/model/user_pref.dart';
import 'package:flutter_provider_architecture/provider_architecture/repository/api/ErrorResponse.dart';
import 'package:flutter_provider_architecture/provider_architecture/ui/base/base_model.dart';
import 'package:flutter_provider_architecture/shared/global_config.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:latlong/latlong.dart' as LatitudeLongitude;
import 'package:location/location.dart';

class PlacesSearchMapViewModel extends BaseModel implements ErrorResponse {
  String keyword = 'Restaurants';
  BuildContext context;

  double latitude = 40.7484405;
  double longitude = -73.9878531;

  double northEastLatitude = 40.7484405;
  double northEastLongitude = -73.9878531;

  double southWestLatitude = 40.7484405;
  double southWestLongitude = -73.9878531;
  LocationData currentLocation;

  List<Marker> markers = <Marker>[];
  Error error;
  List<Result> places;
  bool searching = true;
  final LatitudeLongitude.Distance distance = new LatitudeLongitude.Distance();
  Completer<GoogleMapController> mapcontroller = Completer();
  GoogleMapController controller;
  CameraPosition myLocation;

  User currentUser;
  num meter = 2000;

  init(String keyword, BuildContext context) {
    this.keyword = keyword;
    this.context = context;
    Future.delayed(const Duration(seconds: 1), () async {
      getCurrentLocation();
      // await initUser();
    });
  }

  initUser() async {
    this.currentUser = await UserPreferences().getUser();
  }

  void searchNearby(double latitude, double longitude) async {
    markers.clear();
    setState(ViewState.Busy);
    if (currentLocation == null) {
      getCurrentLocation();
    }
    String url =
        '$baseUrl?key=$mapApiKey&location=$latitude,$longitude&radius=$meter&rectangle=$southWestLatitude,$southWestLongitude|$northEastLatitude,$northEastLongitude&keyword=$keyword';
    print(url);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _handleResponse(data);
    } else {
      throw Exception('An error occurred getting places nearby');
    }

    // make sure to hide searching
    searching = false;
    setState(ViewState.Idle);
    // notifyListeners();
  }

  void _handleResponse(data) {
    // bad api key or otherwise
    if (data['status'] == "REQUEST_DENIED") {
      error = Error.fromJson(data);
      notifyListeners();
      // success
    } else if (data['status'] == "OK") {
      places = PlaceResponse.parseResults(data['results']);
      for (int i = 0; i < places.length; i++) {
        markers.add(
          Marker(
            markerId: MarkerId(places[i].placeId),
            position: LatLng(places[i].geometry.location.lat,
                places[i].geometry.location.long),
            infoWindow:
                InfoWindow(title: places[i].name, snippet: places[i].vicinity),
            onTap: () {},
          ),
        );
      }
      notifyListeners();
    } else {
      print(data);
    }
  }

  void getCurrentLocation() async {
    var location = new Location();

// Platform messages may fail, so we use a try/catch PlatformException.
    try {
      currentLocation = await location.getLocation();
      latitude = currentLocation.latitude;
      longitude = currentLocation.longitude;

      myLocation = CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: 12,
          bearing: 15.0,
          tilt: 75.0);
      notifyListeners();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        var errormsg = 'Permission denied';
        print(errormsg);
      }
      currentLocation = null;
    }
  }

  void getRadius() {
    if (controller != null)
      controller.getVisibleRegion().then((onValue) {
        southWestLatitude = onValue.southwest.latitude;
        southWestLongitude = onValue.southwest.longitude;

        northEastLatitude = onValue.northeast.latitude;
        northEastLongitude = onValue.northeast.longitude;
        meter = distance(
            LatitudeLongitude.LatLng(
                onValue.southwest.latitude, onValue.southwest.longitude),
            LatitudeLongitude.LatLng(
                onValue.northeast.latitude, onValue.northeast.longitude));
        meter = meter / 10;

        print(
            'Locaiton southWest ==>  latitude: ${onValue.southwest.longitude} longitude: ${onValue.southwest.longitude}');
        print(
            'Locaiton northEst ==>  latitude: ${onValue.northeast.longitude} longitude: ${onValue.northeast.longitude}');
      });
  }

  @override
  void serverMessage(String message, bool isError) {
    showMessage(message, isError);
    setState(ViewState.Idle);
  }
}
