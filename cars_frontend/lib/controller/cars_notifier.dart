import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cars_frontend/api/api_client.dart';
import 'package:cars_frontend/controller/cars_list_state.dart';
import 'package:cars_frontend/di.dart';
import 'dart:convert';
import 'dart:html' as html;  // Potrebno za preuzimanje datoteka u Web aplikacijama
import 'package:csv/csv.dart';
import 'package:cars_frontend/model/cars.dart';
List<Library> preuzimanjePodaci = [];
class LibraryNotifier extends Notifier<ListState> {
  late final ApiClient _apiClient;
  List<Library> podaci = []; // Eksplicitno definiramo `podaci` kao `List<Library>`
  List<Library> filtriraniPodaci = []; // Dodajemo varijablu za filtrirane podatke
  
  @override
  ListState build() {
    _apiClient = ref.watch(httpClientProvider);
    fetchLibraries();
    return LoadingState();
  }

  // Metoda za dohvaćanje svih podataka
  void fetchLibraries() async {
    try {
      state = LoadingState();
      final result = await _apiClient.getLibraries();
      podaci = result;  // Pohranjujemo sve podatke u `podaci`
      filtriraniPodaci = podaci; // Inicijalno postavljamo filtrirane podatke na sve podatke
      state = SuccessState(filtriraniPodaci);
    } catch (e) {
      state = ErrorState("Dogodila se pogreška.");  
    }
  }

  // Preuzimanje filtriranih podataka kao JSON datoteke
  void downloadJson() {
    print("Tu sam JSON download");
    print(preuzimanjePodaci);
    final jsonData = jsonEncode(preuzimanjePodaci.map((library) => library.toJson()).toList());  // Generiramo JSON samo od filtriranih podataka
    final bytes = utf8.encode(jsonData);
    final blob = html.Blob([bytes], 'application/json');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", "filtered_data.json")  // Naziv datoteke
      ..click();
    html.Url.revokeObjectUrl(url);  // Oslobađamo URL
  }

  // Preuzimanje filtriranih podataka kao CSV datoteke
  void downloadCsv() {
    print("Tu sam csv download");
    print(preuzimanjePodaci);
    final csvData = const ListToCsvConverter().convert(
      preuzimanjePodaci.map((library) => [
        library.name,
        library.web,
        library.year,
        ...library.model.map((model) => [
          model.model,
          model.snaga,
          model.duljina,
          model.sirina,
          model.visina,
          model.brojsjedecihmjesta,
          model.godinaproizvodnje
        ]).expand((i) => i)
      ]).toList()
    );  // Pretvaramo filtrirane podatke u CSV format
    final bytes = utf8.encode(csvData);
    final blob = html.Blob([bytes], 'text/csv');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", "filtered_data.csv")  // Naziv datoteke
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  void downloadJsonFull() {
    print("Tu sam JSON download");
    print(filtriraniPodaci);
    final jsonData = jsonEncode(filtriraniPodaci.map((library) => library.toJson()).toList());  // Generiramo JSON samo od filtriranih podataka
    final bytes = utf8.encode(jsonData);
    final blob = html.Blob([bytes], 'application/json');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", "filtered_data.json")  // Naziv datoteke
      ..click();
    html.Url.revokeObjectUrl(url);  // Oslobađamo URL
  }

  // Preuzimanje filtriranih podataka kao CSV datoteke
  void downloadCsvFull() {
    print("Tu sam csv download");
    print(filtriraniPodaci);
    final csvData = const ListToCsvConverter().convert(
      filtriraniPodaci.map((library) => [
        library.name,
        library.web,
        library.year,
        ...library.model.map((model) => [
          model.model,
          model.snaga,
          model.duljina,
          model.sirina,
          model.visina,
          model.brojsjedecihmjesta,
          model.godinaproizvodnje
        ]).expand((i) => i)
      ]).toList()
    );  // Pretvaramo filtrirane podatke u CSV format
    final bytes = utf8.encode(csvData);
    final blob = html.Blob([bytes], 'text/csv');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", "filtered_data.csv")  // Naziv datoteke
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  // Metoda za filtriranje podataka prema specificiranim kriterijima
  void filterData(final FilterProperty filter, final String query) async {
    filtriraniPodaci = podaci.where((library) {
      switch (filter) {
        case FilterProperty.any:
          return library.name.toLowerCase().contains(query.toLowerCase()) ||
                 library.web.toLowerCase().contains(query.toLowerCase()) ||
                 library.year.toString().contains(query) ||
                 library.model.any((model) =>
                   model.model.toLowerCase().contains(query.toLowerCase()) ||
                   model.snaga.toString().contains(query) ||
                   model.duljina.toString().contains(query) ||
                   model.sirina.toString().contains(query) ||
                   model.visina.toString().contains(query) ||
                   model.brojsjedecihmjesta.toString().contains(query) ||
                   model.godinaproizvodnje.toString().contains(query));
        case FilterProperty.name:
          return library.name.toLowerCase().contains(query.toLowerCase());
        case FilterProperty.web:
          return library.web.toLowerCase().contains(query.toLowerCase());
        case FilterProperty.year:
          return library.year.toString().contains(query);
        case FilterProperty.modelName:
          return library.model.any((model) =>
            model.model.toLowerCase().contains(query.toLowerCase()));
        case FilterProperty.modelPower:
          return library.model.any((model) =>
            model.snaga.toString().contains(query));
        case FilterProperty.modelLength:
          return library.model.any((model) =>
            model.duljina.toString().contains(query));
        case FilterProperty.modelWidth:
          return library.model.any((model) =>
            model.sirina.toString().contains(query));
        case FilterProperty.modelHeight:
          return library.model.any((model) =>
            model.visina.toString().contains(query));
        case FilterProperty.modelSeats:
          return library.model.any((model) =>
            model.brojsjedecihmjesta.toString().contains(query));
        case FilterProperty.modelYear:
          return library.model.any((model) =>
            model.godinaproizvodnje.toString().contains(query));
      }
    }).toList();
    preuzimanjePodaci = filtriraniPodaci;
    print("Tu sam filter");
    print(preuzimanjePodaci);
    state = SuccessState(filtriraniPodaci);  // Ažuriramo stanje s filtriranim podacima
  }

  // Resetiramo filter i vraćamo sve podatke
  void resetFilter() {
    print("Tu sam reser");
    filtriraniPodaci = podaci;
    state = SuccessState(filtriraniPodaci);
  }
}

enum FilterProperty {
  any("Sva polja (wildcard)"),
  name("Naziv"),
  web("Web adresa"),
  year("Godina nastanka"),
  modelName("Naziv modela"),
  modelPower("Snaga modela"),
  modelLength("Duljina modela"),
  modelWidth("Širina modela"),
  modelHeight("Visina modela"),
  modelSeats("Broj sjedecih mjesta modela"),
  modelYear("Godina proizvodnje modela");

  final String label;
  const FilterProperty(this.label);
}
