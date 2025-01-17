import 'package:bloc/bloc.dart';
import 'package:carpet_delivery/core/dependency/di.dart';
import 'package:carpet_delivery/data/models/auth/login_request.dart';
import 'package:carpet_delivery/data/repositories/auth_repository.dart';
import 'package:carpet_delivery/data/services/auth_local_service.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  AuthBloc({required this.authRepository}) : super(InitialAuthState()) {
    on<LoginAuthEvent>(_onLogin);
    on<LogoutAuthEvent>(_onLogout);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
  }

  void _onLogin(LoginAuthEvent event, emit) async {
    emit(LoadingAuthState());
    try {
      await authRepository.login(event.request);
      emit(AuthorizedAuthState());
    } catch (e) {
      emit(ErrorAuthState(message: e.toString()));
    }
  }

  void _onLogout(LogoutAuthEvent event, emit) async {
    emit(LoadingAuthState());
    try {
      await authRepository.logout();
      emit(UnauthorizedAuthState());
    } catch (e) {
      emit(ErrorAuthState(message: e.toString()));
    }
  }

  void _onCheckAuthStatus(CheckAuthStatusEvent event, emit) {
    final AuthLocalService authLocalService = getIt.get<AuthLocalService>();
    final token = authLocalService.getAccessToken();

    bool isAuthorized = token == null ? false : true;

    if (isAuthorized) {
      emit(AuthorizedAuthState());
    } else {
      emit(UnauthorizedAuthState());
    }
  }
}
