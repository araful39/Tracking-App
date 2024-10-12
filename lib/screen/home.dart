import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:tracking_app/controller/auth_controller.dart';
import 'package:tracking_app/controller/location_controller.dart';

class MapScreen extends StatelessWidget {



  const MapScreen({super.key,  });

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();

    final LocationController locationController = Get.put(LocationController());

    authController.startTrackingUser1();
    locationController.trackUser2();

    return Scaffold(
      appBar: AppBar(title: const Text("Track Location")),
      body: Obx(() {
        return GoogleMap(
          mapType: MapType.hybrid,
          initialCameraPosition: CameraPosition(
            target: LatLng(
              authController.currentPosition.value.latitude,
              authController.currentPosition.value.longitude,
            ),
            zoom: 14.0,
          ),
          markers: _createMarkers(
            authController.currentPosition.value.latitude,
            authController.currentPosition.value.longitude,
            locationController.currentPosition.value.latitude,
            locationController.currentPosition.value.longitude,
          ),
          polylines: _createPolyline(
            authController.currentPosition.value.latitude,
            authController.currentPosition.value.longitude,
            locationController.currentPosition.value.latitude,
            locationController.currentPosition.value.longitude,
          ),
        );
      }),
    );
  }

  // Create markers based on user locations
  Set<Marker> _createMarkers(
    double user1Lat,
    double user1Lng,
    double user2Lat,
    double user2Lng,
  ) {
    return <Marker>[
      Marker(
        markerId: MarkerId('user1'),
        position: LatLng(user1Lat, user1Lng),
        infoWindow: InfoWindow(title: 'User 1 Location'),
      ),
      Marker(
        markerId: MarkerId('user2'),
        position: LatLng(user2Lat, user2Lng),
        infoWindow: InfoWindow(title: 'User 2 Location'),
      ),
    ].toSet();
  }

  // Create a polyline between the two users
  Set<Polyline> _createPolyline(
    double user1Lat,
    double user1Lng,
    double user2Lat,
    double user2Lng,
  ) {
    return <Polyline>{
      Polyline(
        polylineId: PolylineId('track'),
        visible: true,
        points: [
          LatLng(user1Lat, user1Lng),
          LatLng(user2Lat, user2Lng),
        ],
        color: Colors.blue,
        width: 5,
      ),
    };
  }
}
