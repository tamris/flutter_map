// lib/app/modules/mapping/views/mapping_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import '../controllers/mapping_controller.dart';

class MappingView extends GetView<MappingController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Peta Lokasi")),
      body: Obx(() {
        print(">>> Current: ${controller.currentLocation.value}");

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

            // Tampilkan marker HANYA jika lokasi user sudah didapat
            if (controller.locationLoaded.value)
              MarkerLayer(
                markers: [
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
                ],
              ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          print(">>> Klik tombol lokasi");
          await controller.getUserLocation();
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
