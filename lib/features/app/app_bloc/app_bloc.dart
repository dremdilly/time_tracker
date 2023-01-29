import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracker/features/app/resource/app_repository.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final _repository = AppRepository();

  AppBloc() : super(AppInitial()) {
    on<LocaleInitAppEvent>(_repository.onLocaleInitAppEvent);
    on<AppFirstStartedEvent>(_repository.onAppFirstStartedEvent);
    on<UserAuthenticatedAppEvent>(_repository.onUserAuthenticatedAppEvent);
    // on<LogoutUserAppEvent>(_repository.onLogoutUserAppEvent);
    // on<DeleteUserAppEvent>(_repository.onDeleteUserAppEvent);
    // on<ShowDeletedAppEvent>((event, emit) async {
    //   await _repository.onLogoutUserAppEvent(LogoutUserAppEvent(), emit);
    //   emit(DeletedAppState());
    // });
  }
}