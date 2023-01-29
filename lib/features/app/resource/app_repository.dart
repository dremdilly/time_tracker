import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracker/features/app/app_bloc/app_bloc.dart';
import 'package:time_tracker/services/shared_preference.dart';

class AppRepository {
  Future<void> onLocaleInitAppEvent(LocaleInitAppEvent event, Emitter<AppState> emit) async {
    if (await sharedPreference.authenticationStatus == false) {
      emit(LocaleInitAppState());
    } else {
      await onAppFirstStartedEvent(AppFirstStartedEvent(), emit);
    }
  }

  Future<void> onAppFirstStartedEvent(AppFirstStartedEvent event, Emitter<AppState> emit) async {
    emit(LoadingAppState());
    if (await isAuthenticated()) {
      emit(AuthenticatedAppState());
    } else {
      emit(UnauthenticatedAppState());
    }
  }

  Future<void> onUserAuthenticatedAppEvent(UserAuthenticatedAppEvent event, Emitter<AppState> emit) async {
    emit(AuthenticatedAppState());
  }

  Future<bool> isAuthenticated() async {
    if (await sharedPreference.authenticationStatus) return true;
    return false;
  }
}