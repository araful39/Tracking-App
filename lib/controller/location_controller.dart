import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    log("-------------Init--------------");
    trackUser2();
  }
  FirebaseFirestore firestore = FirebaseFirestore.instance;



  var currentPosition =  const LatLng(
    0,
   0,
  ).obs;


  // void startTrackingUser1(String userId) async {
  // // var user2Position = Position(
  //   //   latitude: 29.8643545,
  //   //   longitude: 98.363962,
  //   //   timestamp: DateTime.now(),
  //   //   accuracy: 0.0,
  //   //   altitude: 0.0,
  //   //   heading: 0.0,
  //   //   speed: 0.0,
  //   //   speedAccuracy: 0.0,
  //   //   altitudeAccuracy: 0.0, // Default value instead of null
  //   //   headingAccuracy: 0.0, // Default value instead of null
  //   // ).obs;
  //   LocationPermission permission = await Geolocator.requestPermission();
  //   if (permission == LocationPermission.denied ||
  //       permission == LocationPermission.deniedForever) {
  //     return;
  //   }
  //
  //   Geolocator.getPositionStream().listen((Position position) {
  //     currentPosition = LatLng(position.latitude,position.longitude).obs;;
  //
  //
  //
  //     firestore.collection('users').doc(userId).set(
  //         {
  //           'location': {
  //             'latitude': position.latitude,
  //             'longitude': position.longitude,
  //           }
  //         },
  //         SetOptions(
  //             merge:
  //                 true));
  //   });
  // }

  void trackUser2() async{
    log("-------------------------TrackUser---------------------");
   firestore.collection('users').doc("l").snapshots().listen((snapshot) async{
     log("------------------------2222222222222222222222---------------------");
      if (snapshot.exists && snapshot.data() != null) {
        var data = snapshot.data();
        if (data != null && data.containsKey('location')) {
          var location = data['location'];
          log("------------------------Location: ${data['location']}---------------------");
          if (location.containsKey('latitude') && location.containsKey('longitude')) {
            // Log the location data
            log("------------------------Location: ${location['latitude']}, ${location['longitude']}---------------------");

            // Update the currentPosition with LatLng for Google Maps
            currentPosition.value = LatLng(
              location['latitude'],
              location['longitude'],
            );
          }

        }
        else{
          log("----------------------No location data found for User2.-------------------------");
        }
      }
    });
  }


}
