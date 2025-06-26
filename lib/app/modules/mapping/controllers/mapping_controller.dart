import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:flutter_map/flutter_map.dart';
import '../../../data/models/batik_place_model.dart';
import '../../../data/service/batik_place_service.dart';

class MappingController extends GetxController {
  var currentLocation = LatLng(-6.869969, 109.140259).obs; // Default Tegal
  var locationLoaded = false.obs;
  var batikPlaces = <BatikPlace>[].obs;

  final location = Location();
  final mapController = MapController();

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
        if (!serviceEnabled) return;
      }

      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) return;
      }

      final userLoc = await location.getLocation();
      if (userLoc.latitude != null && userLoc.longitude != null) {
        final newLoc = LatLng(userLoc.latitude!, userLoc.longitude!);
        currentLocation.value = newLoc;
        locationLoaded.value = true;
        mapController.move(newLoc, 14.0);
        print(">>> Lokasi user: $newLoc");
      }
    } catch (e) {
      print("❌ Gagal ambil lokasi user: $e");
    }
  }

  Future<void> fetchBatikPlaces() async {
    try {
      final result = await BatikPlaceService.fetchPlaces();
      batikPlaces.value = result;
    } catch (e) {
      print("❌ Gagal fetch batik places: $e");
    }
  }
}
