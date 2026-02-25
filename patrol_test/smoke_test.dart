import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

// Lancement : patrol test --target patrol_test/smoke_test.dart --flavor development
//
// L'app est démarrée par le runner Patrol avant ce test.
// $ donne accès aux widgets Flutter ET aux interactions natives ($.native).

void main() {
  patrolTest(
    'smoke — navigation à travers tous les écrans principaux',
    ($) async {
      await $.pumpAndSettle(const Duration(seconds: 3));

      // ─────────────────────────────────────────
      // ÉCRAN 1 : HomePage
      // ─────────────────────────────────────────
      expect($('Manage Users'), findsOneWidget);
      await Future.delayed(const Duration(seconds: 2));

      // ─────────────────────────────────────────
      // ÉCRAN 2 : UsersPage — liste
      // ─────────────────────────────────────────
      await $('Manage Users').tap();
      await $.pumpAndSettle(const Duration(seconds: 3));

      expect($('Users'), findsOneWidget);
      await Future.delayed(const Duration(seconds: 2));

      // ─────────────────────────────────────────
      // ÉCRAN 3 : UserFormPage — création
      // ─────────────────────────────────────────
      await $(FloatingActionButton).tap();
      await $.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));

      expect($('New User'), findsOneWidget);

      final ts = DateTime.now().millisecondsSinceEpoch;
      final smokeName = 'Smoke $ts';
      final smokeEmail = 'smoke.$ts@test.com';

      await $(TextFormField).at(0).enterText(smokeName);
      await $.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 1));

      await $(TextFormField).at(1).enterText(smokeEmail);
      await $.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 1));

      await $(TextFormField).at(2).enterText('0600000000');
      await $.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 1));

      await $('Create').tap();
      await $.pumpAndSettle(const Duration(seconds: 5));
      await Future.delayed(const Duration(seconds: 2));

      // ─────────────────────────────────────────
      // ÉCRAN 2 (retour) : user créé visible
      // ─────────────────────────────────────────
      expect($('Users'), findsOneWidget);
      expect($(smokeName), findsOneWidget);
      await Future.delayed(const Duration(seconds: 2));

      // ─────────────────────────────────────────
      // ÉCRAN 4 : UserFormPage — modification
      // ─────────────────────────────────────────
      await $(smokeName).tap();
      await $.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));

      expect($('Edit User'), findsOneWidget);
      await Future.delayed(const Duration(seconds: 2));

      // Retour sans sauvegarder
      await $.native.pressBack();
      await $.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));

      // ─────────────────────────────────────────
      // ÉCRAN 2 : suppression du user de smoke
      // ─────────────────────────────────────────
      expect($(smokeName), findsOneWidget);

      final tile = find.ancestor(
        of: find.text(smokeName),
        matching: find.byType(ListTile),
      );
      await $.tester.tap(
        find.descendant(of: tile, matching: find.byIcon(Icons.delete)),
      );
      await $.pumpAndSettle(const Duration(seconds: 5));
      await Future.delayed(const Duration(seconds: 2));

      expect($(smokeName), findsNothing);
      await Future.delayed(const Duration(seconds: 2));
    },
  );
}
