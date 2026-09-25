import 'package:shared_preferences/shared_preferences.dart';

class ProfileData {
  const ProfileData({
    required this.fullName,
    required this.phoneNumber,
    this.email,
  });

  final String fullName;
  final String phoneNumber;
  final String? email;
}

abstract interface class ProfileRepository {
  Future<bool> hasRegistration();
  Future<ProfileData?> getProfile();
  Future<void> saveProfile(ProfileData profile);
  Future<void> clearProfile();
}

class ProfileLocalStorage implements ProfileRepository {
  ProfileLocalStorage(this._preferences);

  static const _registrationCompleteKey = 'profile.registrationComplete';
  static const _fullNameKey = 'profile.fullName';
  static const _phoneNumberKey = 'profile.phoneNumber';
  static const _emailKey = 'profile.email';

  final SharedPreferences _preferences;

  static Future<ProfileLocalStorage> create() async {
    return ProfileLocalStorage(await SharedPreferences.getInstance());
  }

  @override
  Future<bool> hasRegistration() async {
    return _preferences.getBool(_registrationCompleteKey) ?? false;
  }

  @override
  Future<ProfileData?> getProfile() async {
    if (!await hasRegistration()) {
      return null;
    }

    final fullName = _preferences.getString(_fullNameKey);
    final phoneNumber = _preferences.getString(_phoneNumberKey);
    if (fullName == null || phoneNumber == null) {
      return null;
    }

    return ProfileData(
      fullName: fullName,
      phoneNumber: phoneNumber,
      email: _preferences.getString(_emailKey),
    );
  }

  @override
  Future<void> saveProfile(ProfileData profile) async {
    await _preferences.setString(_fullNameKey, profile.fullName);
    await _preferences.setString(_phoneNumberKey, profile.phoneNumber);
    if (profile.email == null || profile.email!.isEmpty) {
      await _preferences.remove(_emailKey);
    } else {
      await _preferences.setString(_emailKey, profile.email!);
    }
    await _preferences.setBool(_registrationCompleteKey, true);
  }

  @override
  Future<void> clearProfile() async {
    await _preferences.remove(_registrationCompleteKey);
    await _preferences.remove(_fullNameKey);
    await _preferences.remove(_phoneNumberKey);
    await _preferences.remove(_emailKey);
  }
}
