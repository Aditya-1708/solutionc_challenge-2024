import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:nourishnet/const.dart';
import 'package:nourishnet/widgets/bottom_navbar_user.dart';

class LocationPage extends StatefulWidget {
  final String? locationName;
  const LocationPage({Key? key, this.locationName}) : super(key: key);

  @override
  State<LocationPage> createState() => LocationPageState();
}

class LocationPageState extends State<LocationPage> {
  int currentPage = 1;
  Location _location = Location();
  Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  LatLng? _currentPosition;
  LatLng? _destinationPosition;
  Set<Marker> _markers = {};

  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    _getLocationUpdates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[800],
        title: Text(
          'NourishNet',
          style: TextStyle(
            fontSize: 35,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: _currentPosition == null
          ? Center(
              child: Text("Loading..."),
            )
          : GoogleMap(
              onMapCreated: ((GoogleMapController controller) =>
                  _mapController.complete(controller)),
              initialCameraPosition: CameraPosition(
                target: _currentPosition!,
                zoom: 13,
              ),
              markers: Set<Marker>.of(_markers),
              polylines: Set<Polyline>.of(polylines.values),
            ),
      bottomNavigationBar: CustomBottomNavigationBarUser(
        currentIndex: currentPage,
        onTap: (index) {
          setState(() {
            currentPage = index;
          });
        },
      ),
    );
  }

  Future<void> _moveCameraToPosition(LatLng position) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition newPosition = CameraPosition(target: position, zoom: 13);
    await controller.animateCamera(CameraUpdate.newCameraPosition(newPosition));
  }

  Future<void> _getLocationUpdates() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _location.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        Marker newUserLocation = Marker(
          markerId: MarkerId("_userLocation"),
          icon: BitmapDescriptor.defaultMarker,
          position:
              LatLng(currentLocation.latitude!, currentLocation.longitude!),
        );
        setState(() {
          _markers.add(newUserLocation);
          _currentPosition =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
          _moveCameraToPosition(_currentPosition!);
        });
        if (widget.locationName != null) {
          _markLocation(widget.locationName!);
        }
      }
    });
  }

  void _markLocation(String locationName) async {
    try {
      List<geo.Location> locations =
          await geo.locationFromAddress(locationName);
      if (locations.isNotEmpty) {
        geo.Location location = locations.first;
        Marker newLocationMarker = Marker(
          markerId: MarkerId("_newLocation"),
          position: LatLng(location.latitude, location.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueCyan,
          ),
        );
        _destinationPosition = LatLng(location.latitude, location.longitude);
        setState(() {
          _markers.add(newLocationMarker);
        });
      } else {
        print('Location not found for $locationName');
      }
    } catch (e) {
      print('Error: $e');
    }
    getPolylinePoints().then((coordinates) => {
          generatePolylineFromPoints(coordinates),
        });
  }

  Future<List<LatLng>> getPolylinePoints() async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      Google_maps_api,
      PointLatLng(_currentPosition!.latitude, _currentPosition!.longitude),
      PointLatLng(
          _destinationPosition!.latitude, _destinationPosition!.longitude),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    print("Inside polyline points");
    return polylineCoordinates;
  }

  void generatePolylineFromPoints(List<LatLng> polylineCoordinates) async {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.black,
        points: polylineCoordinates,
        width: 8);
    setState(() {
      polylines[id] = polyline;
    });
  }
  // @override
  // void dispose() {
  //   super.dispose();
  // }
}
