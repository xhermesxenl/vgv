import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vgv/auth/cubit/login_cubit.dart';
import 'package:vgv/auth/cubit/login_state.dart';

class AuthForm extends StatelessWidget {
  const AuthForm({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<LoginCubit>().state;
    final cubit = context.read<LoginCubit>();

    final isLoading = state.status == LoginStatus.loading;
    final isSignUp = state.mode == AuthMode.signUp;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 48),
          const Text(
            'VGV App',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            isSignUp ? 'Create your account' : 'Sign in to continue',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 40),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
            onChanged: cubit.emailChanged,
            enabled: !isLoading,
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
            obscureText: true,
            onChanged: cubit.passwordChanged,
            enabled: !isLoading,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: isLoading ? null : cubit.submit,
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(isSignUp ? 'Sign Up' : 'Sign In'),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: isLoading ? null : cubit.toggleMode,
            child: Text(
              isSignUp
                  ? 'Already have an account? Sign In'
                  : 'No account yet? Create one',
            ),
          ),
          const SizedBox(height: 24),
          const Row(
            children: [
              Expanded(child: Divider()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text('OR'),
              ),
              Expanded(child: Divider()),
            ],
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: isLoading ? null : cubit.signInWithGoogle,
            icon: const Icon(Icons.g_mobiledata),
            label: const Text('Continue with Google'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: isLoading ? null : cubit.signInWithGithub,
            icon: const Icon(Icons.code),
            label: const Text('Continue with GitHub'),
          ),
        ],
      ),
    );
  }
}
