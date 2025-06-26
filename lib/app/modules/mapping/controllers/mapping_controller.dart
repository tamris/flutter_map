// lib/app/modules/mapping/controllers/mapping_controller.dart
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:flutter_map/flutter_map.dart';

class MappingController extends GetxController {
  var currentLocation = LatLng(-6.869969, 109.140259).obs; // Default: Tegal
  final location = Location();
  final mapController = MapController();

  var locationLoaded = false.obs; // ⬅️ Tambahan

  @override
  void onInit() {
    super.onInit();
    getUserLocation();
  }

  Future<void> getUserLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    final userLocation = await location.getLocation();
    if (userLocation.latitude != null && userLocation.longitude != null) {
      final newLatLng = LatLng(userLocation.latitude!, userLocation.longitude!);
      currentLocation.value = newLatLng;
      locationLoaded.value = true; // ⬅️ Set sudah dapat lokasi

      print(">>> Lokasi berhasil didapat: $newLatLng");
      mapController.move(newLatLng, 14.0);
    }
  }
}

