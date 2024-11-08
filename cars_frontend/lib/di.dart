import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cars_frontend/api/api_client.dart';
import 'package:cars_frontend/controller/cars_notifier.dart';
import 'package:cars_frontend/controller/cars_list_state.dart';

final httpClientProvider = Provider<ApiClient>(
  (ref) => ApiClient(),
);

final libraryNotifierProvider = NotifierProvider<LibraryNotifier, ListState>(
  () => LibraryNotifier(),
);
