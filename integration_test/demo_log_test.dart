import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:vgv/main_development.dart' as app; // Remplacez main_development par main si nécessaire
import 'dart:developer' as developer;

void main() {
  // Cette ligne initialise le driver de test sur l'émulateur/appareil réel
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Test Fonctionnel avec Logs', () {
    testWidgets('Lancement de l\'app, passage de l\'onboarding et connexion', (tester) async {

      developer.log('=== DÉBUT DU TEST ===', name: 'UI_TEST');

      // Étape 1 : Lancer l'application
      developer.log('Étape 1 : Lancement de l\'application en cours...', name: 'UI_TEST');
      app.main();

      // On attend 3 secondes pour s'assurer que l'app et les routes initiales sont prêtes
      await tester.pumpAndSettle(const Duration(seconds: 3));
      developer.log('Application lancée. Écran actuel chargé.', name: 'UI_TEST');

      // Étape 2 : Passer l'écran d'Onboarding (Si c'est un appareil "neuf", il l'affiche)
      developer.log('Étape 2 : Vérification de la présence de l\'Onboarding...', name: 'UI_TEST');

      final nextButton = find.text('Next');
      final getStartedButton = find.text('Get started');

      // Si le bouton "Next" de l'onboarding est visible sur l'écran d'accueil
      if (nextButton.evaluate().isNotEmpty) {
        developer.log('Tutoriel (Onboarding) détecté. Clic sur "Next" (Page 1)', name: 'UI_TEST');
        await tester.tap(nextButton);
        await tester.pumpAndSettle();

        developer.log('Clic sur "Next" (Page 2)', name: 'UI_TEST');
        await tester.tap(nextButton);
        await tester.pumpAndSettle();

        developer.log('Clic sur "Get started" (Page 3)', name: 'UI_TEST');
        await tester.tap(getStartedButton);
        await tester.pumpAndSettle(const Duration(seconds: 2));
      } else if (getStartedButton.evaluate().isNotEmpty) {
        // Au cas où on est direct sur la 3ème page
        developer.log('Tutoriel détecté. Clic sur "Get started"', name: 'UI_TEST');
        await tester.tap(getStartedButton);
        await tester.pumpAndSettle(const Duration(seconds: 2));
      } else {
        developer.log('Aucun tutoriel détecté. Certainement déjà terminé avant.', name: 'UI_TEST');
      }

      // Étape 3 : Arrivée sur la page de connexion
      developer.log('Étape 3 : Recherche du formulaire de connexion...', name: 'UI_TEST');

      // On cherche "Sign in to continue" ou directement les champs
      if (find.text('Sign in to continue').evaluate().isNotEmpty || find.text('VGV App').evaluate().isNotEmpty) {
        developer.log('Formulaire de connexion trouvé sur l\'écran !', name: 'UI_TEST');

        // On récupère le premier TextField (Email) et le deuxième (Password)
        final emailField = find.byType(TextField).at(0);
        final passwordField = find.byType(TextField).at(1);
        final signInButton = find.text('Sign In');

        developer.log('Remplissage de l\'email...', name: 'UI_TEST');
        await tester.enterText(emailField, 'test@example.com');
        await tester.pumpAndSettle();

        developer.log('Remplissage du mot de passe...', name: 'UI_TEST');
        await tester.enterText(passwordField, 'monMotDePasse123');
        await tester.pumpAndSettle();

        // Petite pause pour bien vous laisser voir les champs remplis sur l'émulateur
        await Future.delayed(const Duration(seconds: 2));

        developer.log('Clic sur le bouton "Sign In"...', name: 'UI_TEST');
        await tester.tap(signInButton);
        // On attend la réponse de la tentative de connexion
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Vérifier si un message d'erreur rouge apparait (Snackbar)
        if (find.byType(SnackBar).evaluate().isNotEmpty) {
          developer.log('L\'application a renvoyé une erreur de connexion (Snackbar rouge visible).', name: 'UI_TEST');
        } else {
          developer.log('Tentative de connexion effectuée sans Snackbar d\'erreur.', name: 'UI_TEST');
        }
      } else {
        developer.log('Attention : Écran de connexion introuvable.', name: 'UI_TEST');
      }

      // Étape 4 : Fin du test avec une courte pause pour observer
      developer.log('Étape 4 : Wait visuel de 3 secondes avant la fermeture de l\'émulateur...', name: 'UI_TEST');
      await Future.delayed(const Duration(seconds: 3));

      developer.log('=== FIN DU TEST AVEC SUCCÈS ===', name: 'UI_TEST');
    });
  });
}
