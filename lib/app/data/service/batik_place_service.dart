import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../models/batik_place_model.dart';

class BatikPlaceService {
  static Future<List<BatikPlace>> fetchPlaces() async {
    final url = Uri.parse('${Config.baseUrl}/api/batik-places');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List places = body['places'];
      return places.map((e) => BatikPlace.fromJson(e)).toList();
    } else {
      throw Exception("Gagal mengambil data batik places");
    }
  }
}
