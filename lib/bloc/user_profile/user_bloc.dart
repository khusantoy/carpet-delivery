import 'package:bloc/bloc.dart';
import 'package:carpet_delivery/data/models/user/user.dart';
import 'package:carpet_delivery/data/repositories/user_repository.dart';

part "user_state.dart";
part 'user_event.dart';

class UserBloc extends Bloc<UserProfileEvent, UserState> {
  final UserRepository userRepository;

  UserBloc({required this.userRepository}) : super(InitialState()) {
    on<FetchUserProfileEvent>(_getUserInfo);
  }

  void _getUserInfo(FetchUserProfileEvent event, emit) async {
    emit(LoadingState());
    try {
      final response = await userRepository.getUser();
      emit(LoadedState(user: response!));
    } catch (e) {
      emit(ErrorState(message: e.toString()));
    }
  }
}
