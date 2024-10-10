import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart'; // Import permission_handler

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  String googleApiKey =
      'AIzaSyANAAs0t1wT_aHvoUlr4kqlUzqgIybTu6k'; // Google API Key
  LatLng? currentLocation;
  LatLng mirpurLocation = const LatLng(23.8223, 90.3654);
  List<LatLng> polylineCoordinates = [];
  Set<Polyline> polylines = {};
  PolylinePoints polylinePoints = PolylinePoints();
  Location location = Location();
  Timer? locationTimer;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission(); // Check permission on startup
    _startLocationUpdateTimer();
  }

  @override
  void dispose() {
    locationTimer?.cancel();
    super.dispose();
  }

  Future<void> _checkLocationPermission() async {
    var status = await Permission.locationWhenInUse.status;

    if (status.isDenied) {
      if (await Permission.locationWhenInUse.request().isGranted) {
        _getCurrentLocation();
      } else {
        if (await Permission.locationWhenInUse.isPermanentlyDenied) {
          _showPermissionDialog();
        }
      }
    } else if (status.isGranted) {
      _getCurrentLocation();
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Location Permission Needed"),
        content: const Text(
            "The app needs location access to display your current location. Please enable it from settings."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings(); // Open app settings for manual permission
            },
            child: const Text("Go to Settings"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void _startLocationUpdateTimer() {
    locationTimer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      _getCurrentLocation();
    });
  }

  void _getCurrentLocation() async {
    try {
      LocationData locationData = await location.getLocation();
      setState(() {
        currentLocation =
            LatLng(locationData.latitude!, locationData.longitude!);
      });
      _updateCameraPosition();
      _getPolyline();
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  void _updateCameraPosition() {
    if (mapController != null && currentLocation != null) {
      mapController!.animateCamera(
        CameraUpdate.newLatLng(currentLocation!),
      );
    }
  }

  void _getPolyline() async {
    if (currentLocation == null) return;

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: googleApiKey,
      request: PolylineRequest(
        origin: PointLatLng(23.868918, 90.3790297),
        destination: PointLatLng(23.7621417, 90.4276339),
        mode: TravelMode.driving,
      ),
    );

    if (result.points.isNotEmpty) {
      print("PolylineResult status: ${result.status}");
      polylineCoordinates.clear();

      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }

      setState(() {
        polylines = {
          Polyline(
            polylineId: const PolylineId('polyline_route'),
            width: 6,
            color: Colors.orange,
            points: polylineCoordinates,
          ),
        };
      });
    } else {
      print("Error fetching route: ${result.errorMessage}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Google Maps Polyline Example")),
      body: currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: currentLocation ?? mirpurLocation,
                zoom: 14,
              ),
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
              polylines: polylines,
              markers: {
                Marker(
                    markerId: const MarkerId("currentLocation"),
                    position: currentLocation!),
                Marker(
                    markerId: const MarkerId("mirpur"),
                    position: mirpurLocation),
              },
            ),
    );
  }
}
