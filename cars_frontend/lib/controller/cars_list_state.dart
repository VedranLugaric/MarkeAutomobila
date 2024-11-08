import 'package:cars_frontend/model/cars.dart';

sealed class ListState {}

class LoadingState extends ListState {}

class SuccessState extends ListState {
  final List<Library> list;

  SuccessState(this.list);
}

class ErrorState extends ListState {
  final String message;

  ErrorState(this.message);
}
