import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cars_frontend/controller/cars_notifier.dart';
import 'package:cars_frontend/controller/cars_list_state.dart';

// Provider za LibraryNotifier
final libraryNotifierProvider = NotifierProvider<LibraryNotifier, ListState>(
  () => LibraryNotifier(),
);

class DownloadButtons extends ConsumerWidget {
  const DownloadButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final libraryNotifier = ref.watch(libraryNotifierProvider.notifier);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            libraryNotifier.downloadJson();
          },
          icon: const Icon(Icons.download),
          label: const Text("Preuzmi JSON filtrirani"),
        ),
        const SizedBox(width: 10),
        ElevatedButton.icon(
          onPressed: () {
            libraryNotifier.downloadCsv();
          },
          icon: const Icon(Icons.download),
          label: const Text("Preuzmi CSV filtrirani"),
        ),
        const SizedBox(width: 10),
        ElevatedButton.icon(
          onPressed: () {
            libraryNotifier.downloadJsonFull();
          },
          icon: const Icon(Icons.download),
          label: const Text("Preuzmi JSON"),
        ),
        const SizedBox(width: 10),
        ElevatedButton.icon(
          onPressed: () {
            libraryNotifier.downloadCsvFull();
          },
          icon: const Icon(Icons.download),
          label: const Text("Preuzmi CSV"),
        ),
      ],
    );
  }
}

class DownloadButtonsOsvjezi extends ConsumerWidget {
  const DownloadButtonsOsvjezi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final libraryNotifier = ref.watch(libraryNotifierProvider.notifier);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            libraryNotifier.downloadJsonFull();
            libraryNotifier.downloadCsvFull();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.yellowAccent,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            textStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          icon: const Icon(Icons.download),
          label: const Text("Preuzmi osvjezenje"),
        ),
      ],
    );
  }
}
