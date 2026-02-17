import 'package:flutter/material.dart';
import 'package:vgv/l10n/l10n.dart';
import 'package:vgv/users/view/users_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.counterAppBarTitle),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const UsersPage(),
              ),
            );
          },
          child: const Text('Manage Users'),
        ),
      ),
    );
  }
}
