import 'package:flutter/material.dart';
import 'package:cars_frontend/model/cars.dart';

class LibraryDataTable extends StatelessWidget {
  final List<Library> libraries;

  const LibraryDataTable({super.key, required this.libraries});

  @override
  Widget build(BuildContext context) {
    List<DataRow> rows = [];

    for (var library in libraries) {
      for (var model in library.model) {
        rows.add(
          DataRow(cells: [
            DataCell(Text(library.id.toString())),
            DataCell(Text(library.name)),
            DataCell(Text(library.web)),
            DataCell(Text(library.year.toString())),
            DataCell(Text(model.model)),
            DataCell(Text(model.snaga.toString())),
            DataCell(Text(model.duljina.toString())),
            DataCell(Text(model.sirina.toString())),
            DataCell(Text(model.visina.toString())),
            DataCell(Text(model.brojsjedecihmjesta.toString())),
            DataCell(Text(model.godinaproizvodnje.toString())),
          ]),
        );
      }
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Card(
        elevation: 5,
        margin: EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DataTable(
            columnSpacing: 20,
            headingRowColor:
                MaterialStateColor.resolveWith((states) => Colors.blueGrey.shade100),
            columns: const [
              DataColumn(label: Text("ID proizvodaca")),
              DataColumn(label: Text("Ime proizvodaca")),
              DataColumn(label: Text("Web adresa")),
              DataColumn(label: Text("Godina nastanka")),
              DataColumn(label: Text("Model")),
              DataColumn(label: Text("Snaga")),
              DataColumn(label: Text("Duljina")),
              DataColumn(label: Text("Širina")),
              DataColumn(label: Text("Visina")),
              DataColumn(label: Text("Broj sjedecih mjesta")),
              DataColumn(label: Text("Godina proizvodnje")),
            ],
            rows: rows,
          ),
        ),
      ),
    );
  }
}
