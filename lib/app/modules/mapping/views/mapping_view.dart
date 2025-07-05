import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
// import 'package:collection/collection.dart'; // untuk firstWhereOrNull

import '../controllers/mapping_controller.dart';
import 'batik_place_detail_sheet.dart';

class MappingView extends GetView<MappingController> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Peta Lokasi")),
      body: Obx(() {
        final location = controller.currentLocation.value;

        if (location == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final markers = <Marker>[];

        // 🔴 Marker lokasi user
        if (controller.locationLoaded.value) {
          markers.add(
            Marker(
              point: location,
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

        // 🔵 Marker batik interaktif
        markers.addAll(controller.batikPlaces.map((place) {
          return Marker(
            point: LatLng(place.latitude, place.longitude),
            width: 60,
            height: 60,
            child: GestureDetector(
              onTap: () => showBatikPlaceDetailBottomSheet(context, place),
              child: const Icon(
                Icons.location_pin,
                color: Colors.blueAccent,
                size: 36,
              ),
            ),
          );
        }));

        return Stack(
          children: [
            FlutterMap(
              mapController: controller.mapController,
              options: MapOptions(
                initialCenter: location,
                initialZoom: controller.zoom.value,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                MarkerLayer(markers: markers),
              ],
            ),

            // 🔍 Search bar
            Positioned(
              top: 20,
              left: 16,
              right: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    final result = controller.batikPlaces.firstWhereOrNull(
                      (place) =>
                          place.name
                              .toLowerCase()
                              .contains(value.toLowerCase()) ||
                          place.address
                              .toLowerCase()
                              .contains(value.toLowerCase()),
                    );

                    if (result != null) {
                      controller.mapController.move(
                        LatLng(result.latitude, result.longitude),
                        controller.zoom.value,
                      );
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "Cari tempat batik",
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                    prefixIcon:
                        const Icon(Icons.search, size: 20, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),

            // 🔍 Tombol Zoom In / Out
            Positioned(
              bottom: 90,
              right: 16,
              child: Column(
                children: [
                  FloatingActionButton(
                    heroTag: "zoom_in",
                    mini: true,
                    onPressed: controller.zoomIn,
                    child: const Icon(Icons.add),
                  ),
                  const SizedBox(height: 8),
                  FloatingActionButton(
                    heroTag: "zoom_out",
                    mini: true,
                    onPressed: controller.zoomOut,
                    child: const Icon(Icons.remove),
                  ),
                ],
              ),
            ),
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
