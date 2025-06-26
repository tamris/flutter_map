// lib/app/modules/mapping/controllers/mapping_controller.dart
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:flutter_map/flutter_map.dart';

class MappingController extends GetxController {
  var currentLocation = LatLng(109.12710991826437, -6.871848472979647).obs; // Default London
  final location = Location();
  final mapController = MapController();

  @override
  void onInit() {
    super.onInit();
    getUserLocation();
  }

  Future<void> getUserLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // Cek apakah layanan lokasi aktif
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    // Cek permission
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    // Ambil lokasi
    final userLocation = await location.getLocation();
    if (userLocation.latitude != null && userLocation.longitude != null) {
      final newLatLng = LatLng(userLocation.latitude!, userLocation.longitude!);
      currentLocation.value = newLatLng;
      print(">>> Lokasi berhasil didapat: $newLatLng");

      // Pindahkan peta ke lokasi baru
      mapController.move(newLatLng, 14.0);
    }
  }
}
