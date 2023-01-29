part of 'app_bloc.dart';

@immutable
abstract class AppState {}

class AppInitial extends AppState {}

class LoadingAppState extends AppState {}

class LocaleInitAppState extends AppState {}

class UnauthenticatedAppState extends AppState {}

class AuthenticatedAppState extends AppState {}

class FailureAppState extends AppState {
  final String? error;
  FailureAppState({this.error});
}

class DeletedAppState extends AppState {}