import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/models/batik_place_model.dart';
import '../controllers/mapping_controller.dart';

void showBatikPlaceDetailBottomSheet(BuildContext context, BatikPlace place) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Nama Toko
            Row(
              children: [
                const Icon(Icons.store_mall_directory,
                    color: Colors.blueAccent, size: 32),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    place.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Alamat
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.place, color: Colors.redAccent),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    place.address,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Deskripsi
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.description, color: Colors.orange),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    place.description,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Tombol Rute & Tutup
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    final userLoc =
                        Get.find<MappingController>().currentLocation.value;

                    if (userLoc != null) {
                      await openGoogleMapsRoute(
                        fromLat: userLoc.latitude,
                        fromLng: userLoc.longitude,
                        toLat: place.latitude,
                        toLng: place.longitude,
                      );
                    } else {
                      Get.snackbar("Gagal", "Lokasi kamu belum tersedia");
                    }
                  },
                  icon: const Icon(Icons.directions),
                  label: const Text("Rute"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  label: const Text("Tutup"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

Future<void> openGoogleMapsRoute({
  required double fromLat,
  required double fromLng,
  required double toLat,
  required double toLng,
}) async {
  final url = Uri.parse(
    'https://www.google.com/maps/dir/?api=1&origin=$fromLat,$fromLng&destination=$toLat,$toLng&travelmode=driving',
  );

  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch $url';
  }
}
