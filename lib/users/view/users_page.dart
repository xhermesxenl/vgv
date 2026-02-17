import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vgv/users/bloc/user_bloc.dart';
import 'package:vgv/users/bloc/user_event.dart';
import 'package:vgv/users/bloc/user_state.dart';
import 'package:vgv/users/model/user.dart';
import 'package:vgv/users/repository/user_repository.dart';

import 'package:vgv/users/view/user_form_page.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          UserBloc(userRepository: context.read<UserRepository>())
            ..add(const LoadUsers()),
      child: const UsersView(),
    );
  }
}

class UsersView extends StatelessWidget {
  const UsersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading || state is UserInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is UserError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          if (state is UserLoaded) {
            if (state.users.isEmpty) {
              return const Center(child: Text('No users yet.'));
            }
            return ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                return _UserTile(user: user);
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _navigateToForm(BuildContext context) async {
    final bloc = context.read<UserBloc>();
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(builder: (_) => const UserFormPage()),
    );
    if (result == true) {
      bloc.add(const LoadUsers());
    }
  }
}

class _UserTile extends StatelessWidget {
  const _UserTile({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(user.name),
      subtitle: Text(user.email),
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: () {
          context.read<UserBloc>().add(DeleteUser(user.id));
        },
      ),
      onTap: () async {
        final bloc = context.read<UserBloc>();
        final result = await Navigator.of(context).push<bool>(
          MaterialPageRoute<bool>(
            builder: (_) => UserFormPage(user: user),
          ),
        );
        if (result == true) {
          bloc.add(const LoadUsers());
        }
      },
    );
  }
}
