import 'package:demo_mapping/app/data/models/batik_place_model.dart';
import 'package:demo_mapping/app/data/service/batik_place_service.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:flutter_map/flutter_map.dart';

class MappingController extends GetxController {
  final mapController = MapController();

  final location = Location();
  var currentLocation = Rxn<LatLng>();
  var locationLoaded = false.obs;
  var batikPlaces = <BatikPlace>[].obs;

  // 🌟 Tambahan: kontrol zoom
  var zoom = 14.0.obs;

  @override
  void onInit() {
    super.onInit();
    getUserLocation();
    fetchBatikPlaces();
  }

  Future<void> getUserLocation() async {
    try {
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          fallbackToTegal();
          return;
        }
      }

      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          fallbackToTegal();
          return;
        }
      }

      final userLoc = await location.getLocation();
      if (userLoc.latitude != null && userLoc.longitude != null) {
        final userLatLng = LatLng(userLoc.latitude!, userLoc.longitude!);
        currentLocation.value = userLatLng;
        locationLoaded.value = true;

        Future.delayed(const Duration(milliseconds: 300), () {
          mapController.move(userLatLng, zoom.value); // 🌟 Perhatikan: pakai zoom.value
        });

        print("✅ Lokasi user: $userLatLng");
      }
    } catch (e) {
      print("❌ Error ambil lokasi: $e");
      fallbackToTegal();
    }
  }

  void fallbackToTegal() {
    currentLocation.value = LatLng(-6.869969, 109.140259); // Kota Tegal
    locationLoaded.value = false;
  }

  Future<void> fetchBatikPlaces() async {
    try {
      final result = await BatikPlaceService.fetchPlaces();
      batikPlaces.value = result;
    } catch (e) {
      print("❌ Gagal fetch batik places: $e");
    }
  }

  // 🌟 Tambahan: Fungsi zoom in
  void zoomIn() {
    zoom.value += 1;
    if (currentLocation.value != null) {
      mapController.move(currentLocation.value!, zoom.value);
    }
  }

  // 🌟 Tambahan: Fungsi zoom out
  void zoomOut() {
    zoom.value -= 1;
    if (currentLocation.value != null) {
      mapController.move(currentLocation.value!, zoom.value);
    }
  }
}
