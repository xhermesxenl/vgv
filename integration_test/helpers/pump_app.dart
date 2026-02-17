import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mocktail/mocktail.dart';
import 'package:patrol_finders/patrol_finders.dart';
import 'package:vgv/l10n/l10n.dart';
import 'package:vgv/users/model/user.dart';
import 'package:vgv/users/repository/user_repository.dart';

class MockUserRepository extends Mock implements UserRepository {}

class FakeUser extends Fake implements User {}

extension PumpApp on PatrolTester {
  Future<void> pumpApp({
    required Widget home,
    required MockUserRepository userRepository,
  }) async {
    await pumpWidgetAndSettle(
      RepositoryProvider<UserRepository>.value(
        value: userRepository,
        child: MaterialApp(
          localizationsDelegates: const [
            ...AppLocalizations.localizationsDelegates,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: home,
        ),
      ),
    );
  }
}
