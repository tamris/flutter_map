class BatikPlace {
  final String name;
  final double latitude;
  final double longitude;
  final String description;
  final String address; // ✅ Tambahan

  BatikPlace({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.address, // ✅ Tambahan
  });

  factory BatikPlace.fromJson(Map<String, dynamic> json) => BatikPlace(
        name: json['name'],
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
        description: json['description'],
        address: json['address'] ?? '-', // ✅ Tambahan (pakai default biar aman)
      );
}
