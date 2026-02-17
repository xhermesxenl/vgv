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

    await $('Manage Users').tap();
    await $.pumpAndSettle();

    expect($('Users'), findsOneWidget);
    expect($('No users yet.'), findsOneWidget);
  });

  patrolWidgetTest('creates a new user via form', ($) async {
    when(() => mockRepo.getUsers()).thenAnswer((_) async => []);
    when(() => mockRepo.addUser(any())).thenAnswer((_) async => testUser);

    await $.pumpApp(home: const HomePage(), userRepository: mockRepo);

    await $('Manage Users').tap();
    await $.pumpAndSettle();

    await $(FloatingActionButton).tap();
    await $.pumpAndSettle();

    expect($('New User'), findsOneWidget);

    await $(TextFormField).at(0).enterText('John Doe');
    await $(TextFormField).at(1).enterText('john@example.com');
    await $(TextFormField).at(2).enterText('123456789');

    when(() => mockRepo.getUsers()).thenAnswer((_) async => [testUser]);

    await $('Create').tap();
    await $.pumpAndSettle();

    verify(() => mockRepo.addUser(any())).called(1);

    expect($('John Doe'), findsOneWidget);
    expect($('john@example.com'), findsOneWidget);
  });

  patrolWidgetTest('edits an existing user', ($) async {
    when(() => mockRepo.getUsers()).thenAnswer((_) async => [testUser]);
    when(() => mockRepo.updateUser(any())).thenAnswer((_) async => updatedUser);

    await $.pumpApp(home: const HomePage(), userRepository: mockRepo);

    await $('Manage Users').tap();
    await $.pumpAndSettle();

    await $('John Doe').tap();
    await $.pumpAndSettle();

    expect($('Edit User'), findsOneWidget);

    await $(TextFormField).at(0).enterText('Jane Doe');
    await $(TextFormField).at(1).enterText('jane@example.com');

    when(() => mockRepo.getUsers()).thenAnswer((_) async => [updatedUser]);

    await $('Update').tap();
    await $.pumpAndSettle();

    verify(() => mockRepo.updateUser(any())).called(1);

    expect($('Jane Doe'), findsOneWidget);
    expect($('jane@example.com'), findsOneWidget);
  });

  patrolWidgetTest('deletes a user', ($) async {
    when(() => mockRepo.getUsers()).thenAnswer((_) async => [testUser]);
    when(() => mockRepo.deleteUser(any())).thenAnswer((_) async {});

    await $.pumpApp(home: const HomePage(), userRepository: mockRepo);

    await $('Manage Users').tap();
    await $.pumpAndSettle();

    expect($('John Doe'), findsOneWidget);

    when(() => mockRepo.getUsers()).thenAnswer((_) async => []);

    await $(Icons.delete).tap();
    await $.pumpAndSettle();

    verify(() => mockRepo.deleteUser('1')).called(1);

    expect($('No users yet.'), findsOneWidget);
  });

  patrolWidgetTest('shows validation errors on empty form submission',
      ($) async {
    when(() => mockRepo.getUsers()).thenAnswer((_) async => []);

    await $.pumpApp(home: const HomePage(), userRepository: mockRepo);

    await $('Manage Users').tap();
    await $.pumpAndSettle();

    await $(FloatingActionButton).tap();
    await $.pumpAndSettle();

    await $('Create').tap();
    await $.pumpAndSettle();

    expect($('Name is required'), findsOneWidget);
    expect($('Email is required'), findsOneWidget);

    verifyNever(() => mockRepo.addUser(any()));
  });

  patrolWidgetTest('shows error state when loading fails', ($) async {
    when(() => mockRepo.getUsers()).thenThrow(Exception('Network error'));

    await $.pumpApp(home: const HomePage(), userRepository: mockRepo);

    await $('Manage Users').tap();
    await $.pumpAndSettle();

    expect(find.textContaining('Error'), findsOneWidget);
    expect(find.textContaining('Network error'), findsOneWidget);
  });
}
