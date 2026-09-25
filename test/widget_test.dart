import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sn_properties/features/profile/data/profile_local_storage.dart';
import 'package:sn_properties/features/profile/login_screen.dart';
import 'package:sn_properties/features/profile/profile_screen.dart';
import 'package:sn_properties/main.dart';

void main() {
  testWidgets('renders the SN PROPERTIES home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('SN PROPERTIES'), findsOneWidget);
    expect(find.text('Find a place\nyou will love.'), findsOneWidget);
    expect(find.text('Featured properties'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Recently added'),
      500,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Recently added'), findsOneWidget);
  });

  testWidgets('registers locally and can log out', (WidgetTester tester) async {
    final storage = _MemoryProfileRepository();
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(useMaterial3: true),
        home: ProfileScreen(storage: storage),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Register'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'Asha Rao');
    await tester.enterText(find.byType(TextFormField).at(1), '9876543210');
    await tester.tap(find.widgetWithText(FilledButton, 'Create Account'));
    await tester.pumpAndSettle();

    expect(find.text('Asha Rao'), findsOneWidget);
    expect(find.text('9876543210'), findsOneWidget);
    expect(storage.profile, isNotNull);

    await tester.tap(find.text('Logout'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome to SN PROPERTIES'), findsOneWidget);
    expect(storage.profile, isNull);
  });

  testWidgets('login validates an empty phone number', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LoginScreen(storage: _MemoryProfileRepository()),
      ),
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Login'));
    await tester.pump();

    expect(find.text('Phone number is required.'), findsOneWidget);
  });

  testWidgets('login validates an invalid phone number', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LoginScreen(storage: _MemoryProfileRepository()),
      ),
    );
    await tester.enterText(find.byType(TextFormField), '5123456789');

    await tester.tap(find.widgetWithText(FilledButton, 'Login'));
    await tester.pump();

    expect(find.text('Enter a valid 10-digit phone number.'), findsOneWidget);
  });

  testWidgets('matching local phone opens Profile Details',
      (WidgetTester tester) async {
    final storage = _MemoryProfileRepository()
      ..profile = const ProfileData(
        fullName: 'Asha Rao',
        phoneNumber: '9876543210',
        email: 'asha@example.com',
      );
    await tester.pumpWidget(
      MaterialApp(
        home: LoginScreen(storage: storage),
      ),
    );
    await tester.enterText(find.byType(TextFormField), '9876543210');

    await tester.tap(find.widgetWithText(FilledButton, 'Login'));
    await tester.pumpAndSettle();

    expect(find.text('Asha Rao'), findsOneWidget);
    expect(find.text('asha@example.com'), findsOneWidget);
  });

  testWidgets('non-matching local phone shows account-not-found message',
      (WidgetTester tester) async {
    final storage = _MemoryProfileRepository()
      ..profile = const ProfileData(
        fullName: 'Asha Rao',
        phoneNumber: '9876543210',
      );
    await tester.pumpWidget(
      MaterialApp(
        home: LoginScreen(storage: storage),
      ),
    );
    await tester.enterText(find.byType(TextFormField), '9123456780');

    await tester.tap(find.widgetWithText(FilledButton, 'Login'));
    await tester.pump();

    expect(
      find.text('No account found for this phone number. Please register.'),
      findsOneWidget,
    );
    expect(storage.profile?.phoneNumber, '9876543210');
  });

  testWidgets('login screen opens Registration screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LoginScreen(storage: _MemoryProfileRepository()),
      ),
    );

    await tester.tap(find.text("Don't have an account? Register"));
    await tester.pumpAndSettle();

    expect(find.text('Create your account'), findsOneWidget);
    expect(find.text('Create Account'), findsWidgets);
  });
}

class _MemoryProfileRepository implements ProfileRepository {
  ProfileData? profile;

  @override
  Future<void> clearProfile() async {
    profile = null;
  }

  @override
  Future<ProfileData?> getProfile() async => profile;

  @override
  Future<bool> hasRegistration() async => profile != null;

  @override
  Future<void> saveProfile(ProfileData value) async {
    profile = value;
  }
}
