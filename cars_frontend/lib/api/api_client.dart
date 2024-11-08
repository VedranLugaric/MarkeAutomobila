import 'package:dio/dio.dart';
import 'package:cars_frontend/model/cars.dart';

class ApiClient {
  late final Dio _httpClient;

  ApiClient() {
    _httpClient = Dio();
  }

  Future<List<Library>> getLibraries() async {
    final response = await _httpClient.get("http://localhost:3000/libraries");

    final libraries = (response.data as List<dynamic>)
        .map((element) => Library.fromJson(element as Map<String, dynamic>))
        .toList();

    // Kreiraj listu koja će sadržavati svaki model kao zaseban Library objekt
    List<Library> flattenedLibraries = [];
    for (var library in libraries) {
      for (var model in library.model) {
        flattenedLibraries.add(
          Library(
            idmain: library.idmain,
            id: library.id,
            name: library.name,
            web: library.web,
            year: library.year,
            model: [model], // svaki model u zasebnom Library objektu
          ),
        );
      }
    }

    return flattenedLibraries;
  }
}
