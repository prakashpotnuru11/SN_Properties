import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_properties/shared/models/property.dart';

abstract interface class FavoritesRepository {
  Future<Set<String>> loadFavoriteIds();
  Future<void> saveFavoriteIds(Set<String> ids);
}

class FavoritesLocalStorage implements FavoritesRepository {
  static const _favoriteIdsKey = 'favorites.propertyIds';

  @override
  Future<Set<String>> loadFavoriteIds() async {
    final preferences = await SharedPreferences.getInstance();
    return (preferences.getStringList(_favoriteIdsKey) ?? []).toSet();
  }

  @override
  Future<void> saveFavoriteIds(Set<String> ids) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setStringList(_favoriteIdsKey, ids.toList());
  }
}

class FavoritesStore extends ChangeNotifier {
  FavoritesStore(this._repository);

  final FavoritesRepository _repository;
  Set<String> _favoriteIds = {};
  Future<void>? _initialization;
  Future<void> _pendingWrites = Future<void>.value();
  bool _isReady = false;

  bool get isReady => _isReady;
  Set<String> get favoriteIds => Set.unmodifiable(_favoriteIds);

  bool isFavorite(Property property) => _favoriteIds.contains(property.id);

  Future<void> initialize() {
    return _initialization ??= _loadFavoriteIds();
  }

  Future<void> _loadFavoriteIds() async {
    _favoriteIds = await _repository.loadFavoriteIds();
    _isReady = true;
    notifyListeners();
  }

  Future<void> toggle(Property property) async {
    await initialize();
    final nextIds = Set<String>.of(_favoriteIds);
    if (!nextIds.add(property.id)) {
      nextIds.remove(property.id);
    }
    _favoriteIds = nextIds;
    notifyListeners();

    final savedIds = Set<String>.of(nextIds);
    _pendingWrites = _pendingWrites.then(
      (_) => _repository.saveFavoriteIds(savedIds),
    );
    await _pendingWrites;
  }
}