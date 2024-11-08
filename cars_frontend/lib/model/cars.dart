class Library {
  final String idmain;
  final int id;
  final String name;
  final String web;
  final int year;
  final List<WorkingTime> model;

  const Library({
    required this.idmain,
    required this.id,
    required this.name,
    required this.web,
    required this.year,
    required this.model,
  });

  factory Library.fromJson(Map<String, dynamic> json) {
    return Library(
      idmain: json['_id'] as String,
      id: json['ID_proizvodjac'] as int,
      name: json['Ime_proizvodjac'] as String,
      web: json['Web_adresa'] as String,
      year: json['Godina_nastanka'] as int,
      model: (json['model'] as List<dynamic>)
          .map((element) => WorkingTime.fromJson(element as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': idmain,
        'ID_proizvodjac': id,
        'Ime_proizvodjac': name,
        'Web_adresa': web,
        'Godina_nastanka': year,
        'model': model.map((m) => m.toJson()).toList(),
      };
}

class WorkingTime {
  final int idmodel;
  final String model;
  final int snaga;
  final int duljina;
  final int sirina;
  final int visina;
  final int brojsjedecihmjesta;
  final int godinaproizvodnje;

  const WorkingTime({
    required this.idmodel,
    required this.model,
    required this.snaga,
    required this.duljina,
    required this.sirina,
    required this.visina,
    required this.brojsjedecihmjesta,
    required this.godinaproizvodnje,
  });

  factory WorkingTime.fromJson(Map<String, dynamic> json) {
    return WorkingTime(
      idmodel: json['ID_model'] as int,
      model: json['Model'] as String,
      snaga: json['Snaga'] as int,
      duljina: json['Duljina'] as int,
      sirina: json['Sirina'] as int,
      visina: json['Visina'] as int,
      brojsjedecihmjesta: json['Broj_sjedecih_mjesta'] as int,
      godinaproizvodnje: json['Godina_proizvodnje'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'ID_model': idmodel,
        'Model': model,
        'Snaga': snaga,
        'Duljina': duljina,
        'Sirina': sirina,
        'Visina': visina,
        'Broj_sjedecih_mjesta': brojsjedecihmjesta,
        'Godina_proizvodnje': godinaproizvodnje,
      };
}
