import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:patrol_finders/patrol_finders.dart';
import 'package:vgv/home/view/home_page.dart';
import 'package:vgv/users/model/user.dart';

import 'helpers/helpers.dart';

void main() {
  late MockUserRepository mockRepo;

  const testUser = User(
    id: '1',
    name: 'John Doe',
    email: 'john@example.com',
    phone: '123456789',
  );

  const updatedUser = User(
    id: '1',
    name: 'Jane Doe',
    email: 'jane@example.com',
    phone: '987654321',
  );

  setUpAll(() {
    registerFallbackValue(FakeUser());
  });

  setUp(() {
    mockRepo = MockUserRepository();
  });

  patrolWidgetTest('navigates from HomePage to UsersPage and shows empty state',
      ($) async {
    when(() => mockRepo.getUsers()).thenAnswer((_) async => []);

    await $.pumpApp(home: const HomePage(), userRepository: mockRepo);

    // Tap the "Manage Users" button
    await $('Manage Users').tap();
    await $.pumpAndSettle();

    // Verify we're on UsersPage with empty state
    expect($('Users'), findsOneWidget);
    expect($('No users yet.'), findsOneWidget);
  });

  patrolWidgetTest('creates a new user via form', ($) async {
    when(() => mockRepo.getUsers()).thenAnswer((_) async => []);
    when(() => mockRepo.addUser(any())).thenAnswer((_) async => testUser);

    await $.pumpApp(home: const HomePage(), userRepository: mockRepo);

    // Navigate to UsersPage
    await $('Manage Users').tap();
    await $.pumpAndSettle();

    // Tap FAB to open form
    await $(FloatingActionButton).tap();
    await $.pumpAndSettle();

    // Verify we're on the New User form
    expect($('New User'), findsOneWidget);

    // Fill in the form
    await $(TextFormField).at(0).enterText('John Doe');
    await $(TextFormField).at(1).enterText('john@example.com');
    await $(TextFormField).at(2).enterText('123456789');

    // After form submission, mock returns the created user
    when(() => mockRepo.getUsers()).thenAnswer((_) async => [testUser]);

    // Tap Create button
    await $('Create').tap();
    await $.pumpAndSettle();

    // Verify addUser was called
    verify(() => mockRepo.addUser(any())).called(1);

    // Back on users list, user should appear
    expect($('John Doe'), findsOneWidget);
    expect($('john@example.com'), findsOneWidget);
  });

  patrolWidgetTest('edits an existing user', ($) async {
    when(() => mockRepo.getUsers()).thenAnswer((_) async => [testUser]);
    when(() => mockRepo.updateUser(any())).thenAnswer((_) async => updatedUser);

    await $.pumpApp(home: const HomePage(), userRepository: mockRepo);

    // Navigate to UsersPage
    await $('Manage Users').tap();
    await $.pumpAndSettle();

    // Tap on the user tile to edit
    await $('John Doe').tap();
    await $.pumpAndSettle();

    // Verify we're on the Edit User form
    expect($('Edit User'), findsOneWidget);

    // Clear and update the name field
    await $(TextFormField).at(0).enterText('Jane Doe');

    // Clear and update the email field
    await $(TextFormField).at(1).enterText('jane@example.com');

    // After update, mock returns updated user
    when(() => mockRepo.getUsers()).thenAnswer((_) async => [updatedUser]);

    // Tap Update button
    await $('Update').tap();
    await $.pumpAndSettle();

    // Verify updateUser was called
    verify(() => mockRepo.updateUser(any())).called(1);

    // Back on users list, updated user should appear
    expect($('Jane Doe'), findsOneWidget);
    expect($('jane@example.com'), findsOneWidget);
  });

  patrolWidgetTest('deletes a user', ($) async {
    when(() => mockRepo.getUsers()).thenAnswer((_) async => [testUser]);
    when(() => mockRepo.deleteUser(any())).thenAnswer((_) async {});

    await $.pumpApp(home: const HomePage(), userRepository: mockRepo);

    // Navigate to UsersPage
    await $('Manage Users').tap();
    await $.pumpAndSettle();

    // Verify user is shown
    expect($('John Doe'), findsOneWidget);

    // After delete, mock returns empty list
    when(() => mockRepo.getUsers()).thenAnswer((_) async => []);

    // Tap delete icon
    await $(Icons.delete).tap();
    await $.pumpAndSettle();

    // Verify deleteUser was called
    verify(() => mockRepo.deleteUser('1')).called(1);

    // List should now be empty
    expect($('No users yet.'), findsOneWidget);
  });

  patrolWidgetTest('shows validation errors on empty form submission',
      ($) async {
    when(() => mockRepo.getUsers()).thenAnswer((_) async => []);

    await $.pumpApp(home: const HomePage(), userRepository: mockRepo);

    // Navigate to UsersPage
    await $('Manage Users').tap();
    await $.pumpAndSettle();

    // Tap FAB to open form
    await $(FloatingActionButton).tap();
    await $.pumpAndSettle();

    // Tap Create without filling in fields
    await $('Create').tap();
    await $.pumpAndSettle();

    // Verify validation messages
    expect($('Name is required'), findsOneWidget);
    expect($('Email is required'), findsOneWidget);

    // addUser should NOT have been called
    verifyNever(() => mockRepo.addUser(any()));
  });

  patrolWidgetTest('shows error state when loading fails', ($) async {
    when(() => mockRepo.getUsers()).thenThrow(Exception('Network error'));

    await $.pumpApp(home: const HomePage(), userRepository: mockRepo);

    // Navigate to UsersPage
    await $('Manage Users').tap();
    await $.pumpAndSettle();

    // Verify error message is displayed
    expect(
      find.textContaining('Error'),
      findsOneWidget,
    );
    expect(
      find.textContaining('Network error'),
      findsOneWidget,
    );
  });
}
