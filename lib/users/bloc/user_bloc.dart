import 'package:bloc/bloc.dart';
import 'package:vgv/users/bloc/user_event.dart';
import 'package:vgv/users/bloc/user_state.dart';
import 'package:vgv/users/repository/user_repository.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(const UserInitial()) {
    on<LoadUsers>(_onLoadUsers);
    on<AddUser>(_onAddUser);
    on<UpdateUser>(_onUpdateUser);
    on<DeleteUser>(_onDeleteUser);
  }

  final UserRepository _userRepository;

  Future<void> _onLoadUsers(LoadUsers event, Emitter<UserState> emit) async {
    emit(const UserLoading());
    try {
      final users = await _userRepository.getUsers();
      emit(UserLoaded(users));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onAddUser(AddUser event, Emitter<UserState> emit) async {
    try {
      await _userRepository.addUser(event.user);
      add(const LoadUsers());
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onUpdateUser(UpdateUser event, Emitter<UserState> emit) async {
    try {
      await _userRepository.updateUser(event.user);
      add(const LoadUsers());
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onDeleteUser(DeleteUser event, Emitter<UserState> emit) async {
    try {
      await _userRepository.deleteUser(event.id);
      add(const LoadUsers());
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}
