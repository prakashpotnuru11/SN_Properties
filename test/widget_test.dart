import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sn_properties/features/home/data/sample_properties.dart';
import 'package:sn_properties/features/properties/widgets/property_image.dart';
import 'package:sn_properties/features/profile/data/profile_local_storage.dart';
import 'package:sn_properties/features/profile/login_screen.dart';
import 'package:sn_properties/features/profile/profile_screen.dart';
import 'package:sn_properties/main.dart';
import 'package:sn_properties/shared/models/property.dart';

void main() {
  test('every sample property has a unique image URL', () {
    final imageUrls = SampleProperties.all
        .map((property) => property.imageUrls)
        .expand((urls) => urls)
        .toList();

    expect(imageUrls, hasLength(SampleProperties.all.length));
    expect(imageUrls.every((url) => url.isNotEmpty), isTrue);
    expect(imageUrls.toSet(), hasLength(SampleProperties.all.length));
  });

  testWidgets('failed property image displays the placeholder',
      (WidgetTester tester) async {
    const property = Property(
      title: 'Image fallback test',
      location: 'Test locality',
      price: '₹1 Cr',
      type: PropertyType.buy,
      category: PropertyCategory.residential,
      bedrooms: 1,
      area: '1,000 sq.ft',
      accentColor: Color(0xFF927A9F),
      imageUrls: ['https://invalid.example/property.jpg'],
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: SizedBox(
          width: 300,
          child: PropertyImage(property: property, height: 160),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.home_work_outlined), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

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

  testWidgets('searches local properties across searchable fields',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    final searchField = find.byType(TextField).first;

    await tester.enterText(searchField, 'hItEcH cItY');
    await tester.pumpAndSettle();
    expect(find.text('Skyline Crest'), findsOneWidget);
    expect(find.text('The Willow Residence'), findsNothing);

    await tester.enterText(searchField, 'rent');
    await tester.pumpAndSettle();
    expect(find.text('Skyline Crest'), findsOneWidget);
    expect(find.text('The Atelier Offices'), findsOneWidget);

    await tester.enterText(searchField, 'commercial');
    await tester.pumpAndSettle();
    expect(find.text('The Atelier Offices'), findsOneWidget);

    await tester.enterText(searchField, 'sunlit');
    await tester.pumpAndSettle();
    expect(find.text('The Willow Residence'), findsOneWidget);

    await tester.enterText(searchField, 'no matching property');
    await tester.pumpAndSettle();
    expect(find.text('No properties found'), findsOneWidget);
  });

  testWidgets('bottom Search opens searchable property results',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();

    expect(find.text('Search properties'), findsOneWidget);
    final searchField = find.byType(TextField).last;
    await tester.enterText(searchField, 'hItEcH cItY');
    await tester.pumpAndSettle();
    expect(find.text('Skyline Crest'), findsOneWidget);
    expect(find.text('The Willow Residence'), findsNothing);

    await tester.enterText(searchField, 'no matching property');
    await tester.pumpAndSettle();
    expect(find.text('No properties found'), findsOneWidget);

    await tester.tap(find.byTooltip('Clear search'));
    await tester.pumpAndSettle();
    expect(find.text('Available properties'), findsOneWidget);
    expect(find.text('The Willow Residence'), findsOneWidget);
  });

  testWidgets('property card opens details from Home and Search',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.drag(
      find.byType(CustomScrollView),
      const Offset(0, -420),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('The Willow Residence'));
    await tester.pumpAndSettle();
    expect(find.text('Property details'), findsOneWidget);
    expect(find.text('₹1.85 Cr'), findsOneWidget);
    expect(find.text('Whitefield, Bengaluru'), findsOneWidget);
    expect(find.text('Residential'), findsOneWidget);
    expect(find.text('3 bedrooms'), findsOneWidget);
    expect(find.text('A sunlit family home with a private balcony.'), findsOneWidget);
    expect(
      tester.widget<PropertyImage>(find.byType(PropertyImage)).property.imageUrls.first,
      SampleProperties.featured.first.imageUrls.first,
    );

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.text('Featured properties'), findsOneWidget);

    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Skyline Crest'));
    await tester.pumpAndSettle();
    expect(find.text('Property details'), findsOneWidget);
    expect(find.text('Hitech City, Hyderabad'), findsOneWidget);
    expect(
      tester.widget<PropertyImage>(find.byType(PropertyImage)).property.imageUrls.first,
      SampleProperties.featured[1].imageUrls.first,
    );
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
