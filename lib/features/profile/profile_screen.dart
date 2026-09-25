import 'package:flutter/material.dart';
import 'package:sn_properties/features/profile/data/profile_local_storage.dart';
import 'package:sn_properties/features/profile/profile_details_screen.dart';
import 'package:sn_properties/features/profile/login_screen.dart';
import 'package:sn_properties/features/profile/registration_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, this.storage});

  final ProfileRepository? storage;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final Future<ProfileRepository> _storageFuture;

  @override
  void initState() {
    super.initState();
    _storageFuture = widget.storage == null
        ? ProfileLocalStorage.create()
        : Future.value(widget.storage);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProfileRepository>(
      future: _storageFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError || snapshot.data == null) {
          return const Scaffold(
            body: Center(child: Text('Unable to load profile.')),
          );
        }
        return _ProfileContent(storage: snapshot.data!);
      },
    );
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({required this.storage});

  final ProfileRepository storage;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProfileData?>(
      future: storage.getProfile(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final profile = snapshot.data;
        if (profile != null) {
          return ProfileDetailsScreen(profile: profile, storage: storage);
        }
        return _UnauthenticatedProfile(storage: storage);
      },
    );
  }
}

class _UnauthenticatedProfile extends StatelessWidget {
  const _UnauthenticatedProfile({required this.storage});

  final ProfileRepository storage;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 48,
                backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                child: Icon(
                  Icons.person_outline,
                  size: 52,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'Welcome to SN PROPERTIES',
                textAlign: TextAlign.center,
                style: textTheme.headlineSmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Login or register to manage your profile.',
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => LoginScreen(storage: storage),
                      ),
                    );
                  },
                  child: const Text('Login'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                          builder: (_) => RegistrationScreen(storage: storage),
                      ),
                    );
                  },
                  child: const Text('Register'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
