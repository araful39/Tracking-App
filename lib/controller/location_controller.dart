import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var userPosition = const LatLng(0, 0).obs;
  Timer? locationUpdateTimer;

  @override
  void onInit() {
    super.onInit();
    // Start the location update timer
    startLocationUpdates();
  }

  void startLocationUpdates() {
    locationUpdateTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      trackUser2();
    });
  }

  void trackUser2() async {
    log("-------------------------TrackUser---------------------");
    firestore.collection('users').doc("l").snapshots().listen((snapshot) async {
      log("------------------------Fetching location data---------------------");
      if (snapshot.exists && snapshot.data() != null) {
        var data = snapshot.data();
        if (data != null && data.containsKey('location')) {
          var location = data['location'];
          log("------------------------Location: ${data['location']}---------------------");
          if (location.containsKey('latitude') &&
              location.containsKey('longitude')) {
            // Log the location data
            log("------------------------Location: ${location['latitude']}, ${location['longitude']}---------------------");

            // Update the userPosition with LatLng for Google Maps
            userPosition.value = LatLng(
              location['latitude'],
              location['longitude'],
            );
          }
        } else {
          log("----------------------No location data found for User2.-------------------------");
        }
      }
    });
  }

  @override
  void onClose() {
    // Cancel the timer when the controller is destroyed
    locationUpdateTimer?.cancel();
    super.onClose();
  }
}
