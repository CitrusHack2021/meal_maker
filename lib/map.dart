import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'package:flutter/cupertino.dart';

import 'package:google_maps_webservice/directions.dart';
import 'package:google_maps_webservice/distance.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/geolocation.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_maps_webservice/staticmap.dart';
import 'package:google_maps_webservice/timezone.dart';

//Fake API Key, replace with real one
final places =
    GoogleMapsPlaces(apiKey: "APIKEY");

// Nearby Restaurants
Set<Marker> _markers = {};

class MapView extends StatelessWidget {
  final String keyword;
  MapView(this.keyword);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Food Decision',
      //home: MapSample(),
      home: Scaffold(
          appBar: AppBar(
            title: Text("Pick A Location"),
            leading: BackButton(
              onPressed: () {
                _markers.clear();
                Navigator.pop(context);
              },
            ),
          ),
          body: MapSample(keyword)),
    );
  }
}

class MapSample extends StatefulWidget {
  final String keyword;

  MapSample(this.keyword);

  @override
  State<StatefulWidget> createState() {
    return MapSampleState();
  }
}

class MapSampleState extends State<MapSample> {
  /// Determine the current position of the device.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    //permissions are granted
    return await Geolocator.getCurrentPosition();
  }

  Future<void> _retrieveNearbyRestaurants(
      LatLng _userLocation, String searchTerm) async {
    PlacesSearchResponse _response = await places.searchNearbyWithRadius(
        Location(lat: _userLocation.latitude, lng: _userLocation.longitude),
        100,
        type: "restuarant",
        keyword: searchTerm);

    // print results
    _response.results.forEach((element) {
      print(element.vicinity);
    });

    Set<Marker> _restaurantMarkers = _response.results
        .map((result) => Marker(
            onTap: () {
              showDialog<void>(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(result.name),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: [
                            Text("${result.vicinity}"),
                            Text("Average rating: ${result.rating}/5")
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          child: Text("Copy Address"),
                          onPressed: () {
                            Clipboard.setData(
                                ClipboardData(text: result.vicinity));
                            Navigator.pop(context);
                          },
                        ),
                        TextButton(
                          child: Text("Close"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  });
            },
            markerId: MarkerId(result.name),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueAzure),
            infoWindow: InfoWindow(
                title: result.name,
                snippet:
                    "Ratings: " + (result.rating?.toString() ?? "Not Rated")),
            position: LatLng(
                result.geometry.location.lat, result.geometry.location.lng)))
        .toSet();

    setState(() {
      _markers.addAll(_restaurantMarkers);
    });
  }

  @override
  Widget build(BuildContext context) {
    String matchedFood = widget.keyword;

    return FutureBuilder(
        future: _determinePosition(),
        builder: (context, AsyncSnapshot<Position> currLoc) {
          if (currLoc.connectionState == ConnectionState.done) {
            if (currLoc.hasData) {
              // The user location returned from the snapshot
              double latitude = currLoc.data.latitude;
              double longitude = currLoc.data.longitude;

              if (_markers.isEmpty) {
                _retrieveNearbyRestaurants(
                    LatLng(latitude, longitude), matchedFood);
              }

              return GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(latitude, longitude),
                    zoom: 15,
                  ),
                  markers: _markers
                    ..add(Marker(
                        markerId: MarkerId("Your Location"),
                        infoWindow: InfoWindow(title: "Your Location"),
                        position: LatLng(latitude, longitude))));
            } else {
              return Center(child: Text("Failed to get user location."));
            }
          }
          // While the connection is not in the done state yet
          return Center(child: CircularProgressIndicator());
        });
  }
}
