import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:vgv/main_development.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'CRUD flow complet : liste → création → modification → suppression',
    (tester) async {
      // ─────────────────────────────────────────
      // Démarrage — Supabase init + HomePage
      // ─────────────────────────────────────────
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.text('Manage Users'), findsOneWidget);
      await Future.delayed(const Duration(seconds: 2));

      // ─────────────────────────────────────────
      // ÉCRAN 1 → 2 : HomePage → UsersPage
      // ─────────────────────────────────────────
      await tester.tap(find.text('Manage Users'));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.text('Users'), findsOneWidget);
      await Future.delayed(const Duration(seconds: 2));

      // ─────────────────────────────────────────
      // ÉCRAN 3 : UserFormPage — création
      // ─────────────────────────────────────────
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));

      expect(find.text('New User'), findsOneWidget);

      final ts = DateTime.now().millisecondsSinceEpoch;
      final testName = 'Integration $ts';
      final testEmail = 'integration.$ts@test.com';

      await tester.enterText(find.byType(TextFormField).at(0), testName);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 1));

      await tester.enterText(find.byType(TextFormField).at(1), testEmail);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 1));

      await tester.enterText(find.byType(TextFormField).at(2), '0600000000');
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 1));

      await tester.tap(find.text('Create'));
      await tester.pumpAndSettle(const Duration(seconds: 5));
      await Future.delayed(const Duration(seconds: 2));

      // ─────────────────────────────────────────
      // ÉCRAN 2 (retour) : user créé visible dans la liste
      // ─────────────────────────────────────────
      expect(find.text('Users'), findsOneWidget);
      expect(find.text(testName), findsOneWidget);
      await Future.delayed(const Duration(seconds: 2));

      // ─────────────────────────────────────────
      // ÉCRAN 4 : UserFormPage — modification
      // ─────────────────────────────────────────
      await tester.tap(find.text(testName));
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));

      expect(find.text('Edit User'), findsOneWidget);

      final updatedName = 'Updated $ts';

      await tester.enterText(find.byType(TextFormField).at(0), updatedName);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 1));

      await tester.tap(find.text('Update'));
      await tester.pumpAndSettle(const Duration(seconds: 5));
      await Future.delayed(const Duration(seconds: 2));

      // ─────────────────────────────────────────
      // ÉCRAN 2 (retour) : nom mis à jour dans la liste
      // ─────────────────────────────────────────
      expect(find.text('Users'), findsOneWidget);
      expect(find.text(updatedName), findsOneWidget);
      await Future.delayed(const Duration(seconds: 2));

      // ─────────────────────────────────────────
      // SUPPRESSION : icône delete sur la tile du user
      // ─────────────────────────────────────────
      final userTile = find.ancestor(
        of: find.text(updatedName),
        matching: find.byType(ListTile),
      );
      await tester.tap(
        find.descendant(of: userTile, matching: find.byIcon(Icons.delete)),
      );
      await tester.pumpAndSettle(const Duration(seconds: 5));
      await Future.delayed(const Duration(seconds: 2));

      expect(find.text(updatedName), findsNothing);
      await Future.delayed(const Duration(seconds: 2));
    },
  );

  testWidgets('validation formulaire — soumission avec champs vides',
      (tester) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 3));

    await tester.tap(find.text('Manage Users'));
    await tester.pumpAndSettle(const Duration(seconds: 3));
    await Future.delayed(const Duration(seconds: 2));

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 2));

    expect(find.text('New User'), findsOneWidget);

    // Soumettre sans rien remplir
    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 2));

    expect(find.text('Name is required'), findsOneWidget);
    expect(find.text('Email is required'), findsOneWidget);
    await Future.delayed(const Duration(seconds: 2));
  });
}
