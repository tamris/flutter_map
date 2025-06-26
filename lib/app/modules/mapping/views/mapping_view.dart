import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../controllers/mapping_controller.dart';

class MappingView extends GetView<MappingController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Peta Lokasi")),
      body: Obx(() {
        final markers = <Marker>[];

        // 🔴 Lokasi user
        if (controller.locationLoaded.value) {
          markers.add(
            Marker(
              point: controller.currentLocation.value,
              width: 80,
              height: 80,
              child: const Icon(
                Icons.location_pin,
                color: Colors.red,
                size: 40,
              ),
            ),
          );
        }

        // 🔵 Lokasi toko batik dari backend
        markers.addAll(controller.batikPlaces.map((place) {
          return Marker(
            point: LatLng(place.latitude, place.longitude),
            width: 60,
            height: 60,
            child: Tooltip(
              message: '${place.name}\n${place.description}',
              child: const Icon(
                Icons.store_mall_directory,
                color: Colors.blueAccent,
                size: 36,
              ),
            ),
          );
        }));

        return FlutterMap(
          mapController: controller.mapController,
          options: MapOptions(
            initialCenter: controller.currentLocation.value,
            initialZoom: 14.0,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
            ),
            MarkerLayer(markers: markers),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.getUserLocation(),
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
