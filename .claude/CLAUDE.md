## Model Selection

- **Sonnet** (`claude-sonnet-4-6`): Default for all daily tasks — CRUD, features, refactoring, tests, Flutter code generation.
- **Opus** (`claude-opus-4-6`): Only for complex architecture decisions, tricky multi-file debugging, or security reviews.
- **Haiku** (`claude-haiku-4-5-20251001`): Only for quick questions, simple formatting, or single-line edits.

## Plan Mode

- Use **Opus in plan mode** when starting a new complex feature from scratch.


# CLAUDE.md — Boilerplate Flutter VGV × Supabase

## Contexte projet
Ce repo est un **boilerplate personnel** basé sur Very Good CLI (VGV), enrichi avec :
- Auth Supabase complète (login / register / logout / session)
- CRUD générique Supabase (en cours de design)
- Navigation / Router configuré
- Thème & Design System intégré

Objectif : base de référence pour tous les futurs projets Flutter Android.
**Ce n'est pas une app finale.** Chaque ajout doit rester générique et réutilisable.

---

## Stack
- Flutter + Very Good CLI (feature-first, flavors dev/staging/prod)
- State management : flutter_bloc / Cubit
- Backend : Supabase (auth, database, storage)
- Lint : very_good_analysis (strict, 0 warning toléré)
- Tests : bloc_test + mocktail, cible 100% coverage
- Cible : Android

---

## Commandes
```bash
# Run
flutter run --flavor development --target lib/main_development.dart
flutter run --flavor production --target lib/main_production.dart

# Tests
very_good test -j 4 --coverage
flutter test --coverage

# Qualité
flutter analyze
dart format .

# Génération de code
dart run build_runner build --delete-conflicting-outputs
```

---

## Architecture (Feature-First VGV)
```
lib/
├── app/                  # AppWidget, AppRouter, AppBloc, bootstrap
├── core/
│   ├── theme/            # Thème, couleurs, typography, Design System
│   ├── router/           # GoRouter config
│   ├── extensions/       # Extensions Dart utilitaires
│   └── errors/           # Failures, Exceptions domaine
├── features/
│   └── [feature]/
│       ├── bloc/         # *_cubit.dart + state | *_bloc + event + state
│       ├── data/         # datasource Supabase, repository impl
│       ├── domain/       # models (Equatable), repository interface
│       └── view/         # *_page.dart, *_view.dart, widgets/
└── l10n/
packages/
├── supabase_auth_client/       # Wrapper auth Supabase (fait)
└── supabase_database_client/   # Wrapper CRUD Supabase (en design)
```

---

## Règles architecture
- View = UI only, zéro logique métier, zéro appel direct Supabase
- Bloc/Cubit = logique métier uniquement, jamais de BuildContext
- Repository interface dans domain/, implémentation dans data/
- Supabase uniquement dans packages/, jamais importé directement dans lib/
- Toujours Equatable sur states, events et models
- Cubit si flux simple, Bloc si events multiples/complexes
- Credentials dans `.env`, jamais hardcodés

---

## Pattern CRUD — À DÉCIDER avant d'implémenter

Avant tout code CRUD, comparer et valider l'une de ces options :

**Option A — Repository générique typé**
```dart
abstract class Repository<T> {
  Future<List<T>> getAll();
  Future<T> getById(String id);
  Future<T> create(T item);
  Future<T> update(T item);
  Future<void> delete(String id);
}
```
✅ DRY, une seule impl Supabase  ⚠️ Moins flexible pour queries complexes

**Option B — Repository par feature**
Chaque feature a son propre repository avec ses méthodes métier spécifiques.
✅ Très flexible  ⚠️ Duplication possible

**Option C — Service layer générique (recommandé pour boilerplate)**
`SupabaseDatabaseService` générique appelé par chaque repository feature.
✅ Équilibre DRY + flexibilité  ✅ Le plus adapté à un boilerplate réutilisable

→ Demander à Claude de comparer ces options selon le besoin avant de coder.
→ Utiliser context7 pour vérifier les patterns Supabase + Bloc récents.

---

## Auth Supabase (intégré)
- Session gérée dans AppBloc via `onAuthStateChange`
- Redirect automatique login ↔ home via Router
- `supabase_auth_client` encapsule tout l'accès auth
- Flows : login email/password, register, logout, session restore

---

## Tests
- Chaque Bloc/Cubit a son `*_test.dart` avec bloc_test
- Repositories mockés avec mocktail
- `flutter analyze && flutter test` avant chaque commit
- 0 test en échec toléré

---

## Git
- Branches : `feat/`, `fix/`, `refactor/`, `chore/`
- Branche principale : `main`
- Commit atomique après chaque tâche validée
- Format : `feat(scope): description courte`

---

## Instructions Claude
- Toujours utiliser context7 pour doc Flutter, Dart, Supabase, bloc
- Ce repo est un boilerplate : toute solution doit être générique et réutilisable
- Avant d'implémenter le CRUD, proposer une comparaison des patterns et attendre validation
- Respecter very_good_analysis : 0 warning, 0 lint error
- Ne jamais importer supabase_flutter dans lib/, passer par packages/
- Vérifier les packages/ existants avant de créer du nouveau code