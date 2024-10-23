import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tracking_app/screen/home.dart';

class AuthController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  var isLoggedIn = false.obs;
  var currentPosition = const LatLng(23.8664883, 90.3848837).obs;

  void login(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        isLoggedIn.value = true;
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        String userId = userCredential.user!.uid;

        await startTrackingUser1();

        await saveUserDataToFirestore(userId, email, password);

        isLoggedIn.value = false;
        Get.to(() => const MapScreen()); // Example navigation
      } else {
        Get.snackbar("Email and Password Empty", "Please fill in both fields.");
      }
    } catch (e) {
      isLoggedIn.value = false;
      Get.snackbar("Login Error", e.toString());
    }
  }

  // Sign Up Function
  void signUp(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        isLoggedIn.value = true;
        log("Signing up user: $email");

        UserCredential userCredential =
            await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        String userId = userCredential.user!.uid; // Get the user's UID

        // Save user data in a new Firestore collection upon signup
        await saveUserDataToFirestore(userId, email, password);

        // Start tracking the user by UID
        await startTrackingUser1();

        isLoggedIn.value = false;
        Get.to(() => const MapScreen()); // Example navigation
      } else {
        Get.snackbar("Email and Password Empty", "Please fill in both fields.");
      }
    } catch (e) {
      isLoggedIn.value = false;
      Get.snackbar("Sign Up Error", e.toString());
    }
  }

  // Logout Function
  void logout() async {
    await auth.signOut();
    isLoggedIn.value = false;
  }

  Future<void> startTrackingUser1() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      log("Location permission denied");
      return; // If permission is denied, return
    }

    Geolocator.getPositionStream().listen((Position position) async {
      log("Position: ${position.latitude}, ${position.longitude}");
      currentPosition = LatLng(position.latitude, position.longitude).obs;

      // Update Firestore with the user's location
      await firestore.collection('users').doc("l").set(
        {
          'location': {
            'latitude': position.latitude,
            'longitude': position.longitude,
          }
        },
        SetOptions(merge: true), // Merge with existing data if needed
      );
    });
  }

  // Save user data to Firestore (in a separate collection)
  Future<void> saveUserDataToFirestore(
      String userId, String email, String password) async {
    try {
      // Create a new document in the 'userDetails' collection with the user's ID
      await firestore.collection('userDetails').doc(userId).set({
        'email': email,
        'password': password,
        'createdAt': FieldValue.serverTimestamp(), // Timestamp of user creation
        // Add any other necessary user data here (except passwords)
      }, SetOptions(merge: true)); // Merge data with existing doc if needed
    } catch (e) {
      log("Error saving user data: $e");
    }
  }
}
