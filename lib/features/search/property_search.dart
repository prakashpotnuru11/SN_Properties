import 'package:sn_properties/shared/models/property.dart';

abstract final class PropertySearch {
  static List<Property> filter(Iterable<Property> properties, String query) {
    final normalizedQuery = query.trim().toLowerCase();
    return properties.where((property) {
      final searchableText = [
        property.title,
        property.location,
        property.category.name,
        property.type.name,
        property.description,
      ].join(' ').toLowerCase();
      return searchableText.contains(normalizedQuery);
    }).toList();
  }
}