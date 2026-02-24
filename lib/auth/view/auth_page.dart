import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vgv/auth/cubit/login_cubit.dart';
import 'package:vgv/auth/cubit/login_state.dart';
import 'package:vgv/auth/repository/auth_repository.dart';
import 'package:vgv/auth/view/auth_form.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginCubit>(
      create: (ctx) => LoginCubit(
        authRepository: ctx.read<AuthRepository>(),
      ),
      child: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.status == LoginStatus.failure &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: Colors.red,
                ),
              );
          }
        },
        child: const Scaffold(
          body: SafeArea(
            child: AuthForm(),
          ),
        ),
      ),
    );
  }
}
