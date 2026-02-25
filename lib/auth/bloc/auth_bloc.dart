import 'package:bloc/bloc.dart';
import 'package:vgv/auth/bloc/auth_event.dart';
import 'package:vgv/auth/bloc/auth_state.dart';
import 'package:vgv/auth/repository/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AuthInitial()) {
    on<AuthStarted>(_onAuthStarted);
    on<AuthUserChanged>(_onAuthUserChanged);
    on<AuthSignOutRequested>(_onAuthSignOutRequested);
  }

  final AuthRepository _authRepository;

  Future<void> _onAuthStarted(
    AuthStarted event,
    Emitter<AuthState> emit,
  ) async {
    final user = _authRepository.currentUser;
    if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(const AuthUnauthenticated());
    }
    await emit.onEach(
      _authRepository.authStateChanges,
      onData: (user) => add(AuthUserChanged(user)),
    );
  }

  void _onAuthUserChanged(
    AuthUserChanged event,
    Emitter<AuthState> emit,
  ) {
    final user = event.user;
    if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onAuthSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _authRepository.signOut();
  }
}
