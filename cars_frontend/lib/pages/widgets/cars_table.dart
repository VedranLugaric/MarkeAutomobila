import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cars_frontend/controller/cars_list_state.dart';
import 'package:cars_frontend/di.dart';
import 'package:cars_frontend/pages/widgets/cars_data_table.dart';

class LibraryTable extends ConsumerWidget {
  const LibraryTable({super.key});

  void downloadJson(List<Map<String, dynamic>> filteredData) async {
    final jsonData = jsonEncode(filteredData);
    final content = base64Encode(utf8.encode(jsonData));
    final url = 'data:application/json;base64,$content';
    await launchUrl(Uri.parse(url));
  }

  void downloadCsv(List<List<dynamic>> filteredData) async {
    final csvData = const ListToCsvConverter().convert(filteredData);
    final content = base64Encode(utf8.encode(csvData));
    final url = 'data:text/csv;base64,$content';
    await launchUrl(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final libraries = ref.watch(libraryNotifierProvider);

    ElevatedButton(
      onPressed: () => downloadJson(libraries as List<Map<String, dynamic>>),
      child: Text("Download JSON"),
    );
    ElevatedButton(
      onPressed: () => downloadCsv(libraries as List<List>),
      child: Text("Download CSV"),
    );

    switch (libraries) {
      case LoadingState():
        return const Center(child: CircularProgressIndicator.adaptive());
      case SuccessState(list: var libraries):
        return LibraryDataTable(libraries: libraries);
      case ErrorState(message: var errorMessage):
        return Text(
          errorMessage,
          style: const TextStyle(
            fontSize: 42,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        );
    }
  }
}
