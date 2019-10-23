import 'package:flutter/material.dart';
import 'package:flutter_provider_architecture/provider_architecture/ui/base/base_view.dart';
import 'package:flutter_provider_architecture/provider_architecture/ui/place/PlacesSearchMapViewModel.dart';
import 'package:flutter_provider_architecture/shared/global_config.dart';
import 'package:flutter_provider_architecture/utils/Utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlacesSearchMapView extends StatefulWidget {
  final String keyword;

  PlacesSearchMapView(this.keyword);

  @override
  _PlacesSearchMapSample createState() => _PlacesSearchMapSample();
}

class _PlacesSearchMapSample extends State<PlacesSearchMapView> {
  @override
  void initState() {
    screen = 1;
    super.initState();
  }

  void showMessage(PlacesSearchMapViewModel model) {
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
    return BaseView<PlacesSearchMapViewModel>(
      onModelReady: (model) =>
          PlacesSearchMapViewModel().init(widget.keyword, context),
      builder: (context, model, child) {
        showMessage(model);
        return new Scaffold(
          appBar: AppBar(
            leading: Container(),
            title: Text('Home'),
          ),
          body: model.myLocation == null
              ? Text('Please wait')
              : GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: model.myLocation,
                  onMapCreated: (GoogleMapController controller) {
                    model.controller = controller;
                    model.getRadius();

                    model.mapcontroller.complete(controller);
                  },
                  onCameraIdle: () {
                    model.getRadius();
                  },
                  onCameraMove: ((value) {
                    model.latitude = value.target.latitude;
                    model.longitude = value.target.longitude;
                  }),
                  markers: Set<Marker>.of(model.markers),
                ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              model.searchNearby(model.latitude, model.longitude);
            },
            label: Text('Places Nearby'),
            icon: Icon(Icons.place),
          ),
        );
      },
    );
  }
}
