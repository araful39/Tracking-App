import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tracking_app/controller/home_controller.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.put(HomeController());

    return Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition:
            CameraPosition(target: homeController.sourceLocation, zoom: 14.4),
      ),
    );
  }
}
