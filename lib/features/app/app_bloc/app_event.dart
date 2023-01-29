part of 'app_bloc.dart';

@immutable
abstract class AppEvent {}

class AppFirstStartedEvent extends AppEvent {}

class UserAuthenticatedAppEvent extends AppEvent {}

class LogoutUserAppEvent extends AppEvent {}

class LocaleInitAppEvent extends AppEvent {}

class DeleteUserAppEvent extends AppEvent {}

class ShowDeletedAppEvent extends AppEvent {}