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

  

  Future<void> postData(Map<String, dynamic> data) async {
    final response = await _httpClient.post("http://localhost:3000/libraries/add/:id", data: data);
    print(response.data['message']);
    print("Post api client");
  }

  Future<void> putData(String id, Map<String, dynamic> data) async {
    await _httpClient.put("http://localhost:3000/libraries/update/$id", data: data);
  }

  Future<void> deleteData(String id) async {
    await _httpClient.delete("http://localhost:3000/libraries/delete/$id");
  }
}


